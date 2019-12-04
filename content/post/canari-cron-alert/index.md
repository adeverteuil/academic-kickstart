---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Canari Cron Alert"
subtitle: ""
summary: "Trigger an alert from a cronjob daily at noon local time as a canary alert for the monitoring of the monitoring system itself."
authors: []
tags: ["sysadmin", "monitoring", "prometheus"]
categories: ["informatique"]
date: 2018-04-25
lastmod: 2018-04-25
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Suppose you have a distributed monitoring system with alerting and
mail servers. A common problem is the monitoring of the monitoring
system itelf. In case you are not familiar with the problem, imagine
your mailserver is down, and you rely on email to receive alerts
about services that are unexpectedly offline. You might want to set
up some monitoring through an external provider and use a different
communication channel such as SMS.

Alternatively, I thought of programming an API call to my alerting
service and executing it every day at exactly noon. This would be
a pager-level alert which does not require acknowledgement and
self-resolves quickly. The procedure for the human receiving the alert
is simply to habituate and come to expect the daily chime at noon.

This idea builds on two existing concepts:
[the canary in the coal mine](https://en.wikipedia.org/wiki/Sentinel_species#Historical_examples) and 
[symptom-based monitoring](https://docs.google.com/document/d/199PqyG3UsyXlwieHaqbGiWVa8eMWi8zzAn0YfcApr8Q/edit?usp=sharing).

The advantages are less components to manage and low time and money cost
to implement. It also provides a positive confirmation, instead of only
adding an additional “silence means good” layer. It also has the
benefit of indirectly monitoring crond on my tools server.

The disadvantage is the average minimum awareness latency for an
alerting service outage is 12 hours. And of course the risk is having a
critical outage and an alerting system outage at the same time.


# Example with Prometheus and Alertmanager

This script will create an alert in Alertmanager with the label `severity: test`.

    #!/bin/bash
    template='[
        {
            "labels": {
                "alertname": "Canary alarm — Test of the alert system",
                "instance": "1",
                "severity": "test",
                "job": "alertmanager"
            },
            "annotations": {
                "info": "This is a test",
                "summary": "This should chime daily at noon."
            },
            "endsAt": "ENDSAT",
            "generatorURL": "https://prometheus.sc.iweb.com/graph?g0.range_input=1h&g0.expr=alertmanager_alerts&g0.tab=0"
        },
        {
            "labels": {
                "alertname": "Canary alarm — Test of the alert system",
                "instance": "2",
                "severity": "test",
                "job": "alertmanager"
            },
            "annotations": {
                "info": "This is a test",
                "summary": "This should chime daily at noon."
            },
            "endsAt": "ENDSAT",
            "generatorURL": "https://prometheus.sc.iweb.com/graph?g0.range_input=1h&g0.expr=alertmanager_alerts&g0.tab=0"
    
        }
    ]'
    endsAt="$(date --date="45 seconds" +%Y-%m-%dT%H:%M:%S.%N%:z)"
    alerts="$(sed "s/ENDSAT/${endsAt}/" <<<"${template}")"
    curl --data "${alerts}" http://prometheus02.private.deverteuil.net:9093/api/v1/alerts -s | grep -v success
    sleep 2
    curl --data "${alerts}" http://prometheus02.private.deverteuil.net:9093/api/v1/alerts -s | grep -v success


This is the cron job:

    0 12 * * * ~/src/dotfiles/scripts/send-test-alert.sh

This trick also requires it's own alert router in alertmanager.yml

    route:
      receiver: notify_email
      group_by: [job]
      routes:
        - match:
            severity: alert
          receiver: alert_email
          group_by: [job]
        - match:
            severity: test
          group_wait: 5s
          group_interval: 1m
          repeat_interval: 1m
          receiver: alert_email

The `severity: test` match sends alerts to the same receiver as
`severity: alert`, but duplicates are waited for a shorter period. The
repeat\_interval is also shorter should you need to test it.


# References

 * [Alertmanager client API](https://prometheus.io/docs/alerting/clients/)
 * [Alertmanager route configuration](https://prometheus.io/docs/alerting/configuration/#%3Croute%3E)

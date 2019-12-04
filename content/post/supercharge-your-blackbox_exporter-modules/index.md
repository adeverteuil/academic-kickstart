---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Supercharge your blackbox_exporter modules"
subtitle: ""
summary: "Using regexes to pass multiple parameters to each blackbox target."
authors: []
tags: ["sysadmin", "monitoring", "prometheus"]
categories: ["informatique"]
date: 2019-01-07
lastmod: 2019-01-07
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

I needed to measure DNS resolution performance
of two domains from two different locations
using three DNS resolvers at each location.

The [example configuration](https://github.com/prometheus/blackbox_exporter#prometheus-configuration)
demonstrates how to use Prometheus relabel configs
to pass multiple targets to one `blackbox_exporter`.
Two web search results (referenced below) hinted on using regexes
to pass more than one parameter for each target.
I did a little cleanup of the regex pattern
and used the `@` separator instead of `:`.
The resulting configuration is easy to follow and
can be adapted for other blackbox use-cases.

Each DNS query must be configured as separate modules in `blackbox.yml`.
The `blackbox.yml` content is copied on both blackboxes.

```yaml
modules:
  dns_udp_host1_cname:
    prober: dns
    timeout: 5s
    dns:
      preferred_ip_protocol: ip4
      query_name: "alias.example.com"
      query_type: "CNAME"
      valid_rcodes:
      - NOERROR
      validate_answer_rrs:
        fail_if_not_matches_regexp:
        - "alias.example.com.\t.*\tIN\tCNAME\thost.example.com."
  dns_udp_host1_a:
    prober: dns
    timeout: 5s
    dns:
      preferred_ip_protocol: ip4
      query_name: "host.example.com"
      query_type: "A"
      valid_rcodes:
      - NOERROR
      validate_answer_rrs:
        fail_if_not_matches_regexp:
        - "host.example.com.\t.*\tIN\tA\t.*"
```

This is what the `scrape_config` in `prometheus.yml` looks like:

```yaml
- job_name: dns_probes
  scrape_interval: 60s
  metrics_path: /probe
  static_configs:
    - targets:
      - blackbox1:9115@dns_udp_host1_cname@192.168.13.1:53
      - blackbox1:9115@dns_udp_host1_cname@ns1.example.com:53
      - blackbox1:9115@dns_udp_host1_cname@ns2.example.com:53
      - blackbox1:9115@dns_udp_host1_a@192.168.13.1:53
      - blackbox1:9115@dns_udp_host1_a@ns1.example.com:53
      - blackbox1:9115@dns_udp_host1_a@ns2.example.com:53
      - blackbox2:9115@dns_udp_host1_cname@8.8.8.8:53
      - blackbox2:9115@dns_udp_host1_cname@ns1.example.com:53
      - blackbox2:9115@dns_udp_host1_cname@ns2.example.com:53
      - blackbox2:9115@dns_udp_host1_a@8.8.8.8:53
      - blackbox2:9115@dns_udp_host1_a@ns1.example.com:53
      - blackbox2:9115@dns_udp_host1_a@ns2.example.com:53
  relabel_configs:
    - source_labels: [__address__]
      regex: '(.*)@.*@.*'
      replacement: $1
      target_label: 'instance'      # instance label for Prometheus datapoints
    - source_labels: [__address__]
      regex: '.*@(.*)@.*'
      replacement: $1
      target_label: __param_module  # module parameter to blackbox exporter
    - source_labels: [__address__]
      regex: '.*@(.*)@.*'
      replacement: $1
      target_label: module          # module label for Prometheus datapoints
    - source_labels: [__address__]
      regex: '.*@.*@(.*)'
      replacement: $1
      target_label: __param_target  # target parameter to blackbox exporter
    - source_labels: [__address__]
      regex: '.*@.*@(.*)'
      replacement: $1
      target_label: resolver        # resolver label for Prometheus datapoints
    - source_labels: [__address__]
      regex: '(.*)@.*@.*'
      replacement: $1
      target_label: __address__  # The blackbox exporter's real hostname:port.
```

This pattern of `@` separators, regexes and replacement string
is easy to read and expand to pass more labels or parameters.

To debug your DNS queries and validation, you can `curl` the following URL on your `blackbox_exporter`:

```plaintext
http://blackbox1:9115/probe?module=dns_udp_host1_a&target=ns1.example.com&debug=true
```


# References

Upstream documentation:

 * [blackbox_exporter](https://github.com/prometheus/blackbox_exporter)
 * `dns_udp_example` in [blackbox_exporter/example.yml](https://github.com/prometheus/blackbox_exporter/blob/master/example.yml)
 * `relabel_config` in [Prometheus documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config)

Ideas from community discussion:

 * GitHub issue #51 [Targeting multiple DNS records](https://github.com/prometheus/blackbox_exporter/issues/51)
 * [multiple blackbox_exporter modules with different targets](https://groups.google.com/forum/#!topic/prometheus-users/zTfTkUhIU7I)

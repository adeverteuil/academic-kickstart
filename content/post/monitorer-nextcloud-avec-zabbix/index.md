---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Monitorer Nextcloud avec Zabbix"
subtitle: ""
summary: "Monitorer la page de statut de Nextcloud avec une expression régulière"
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2016-08-15
lastmod: 2016-08-15
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

Nextcloud (et ownCloud aussi) sert une page de statut à des fins de monitorage.

* [Documentation officielle](https://docs.nextcloud.com/server/9/admin_manual/operations/considerations_on_monitoring.html)
* [Exemple sur mon instance de Nextcloud](https://nextcloud.deverteuil.net/status.php):
  ```
  {"installed":true,"maintenance":false,"version":"9.0.51.0","versionstring":"9.0.51","edition":""}
  ```

Zabbix peut tester des scénarios web complexes et comparer le contenu html des pages avec une expression régulière POSIX.

* Documentation Zabbix [Web monitoring](https://www.zabbix.com/documentation/2.2/manual/web_monitoring)
* Documentation Zabbix [Regular expressions](https://www.zabbix.com/documentation/2.2/manual/regular_expressions)
* [POSIX Regular expressions](https://en.wikipedia.org/wiki/Regular_expression#POSIX_extended) sur Wikipedia

Donc l'expression régulière à utiliser pour monitorer la page de statut de Nextcloud dans Zabbix est la suivante:

```plaintext
\{"installed":true,"maintenance":false,"version":"[[:digit:]\.]*","versionstring":"[[:digit:]\.]*","edition":""\}
```

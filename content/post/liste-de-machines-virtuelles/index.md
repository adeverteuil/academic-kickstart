---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Liste de machines virtuelles dans mon réseau"
subtitle: ""
summary: "Pour les gens qui demandent qu'est-ce que je fais avec 18 VM."
authors: []
tags: ["sysadmin", "créations"]
categories: ["informatique"]
date: 2016-08-12
lastmod: 2016-08-12
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

Pour les gens qui me demandent qu'est-ce que je fais avec 18 VM et je ne
me rappelle jamais par cœur.

1. `apt` — un dépôt de paquets pour mes programmes.
2. `backup` — mon script de backup (désservi par `apt`).
3. `dhcp`
4. `freeipa`
5. `home` — la machine qui reçoit les connexions ssh de l'Internet.
6. `mysql`
7. `nextcloud`
8. `nginx` — reverse proxy pour tous les services web auto-hébergés
9. `ns1`
10. `ns2`
11. `openvpn`
12. `pfSense` — bientôt deviendra mon routeur, je vais mettre le modem VDSL en mode *bridge*.
13. `postgresql`
14. `smtp`
15. `tor`
16. `unifi` — interface web de contrôle pour le point d'accès 802.11.
17. `web`
18. `zabbix`

Et pour finir, voilà deux photos de mon projet en cours. J'ai installé
le serveur, avec ses disques durs et le PSU. J'ai reçu ma commande de
câble Cat6 (1000 pieds) donc mettre de l'ordre là dedans sera la
prochaine étape.

{{< figure src="projet_reseau_20160811_1.jpg" title="Avancement de mon projet réseau maison avec le serveur nouvellement accroché au panneau au mur." lightbox="true" >}}

{{< figure src="projet_reseau_20160811_2.jpg" title="Vue rapprochée" lightbox="true" >}}

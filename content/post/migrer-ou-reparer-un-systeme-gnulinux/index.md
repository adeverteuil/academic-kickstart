---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Migrer ou réparer un système GNU/Linux"
subtitle: ""
summary: "Dans ce billet, je vais proposer des scénarios justifiant le recours à un disque d’amorçage comme SystemRescueCD, ainsi que partager mes trucs pour être efficace lors d’une intervention."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2014-12-08
lastmod: 2014-12-08
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

## Introduction

La séquence de démarrage d’un ordinateur est un processus complexe faisant intervenir de nombreux packages logiciels. Ils doivent fonctionner selon une séquence précise. Si un élément échoue, le PC est inutilisable et un autre support de démarrage devient nécessaire pour investiguer et réparer. Similairement, la migration d’un système &mdash; par exemple pour remplacer le disque dur &mdash; implique la reconstruction de la chaîne de démarrage.

Un bon disque d’amorçage (*live CD*) est un outil incontournable pour un propriétaire de PC. Dans ce billet, je vais proposer des scénarios justifiant le recours à un disque d’amorçage comme SystemRescueCD, ainsi que partager mes trucs pour être efficace lors d’une intervention.

## Scénarios

Les situations nécessitant le démarrage à l’aide d’un disque d’amorçage sont nombreuses et vous prendront souvent par surprise!

* Redimensionner les partitions avec gparted;
* Restaurer une sauvegarde;
* Récupérer un système qui ne démarre plus suite à une mise à jour bâclée;
* Réinitialiser le mot de passe root.
* Balayer une partition avec `fdisk -cc -k` pour recenser les secteurs défectueux (badblocks);
* Récupérer un fichier supprimé par erreur.

## Recommendation de disque d’amorçage

{{< figure src="sysresccd.png" >}}

J’ai toujours une copie de [SystemRescueCD](http://www.sysresccd.org/) à la portée de la main. C’est une distribution GNU/Linux à garder sur une clé USB ou un CD. Elle contient une grande quantité des meilleurs outils pour l’administration de système et accéder à Internet.

Le CD d’installation de votre distribution GNU/Linux peut également servir en second ressort.

## La séquence de démarrage

En résumé, lors du démarrage d’un système GNU/Linux, les logiciels suivants sont exécutés en chaîne.


1. Le microprogramme de la machine, souvent un **BIOS**, démarre à partir de la ROM. Il cherche le premier média bootable et exécute le code situé dans le MBR.
1. Le MBR (master boot record) ou la partition de démarrage d’un disque partitionné en GPT contient la **phase 1 de Grub**. Sa tâche consiste trouver la partition /boot du système et à charger la phase 2 de Grub.
1. Les 512 octets du MBR ne suffisent plus pour contenir un bootloader moderne. Donc on a une **phase 2 de Grub**. Celle-ci va charger le noyau Linux et l’initramfs en mémoire.
1. Le noyau **Linux** avec l’initramfs vont charger en mémoire les pilotes requis pour exploiter le matériel.
1. Le noyau va exécuter le **processus init** &mdash; systemd, SysVinit ou autre.
1. Init va démarrer les **services**, incluant un gestionnaire de session pour les utilisateurs.
1. L’utilisateur s’authentifie, une session s’ouvre et son **interface** de choix est chargé, que ce soit un interpréteur de commande ou un environnement graphique.

## Procédure de migration d’un système

Cette procédure peut être utilisée pour remplacer le disque dur ou bien récupérer une sauvegarde sans réinstaller le système d’exploitation et les programmes. Vous aurez besoin d’un disque d’amorçage tel que SystemRescueCD.

1. Booter un disque d’amorçage;
1. Partitionner et formater le nouveau disque dur (`cfdisk` et `mke2fs`);
1. Monter l’ancien et le nouvel emplacement;
1. Copier les données vers le nouvel emplacement;
   ```
   rsync -avH --progress src/ dest
   ```
1. Monter les systèmes de fichiers virtuels en *bind*. Ce petit *one-liner* est bon à savoir par cœur&nbsp;:
   ```
   for f in sys proc dev; do mount -o bind /$f ${mountpoint}/$f; done
   ```
   remplacez `${mountpoint}` par le chemin du point de montage du système de fichier de destination;
1. Chrooter dans le nouvel emplacement&nbsp;:
   ```
   chroot ${mountpoint}
   ```
1. Installer Grub&nbsp; sur le nouveau disque de démarrage avec `grub-install /dev/sd?`;
1. Regénérer la config&nbsp;: `grub-mkconfig -o /boot/grub/grub.cfg`;
1. Éditer la table de partition avec les nouveaux LABELs ou UUID des disques.
   ```
   vim /etc/fstab
   ```
1. Sortir de l’environnement chroot et redémarrer le système.

## Pour en apprendre plus

* [How Grub boots](http://www.sysresccd.org/Sysresccd-Partitioning-EN-Grub-boot-stages) de sysresccd.org.
* [Arch Linux boot process](https://wiki.archlinux.org/index.php/Arch_boot_process) de archlinux.org.
* [Linux startup process](http://en.wikipedia.org/wiki/Linux_startup_process) de wikipedia.org.

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Exercisse de restauration d'une sauvegarde"
subtitle: ""
summary: "Toute sauvegarde qui n'est pas vérifiée n'a pas de valeur! Voici comment j'ai vérifié la fidélité de ma sauvegarde de système."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2011-08-28
lastmod: 2011-08-28
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

## préface

Tout d'abord, je vous présente mon système&nbsp;:

```plaintext
$ uname -a
Linux electron 3.0-ARCH #1 SMP PREEMPT Wed Aug 17 21:55:57 CEST 2011 x86_64 AMD Phenom(tm) II X4 955 Processor AuthenticAMD GNU/Linux
```

C'est un vaillant *ArchLinux* 64 bits affectueusement nommé
*electron*, amené à la vie par un CPU AMD PhenomII à quatre
coeurs. Mon système est sauvegardé par incréments horaires avec
`rsync` et un script *python* fait maison sur un disque dur
externe. J'ai aussi une sauvegarde hors-site à base de `dar`
sur support DVD mais il ne contient que mes données personnelles et ne
permet pas de restaurer un système bootable. Le présent article traite
de ma sauvegarde de système complet.

## /préface

La sagesse en informatique est de sauvegarder ses données de façon
régulière, localement **et** hors site. Toute donnée qui n'est pas
sauvegardée n'a aucune valeur. Toutefois, toute sauvegarde qui n'est
pas vérifiée n'a pas davantage de valeur! En fin de semaine, j'ai
procédé à un exercisse post-catastrophe. J'ai débranché mon disque
dur principal pour voir si je pouvais récupérer mon système à
partir de mon disque de sauvegarde vers mon disque secondaire. J'ai
dû surmonter quelques imprévus et j'ai appris de quelques erreurs
pour éventuellement arriver à démarrer dans un clone réussi de mon
système.

Le but de cet article est d'énumérer les connaissances
requises, quantifier le travail impliqué, fournir un exemple concret
et prouver que mon backup est meilleur que le tien.

{{< figure src="sata.jpg" >}}

Tout d'abord, j'ai booté mon loyal
[SystemRescueCD](http://www.sysresccd.org/)
et fait face à une première réalité&nbsp;: ça fais longtemps que
je n'ai pas partitionné un disque. C'est probablement une question
de le pratiquer plus souvent. Je vérifie l'espace requis pour les
partitions root, home et boot. Je monte `/dev/sda2` à
`/mnt/electron` (`electron`, c'est mon hostname),
je `mkdir /mnt/electron/{boot,home,proc,sys,dev}` puis monte
les systèmes de fichiers restants&nbsp;:

```plaintext
# mount /dev/sda1 /mnt/electron/boot
# mount /dev/sda3 /mnt/electron/home
# mount -t sysfs /sys /mnt/electron/sys
# mount -t proc /proc /mnt/electron/proc
# mount -o bind /dev /mnt/electron/dev
```

Ensuite viens le temps de lancer la commande `rsync`. Je
suis fier d'avoir pensé à monter mon disque de sauvegarde en lecture
seule. Ça n'a fait aucune différence mais le potentiel d'erreur
irréversible était là. Bof, j'avais quand même débranché mon
disque dur principal mais il vaut mieux ajouter cette précaution
dans ma liste de vérification pour une éventuelle restauration
réelle. J'omets mon dossier *mm* qui contient musique, vidéos
et photos. Je veux un système bootable le plus vite possible et je
pourrai toujours transférer ces données en arrière plan plus
tard.

```plaintext
# rsync -av --exclude "home/alex/mm" /mnt/backup/electron/hourly.01/ /mnt/electron
```

Beaucoup de temps et de lignes de terminal passèrent. Une fois
les fichiers copiés, il reste à installer `grub` dans
le *MBR*. La façon la plus facile que j'ai trouvée est de
`chroot`er dans le système de fichier restauré et de lancer
la console interactive `grub`. C'est la raison pour
laquelle j'ai monté les systèmes de fichier `/proc`,
`/sys` et `/dev` dans leur sous-dossier de
`/mnt/electron` respectifs. Par contre, il se trouve que le
noyau par défaut de *SystemRescueCD* est 32 bits alors que mon
système est compilé à 64 bits. Je redémarre donc en prenant soin
cette fois de sélectionner l'option 64 bits du menu de démarrage de
*SystemRescueCD* et remonte tous les systèmes de fichiers. Je
lance ensuite les commandes&nbsp;:

```plaintext
# chroot /mnt/electron /bin/bash
[~]# grub
grub> find /grub/stage1
grub> root (hd0,0)
grub> setup (hd0)
grub> quit
[~]# exit
#
```

Ce qui précède est grossièrement abrégé car de
la documentation détaillée est disponible sur le
[wiki de Archlinux](https://wiki.archlinux.org/index.php/Grub#Bootloader_installation)
et sur
[les forums Ubuntu](http://ubuntuforums.org/showthread.php?t=24113)
Des ajustements à `/mnt/electron/etc/fstab` et à `/mnt/electron/boot/grub/menu.lst`
sont requis et le système est prêt à booter.

{{< figure src="awesomeness_acheived.jpg" >}}

## En résumé

Les prérequis absolus pour réussir l'exercisse sont&nbsp;:

1. une sauvegarde de tout sauf `/proc`, `/sys` et `/dev` car ceux-ci sont générés automatiquement par le système d'exploitation
2. un disque de démarrage de secours tel que *SystemRescueCD* ou celui de votre système d'exploitation

Les étapes suivies sont&nbsp;:

1. Démarrer dans un environnement avec la même architecture (32 ou 64 bits) que le système sauvegardé;
2. Refaire une table de partition sur le nouveau disque dur;
3. Créer les systèmes de fichiers de destination;
4. Créer les dossiers proc, sys, dev, boot et home;
5. Monter les systèmes de fichier de destination;
6. Monter le système de fichier source en lecture seule;
7. Copier les données;
8. Dans un environnement `chroot`, installer le *bootloader* dans le *MBR*;
9. Ajuster `etc/fstab` et `boot/grub/menu.lst`;
10. Redémarrer

## Ressources additionnelles

* [SystemRescueCD](http://www.sysresccd.org/)
* `man rsync`</li>
* [Backing up Linux and other Unix(-like) systems](http://www.halfgaar.net/backing-up-unix)
* [Easy Automated Snapshot-Style Backups with Linux and Rsync](http://www.mikerubel.org/computers/rsync_snapshots/)
* [Bare Metal Recovery](http://www.charlescurley.com/Linux-Complete-Backup-and-Recovery-HOWTO.html)
* [dar](http://dar.linux.free.fr/)
* [Torture-testing Backup and Archive Programs: Things You Ought to Know But Probably Would Rather Not ](http://www.coredumps.de/doc/dump/zwicky/testdump.doc.html)

## Conclusion

Suite à cet exercisse, je réalise que l'implémentation et
l'entretien d'une routine de sauvegarde ne représente que la
moitié du travail. Il est nécessaire de pratiquer la restauration
de la sauvegarde régulièrement et avec différents scénarios de
handicap. Il existe **énormément** de matériel et d'outils
sur le web pour la sauvegarde de données. Tous, ou presque,
mentionnent l'absolue nécéssité de tester et de vérifier ses
sauvegardes. Je n'ai trouvé quasiment rien sur ce à quoi ressemble
une restauration de système.

À chaque méthode de sauvegarde sa restauration réciproque. Une
sauvegarde d'une image (i.e. ghost) serait plus facile et rapide,
mais j'ai fait le choix conscient d'avoir une sauvegarde horaire par
incrément.

Je suis certain d'avoir oublié plein d'éléments. Suite au
démarrage dans mon système cloné, j'ai testé la résautique,
incluant le VPN, le serveur X, le son. Il serait pertinent d'établir
une liste de vérification des fonctionnalités pouvant avoir été
affectées par la migration des données. Chaque pratique de
restauration m'apportera des connaissances précieuses.

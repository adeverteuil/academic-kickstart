---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Séparation et sécurité des disques de sauvegarde"
subtitle: ""
summary: "Dans cet article, j’explique comment j’accomplis la séparation et la sécurité des données de sauvegarde."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2015-02-03
lastmod: 2015-02-03
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

## Tao

Révisons les qualités d’une sauvegarde&nbsp;: couverture, fréquence, séparation, historique, vérification, sécurité, intégrité. Dans cet article, j’explique comment j’accomplis la séparation et la sécurité avec deux disques et de l’encryption.

Pour plus de détails sur les qualités d’une sauvegarde, je recommande fortement la lecture de [The Tao of Backup](http://www.taobackup.com/).

## Séparation

Il est crucial qu’une sauvegarde soit sur un disque dur autre que celui qui contient les données à sauvegarder. Mais en plus, il faut s’assurer d’une suffisante séparation géographique pour éviter qu’un sinistre ne détruise simultanément les données et la sauvegarde.
J’ai deux disques durs de sauvegarde. En tout temps, un des disques est *live* et y est écrit périodiquement. L’autre est hors-ligne et hors-site, rangé sur mon lieu de travail. Quelques fois par année, je fais la rotation des disques. Je ramène ma sauvegarde du travail à la maison, et celle qui était *live* est amenée au travail.

Un bénéfice secondaire de cette stratégie est qu’elle double l’historiques de mes sauvegardes.

### Bind mount

Une autre stratégie employée pour le principe de séparation est le montage du disque de sauvegarde en lecture et écriture dans un répertoire accessible à root seulement. Le système de fichiers est ensuite monté en bind en lecture seule pour la consultation. Pour les détails de cet arrangement, consultez le [dépôt git de mon script de backup](https://github.com/adeverteuil/backup/blob/master/backup.1.rst#convention-over-configuration) sur GitHub.

## Sécurité

La sécurité des données et des sauvegardes est une guerre sur plusieurs fronts. Je présume que vous avez déjà des bonnes pratiques en sécurité réseau et beaucoup d’articles sont déjà écrits sur le sujet. Sur le plan de la sécurité physique, je crois qu’une des premières mesures à prendre est l’encryption des partitions de disques. Ainsi, même en cas d’accès physique aux disques durs, un voleur ou un espion ne pourra pas accéder aux données à moins d’avoir les moyens financiers d’une organisation gouvernementale.

Le standard pour l’encryption de disques sur Linux est LUKS (Linux Unified Key Setup).

### Préparation les disques de sauvegarde

On suit ces étapes pour les 2 disques. On commence par écrire des données aléatoire sur l’ensemble du disque, puis créer une partition qui occupera la totalité de l’espace disponible.

```plaintext
# cryptsetup open --type plain /dev/sdX container
# dd if=/dev/zero of=/dev/mapper/container
# cryptsetup close container
# cfdisk /dev/sdX
```

La couche d’encryption temporairement créée procurera la source des données pseudo-aléatoires. Il n’est donc pas nécessaire d’utiliser `/dev/urandom`.

Ensuite, on crée la partition LUKS. Pour éviter d’avoir à saisir une *passphase* à chaque démarrage, on va créer des clés de chiffrement et les enregistrer en clair dans un répertoire protégé en lecture.

*Important*&nbsp;: il faut tout de même enregistrer une version de la clé protégée par une *passphrase* dans l’entête LUKS au cas où les clés seraient illisibles ou corrompues. Ainsi, si notre disque de données meurt, les données sur les disques de sauvegarde ne tombent pas avec lui. Un détail non négligeable!

```plaintext
# dd bs=1024 count=1 if=/dev/urandom of=/root/lib/crypt/disk_backups.key iflag=fullblock
# dd bs=1024 count=1 if=/dev/urandom of=/root/lib/crypt/disk_backups2.key iflag=fullblock
# cryptsetup luksFormat /dev/sdX1
Enter passphrase: <password>
Verify passphrase: <password>
# cryptsetup luksAddKey /dev/sdX1 /root/lib/crypt/disk_backups.key
Enter passphrase: <password>
Verify passphrase: <password>
```

Maintenant on crée le système de fichiers sur la partition chiffrée.

```plaintext
# cryptsetup --key-file /root/lib/crypt/disk_backups.key open --type luks /dev/sdX1 backups
# cryptsetup --key-file /root/lib/crypt/disk_backups2.key open --type luks /dev/sdY1 backups2
# mke2fs -L backups /dev/mapper/backups
# mke2fs -L backups2 /dev/mapper/backups2
```

### Configuration du système

Le fichier `/etc/crypttab` dit au système comment déchiffrer les partitions au démarrage.

```plaintext
# /etc/crypttab
backups   /dev/disk/by-uuid/83b124a4-826e-4aa5-8e72-a540631cfea3  /root/lib/crypt/disk-backups.key   nofail
backups2  /dev/disk/by-uuid/e0bd582e-b64f-45c8-9c79-b4539bcb0039  /root/lib/crypt/disk-backups2.key  nofail
```

Et les 2 lignes suivantes vont dans `/etc/fstab`.

```plaintext
# /etc/fstab
#LABEL=backups /root/var/backups ext3 rw,noexec,nouser,async,nodev,noauto,nosuid,nofail,x-systemd.automount 0   2
LABEL=backups2 /root/var/backups ext3 rw,noexec,nouser,async,nodev,noauto,nosuid,nofail,x-systemd.automount 0   2
```

Une des deux lignes est commentée pour éviter que le point de montage d’un système de fichiers ne soit écrasé par un autre lorsqu’ils sont connectés en même temps. Il faut manuellement changer la ligne commentée lorsque la rotation des disques est effectuée.

### Rotation des disques

1. Interrompre le script de sauvegarde;
   ```plaintext
   # systemctl stop backup.timer
   # systemctl stop backup
   ```
1. Démonter le système de fichiers;
   ```plaintext
   # systemctl stop var-backups.automount
   # systemctl stop var-backups.mount
   # systemctl stop root-var-backups.automount
   # systemctl stop root-var-backups.mount
   ```
1. Changer la ligne commentée dans `/etc/fstab`;
   ```plaintext
   # vim /etc/fstab
   ```
1. Dire à systemd de relire le fichier `/etc/fstab`;
   ```plaintext
   # systemctl --daemon-reload
   ```
1. *Hotswapper* les disques;
1. Redémarrer le script de sauvegarde;
   ```plaintext
   # systemctl start root-var-backups.automount
   # systemctl start var-backups.automount
   # systemctl start backup.timer
   ```

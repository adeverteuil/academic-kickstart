---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Compresser une image de disque"
subtitle: ""
summary: "Expérience en compression d'image de disque."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2015-10-31
lastmod: 2015-10-31
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

Je veux changer l'OS sur ma machine au travail mais par bonne habitude je vais commencer par copier l'image du disque avant d'écraser les données. Par contre je trouve que 120 Go c'est lourd et je vais voir si je peux compresser ça au maximum, tout en gardant la copie au niveau du *block device*. C'est sûr qu'une sauvegarde du système de fichiers prendrait moins d'espace mais il y aurait une perte d'information en passant de HFS+ à ext2/3/4.

Voici mon plan&nbsp;:

1. Libérer de l'espace. Supprimer les téléchargements, les fichiers temporaires, les caches, les logiciels que je n'ai pas besoin et vider la corbeille.
1. Prendre la mesure de l'espace disque utilisé
1. Démarrer sur une clé USB avec Ubuntu
1. Copier l'image du disque sur un autre système
1. Redémarrer OS X
1. Écrire un fichier avec `dd if=/dev/zero of=/zero` jusqu'à ce que le disque soit plein.
1. Supprimer `/zero`
1. Démarrer encore sur une clé USB avec Ubuntu
1. Copier les quelques documents que je veux conserver (la majorité est synchronisé en ligne).
1. Transférer la deuxième image du disque sur un autre système
1. Compresser le disque, en espérant que tous les octets zérotés "disparaissent", laissant une image qui ne prend pas plus d'espace que la taille du système de fichiers qu'il contient


<p>Afin de mesurer le gain scientifiquement, je vais faire deux copies de l'image du disque. Une fois avant d'écrire <code>/zero</code> et une fois après. Je vais ensuite compresser les deux images et comparer leur tailles.</p>

<h2>Données de départ</h2>

<p>Taille du disque&nbsp;: 120&nbsp;034&nbsp;123&nbsp;264&nbsp;octets (120&nbsp;Go).<br />
Espace utilisé&nbsp;: 45&nbsp;042&nbsp;335&nbsp;744&nbsp;octets (45&nbsp;Go).<br />
Espace utilisé après le ménage&nbsp;: 23&nbsp;937&nbsp;101&nbsp;824&nbsp;octets (23,9&nbsp;Go).</p>

<p>Les deux machines sont sur un LAN 100&nbsp;Mbps et ont une puissance de traitement similaire &mdash; quatre cœurs, 3,1&nbsp;GHz <i>vs</i> 3,2&nbsp;GHz.</p>

<h2>Commandes utilisées pour le transfert</h2>

<h3>Image contrôle</h3>

<p>Sur la machine source&nbsp;:<br />
<code>sudo dd if=/dev/sda | nc 192.168.13.20 8080</code></p>

<p>Sur la machine de destination&nbsp;:<br />
<code>nc -l -p 8080 | pv | gzip > MacMini.raw.gz</code></p>

<p>Ça a pris 2&nbsp;h 50&nbsp;m à 11.2&nbsp;Mio/s</p>

<h3>Zérotage des blocs inutilisés</h3>

<pre><span class="prompt">$</span> sudo dd if=/dev/zero of=/zero
Password:
dd: /zero: No space left on device
186046745+0 records in
186046744+0 records out
95255932928 bytes transferred in 574.286639 secs (165868273 bytes/sec)</pre>

<p>92&nbsp;Go ont été écrits en moins de 10 minutes (c'est un SSD).</p>

<h3>Image expérimentale, compression sur la machine destination</h3>

<p>Sur la machine source&nbsp;:<br />
<code>sudo dd if=/dev/sda | nc 192.168.13.20 8080</code></p>

<p>Sur la machine de destination&nbsp;:<br />
<code>nc -l -p 8080 | pv | gzip > MacMiniZeroed.raw.gz</code></p>

<p>Ça a pris 2&nbsp;h 50&nbsp;m à 11.2&nbsp;Mio/s comme le précédent</p>

<h3>Image expérimentale, compression sur la machine source</h3>

<p>Sur la machine source&nbsp;:<br />
<code>sudo dd if=/dev/sda | gzip | nc 192.168.13.20 8080</code></p>

<p>Sur la machine de destination&nbsp;:<br />
<code>nc -l -p 8080 | pv > MacMiniZeroed.raw.gz</code></p>

<p>Ça a pris 32 minutes à 6,25&nbsp;Mio/s pour transférer 11,9&nbsp;Gio.</p>

<h2>Résultat</h2>

<p>Voici la comparaison de la taille des images. L'image contrôle est compressée avec gzip. L'image expérimentale est du même disque de stockage compressé avec gzip contenant le même système de fichier mais les blocs inutilisés ont été écrits avec des zéros pour une compressibilité maximale.

<p>Contrôle&nbsp;: 80&nbsp;872&nbsp;770&nbsp;328&nbsp;octets (80,9&nbsp;Go)<br />
Expérience&nbsp;: 12&nbsp;764&nbsp;953&nbsp;094&nbsp;octets (12,8&nbsp;Go)</p>

<h2>Conclusion</h2>

<h3>Vitesse de transfert</h3>

<p>Sur un réseau 100&nbsp;Mbps, lorsque la compression se fait sur la machine de destination, la vitesse de transfert était le goulot d'étranglement.</p>
<p>Lorsque la compression se fait sur la machine source, la vitesse de transfert n'est pas maximale mais la quantité de données à transférer est diminuée et le processus est beaucoup plus efficace.</p>

<h3>Taille de l'image</h3>

<p>L'image du disque de 120&nbsp;Go se compresse en 80,9&nbsp;Go, un ratio de 67&nbsp;% par rapport au disque, mais 338&nbsp;% par rapport au système de fichiers.</p>
<p>Après avoir écrit des zéros sur l'espace inutilisé du disque, l'image prend 12,8&nbsp;Go, un ratio de 10,6&nbsp;% par rapport au disque, 53,5&nbsp;% par rapport au système de fichier, et 15,8&nbsp;% par rapport au contrôle.</p>

<h3>Temps d'écriture des zéros</h3>

<p>Le disque source étant un SSD, le temps requis pour écrire des zéros sur l'espace inutilisé est petit. Pour comparer avec un disque tournant, j'ai écris un fichier de 92&nbsp;Go de zéros sur le disque de la machine destination. Le temps requis a été de 26 minutes <i>versus</i> moins de 10 minutes sur un SSD.</p>

<h3>Nouvelles connaissances</h3>

<p>À l'avenir lorsque j'aurai une image ou un clone de disque à faire et à transférer par réseau, je n'hésiterai pas à écrire un fichier avec des zéros (si possible) et à compresser le flux sur la machine source.</p>

<h3>Commentaires, questions</h3>

<p>N'hésitez pas à m'envoyer un courriel ou à me tweeter&nbsp;: <a href="https://twitter.com/SystemPk/status/660531388211441664">@SystemPk</a>.

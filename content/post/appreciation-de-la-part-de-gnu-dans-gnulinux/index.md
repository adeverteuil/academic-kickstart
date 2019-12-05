---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Appréciation de la part de GNU dans GNU/Linux"
subtitle: ""
summary: "Combien y a-t-il de GNU dans un système GNU/Linux?"
authors: []
tags: ["sysadmin", "foss"]
categories: ["informatique"]
date: 2014-10-24
lastmod: 2014-10-24
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

Je suis intéressé au [débat](http://en.wikipedia.org/wiki/GNU/Linux_naming_controversy) entourant le nom qu’on devrait appeler un système d’exploitation composé du noyau Linux et de logiciels du projet GNU et d’autres projets. Je n’ai pas d’opinion très forte, mais j’ai tendance à vouloir aider Richard Stallman à promouvoir la philosophie du logiciel libre en m’efforçant d’appeler mon système GNU/Linux, pas seulement Linux.

Pour prendre un peu de perpective et satisfaire une curiosité, j’ai décidé de comparer la taille relative des paquetages provenant du projet GNU avec la taille du paquetage Linux et celle des autres paquetages. Cet exercice a déjà été fait de manière plus approfondie ([Wheeler, David A. 2001](http://www.dwheeler.com/sloc/redhat71-v1/redhat71sloc.html); [Côrte-Real, Pedro 2011](http://pedrocr.pt/text/how-much-gnu-in-gnu-linux/)), j’en ai donc fait une version très simple.

Je crois qu’ArchLinux est un bon choix de distribution GNU/Linux pour ce test parce l’installation de base contient le strict nécessaire pour démarrer et fournir un environnement d’exécution POSIX. Incidemment, je veux connaître la part de GNU dans le système d’exploitation, excluant les applications destinées à l’utilisateur.

## Méthode

J’ai écris un script en Python pour analyser la liste détaillée d’un système ArchLinux produite avec `pacman -Qi`. Dans un premier temps, j’ai analysé mon système principal. J’ai ensuite analysé un système fraîchement installé dans une machine virtuelle et uniquement composée des paquetages du groupe «&nbsp;base&nbsp;» plus Grub.

La taille mesurée est le nombre d’octets occupés par le paquetage installé (le champ «&nbsp;Installed Size&nbsp;»).

## Résultats

### Ma machine principale

{{< figure src="pacman_machine_principale.png" >}}

| Catégorie | Taille ([Mio](http://fr.wikipedia.org/wiki/Octet#Multiples_normalis.C3.A9s)) | %            |
|-----------|------------------------------------------------------------------------------|--------------|
| GNU       | 572,64                                                                       | 9,26&nbsp;%  |
| Non-GNU   | 5&nbsp;538,34                                                                | 89,58&nbsp;% |
| Linux     | 71,49                                                                        | 1,16&nbsp;%  |

Parmi les paquetages volumineux installés sur cette machine, on a Libre Office, Wine, Popcorntime, Firefox, etc. Il y a un total de 1117 paquetages, dont 74 (6,63&nbsp;%) sont du projet GNU. Il y a des logiciels GNU ne faisant pas partie du système d’exploitation et qui amplifient la part de GNU par rapport à Linux (Gimp, Emacs). Il y a 8,01 octets GNU pour 1 octet Linux.

### Une installation de base d’Arch Linux

{{< figure src="pacman_archlinux_base.png" >}}

| Catégorie | Taille ([Mio](http://fr.wikipedia.org/wiki/Octet#Multiples_normalis.C3.A9s)) | %            |
|-----------|------------------------------------------------------------------------------|--------------|
| GNU       | 149,07                                                                       | 31,38&nbsp;% |
| Non-GNU   | 254,56                                                                       | 53,58&nbsp;% |
| Linux     | 71,49                                                                        | 15,05&nbsp;% |

Cette installation minimale comporte 119 paquetages, dont 31 (26,05&nbsp;%) du projet GNU. On remarque la plus faible taille absolue de la catégorie GNU dans cette machine par rapport à la précédente. Il y a 2,09 octets GNU pour 1 octet Linux.

## Analyse

À entendre Richard Stallman insister sur l’importance relative de GNU par rapport à Linux, je suis surpris que Linux et les autres logiciels non-GNU occupent une proportion aussi importante du système de base. Il ne faut surtout pas voir cela comme une raison de ne pas mentionner GNU. GNU a une importance historique et éthique. Il évoque les libertés accordées à l’utilisateur comme nulle autre marque ne le fait.

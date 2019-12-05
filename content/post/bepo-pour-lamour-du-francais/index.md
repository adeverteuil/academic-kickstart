---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Bépo pour l'amour du français"
subtitle: ""
summary: "Compte rendu de mon apprentissage de la disposition de clavier Bépo."
authors: []
tags: []
categories: ["informatique"]
date: 2014-12-02
lastmod: 2014-12-02
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

J’étais en session d’introduction à OpenStreetMap avec Pierre «&nbsp;Peuc&nbsp;» Choffet. En saisissant «&nbsp;Villeray–St-Michel–Parc-Extension&nbsp;» sur le clavier de son portable, je lui ai demandé plus ou moins consciemment s'il était possible de saisir le [tiret demi-cadratin](http://fr.wikipedia.org/wiki/Tiret#Tiret_moyen) avec cette interface. À ma grande surprise, il savait exactement ce dont je parlais…

## Qu’est-ce que le Bépo?

Pour bien écrire le français à la machine, il faut bien plus que les 105 touches de son clavier (104 en format état-unien). Les caractères accentués, les signes de ponctuation et les symboles typographiques sont obligatoires et nécessitent des combinaisons et des séquences de touches ou des outils logiciels.

Avant Bépo, j’utilisais les digraphes de vim, l’auto-correcteur de LibreOffice, la touche compose d’X Window.

Pierre m’a présenté le Bépo, une disposition de clavier ergonomique française sur la même idée que le Dvorak pour les anglophones. La conception se concentre sur l’ergonomie, s’appuie sur une analyse statistique de la langue française, tient compte des caractères utilisés en programmation informatique et est mis à disposition sous licence libre (CC-by-sa).

J’ai adopté presque du jour au lendemain la disposition de clavier Bépo.

{{< figure src="bépo_simplifiée.svg" caption="Image récupérée de [http://bepo.fr/wiki/Fichier:Bepo-1.0_nemo_BR102-simplifiee.svg](http://bepo.fr/wiki/Fichier:Bepo-1.0_nemo_BR102-simplifiee.svg)" >}}

## Apprentissage

L’apprentissage de la disposition des touches de base a pris une semaine. J’ai utilisé l’application en ligne [Bépodactyl](http://tazzon.free.fr/dactylotest/bepodactyl/). Lorsqu’on apprends une disposition de clavier basée sur une étude statistique de la langue, on arrive très rapidement à des exercices constitués de phrases compréhensibles (leçon 3&nbsp;: «&nbsp;sirius statue et nina sursaute&nbsp;»).

Deux mois plus tard, ma vitesse de frappe tourne autour de 30 mots à la minute. C’est toujours plus lent que les 40 mots à la minute que j’atteignais avec le qwerty, mais ça continue de progresser.

## Configuration sur Arch Linux

Pour configurer mon serveur X Window, je me suis basé sur [l’exemple](http://bepo.fr/wiki/GNU/Linux_et_Unix_libres#Basculement_de_disposition_.C3.A0_la_vol.C3.A9e) du site de Bépo, mais j’ai modifié le clavier azerty pour le canadien français&nbsp;:

```
Section "InputClass"
    Identifier      "Keyboard layouts"
    MatchIsKeyboard "yes"
    Option          "XkbLayout"  "ca,fr"
    Option          "XkbVariant" ",bepo"
    Option          "XkbOptions" "compose:rwin,grp:shift_toggle,grp_led:scroll"
EndSection
```

Voici une explication des `XkbOptions`&nbsp;:

`compose:rwin`
: Activer la [touche compose](http://fr.wikipedia.org/wiki/Touche_compose) lorsque j'appuie sur <kbd>rwin</kbd> (c.-à-d. la touche <kbd>Super</kbd>/<kbd>Méta</kbd>/<kbd>Windows</kbd> de droite). La touche compose est utile peu importe la disposition de clavier.

`grp:shift_toggle`
: En appuyant sur les deux touches <kbd>Shift</kbd> en même temps, je bascule entre les dispositions de clavier canadien-français et français-variante-bépo.

`grp_led:scroll`
: Lorsque je suis en mode Bépo, la DEL «&nbsp;Arrêt défilement&nbsp;» du clavier s’illumine.

Pour de plus amples renseignements, voir `man 5 xorg.conf`. Les valeurs acceptées pour les options `XkbLayout`, `XkbVariant` et `XkbOptions` sont disponibles dans le fichier `/usr/share/X11/xkb/rules/base.lst`.

## Inconvénients

Un des problèmes avec la disposition qwerty est la surcharge de la main gauche par rapport à la main droite. Cela a pourtant un effet secondaire bénéfique qui est perdu avec bépo. Les raccourcis du clavier <kbd>ctrl&nbsp;+&nbsp;c</kbd> et <kbd>ctrl&nbsp;+&nbsp;v</kbd> ne peuvent plus être (facilement) exécutés d’une main pendant que la main droite est sur la souris.

En tant qu’analyste support technique, je dois toujours utiliser la configuration de clavier des utilisateurs que je supporte. Or je dois dorénavant regarder le clavier lorsque je tape en qwerty, ce qui me fait paraître pas mal moins ninja.

## Pour en savoir plus

Visitez le site web de Bépo au [bepo.fr](http://bepo.fr/).

## Amendement
### 2015-01-18

Bien que j’aie été attiré par le design efficace de la disposition Bépo et que j’en aie fait l’expérience concluante, j’ai choisi de revenir à la disposition qwerty canadien-français. Je pense que le Bépo conviendrait à une personne qui écrit de longues proses en français et ne change pas fréquemment d’ordinateur.

Voici quelques réflexions *a posteriori*&nbsp;:

* Lors de l’administration d’un serveur par RDP, la disposition du clavier Bépo ne suit pas;
* Qwerty est bien testé dans toute application;
* Les touches de raccourci de certaines applications sont basés sur le *keycode* et non le caractère;
* La touche «&nbsp;compose&nbsp;» permet de taper tous les caractères manquants sur la disposition canadien-français;
* Dans une équipe de soutien technique, on va souvent taper sur le clavier d’un collègue pour toutes sortes de raisons;
* J’écris autant en français qu’en anglais qu’en langages de programmation.

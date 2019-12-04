---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Nouveau blogue!"
subtitle: ""
summary: "Billet de blogue annonçant mon site web redessiné."
authors: []
tags: ["création"]
categories: ["informatique"]
date: 2014-09-24
lastmod: 2014-09-24
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

<h2>Intro</h2>
<p>Ça fait deux semaines que mon nouveau blogue est en ligne mais je voulais quand même faire une annonce «&nbsp;officielle&nbsp;». Merci à mes amis et ma famille pour les commentaires et suggestions.</p>

<h2>Ce que je n'aimais pas de l'ancien design</h2>
<h3>La page d'accueil et le style du site</h3>
<p>Le thème de couleur était trop froid. La page d'accueil n'avait pas de structure ni de texte de présentation convenable. Les badges «&nbsp;xhtml valide&nbsp;» étaient laides. La police de caractères utilisée pour le corps du texte était trop petite. La largeur du contenu et son positionnement à gauche donnait l'impression que tout était tassé lorsque vu sur un gros moniteur. Ma photo sur chaque page était superflue.</p>
<p>Je connaîs les grands principes de la typographie. J'aime faire la mise en page et la mise en forme de documents imprimés. Je crois que ça devrait se réfléter sur mon site web, ce qui n'était pas du tout le cas.</p>
{{< figure src="screenshot ancien site web.png" title="Capture d'écran de la page d'accueil de mon ancien site web, septembre 2014." lightbox="true" >}}
<h3>Le moteur de blogue</h3>
<p>Publier un billet était assez laborieux. Il fallait écrire un fichier texte et regénérer le site au complet puis l'uploader car il était en HTML statique. Je n'aimais pas que l'index de blogue soit paginé avec les articles tronqués. Les boutons pour avancer et reculer les pages étaient trop petits.</p>
<h3>La SEO*</h3>
<p>La description des pages dans les résultats de recherche sur Google ou DuckDuckGo étaient peu invitants. Je m'assure maintenant que chaque page ait une description convenable dans une balise <code>&lt;meta&gt;</code>.</p>
<p>* Search engine optimisation</p>

<h2>Le nouveau design</h2>
<p>J'ai commencé par designer mon site pour <a href="https://fr.wikipedia.org/wiki/Lynx_%28navigateur%29">Lynx</a>. Ça m'a obligé à me concentrer sur la structure du site avant les détails visuels, et ça m'a également assuré de respecter la «&nbsp;nature&nbsp;» du Web comme médium. Le travail de mise en forme et le CSS ne sont venus qu'à la fin. J'ai suivi le précepte de «&nbsp;<i>convention over configuration</i>&nbsp;» en déviant le moins possible des standards du framework Django. La sémantique du HTML5 est respectée de sorte qu'aucun effort spécifique pour le SEO ne soit requis.</p>
<h3>Caractéristiques</h3>
<ul>
<li>Je suis très heureux du look uniforme, minimal, un peu sérieux mais sans prétention;</li>
<li>Les modèles et les <i>templates</i> simples donnent un code HTML pur et lisible;</li>
<li>Superbe rendu dans lynx;</li>
<li>Une belle présentation de texte informatique.</li>
</ul>

<h2>Technologie</h2>
<ul>
<li><a href="https://www.linode.com/">Linode</a> &mdash; mon site est hébergé sur une machine virtuelle louée chez Linode. Anciennement, j'employais <a href="https://www.nearlyfreespeech.net/">NearlyFreeSpeech.net</a> que je recommande fortement mais qui ne supporte malheureusement pas Django.</li>
<li><a href="https://www.archlinux.org/">ArchLinux</a> &mdash; un argument de vente important de Linode est la possibilité de choisir ma saveur du système d'exploitation GNU/Linux préférée.</li>
<li><a href="https://www.archlinux.org/">Apache</a> &mdash; la colonne vertébrale du Web aujourd'hui.</li>
<li><a href="https://www.djangoproject.com/">Django</a> &mdash; le framework de site web qui se décrit comme «&nbsp;<i>a high-level Python Web framework that encourages rapid development and clean, pragmatic design</i>.&nbsp;» Mon site est assez simple et je n'ai pas installé d'applications Django, j'ai développé un simple moteur de blogue et étendu l'application <code>flatpages</code> inclus avec le framework.</li>
<li><a href="http://www.postgresql.org/">PostgreSQL</a> &mdash; la base de données.</li>
<li><a href="http://html5boilerplate.com/">HTML5 Boilerplate</a> &mdash; une merveilleuse collection de code HTML et CSS, un concentré de l'effort et de l'expérience collective de centaines de développeurs Web.</li>
</ul>

<h2>Inspirations</h2>
<ul>
<li><a href="http://motherfuckingwebsite.com/">Motherfucking Website</a> &mdash; une philosophie du design Web qui me touche,</li>
<li><a href="http://chrislaco.com/">Christopher H. Laco</a> &mdash; un blogue que je trouve beau,</li>
<li><a href="http://nthn.me/">Nathan Borror</a> &mdash; un autre site Web au design à mon goût,</li>
<li><a href="http://practicaltypography.com/">Butterick’s Practical Typography</a> &mdash; un livre/site sur la typographie,</li>
<li><a href="http://ia.net/blog/100e2r">The 100% Easy-2-Read Standard</a> &mdash; un manifeste,</li>
<li><a href="http://matt.might.net/">Matt Might's blog</a> &mdash; également hébergé avec Linode.</li>
</ul>

<h2>À venir</h2>
<p>Merci à mes amis et membres de ma famille qui ont constructivement critiqué mon ancien site Web. Je suis plein d'enthousiasme et j'ai beaucoup d'idées pour le développement futur. Mon site est pour moi un projet école pour pousser plus loin mes aptitudes dans le langage Python, la communication technique, la typographie et l'administration de système. Parmi les choses qui restent à faire&nbsp;:</p>
<ul>
<li><del>RSS</del></li>
<li>Sitemap</li>
<li>i18n et l10n</li>
<li>Créer un clone de <a href="http://sebsauvage.net/wiki/doku.php?id=php:shaarli">Shaarli</a> en application Django pour y migrer mes marques-pages</li>
<li>Installer <a href="https://code.google.com/p/typogrify/">Typogrify</a>, un ensemble de filtres Django pour l'application simple de règles typographiques.</li>
<li><del>Écrire ou installer une petite app pour la gestion des images dans mes billets de blogue</del></li>
<li><del>Mettre le code source sur GitHub</del> <a href="https://github.com/adeverteuil/alexandre.deverteuil.net">fait</a>.</li>
</ul>

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Naviguer dans une page man"
subtitle: ""
summary: "Voici un truc pour naviguer aisément dans une page man."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2015-01-20
lastmod: 2015-01-20
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

Certaines pages man peuvent être extrêmement longues et contenir beaucoup de sections. La page man de Bash 4.3 produit 5724 lignes (en 80 colonnes) et contient 37 sections! J’ai posé ce problème sur le forum d’Arch Linux. L’utilisateur battlepanic m’a donné l’excellent [truc](https://bbs.archlinux.org/viewtopic.php?pid=848060#p848060) qui suit (traduction libre)&nbsp;:

> Sur mon système, presque toutes les lignes d’une page man commencent avec des espaces. Les seules exceptions semblent être les entêtes de sections. Sachant cela, une simple recherche par expression régulière fera l’affaire&nbsp;:
> ```
> /^\w
> ```
> Vous pouvez ensuite appuyer sur <kbd>n</kbd> pour sauter à la prochaine section ou <kbd>N</kbd> pour sauter à la précédente.

Juste par curiosité, voici toutes les sections de la page man de Bash&nbsp;:

<blockquote style="font-variant:small-caps">
Name<br />
Synopsis<br />
Copyright<br />
Description<br />
Options<br />
Arguments<br />
Invocation<br />
Definitions<br />
Reserved Words<br />
Shell Grammar<br />
Comments<br />
Quoting<br />
Parameters<br />
Expansion<br />
Redirection<br />
Aliases<br />
Functions<br />
Arithmetic Evaluation<br />
Conditional Expressions<br />
Simple Command Expansion<br />
Command Execution<br />
Command Execution Environment<br />
Environment<br />
Exit Status<br />
Signals<br />
Job Control<br />
Prompting<br />
Readline<br />
History<br />
History Expansion<br />
Shell Builtin Commands<br />
Restricted Shell<br />
See Also<br />
Files<br />
Authors<br />
Bug Reports<br />
Bugs
</blockquote>

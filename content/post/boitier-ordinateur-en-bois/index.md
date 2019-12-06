---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Boîtier d'ordinateur en bois"
subtitle: ""
summary: "Présentation de mon projet de boîtier de PC en bois."
authors: []
tags: []
categories: ["personnel"]
date: 2012-07-05
lastmod: 2012-07-05
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
gallery_item:
  - album: construction
    image: DSC_4417.jpg
    caption: Test de l'ordinateur, sans boîtier. Ce n'est pas un dual-screen! Le moniteur de droite est celui de mon ordinateur principal.
  - album: construction
    image: DSC_4424.jpg
    caption: Planification de la disposition des composantes.
  - album: construction
    image: DSC_4427.jpg
    caption: Il n'y aura pas d'espace pour un lecteur DVD.
  - album: construction
    image: DSC_4427.jpg
    caption: Il n'y aura pas d'espace pour un lecteur DVD.
  - album: construction
    image: DSC_4429.jpg
    caption: 2<sup>e</sup> test. Je n'ai rien brisé et mon câble VGA modifié est un succès!
  - album: wifi
    image: DSC_4449.jpg
    caption: "Tentative 1 est un échec&nbsp;: J'ai détruit la carte. Mon fer à souder est trop faible et je me suis fâché. J'ai sorti le marteau, mais c'était une erreur."
  - album: wifi
    image: DSC_4477.jpg
    caption: "J'ai acheté une deuxième carte wi-fi PCI. Cette fois-ci a été un (laborieux) succès."
  - album: wifi
    image: DSC_4479.jpg
    caption: "Mon «talent». Notez que j'ai quand même réussi à assembler un connecteur VGA du premier coup là!"
  - album: presque_terminé
    image: DSC_4451.jpg
    caption: "Sur cette photo, l'ordinateur est connecté via ethernet."
  - album: terminé
    image: DSC_4490.jpg
    caption: "Le résultat final"
  - album: terminé
    image: DSC_4460.jpg
    caption: "Vue de face"
  - album: terminé
    image: DSC_4462.jpg
    caption: "Côté gauche"
  - album: terminé
    image: DSC_4463.jpg
    caption: "Vue de dos"
  - album: terminé
    image: DSC_4464.jpg
    caption: "Côté droit"
  - album: terminé
    image: DSC_4491.jpg
    caption: "Mode «&nbsp;transport&nbsp;»"
  - album: intérieur
    image: DSC_4476.jpg
    caption: "On peut voir la carte PCI wi-fi modifiée pour que le câble de l'antenne se connecte par l'intérieur du boîtier et non par l'extérieur."
  - album: intérieur
    image: DSC_4480.jpg
    caption: "Avec le câble IDE retiré pour plus de visibilité."
  - album: intérieur
    image: DSC_4483.jpg
    caption: "Le câble d'alimentation du moniteur est soudé aux *mains* du PSU."
  - album: intérieur
    image: DSC_4482.jpg
    caption: "Câble VGA custom."
  - album: intérieur
    image: DSC_4485.jpg
    caption: "Filage de l'interrupteur et des DELs."
---

Le mois dernier, un ami m'a donné un vieux PC. J'ai extrait
toutes les pièces et j'ai fait un boîtier en bois, avec un moniteur
intégré! Dans cet article, je vais décrire en détails les
caractéristiques du projet et présenter un album photo du processus de
construction et du produit fini, avec des commentaires.

L'idée de base, puisque j'ai reçu un ordinateur désuet en cadeau,
était de conserver les coûts à un minimum. J'ai donc acheté des
retailles de bois, des composantes usagées, et j'ai utilisé du
matériel de construction de qualité moyenne. De plus, ma durée
d'attention pour ce projet était estimée à deux mois, donc j'ai voulu
privilégier la complétion plutôt que la perfection. Il y a beaucoup
d'angles droits, de lignes simples, presqu'aucun travail esthétique mis
à part la recherche d'équilibre dans les dimentions et l'uniformité
des couleurs (bois non traité, noir).

Si vous avez des commentaires ou des questions, je veux bien les recevoir à <a href="mailto:alexandre@deverteuil.net">alexandre@deverteuil.net</a>.

## Pièces

<table>
<thead>
<tr> <th>Item</th> <th>Détail</th> <th>Prix</th> </tr>
</thead>
<tbody>
<tr>
  <td>Carte mère</td>
    <td>
      <a href="http://www.ecs.com.tw/ECSWebSite/Product/Product_Detail.aspx?CategoryID=1&amp;DetailID=663&amp;DetailName=Feature&amp;MenuID=24&amp;LanID=9">
        661FX-M7 (V1.2A)
      </a>
    </td>
  <td rowspan="4" style="text-align: right;">cadeau</td>
</tr>
<tr> <td>Mémoire</td>                 <td>1×512 Mo DDR-400 MHz PC3200U-30331</td> </tr>
<tr> <td>CPU</td>                     <td>Intel&reg; Celeron&reg; D CPU 3,20 GHz; 1 cœur; 32 bits</td> </tr>
<tr> <td>PSU</td>                     <td></td> </tr>
<tr> <td>Disque dur</td>              <td>usagé; IDE; 40 Go</td>           <td style="text-align: right;">10,00 $</td> </tr>
<tr> <td>Adaptateur Wi-Fi PCI</td>    <td>802.11b/g</td>                   <td style="text-align: right;">28,33 $</td> </tr>
<tr> <td>Antenne Wi-Fi</td>           <td>omnidirectionnelle; pliable</td> <td style="text-align: right;">14,94 $</td> </tr>
<tr> <td>Moniteur</td>                <td>usagé; 15 pouces; 1024×768</td>  <td style="text-align: right;">35,00 $</td> </tr>
<tr> <td>Interrupteur</td>            <td></td>                            <td style="text-align: right;">2,50 $</td> </tr>
<tr> <td>Poignée de transport</td>    <td></td>                            <td style="text-align: right;">6,00 $</td> </tr>
<tr> <td>Souris</td>                  <td></td>                            <td style="text-align: right;">3,00 $</td> </tr>
<tr> <td>Clavier</td>                 <td></td>                            <td style="text-align: right;">récupéré</td> </tr>
<tr> <td>2 câbles d'alimentation</td> <td></td>                            <td style="text-align: right;">10,00 $</td> </tr>
<tr> <td>Câble VGA</td>               <td></td>                            <td style="text-align: right;">5,00 $</td> </tr>
<tr> <td>Planche de pin</td>          <td>pièce du dessus</td>             <td style="text-align: right;">11,98 $</td> </tr>
<tr> <td>Retailles de bois</td>       <td></td>                            <td style="text-align: right;">4,70 $</td> </tr>
<tr> <td>Baguette de 1×2</td>         <td></td>                            <td style="text-align: right;">5,00 $</td> </tr>
<tr> <td>Quincaillerie</td>           <td>équerres; vis; loquets</td>      <td style="text-align: right;">35,00 $</td> </tr>
<tr> <td>Grille de ventilateur</td>   <td></td>                            <td style="text-align: right;">1,00 $</td> </tr>
</tbody>
<tfoot>
<tr> <th colspan="3" style="text-align: right;">Total : 172,45 $</th> </tr>
</tfoot>
</table>


## Caractéristiques

<ul>
    <li>Presque portable;</li>
    <li>Poids : 15,8&nbsp;Kg; 35&nbsp;lbs;</li>
    <li>Hauteur : 755&nbsp;mm; 600&nbsp;mm l'antenne repliée;</li>
    <li>Largeur : 370&nbsp;mm;</li>
    <li>Profondeur : 225&nbsp;mm;</li>
    <li>Carte mère au facteur de forme ATX;</li>
    <li>Système d'exploitation GNU/<a href="http://www.archlinux.org/">Arch Linux</a> sans serveur X</li>
</ul>


## Début de la construction

{{< gallery album="construction" >}}


## Alignement des pièces de la boîte

{{< gallery album="alignement" >}}


## Modification de l'adapteur wi-fi PCI

J'ai désoudé le connecteur de l'antenne wi-fi et l'ai réinstallé
à 180°, pour garder une forme compacte. Ainsi, le câble de l'antenne
se connecte par l'intérieur du boîtier. Sans cette modification, le
boîtier ne ferme pas.

{{< gallery album="wifi" >}}


## Presque terminé

<p>Le dessus est une planche de pin taillée en biseau à la scie
sauteuse avec un angle réglé à 30°.</p>
<p>On peut voir que le manque d'expérience et de banc de scie ont
causé quelques erreurs.</p>

{{< gallery album="presque_terminé" >}}


## Résultat final!

<p>Je suis bien content du résultat. J'ai appris beaucoup de choses
et j'éviterai certaines erreurs lors de ma prochaine construction. Le
centre de gravité est trop porté vers l'avant, tout juste derrière
les pattes avant. Par conséquent, il est dangereux de laisser le PC où
il pourrait être renversé par un chat. Ce n'est pas assez grave pour
empêcher l'utilisation normale. Je réfléchis à un design futur qui
serait incliné vers l'arrière, cela permettrait d'obtenir un meilleur
équilibre ainsi qu'un angle confortable pour le moniteur.</p>

<p>La portabilité est parfaite pour transporter l'ordinateur d'une
pièce à l'autre, mais c'est trop lourd pour l'apporter à l'extérieur
sans voiture.</p>

<p>J'ai décidé de ne pas installer de serveur X parce que je
suis à l'aise avec le terminal Linux et ça me permet également
de me pratiquer avec cet environnement. J'ai installé <a
href="http://www.archlinux.org/packages/extra/i686/cmatrix/">cmatrix</a>
pour le <i>eye-candy</i>.</p>

{{< gallery album="terminé" >}}


## L'intérieur

{{< gallery album="intérieur" >}}


## Mot de la fin

<p>Au revoir.</p>

{{< figure src="clip3.gif" >}}

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "2019 Blog engine migration"
subtitle: "Moving from Pelican to Hugo"
summary: ""
authors: []
tags: []
categories: ["informatique"]
date: 2019-12-08T15:51:22-05:00
lastmod: 2019-12-08T15:51:22-05:00
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

## Previous blog engine

I was using [Pelican](http://blog.getpelican.com/) for content management and templating engine.

I wrote my own basic theme based on the [SemanticUI](http://semantic-ui.com/) framework.


### Screenshots

{{< figure src="Screenshot_2019-12-08 Accueil — Alexandre de Verteuil.png" title="The landing page. Nice clean simple design, but too much attention on the picture, not enough useful information for a landing page." >}}

{{< figure src="Screenshot_2019-12-08 Blogue — Alexandre de Verteuil.png" title="The blog posts index. I had only two categories and they each had their little icon." >}}


### What I liked

{{< figure src="screenshot 2019-12-08 2229.png" caption="I wrote my own template files in such a way that the output source code looked super clean" >}}


### What I didn't like

* The landing page contents
* Maintaining my own custom HTML/CSS theme


## The new blog engine and theme

I migrated to [Academic](https://sourcethemes.com/academic/), a theme for [Hugo](https://gohugo.io/).

I filled in more information about me on the landing page
The new picture brings less attention to the clothing and more on a friendly-professional headshot.

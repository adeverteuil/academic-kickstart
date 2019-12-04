---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "New blog iteration"
subtitle: ""
summary: "Migrating my blog from my homebrew Django application to Pelican, the static site generator written in Python."
authors: []
tags: ["sysadmin", "prog"]
categories: []
date: 2016-08-05
lastmod: 2016-08-05
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
- album: previous-blog
  image: 2016-08-05 site screenshot Accueil.png
  caption: Screenshot of my old blog's home page
- album: previous-blog
  image: 2016-08-05 site screenshot Blogue.png
  caption: Screenshot of my old blog's home page
---

## Intro

My last iteration was back in
[September 2014]({{< ref "/post/nouveau-blogue/index.md" >}})
when I moved away from Pelican and decided to code my own blog engine
based on Django. I really liked the idea of a static site, but I found
using Pelican was a bit tedious and I didn't like the theme. That was
two years ago. Pelican has evolved a lot, and so have my skills in
coding, theming and system administration.

{{< gallery album="previous-blog" >}}


## Addressing Pelican's drawbacks that discouraged me two years ago

Obviously the theme has been taken care of. I used
[Semantic UI](http://semantic-ui.com/)'s default theme and wrote my the
Pelican templates. It's not a complete Pelican theme, I only wrote the
features I actually use.

The main usability drawback I had with Pelican was having to generate
the site at each edit, which took as long as 30 seconds because I had
many large videos which needed to be copied to the output directory. So
I wrote
[a new feature](https://github.com/getpelican/pelican/issues/1982) to
create hard links instead of copies, which reduces the processing time
to about 2 seconds.

Using the awesome
[tmuxinator](https://github.com/tmuxinator/tmuxinator), I just have to
type `mux blogue` and my `tmux` preset launches my preferred editor and
a development server (illustrated below). It's effortless now to start
writing a blog article.

{{< figure src="pelican tmux screenshot.png" title="Screenshot of a terminal, multiplexed with tmux, with open panes for editing a Pelican article and a template file." lightbox="true" >}}

Pelican ships with a makefile for easy site deployment. However I'm
personally more comfortable with [Ansible](https://www.ansible.com/) and
decided to write my own playbook instead.

## Improvement over my Django blog engine

I am relieved that I don't have to maintain my code alone anymore. Not
that it was a complicated and rotten code, but I don't have the time
since I shifted my focus towards system administration. Now I have an
entire open source community to help me!

Writing articles is much faster and fun using Markdown. My blog didn't
have that and I wrote all my articles in pure html...

My old blog's theme was just `normalize.css` plus some CSS written by
hand. Now that I have Semantic, I can write some html in my Markdown
files if I need to for articles requiring special formatting.

Hosting got cheaper again.
[NearlyFreeSpeech.net](https://www.nearlyfreespeech.net/) didn't support
Django and I moved to a [Linode](https://www.linode.com/) 10$/month
VPS. Linode worked great, but a VPS is overkill for such a small blog.

## Inspirations

* The [pelican-bootstrap3](https://github.com/getpelican/pelican-themes/tree/master/pelican-bootstrap3) theme
* [`cat /dev/brain`](http://www.coglib.com/~icordasc/blog/)

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Building man pages with Debian packaging scripts"
subtitle: ""
summary: "How to build a man page from RestructuredText format using Debian build scripts."
authors: []
tags: ["prog", "sysadmin"]
categories: ["informatique"]
date: 2016-06-10
lastmod: 2016-06-10
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

I wrote [my own backup script](https://github.com/adeverteuil/backup), and I switched from Archlinux to Debian in my home network. So now I need to package my program in `.deb` format in order to deploy it. Learning Debian packaging is a bit intimidating, but I'm starting to really appreciate the intelligence and “magic” in Debian development tools.

One specific task that took me a long time to figure out the best way to do is how to build a man page from RestructuredText format using Debian build scripts. Here's what I came up with:

```makefile
# debian/rules

# Here's the standard minimal recipe for a Python project.
%:
	dh $@ --with python3 --buildsystem=pybuild

# Here I describe how to build the manpage.
# backup.1.rst is included with the source code.
backup.1.gz: backup.1.rst
	rst2man backup.1.rst | gzip > backup.1.gz

# Here I override dh_auto_build just to add a dependency on backup.1.gz
# nothing else is customized.
override_dh_auto_build: backup.1.gz
	dh_auto_build
```

Then I let `dh_installman` know that `backup.1.gz` is a man page that needs to be installed:

```plaintext
# debian/python3-backup.manpages
backup.1.gz
```

…where `python3-backup` is the name of my package.

Send me an email if it helps or if you know an even better way to do it!

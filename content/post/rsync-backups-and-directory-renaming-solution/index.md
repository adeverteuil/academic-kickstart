---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "rsync Backups and Directory Renaming, a Solution"
subtitle: ""
summary: "How to move large filesystem trees on an rsync mirror or backup."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2012-01-11
lastmod: 2012-01-11
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

Most rsync users will eventually confront this shortcoming. When
renaming a directory tree on the sending side, rsync will copy the whole
tree, then delete the old one on the receiving side.

Here is what my reasearch has given:

* «&nbsp;[Your best bet is simply put up with it. Sorry.](http://lists.samba.org/archive/rsync/2003-March/005474.html)&nbsp;»
* [This interesting solution](http://serenadetoacuckooo.blogspot.com/2009/07/rsync-and-directory-renaming.html) involves hidden metadata files and bash scripts. I would look into this if I were renaming large directories often.
* [This discussion](http://serverfault.com/questions/171871/tool-or-script-to-detect-moved-or-renamed-files-on-linux-prior-to-a-backup) brings up even more complex ideas and pointers to patches for rsync support for renamed directories. tl;dr.

Now, suppose you want to perform a backup which includes such
a renamed directory and this problem is unlikely to be recurring,
thus does not justify much research and development. Here is what I
propose:

1. `cp -la` instead of `mv`;
1. Add the `--hard-links` (or `-H`) switch to your recurring rsync job;
1. Wait for `tail -F /var/log/crond.log | grep backup`;
1. `rm -rf`
1. Repeat #2 and #3.

There. Nothing of value was wasted.

Please do email comments. Contact info below.

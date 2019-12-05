---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Play a music CD with mplayer without skipping"
subtitle: ""
summary: "Music CDs often skip when played with mplayer. Here are the command line arguments I use to prevent this."
authors: []
tags: []
categories: ["informatique"]
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
---

```bash
alias playcd='mplayer cdda://:32 -cdrom-device /dev/sr0 -cache 20000 -cache-min 5'
```

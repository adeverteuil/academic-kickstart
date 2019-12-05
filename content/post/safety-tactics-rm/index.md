---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Safety tactics with `rm`"
subtitle: ""
summary: "This is my catastrophy avoiding tactic for the rm command."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2014-09-14
lastmod: 2014-09-14
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

Here are my catastrophy avoiding tactics for the `rm` command.

1. I have `rm` aliased to `rm -i` in my `.bashrc`.

        alias rm="rm -i"  # Make rm interactive by default.

2.  Whenever I use the `rf` command, I make sure *never* to pass the `*` argument. Always put *something* with `*`. This expliciteness has the double benefit of preventing the mistake of being in the wrong directory when issuing the command, while also keeping your command history free of dangerously versatile and destructive commands.

        ~ $ pwd
        /home/alex/tmp/files_to_delete
        ~ $ # Instead of:
        ~ $ rm *
        ~ $ # do this:
        ~ $ rm ../files_to_delete/*

3. Always put `-rf` last. You do not want to accidentally hit `Enter` when there is a partially typed but valid path on the command line.

        ~ $ # Don't do this, because you don't want to
        ~ $ # accidentally hit Enter rigth after "alex":
        ~ $ rm -rf /home/alex/tmp/*
        ~ $ # But rather, do this:
        ~ $ rm /home/alex/tmp/* -rf
        ~ $ # So if you hit Enter in the middle of it, you will get an error.</span>

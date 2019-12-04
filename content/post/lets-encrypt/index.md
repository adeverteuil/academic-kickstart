---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Let's Encrypt!"
subtitle: ""
summary: "My site now has a Let's Encrypt SSL certificate. Let’s Encrypt is a new Certificate Authority: It’s free, automated, and open."
authors: []
tags: ["infosec", "sysadmin"]
categories: []
date: 2015-12-06
lastmod: 2015-12-06
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

I'm an advocate of encryption by default, rather than by exception. A very common counter-argument to the mainstream availability of strong encryption is that if you have nothing to hide, you shouldn't mind about protecting your privacy. This is a false problem based on a wrong mindset. Encryption is not about hiding. It's about *not disclosing*. You should be protected by default, and you should only voluntarily give out information, and for your own benefit.

I have been following closely the progress of the [Let's Encrypt](https://letsencrypt.org/) project. “Let’s Encrypt is a new Certificate Authority: It’s **free**, **automated**, and **open**.” They have entered public beta last Wednesday and have started giving out free SSL certificates using their open authentication protocol and client software. Today, I have acquired my first Let's Encrypt SSL certificate to secure communications between you and my website. I have also permanently redirected all pages to its https counterpart.

This has cost me no money, only some time to familiarize myself with the `letsencrypt` command. If you have a website, I urge you to take advantage of this system and spread the knowledge!

## Resources

* [Let's Encrypt main website](https://letsencrypt.org/)
* [Wikipedia article](https://en.wikipedia.org/wiki/Let's_Encrypt)
* IRC channel `#letsencrypt` on freenode
* [The Let's Encrypt client documentation](https://letsencrypt.readthedocs.org/en/latest/index.html)

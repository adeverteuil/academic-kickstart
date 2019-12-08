---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Let's Encrypt SSL on NearlyFreeSpeech.net with Ansible"
subtitle: ""
summary: "A playbook to get an SSL certificate from Let's Encrypt and install it on a NearlyFreeSpeech.net site using Ansible's letsencrypt module"
authors: []
tags: ["sysadmin", "prog", "foss"]
categories: ["informatique"]
date: 2016-08-22
lastmod: 2016-08-22
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

I combined three of my favorite things &mdash;
[Let's Encrypt](https://letsencrypt.org/),
[NearlyFreeSpeech.net](https://www.nearlyfreespeech.net/)
and [Ansible](https://www.ansible.com/)
&mdash; and wrote an Ansible playbook
to obtain an SSL certificate from Let's Encrypt and install it on a
NearlyFreeSpeech.net site!

* It is available on my GitHub: [https://github.com/adeverteuil/ansible-letsencrypt-nfsn](https://github.com/adeverteuil/ansible-letsencrypt-nfsn)

Oh by the way I noticed that Ansible's site has a Let's Encrypt
certificate too :)

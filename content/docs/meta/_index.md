---
# Course title, summary, and position.
linktitle: <metadocumentation>
summary: Documentation about my site
weight: 1

# Page metadata.
title: Metadocumentation
date: "2019-12-08"
lastmod: "2019-12-08"
draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.

# Add menu entry to sidebar.
# - name: Declare this menu item as a parent with ID `name`.
# - weight: Position of link in menu.
menu:
  docs:
    weight: 3
  meta:
    name: Overview
---

This is documentation about this site.

## Blog engine

[Academic](https://sourcethemes.com/academic/) theme for [Hugo](https://gohugo.io/).

## Content authoring

Content is edited in Markdown.
I do all my editing in Vim and Tmux.
The whole site, including theme files and content, are checked in Git for version control.


## Hosting platform

Hosted in my house.

I have a [FreeNAS](https://www.freenas.org/) box
and I use FreeBSD jails to isolate and put up web hosting environments.

My `publish.sh` script basically builds the site with `hugo`
and syncs the `public/` directory to the jail over SSH with `rsync`.

Large static files are hosted on a separate static HTTP server.
It's just another FreeBSD jail with apache24 serving a filesystem directory.
This is to avoid commiting large binary files to Git,
like videos or large archives I host for sharing.

I commit blog post images optimized for web in my site's repository,
because they're optimized and I can take advantage of Hugo Page Bundles.

I use the HAProxy and ACME packages on my [pfSense](https://www.pfsense.org/) router
for reverse proxying and SSL offloading.

My website is hosted on `https://alexandre.deverteuil.net/`
and static files are served at `https://static.alexandre.deverteuil.net/`.


## DNS

I use DigitalOcean for the `deverteuil.net` domain.

In pfSense, I configured the Dynamic DNS client with a DigitalOcean API key
to update my DNS A record with my residential DHCP IP address.

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "OpenPGP key migration"
subtitle: ""
summary: "I migrated my OpenPGP key from 1024 bit DSA to 4096 bit RSA."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2016-06-13
lastmod: 2016-06-13
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

My old key was a 1024 bit DSA key which I found out is now insecure and deprecated so I generated a 4096 bit RSA key to replace it. I updated my email signature, my [pgp key page]({{< ref "/pgp.md" >}}), and I issued a {{% staticref "files/key-transition-2016-06-13.txt" "newtab" %}}key transition statement{{% /staticref %}} signed by both keys. Please update your keyring and contact me if you have any questions. Both keys will be valid for some time before I revoke the old one.

I don't think this will affect anyone as I'm not part of any group that uses pgp for any communication. For now, the world of secure communication is still a lonely one :(

Anyways, I'll leave links that I found useful for the key migration process.

* [HOWTO prep for migration off of SHA-1 in OpenPGP](https://debian-administration.org/users/dkg/weblog/48)
* [Keysigning](https://wiki.debian.org/Keysigning)
* [Creating a new GPG key](http://ekaia.org/blog/2009/05/10/creating-new-gpgkey/)
* [OpenPGP Best Practices](https://help.riseup.net/en/security/message-security/openpgp/best-practices)
* [Using OpenPGP subkeys in Debian development](https://wiki.debian.org/Subkeys)

Stay safe. Encrypt All The Things!

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Managed switch case mod"
subtitle: ""
summary: "Don't hold back from buying a managed switch because it's noisy. Case modding is totally an option!"
authors: []
tags: ["création", "sysadmin"]
categories: []
date: 2016-01-22
lastmod: 2016-01-22
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

Don't hold back from buying a managed switch under concerns of noise produced by the fans. Case modding a Cisco switch is totally an option!

In the [last post]({{< ref "/post/home-network-rebuild-project/index.md" >}}), I talked about replacing my all-in-one consumer grade router/switch/firewall/wifi-access-point with dedicated devices. I just finished the Ethernet switch

{{< figure src="projet_réseau_switch01.jpg" >}}

I bought a used [Cisco Small Business ESW540 24-Port 1&nbsp;Gbps](http://www.cisco.com/c/en/us/support/switches/esw540-24-port-10-100-1000-switch/model.html) switch on Kijiji. I was really surprised at how noisy this was (I don't have much experience with datacenter hardware) with its two small fans, air grill and the metallic resonnance. Delightfully, I found that the cover comes off easily with a couple of Phillips screws and I started to plan replacing the fans and cover.

{{< gallery album="switch" >}}

Larger fans turn slower, they are *much* more silent, and displace more air. I am replacing two 5&nbsp;cm fans with one 12&nbsp;cm in diameter. The fan connector on the main board is standard, but the pin layout is not the same as generic fans. The voltage is the same though so I bought a [Y extension with two females and one male connectors](http://www.newegg.ca/Product/Product.aspx?Item=N82E16812119148), cut and resoldered the wires in the correct order.

{{< gallery album="fils" >}}

I *think* it will displace enough air to maintain a low temperature. The CPU's heatsink doesn't heat up much when the device is idle, and I don't expect to be pushing it over 10&nbsp;% capacity for any extended period of time at my home. The device *does* fail the fans self-tests, but the fan turns and that's what counts.

As I was already planning on installing the switch to a plywood surface on the wall, half of the case is already done. I went with transparent acrylic for the front. The front is removable and has an air intake at the bottom and an exhaust at the top with holes for the fan screws.

{{< gallery album="plywood" >}}

Connecting a DB-9 straight-through serial cable (the Small Business series of Cisco switches don't have the RJ-45 serial port) and it's alive! The default username and password is “`cisco`”.

{{< gallery album="switch2" >}}

To do:

* Xen server
* Homebrew firewall and router
* Wi-Fi access point

Stay tuned for the next posts: subscribe to my [RSS](https://alexandre.deverteuil.net/blogue/rss/) or [Twitter](https://twitter.com/SystemPk) feed. Email me your questions and comments.

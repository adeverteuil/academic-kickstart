---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Home network rebuild project"
subtitle: ""
summary: "My new IT project is to redo my home network."
authors: []
tags: ["sysadmin", "création"]
categories: ["informatique"]
date: 2016-01-13
lastmod: 2016-01-13
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

{{< figure src="projet_réseau_current_setup.jpg" lightbox="true" >}}

My current IT project is to redo my home network. I currently have a Linksys WRT54G all-in-one router/firewall/switch/wireless access-point which also acts as a DHCP and recursive DNS server. Most houses have such a device for their gateway to the Internet. I want to change it because:

* It's just not powerful enough &mdash; it's old hardware, probably over 10 years.
* I still have 100&nbsp;Mbps and I want to upgrate to 1&nbsp;Gbps.
* I would benefit professionally from expanding my knowledge in networking.
* I just don't think it's right to connect thousands of dollars of equipment to the internet through a 50&nbsp;$ device and expect good performance.
* Although I flashed the WRT54G with dd-wrt to improve on the stock firmware, I miss the rich toolset for network troubleshooting available in a GNU/Linux distribution (tcpdump, hping2, mtr, ethtool, iperf, etc.).

The first part of my plan is to separate roles to dedicated devices. I will replace the WRT54G with one gateway, one switch, one server and a good wireless access point. The whole setup (maybe except the server) will be neatly arranged on a plywood on the wall on top of the storage space.

```plaintext
  ISP uplink
      ^
      |
  +---+---+
  | VDSL  |
  | modem |
  +---+---+
      |
 +----+-----+ eth0 public IP address
 | Gateway  |
 | Firewall | eth1   VLAN1 192.168.1.1/24
 +----+-----+ eth1:2 VLAN2 192.168.2.1/24
      |
      |VLAN trunk
      |
 +-------------+
 |   Switch    |
 |trunk  VLAN1 |
 +-+-----+-+-+-+
   |     | | |
   |     | | |
   |     | | +---+ PCs, DHCP serving 192.168.1.50+150/24
   |     | |
   |     | +-----+ AP management IP 192.168.1.2/24
   |     |
   |     +-------+ VoIP adapter 192.168.1.3/24
   |
   |VLAN trunk
+--+--------------------------------------------+ Xen server with 3 DomU:
|  |                                            |   - Internal
|  +-+ eth0 VLAN1 +---------+                   |   - External Private
|  |                        +-+ br0             |   - External Public
|  |   vif0 DomU Internal +-+   192.168.1.4/24  |
|  |                                            | Inside DomUs, each service will
|  +-+ eth0:2 VLAN2 +---------------+           | be isolated in LXC containers.
|                                   |           |
|      vif1 DomU External Private +---+ br1     |
|                                   |           |
|      vif2 DomU External Public +--+           |
|                                               |
+-----------------------------------------------+
```

Another improvement to my current setup is to install a plywood on the wall in my small storage room to install everything else on.
{{< figure src="projet_réseau_accrochage.jpg" >}}

## VDSL Modem

I have a VDSL modem which didn't seem to have an option to put it in bridge mode. I didn't trust its software to protect my privacy and it was shit anyways so I still had dd-wrt as the only device directly connected to it. This created a superfluous layer of NATting and possibly some latency and DNS problems.

It turns out putting this modem in bridge mode is undocumented but it totally works. I should have googled it earlier. All I needed to do is configure PPPoE on my router and reset the modem!

## Gateway

{{< figure src="Shuttle_DS81_Intel_H81_Slim_PC_Barebone.jpeg" caption="[Shuttle XH110V Intel H110 Black Barebone System](http://www.newegg.ca/Product/Product.aspx?Item=N82E16856101151)" >}}

I'm thinking of building the gateway out of a small-factor box with two gigabit ports, a low powered CPU and a reasonable amount of storage and RAM. It will be based on Archlinux and iptables, so it will also be acting as a NAT and firewall.

No services will be hosted on this machine to reduce the attack surface to a minimum. DHCP, DNS and other internal services will be hosted on the server.

I'll probably go with this box: [Shuttle DS81 Intel H81 Slim PC Barebone](http://www.newegg.ca/Product/Product.aspx?Item=N82E16856101151) on Newegg.ca.

## Server

My desktop PC currently has too much do and it's starting to increase boot times and take too much RAM. I want to offload all services to a dedicated server. For security, I will isolate services in Xen virtual machines: Internal, External Public and External Private. Inside each VM, each service will be in its own container. The whole system will be orchestrated with Ansible.

My local used computers and computer repair shop sells Lenovo cases with dual-core 2.9&nbsp;GHz CPU, 4&nbsp;GB RAM, 250&nbsp;GB storage and one gigabit interface for 150$.

{{< gallery album="serveur" >}}

### `Dom0`

{{< figure src="Xen.png" >}}

In Xen, `Dom0` is the priviledged virtual machine which has access to the hardware and which can start and stop other virtual machines, called `DomU`.

The `Dom0` will have two VLAN interfaces and will be connected to a trunk port on the switch. Outside facing services will be on VMs with a virtual network interface bridged with a VLAN separate from personal computers. The Dom0 itself will have an IP address on the more secure VLAN and will only have the ssh port open.

### Internal `DomU`

This VM will be in the same VLAN as the personal computers. It will be serving the following for the LAN:

* DHCP
* Backup script and storage
* LDAP
* SQL
* git
* DNS
* pacman cache
* tftp for PXE and Cisco switch config backup
* Unifi &mdash; control software for Ubiquiti wireless AP
* NTP
* remote journald logging

### External Private `DomU`

This VM will host private services that must be accessible from the Internet and which will replace as many "cloud" services as possible, for control, privacy, security and freedom:

* WebDAV
* CalDAV
* CardDAV
* IMAP
* OpenVPN
* SSH

### External Public `DomU`

This VM will host public services and thus is the most vulnerable. No network connection will be allowed to the secure VLAN from this VM. It will serve:

* HTTP
* [SMTP](https://alexandre.deverteuil.net/pages/guide-smtp/)
* Tor

## Wireless Access Point

{{< figure src="projet_réseau_Ubiquiti_AP.jpg" caption="[Ubiquiti UAP – UniFi-US Indoor Wireless N300 Access Point/Bridge](http://www.newegg.ca/Product/Product.aspx?Item=0ED-0005-00014)" >}}

All of my stationary computers are wired with Cat5e. It's reliable, fast and our landlords had holes drilled in the floor so I could run wires through the basement. We still have a few mobile phones, MP3 players and laptops and it's practical to have Wi-Fi connectivity. I heard really good comments about Ubiquiti APs and I will acquire one for this project. I'm sure it will gain acceptance from my girlfriend to improve the Wi-Fi coverage.

## Ethernet Switch

I kept this one for the end. It's more exciting because I already started work on this part and I have pictures to show :)

I bought a 24 Cisco Catalyst switch, 24 ports, gigabit speed, used, 150&nbsp;$. That's a really good deal, considering they are sold new for around 2700&nbsp;$. Prices drop fast for second hand Cisco hardware because they typically have a very short warranty. That's not a problem though, they are well made and last very long.

{{< figure src="projet_réseau_switch01.jpg" >}}

The noise is a big problem! It's unthinkable to have one of those powered on in the appartment even in daytime. They are designed for a datacenter, isolated from human activity. To mitigate this, I changed the two 5&nbsp; cm fans for one 12&nbsp;cm fan. Larger fans spin slower for higher air flow. I made an acrylic cover to adapt the new fan. The board's fan ports had 12&nbsp;V output, but not in the standard pin order. So I ordered a fan cable extension online to cut and resolder the wires in the right order.

{{< gallery album="switch" >}}

When I'm done with the case modification, I shall write a new post.

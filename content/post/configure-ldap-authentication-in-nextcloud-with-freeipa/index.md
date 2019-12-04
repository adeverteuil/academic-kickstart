---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Configure LDAP authentication in Nextcloud with FreeIPA"
subtitle: ""
summary: "Here is how to configure the user-ldap plugin in ownCloud/Nextcloud with a FreeIPA server."
authors: []
tags: ["sysadmin", "foss"]
categories: ["informatique"]
date: 2016-08-30
lastmod: 2016-08-30
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

First I like to create a system user in FreeIPA and add it to the system
users group and give it a password. This will allow Nextcloud to browse
the directory to get a list of users and groups.

Then, after activating
[the user-ldap plugin](https://docs.nextcloud.com/server/9/admin_manual/configuration_user/user_auth_ldap.html),
go to the administration page and find the LDAP section. The LDAP
configuration is done by sequentially filling form fields in six
tabs: Server, Users, Login Attributes, Groups, Advanced and Experts.

By the way, I don't mind showing the world my IPA domain and the
hostname because none of that is directly exposed to the Internet and I
don't believe in [security through obscurity](https://www.shodan.io/).

## Server

Since the communication between my Nextcloud and FreeIPA servers are
done on a trusted network, I don't use LDAP over SSL, and I don't
specify the `ldaps://` prefix, just the hostname and the `389` port. The
bind DN looks something like this:

```plaintext
uid=nextcloud,cn=users,cn=accounts,dc=private,dc=deverteuil,dc=net
```

…and the base DN is your FreeIPA domain in LDIF format:

```plaintext
dc=private,dc=deverteuil,dc=net
```

{{< figure src="server.png" title="screenshot of the Server tab" lightbox="true" >}}


## Users

Just select "Only these object classes: `posixAccount`".

{{< figure src="users.png" title="screenshot of the Users tab" lightbox="true" >}}


## Login Attributes

For the section "[…] find the user based on
the following attributes:", check "LDAP / AD Username".

{{< figure src="loginattributes.png" title="screenshot of the Login Attributes tab" lightbox="true" >}}


## Groups

I suggest you create a usergroup in FreeIPA called "nextcloud_users" and
add the users authorized to login to Nextcloud to it.

Select "Only these object classes: `ipausergroup`" and "Only from these
groups: `nextcloud_users`".

{{< figure src="groups.png" title="screenshot of the Groups tab" lightbox="true" >}}


## Advanced

Fill in the following field in the Directory Settings section:

* User Display Name Field: `displayname`
* Base User Tree: `cn=users,cn=accounts,dc=example,dc=com`
* Group Display Name Field: `cn`
* Base Group Tree: `cn=groups,cn=accounts,dc=example,dc=com`

Of course, replace `dc=example,dc=com` with your own base DN.

{{< figure src="advanced.png" title="screenshot of the Advanced tab, Directory Settings section" lightbox="true" >}}

In the Special Attributes section, fill in these:

* Email Field: `mail`
* User Home Folder Naming Rule: `uid`

{{< figure src="advanced2.png" title="screenshot of the Advanced tab, Special Attributes section" lightbox="true" >}}


## Expert

* UUID Attribute for Users: `ipaUniqueID`
* UUID Attribute for Groups: `ipaUniqueID`

{{< figure src="expert.png" title="screenshot of the Expert tab" lightbox="true" >}}


## References

I used [Apache Directory Studio](http://directory.apache.org/studio/) to
learn the LDAP schema on my FreeIPA server.

This reference was a good start but not quite
complete:
[Owncloud Authentication against FreeIPA](https://www.freeipa.org/page/Owncloud_Authentication_against_Fr
eeIPA)

## Software versions

Nextcloud 9.0.51  
FreeIPA 4.3.1

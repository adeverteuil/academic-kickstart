---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Serialize a single task with Ansible"
subtitle: ""
summary: "A trick to serialize Ansible tasks with delegate_to that cannot execute concurrently."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2016-05-26
lastmod: 2016-05-26
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

When using a `delegate_to:` task in Ansible, commands or modules risk causing errors if they cannot be used concurrently on a single physical machine. The first solution that comes to mind is to set `serial:&nbsp;1` on that task. Sadly, `serial:` is only applicable on entire plays and not on single tasks.

This problem is discussed in the following threads (and many others):

* [Possible to set Serial per task (&nbsp;needed when using delegate_to&nbsp;)&nbsp;?](https://groups.google.com/forum/#!topic/Ansible-project/rBcWzXjt-Xc)
* [Ansible: How to run one Task Host by Host?](http://serverfault.com/questions/736452/ansible-how-to-run-one-task-host-by-host)

In particular, my `freeipa-client` role failed when running `command: ipa host-show`, `ipa host-add` and `ipa-getkeytab` tasks delegated to my [FreeIPA](http://www.freeipa.org) server. Only one or two hosts passed such tasks, and the rest failed with “ipa: ERROR: cannot connect to 'https://freeipa.*********/ipa/json': INTERNAL SERVER ERROR”.

Here's a cool solution using the `flock(1)` command that works if you are using the `command` module:

```plaintext
- name: do something that requires serialization
  command: <span class="fg_yellow">flock /etc/ansible-lock</span> &lt;put your command here&gt;
  delegate_to: <your host>
```

There you go! Now even though there will be simultaneous active Python processes on the `delegate_to:` host, only one at a time will be able to execute the command, while others wait for an exclusive lock on `/etc/ansible-lock`.

See also: `man 1 flock`.

I hope it helps!

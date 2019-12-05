---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Monitor Python subprocess' output streams in real-time"
subtitle: ""
summary: "How to read both stdout and stderr in real-time with Python using select.select()."
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2011-04-03
lastmod: 2011-04-03
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

Here is my (or the) solution to monitor stdout and stderr
of a subprocess in Python 3. Python's documentation recommends
using `subprocess.Popen.communicate()` rather than
`subprocess.Popen.stdout.read()` to avoid blocking the
application, but you only get to use the output once the subprocess
ends. Things get complicated if you need to monitor both stdout and
stderr. I use `select.select()` to solve this. I don't think
it works with MS Windows but that's your problem, not mine :).

```python
import subprocess
import logging
import select

p = subprocess.Popen(["spam", "--verbose"],
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)
outputs = {p.stdout: {"EOF": False, "logcmd": logging.info},
           p.stderr: {"EOF": False, "logcmd": logging.error}}
while (not outputs[p.stdout]["EOF"] and
       not outputs[p.stderr]["EOF"]):
    for fd in select.select([p.stdout, p.stderr], [], [])[0]:
        output = fd.readline()
        if output == b"":
            outputs[fd]["EOF"] = True
        else:
            outputs[fd]["logcmd"](output.decode().rstrip())
```

Resources:

* [http://docs.python.org/py3k/library/logging.html](The `logging` module)
* [http://docs.python.org/py3k/library/select.html](The `select` module)
* [http://docs.python.org/py3k/library/subprocess.html](The `subprocess` module)
* [http://docs.python.org/py3k/howto/sockets.html](Socket Programming HOWTO)

**Edit**&nbsp;: Also read `subprocess` source code
located at `/usr/lib/python3.2/subprocess.py`. You will
learn how to do it with the `threading` module.

---

## 2012-06-02 edit

Mr Eric Pruitt was kind enough to share his improvement on this code. Thank you sir!

> **Date**: 2012-06-02  
> **From**: Eric Pruitt  
> **Website**: [https://www.codevat.com/](https://www.codevat.com/)
> 
> Hey Alexandre,
> 
> I was looking for some information on logging subprocess output when I found
> your post. I re-wrote the code in a little more compact form, and I
> thought you might be interested. Here is my version:
> 
> ```python
> def iterate_fds(handles, functions):
>     methods = dict(zip(handles, functions))
>     while methods:
>         for handle in select.select(methods.keys(), tuple(), tuple())[0]:
>             line = handle.readline()
>             if line:
>                 methods[handle](line[:-1])
>             else:
>                 methods.pop(handle)
> ```
> 
> In my program, I am calling the code like this:
> 
> ```python
> iterate_fds((rsync.stderr, rsync.stdout), (logging.warning, logging.info))
> ```
> 
> Eric

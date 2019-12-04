---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Topology of the Python stack"
subtitle: ""
summary: "How are execution frames located in relation to each other in the stack, and in relation with the __main__ module?"
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2015-02-11
lastmod: 2015-02-11
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

I was composing a comment for a Python <code>try…except</code> statement:

```python
try:
    # …some code
except (KeyboardInterrupt, EOFError):
    print("something")
    # Re-raise the exception for handling “X” in the stack.
    raise
```

… where “X” could be “lower” or “higher”, depending on your point of view, the system architecture, or the design intent of Python’s creators. So how are execution frames located in relation to each other in the stack, and in relation with the `__main__` module? Is there a best, most pythonic terminology?

The [`__main__`](https://docs.python.org/3/library/__main__.html) scope is said to be where the “top-level” code executes, but this top-down concept isn't found anywhere else in the documentation. I searched for variations of the terms “Python stack direction” on search engines and found interesting but ultimately unsatisfying [information](http://stackoverflow.com/questions/664744/what-is-the-direction-of-stack-growth-in-most-modern-systems).

I did find the answer in the Python documentation for [the `try` statement](https://docs.python.org/3/reference/compound_stmts.html?highlight=outer%20inner#try) and [the execution model](https://docs.python.org/3/reference/executionmodel.html?highlight=inner%20outer).

Actually, the vocabulary used in the Python documentation is intuitive and implementation independent. **Inner** and **outer** are *the* words best used to describe the location of stack frames in relation to one another.

```python
try:
    # …some code
except (KeyboardInterrupt, EOFError):
    print("something")
    # Re-raise the exception for handling outwards in the stack.
    raise
```

## Amended 2015-02-27

I found another reference that uses the top-down topology in the [Python debugger module](https://docs.python.org/2.7/library/pdb.html#debugger-commands) `pdb` documentation. However, the technical writer must have found “up” and “down” to provide insufficient information so the concept of “newer” and “older” frame was appended in parenthesis.

> ### Debugger Commands (extract)
> d(own)
> : Move the current frame one level down in the stack trace (to a newer frame).</dd>
>
> u(p)
> : Move the current frame one level up in the stack trace (to an older frame).</dd>

This reminds me of a familiar sentence! On an exit from an unhandled exception, the stack trace is printed and the first line is:

> `Traceback (most recent call last):`

… and here again is the concept of **newer** and **older** frame.

In terms of topology, I guess this would translate as moving “towards the oldest/newest frame in the stack”.

## Amended 2015-04-16

Another thing: you raise &mdash; rather than drop &mdash; an exception, suggesting that older stacks frames are considered to be on top.

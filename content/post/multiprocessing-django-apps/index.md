---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Multiprocessing in Django apps"
subtitle: ""
summary: "Managing multiprocessing and database connexions in Django apps"
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2016-02-09
lastmod: 2016-02-09
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

<p>I found solutions to a multiprocessing problem I was debugging in a Django management command. It is a long-running service process that spawns child processes and all of them use the database backend in parallel.</p>

<p>Django's database API is thread-safe. However, when forking new processes, the database connection becomes shared among un-cooperating processes. SQL statements and returned datasets get mangled, unpredictably generating error messages like “Commands out of sync; you can't run this command now” and introducing inconsistencies in the database which generate errors later.</p>

<p>I tried using <code>multiprocessing.Lock</code>s around any function that used the database but this is error-prone, hard to test, lazy, ugly and didn't work.</p>

<p>I thought of 3 solutions:</p>

<ol>
<li>After forking, trick the ORM into thinking the database is closed by setting <code>db.connection = None</code>. Django will create a new connection as needed. The original connection stays open within the parent process.</li>
<li>Wrap the subprocess' main function in the <code>db.connection.temporary_connection()</code> context manager.</li>
<li><code>close()</code> the connection before forking. Creates unnecessary overhead in the main process, but the other two methods are undocumented so this is the only one that is not hackish.</li>
</ol>

<p>While testing, I discarded options 1 and 2. There is much more state that needs to be taken into account than just the connection object, and much of that state is backend-specific.</p>

<p>I ended up using the following code which works perfectly despite a very slight overhead:</p>

```python
if not p.is_alive():  # p is a multiprocessing.Process instance
    db.connections.close_all()  # Running Django 1.8
    p.start()
```

<p>Relevant StackOverflow question: <a href="https://stackoverflow.com/questions/8242837/django-multiprocessing-and-database-connections">Django multiprocessing and database connections</a></p>

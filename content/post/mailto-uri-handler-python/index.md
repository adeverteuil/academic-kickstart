---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "`mailto:` URI handler in Python"
subtitle: ""
summary: "This is a mailto: URI handler written in Python 3.4."
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2015-04-10
lastmod: 2015-04-10
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

This is a `mailto:` URI handler written in Python 3.4.

The first part of the script parses the URI and constructs a Message object.

The second part of the script should be modified according to your own use case. In my case, the message is written to my Mutt postponed messages directory so I can go to Mutt and press <kbd>m</kbd> to edit and send it.

    #!/bin/python
    #
    # Parses mailto: URI passed as the only argument and constructs a message.
    #
    # by Alexandre de Verteuil
    # 2015-04-10
    #
    # To my knowledge, it properly handles all examples and special cases
    # in http://www.ietf.org/rfc/rfc6068.txt

    import sys

    from urllib.parse import urlparse, parse_qs, unquote
    from email.message import Message
    from email.charset import Charset, QP

    parsed_uri = urlparse(sys.argv[1])
    query_dict = parse_qs(parsed_uri.query)

    charset = Charset("utf-8")
    charset.header_encoding = QP
    charset.body_encoding = QP

    def header_encode(s):
        if max(s.encode()) > 127:
            return charset.header_encode(s)
        else:
            return s

    message = Message()

    if parsed_uri.path != "":
        message['To'] = header_encode(unquote(parsed_uri.path))

    if 'body' in query_dict:
        message.set_payload(query_dict['body'][0])
        del query_dict['body']
        message.set_charset(charset)

    for k, v in query_dict.items():
        if k.lower() == "to" and 'to' in message:
            v = [message[k]] + v
            del message[k]
        message[k] = header_encode(",".join(v))

    # The message is now usable as message.as_string() or str(message).
    # Edit under this comment according to the way you want to handle it.

    from tempfile import mkstemp
    from os.path import expanduser

    dir = expanduser("~/var/mail/brouillons/new")
    fd, path = mkstemp(prefix="mailto_", dir=dir)
    with open(fd, "wb") as f:
        f.write(bytes(message))

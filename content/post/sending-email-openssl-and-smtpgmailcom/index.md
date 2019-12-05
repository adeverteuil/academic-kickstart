---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Sending email with openssl and smtp.gmail.com"
subtitle: ""
summary: "This is an exercise to learn about TLS, OpenSSL's command line tool, and SMTP."
authors: []
tags: ["sysadmin"]
categories: ["informatique"]
date: 2014-01-19
lastmod: 2014-01-19
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

This is an exercise to learn about TLS, OpenSSL's command line tool, and SMTP.

Gmail's SMTP server is a feature offered to its users which requires
a TLS connection, and a username and password authentication. The
username is your @gmail.com email address. Gina Trapani wrote an article on
Lifehacker in 2005 on
[how to configure your email client to use Google's SMTP server](http://lifehacker.com/111166/how-to-use-gmail-as-your-smtp-server).

Now I am studying all things SMTP related in order to deploy my own
personnal SMTP server. Here is the geeky way of sending mail through
Google's SMTP server using the command line. I am on a GNU/Linux
terminal and OpenSSL's command line tool &mdash; `openssl`
&mdash; is available.

### Prepare your credentials

The `AUTH LOGIN` authentication method requires base64
encoding your username and password.

```
bash$ openssl base64 <<< some_dude@gmail.com
c29tZV9kdWRlQGdtYWlsLmNvbQo=
bash$ openssl base64 <<< lame_password
bGFtZV9wYXNzd29yZAo=
```

### Connect to smtp.gmail.com

If the SMTP server doesn't require a TLS connection, we could just
`telnet` into it. We will be using `openssl s_client`
for this exercise.

Following the practice in RFCs documenting SMTP, lines starting with `C:`
are typed and those starting with `S:` are server replies. Some gibberish was
removed from the server replies for simplification.

```
bash$ openssl s_client -connect smtp.gmail.com:587 -starttls smtp -crlf
S: 250
C: AUTH LOGIN
S: 334 VXNlcm5hbWU6
C: c29tZV9kdWRlQGdtYWlsLmNvbQo=
S: 334 UGFzc3dvcmQ6
C: bGFtZV9wYXNzd29yZAo=
S: 235 Accepted
C: MAIL FROM:<some_dude@gmail.com>
S: 250 OK
C: rcpt to:<some_dude@gmail.com>
S: 250 OK
C: DATA
S: 354  Go ahead
C: To: some_dude@gmail.com
From: some_dude@gmail.com
Subject: Test email through smtp.google.ca with openssl

Message's body.
.
S: 250 OK
C: QUIT
S: 221 closing connection
bash$
```

### Notes

Let's study the command line options passed to `openssl`:

`s_client`
: This `openssl` subcommand implements a generic
SSL/TLS client intended for testing purposes.

`-connect smtp.gmail.com:587`
: Connect to Google's SMTP server on port 587. Note that port
25 is for mail transmission, wheras port 587 is the official port for
mail submission.

`-starttls smtp`
: This option instructs `s_client` to send the
`STARTTLS` smtp command and perform the TLS negotiation with the
server. All subsequent TCP communication will be tunnelled through TLS,
allowing for secure authentication.

`-crlf`
: Convert LF from terminal into CRLF as required by
[RFC5321](http://tools.ietf.org/html/rfc5321#section-2.3.8).

`s_client` interprets lines starting with R or Q as his own
commands. This is why you must send the SMTP command `rcpt`
in lowercase. You must also pay attention to your base64 encoded
credentials, and `DATA` content for any lines starting with R or
Q. You can prepend a space to your username and password if
required.

See `man 1 s_client` for more information. Don't hesitate to send
me a message at alexandre@deverteuil.net
if you have a question or a comment.

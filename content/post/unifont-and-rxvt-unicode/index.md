---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Unifont as a fallback in rxvt-unicode"
subtitle: ""
summary: "Using GNU Unifont as a fallback font in rxvt-unicode for full BMP (Basic Multilingual Plane) coverage."
authors: []
tags: ["foss", "sysadmin"]
categories: ["informatique"]
date: 2014-11-21
lastmod: 2014-11-21
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

[rxvt-unicode](http://software.schmorp.de/pkg/rxvt-unicode) is a well known terminal emulator for the X window system with support for Unicode. It also supports multiple fonts. This is great because not all fonts have great looking glyphs for all character blocks.

Here is my `.Xdefaults` config for rxvt-unicode’s fonts settings:

```plaintext
URxvt.font: xft:inconsolata:size=12,\
            -*-unifont-*-*-*-*-*-*-*-*-*-*-*-*
```

I learned about [Inconsolata](http://www.levien.com/type/myfonts/inconsolata.html) in a post titled [Top 10 Programming Fonts](http://hivelogic.com/articles/top-10-programming-fonts) (Hivelogic, 2009). It is a free, very readable fixed width font that I use in my terminal emulator and my website’s `<pre>`, `<code>` and `<kbd>` tags.

[GNU Unifont](http://unifoundry.com/unifont.html) is a bitmap font that covers the entire Unicode’s Basic Multilingual Plane (code points `0x0000` to `0xFFFF`). It’s the perfect fallback font because even though it is ugly, otherwise unsupported glyphs are *never* rendered as a question mark, or worse, as blank space.

The only downside I find is that rxvt-unicode uglyfully scales the second font to fit the first font’s character cells.

## Screenshot

Now here is a stitched screenshot of my terminal’s rendering of [UTF-8-demo.txt](http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt). See how Unifont takes over anywhere Inconsolata lacks a glyph for a code point. You can add other specialised fonts in the `.Xdefaults` configuration and they will be tried in the specified order.

Notes:

1. The underlined URL is from the [Yankable URLs](https://wiki.archlinux.org/index.php/Rxvt-unicode#Yankable_URLs_.28no_mouse.29) extension.
1. There seems to be [a bug](https://bugs.gentoo.org/show_bug.cgi?id=254375) in rxvt-unicode’s rendering of [Ethiopian script](https://en.wikipedia.org/wiki/Ge%27ez_script#Unicode) (`U+1200`..`U+137F`).
1. I also noticed failure at code points `⎲ U+23B2 SUMMATION TOP` and `⎳ U+23B3 SUMMATION BOTTOM` in section “Mathematics and sciences”.

{{< figure src="unicode_test_rendering.png" caption="Screenshot of rxvt-unicode’s rendering of UTF-8 encoded text with Inconsolata and Unifont" >}}
<img class="ui image" src="{filename}/image_uploads/unicode_test_rendering.png" alt="Screenshot of rxvt-unicode’s rendering of UTF-8 encoded text with Inconsolata and Unifont" />

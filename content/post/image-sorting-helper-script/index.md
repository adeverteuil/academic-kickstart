---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Image sorting helper script"
subtitle: ""
summary: "A Bash script to sort images in directories by theme and rename them with tags."
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2011-07-27
lastmod: 2011-07-27
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

As you know, I do all my file management with a CLI interface,
`Midnight Commander` and scripts. It's a slight challenge at
first to manage pictures and videos, but it turns out to be much more
efficient than a GUI as tools are learned and honed. It's also more 1337
and future proof. Yeah, 1337.

```bash
#!/bin/bash
#
# sort.sh
#
# Cycle through all image files in a directory and prompt for a
# directory in which to move them. Useful for organizing downloaded pics
# after a 4chan, ffffound or other imageboard hunt.
#
# Copyright (c) 2011 Alexandre de Verteuil
# No restrictions. None.

VIEWER="feh --scale-down"
GIFVIEWER="gifview --animate"

f_view () {
    # Spawn the appropriate viewer.
    # Return 1 if not a supported file extension.
    ext=${candidate##.*\.}  # Get extension.
    ext=${ext,,}  # Lowercase.
    case $ext in
        jpg|jpeg|png) $VIEWER "$candidate";;
        gif) $GIFVIEWER "$candidate";;
        *) echo Skipping "${candidate}"...
           return 1
           ;;
    esac
    }

for candidate in $(find . -maxdepth 1 -type f); do
    echo -----------------------------------------------------
    # Show an image
    f_view "$candidate" || continue
    # Print available directories and prompt for a target.
    # Rebuild list of dirs because dirs may be created in the process.
    unset -v dirs
    dirs[0]="."
    i=1
    while read dir; do
        echo $i: $dir
        dirs[$((i++))]="$dir"
    done &lt; &lt;(find . -mindepth 1 -type d -printf '%p\n' | sort)
    echo "Move $candidate to..."
    read -p "...target dir (New,Quit): " target
    case $target in
        ""|"0") continue;;
        n|N) read -p "New directory name: " dirname
             mkdir -v "$dirname" &amp;&amp; mv -v "$candidate" "$dirname"
             ;;
        q|Q|quit|exit) exit;;
        *) if [ -d "${dirs[$target]}" ]; then
               mv -v "$candidate" "${dirs[$target]}"
           fi
           ;;
    esac
    sleep 0.5s
done
```

Possible feature expansion include:

* subdirectory recursion
* multiple column output
* exploiting readline facility
* file renaming

I also plan using a file naming structure such as
`<id>-tag_tag_tag.<ext>` where `id`
is a few random alphanumeric digits. This way, I can use a
`locate` database specifically for my pictures and multimedia
or I can just `grep` directories.

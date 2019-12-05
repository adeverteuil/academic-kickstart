---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Image Collection Organizing Helper"
subtitle: ""
summary: "A Bash script to sort images in directories by theme and rename them with tags — improved."
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2011-08-22
lastmod: 2011-08-22
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

```bash
#!/bin/bash
#
# sort.sh
# Cycle through all image files in a directory and prompt for a
# directory in which to move them. Useful for organizing downloaded pics
# after a 4chan or ffffound hunt.
#
# Copyright (c) 2011
# Alexandre de Verteuil 2011-07-31
#
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
#
# Optional dependency: rlwrap for tags autocompletion.
# Bugs: Does not work well with directory names containing spaces.
# Usage: sort.sh [files]
# Filename structure: ffffff_tag1[_tagn ...].ext
#     where ffffff are the first 6 characters of the md5sum, useful for
#     autocompleting a filename with just a few characters.

VIEWER="feh --scale-down"
GIFVIEWER="gifview --animate"
TAGSFILE="/home/alex/mm/p/collection/.tags"
RLWRAP=$(which rlwrap 2>/dev/null)
DEBUG=

[ -f "$TAGSFILE" ] || touch "$TAGSFILE"

f_view () {
    # Spawn the appropriate viewer.
    # Return 1 if not a supported file extension.
    if [ ! -f "$candidate" ]; then
        echo Skipping "${candidate}, file doesn't exist..."
        return 1
    fi
    ext=${candidate##*.}  # Get extension.
    ext=${ext,,}  # Lowercase.
    debug file extension "$ext"
    case $ext in
        jpg|jpeg|png) $VIEWER "$candidate" & ;;
        gif) $GIFVIEWER "$candidate";;
        *) echo Skipping "${candidate}, ${ext} not supported..."
           echo
           return 1
           ;;
    esac
    }

debug () {
    if [ "$DEBUG" ]; then
        echo "##DEBUG: "$* >&2
    fi
    }

debug is ON

if [ $# -gt 0 ]; then
    batch="$*"
else
    batch=$(find . -maxdepth 1 -type f -iregex ".*\(jpg\|jpeg\|png\|gif\)")
fi
debug $batch

for candidate in $batch; do
    echo =====================================================
    echo "    Processing $candidate"
    echo '  -------------------------------------------------'
    while :; do
        # Show an image
        f_view "$candidate" || break
        # Print available directories and prompt for a target.
        # Rebuild list of dirs because dirs may be created in the process.
        if [ "$RLWRAP" ]; then
            echo "key in target directory, or again|quit, empty string for ./"
            # This does NOT work if a directory name contains whitespace.
            target=$(rlwrap --one-shot \
                            --substitute-prompt="dir: " \
                            --prompt-colour="Blue" \
                            --file <(find . -mindepth 1 -type d | cut -b 3-) \
                            cat)
            target=${target// /}
            case "$target" in
                ""|"0") targetdir=".";;
                a|again) continue;;
                q|quit) exit;;
                *) if ! [ -d "$target" ]; then
                       mkdir -pv "$target" || exit 1
                   fi
                   targetdir="$target"
            esac
        else
            unset -v dirs
            dirs[0]="."
            i=1
            while read dir; do
                echo $i: $dir
                dirs[$((i++))]="$dir"
            done < <(find . -mindepth 1 -type d -printf '%p\n' | sort) | column
            echo -n "key in target directory, or New|Again|Quit, "
            echo "empty string for ./"
            read -ep "Move to: " target
            case "$target" in
                ""|"0") targetdir=".";;
                n*|N*) read -p "New directory name: " dirname
                     mkdir -pv "$dirname" || exit 1
                     targetdir="$dirname"
                     ;;
                a*|A*) continue;;
                q*|Q*|exit) exit;;
                *) if [ -d "${dirs[$target]}" ]; then
                       targetdir="${dirs[$target]}"
                   fi
                   ;;
            esac
        fi
        echo "Destination directory: ${targetdir}/"
        echo

        # Parse tags from filename
        if [[ "$candidate" =~ (^|^\./)[[:xdigit:]]{5,6}((_[[:alnum:]$&%\!.-]{1,}){1,})\..{3,4}$ ]]; then
            debug BASH_REMATCH is ${BASH_REMATCH[*]}
            buffer=$(tr "_" " " <<< "${BASH_REMATCH[2]:1}")
            for tag in $buffer; do
                if ! grep "^${tag}$" "$TAGSFILE" &>/dev/null; then
                    buffer=$(sed "s/${tag}/\!&/" <<< "${buffer}")
                fi
            done
        else
            buffer=
        fi
        # Read tags from user
        echo -n "Key in tags, space separated, !tags are not added to "
        echo "dictionary, empty string aborts."
        if [ "$RLWRAP" ]; then
            # http://stackoverflow.com/questions/4726695/
            # bash-and-readline-tab-completion-in-a-user-input-loop
            # This explains how read -e only supports default
            # completion.  I use rlwrap, an external program, as a
            # wrapper for readline with my custom word list.
            tags=$(rlwrap --prompt-colour=Yellow \
                          --substitute-prompt="tags: " \
                          --pre-given="$buffer" \
                          --file="$TAGSFILE" \
                          --one-shot \
                          cat)
            debug rlwrap returnded $?
        else
            cat $TAGSFILE | column
            read -ep ": " -i "$buffer" tags
        fi
        if [ ! "$tags" ]; then
            echo Cancelled.
            break
        fi
        debug tags are: \"$tags\"

        # Add new tags to $TAGSFILE
        for tag in $tags; do
            [[ ${tag:0:1} = "!" ]] || echo $tag
        done | cat - $TAGSFILE | sort | uniq > $TAGSFILE.tmp
        mv $TAGSFILE{.tmp,}
        debug TAGSFILE updated.

        # Filename structure :
        tags=$(sed "s/\!\(\w\{1,\}\)/\1/g" <<< "$tags")  # remove '!' prefixes
        tags=$(sed "s/ $//" <<< "$tags")
        tags=$(tr " " "_" <<< "$tags")
        hash=$(md5sum ${candidate})
        hash=${hash:0:6}
        ext=${candidate##*.}  # Get extension.
        ext=${ext,,}  # Lowercase.
        newname="${targetdir}/${hash}_${tags}.${ext}"
        debug newname is: \"$newname\"

        if [ "$candidate" == "$newname" -o "./$candidate" == "$newname" ]; then
            echo No change... Moving on.
        else
            mv -v "$candidate" "$newname" || exit 1
        fi
        echo; echo
        break
    done
    sleep 0.5s
done
```

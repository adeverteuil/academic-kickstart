---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "How I organize my digital documents"
subtitle: ""
summary: "I describe my system for oranizing $HOME."
authors: []
tags: ["idées"]
categories: ["informatique"]
date: 2010-05-08
lastmod: 2010-05-08
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

I've put much thought into how I organize my home directory. This
is what I love most about using a lightweight, highly customizable,
geeky and elitist operating system. You won't be able to reproduce
this system with a mainstream OS without figuring out how to tell your
applications to let go of the default (and sub-optimal) directories. The
system is planned for fast to typing on the command line and is also
quite french/english bilingual. The most important innovation is the
elimination of a "documents" folder in favor of a resources and a
production directories. Also, the pictures library is future proofed,
relying strictly on the filesystem for it's structure.

```plaintext
######## Utilities

tmp/            Downloads, inbox, short lived files
bak/            Backup of configuration  files,  useful  to  have
                 during software updates to allow rollbacks. This
                 is not my actual full system backup.
bin/            Scripts, binaries.

######## Work

prod/           Production, things I created or worked on.
     art/       Things I made for myself, sorted by media, then
                  by date and title.
         blog/
         drawing/
                 2010-04.Something/
         photography/
         and_so_on/
     */         Other directories are named after companies and
                  people's names for whon I did work.
res/            Resources, work from  other  people,  downloads
                  to keep, collections, manuals,  source  codes,
                  ebooks, databases.
wip/            Work in progress. This directory  allows  quick
                  access to projects I'm currently  working  on.
                  It can also act as a task list. Projects  can
                  move to and from prod/.

######## Multimedia

mm/
   m/           Music
     Artist/
            Albums/
   p/           Pictures (see next section)
   v/           Video (movies). I delete them or burn them on
                  a DVD to keep the directory small enough.

######## Multimedia/Pictures

Much inspiration from www.organizepictures.com
All entertainment/nostalgia pictures go in ~/mm/p.
This directory is split in categories  such as events,
collection, outbox, wallpaper. The  camera  is emptied
in the tmp/ directory then images  are  processed  and
organized. When a category gets larger, it is split in
years subdirectory. The personnal library is  the most
important so years directory for this one are directly
on the ~/mm/p/ level. Events directories start with an
ISO9660 date  and  the  format  is  uniform  for  easy
parsing and scripting.

0/              Undated/old pictues from childhood
2010/
    yyyy-mm[-dd].location.event_description/*.jpg previews
                               1/*.NEF       raw originals
                               4x6/*.tiff          exports
                               web/*.jpg        compressed
                               wallpaper/*.png conversions
outbox/         Hard links to images in above subdirectories
wallpapers/     Hard links to images in above subdirectories
collection/     Cool/interesting downloads to keep
tmp/            Temporary directory for camera dump
```

Other resources on the subject:

* [Organizing "My Documents"](http://lifehacker.com/software/file-storage/geek-to-live--organizing-my-documents-156196.php), a good start.
* [organizepictures.com](http://www.organizepictures.com/), brilliant and very complete.
* Your brain's natural ability to categorize things. Just give it time to process how your files can be grouped and divided.

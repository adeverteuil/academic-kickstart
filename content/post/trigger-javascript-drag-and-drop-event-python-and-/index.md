---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Trigger a Javascript file drop event with Python and Selenium"
subtitle: ""
summary: "I needed unit testing for a page which allows to upload files by dragging and dropping them from the desktop."
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2015-08-24
lastmod: 2015-08-24
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

I needed unit testing for a page which allows to upload files by dragging and dropping them from the desktop.

## Notes

* The target element is identified by `#drag_and_drop`.
* `driver` is an instance of the Firefox Selenium webdriver.
* `filepath` is a string, the path to a jpeg image.
* jQuery is defined in the tested web page.
* Tested with Firefox only.

## Code example

```python
import base64
import os

from selenium import webdriver


def drop_file(driver, filepath):
    with open(filepath, "rb") as f:
        b64 = base64.b64encode(f.read()).decode()
    filename = os.path.basename(filepath)
    mtime = str(int(os.path.getmtime(filepath)*1000))
    driver.execute_script(
        "var byte_characters = atob('"+b64+"');"
        "var byte_numbers = new Array(byte_characters.length);"
        "for (var i = 0; i < byte_characters.length; i++)"
            "byte_numbers[i] = byte_characters.charCodeAt(i);"
        "var byte_array = new Uint8Array(byte_numbers);"
        "var file = new File([byte_array],'"+filename+"', {"
            "type: 'image/jpg',"
            "lastModified: new Date("+mtime+")"
        "});"
        "var e = $.Event('drop');"
        "e.originalEvent = {dataTransfer: {files: [file]}};"
        "$('#drag_and_drop').trigger(e);"
        )
```

We start by encoding the file in base64 and we insert it in the script. The Javascript code will then decode the base64 string. `atob()` returns a string, so we must convert it first to an array of integers, then to a byte array, which we pass as a parameter to the File constructor.
<p>Bytes &rarr; base 64 encoded string &rarr; string &rarr; array of integers &rarr; byte array.</p>

## Sources

* [The `File` constructor](https://w3c.github.io/FileAPI/#file-constructor)
* [Firefox's `atob()` function for base64 decoding](https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/atob)
* [The `drop` event](https://developer.mozilla.org/en-US/docs/Web/Events/drop)
* [Creating a Blob from a base64 string in JavaScript](http://stackoverflow.com/a/16245768)

---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Calculate months elapsed between two dates in Python"
subtitle: ""
summary: "Calculate the number of months elapsed between two dates. Algorigthm and Python implementation."
authors: []
tags: ["prog"]
categories: ["informatique"]
date: 2015-03-18
lastmod: 2015-03-18
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

Here is an algorithm to calculate the number of elapsed months separating two dates. It accounts for the day of month and the fact that months have different lengths. It does not matter whether days and months are zero indexed.

## Algorithm

1. Take the difference between the month numbers of date2 and date1;
1. Add the difference between the years of date2 and date1, times 12;
1. If the day of date2 is the last day of its month, then hold date2's day to be equal to 31;
1. If the day of date1 is larger than that of date2, then substract 1;


## Python implementation

`date1` and `date2` are `datetime.date` objects.

```python
import calendar

def calculate_monthdelta(date1, date2):
    def is_last_day_of_the_month(date):
        days_in_month = calendar.monthrange(date.year, date.month)[1]
        return date.day == days_in_month
    imaginary_day_2 = 31 if is_last_day_of_the_month(date2) else date2.day
    monthdelta = (
        (date2.month - date1.month) +
        (date2.year - date1.year) * 12 +
        (-1 if date1.day > imaginary_day_2 else 0)
        )
    return monthdelta
```

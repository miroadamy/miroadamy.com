---
title: "Sublime text macro to insert timestamp"
date: 2013-09-25T16:12:48+08:00
published: true
type: post
categories: ["Programming"]
tags: ["osx", "editors"]
author: "Miro Adamy"
---

# Sublime text macro to insert timestamp

```
platform-edc $ cat ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/time_stamp.py
 
import sublime_plugin
from datetime import datetime
class TimeStampCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        # formatting options at http://docs.python.org/2/library/datetime.html#strftime-strptime-behavior
        stamp = datetime.now().strftime("%Y-%m-%d_%H:%M:%S")  # 2013-07-18 14:54:23
        for r in self.view.sel():
            if r.empty():
                self.view.insert(edit, r.a, stamp)
            else:
                self.view.replace(edit, r,   stamp)

platform-edc $

```

Documentation - [see](http://docs.python.org/2/library/datetime.html#datetime.datetime)


## Installation: 

Add this to Keybindings / User

![](/images/2013-09-23_8.02.19 PM.png)

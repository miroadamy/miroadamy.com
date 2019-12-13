---
title: "How to make screenshot from command line"
date: 2013-09-24T11:22:48+08:00
published: true
type: post
categories: ["lifehacks"]
tags: ["osx", "virtualbox"]
author: "Miro Adamy"
---

# How to make screenshot from command line


```
platform-edc $ screencapture -i ~/Desktop/$(date +%Y%m%d%H%M%S).png
libpng warning: zero length keyword
libpng warning: Empty language field in iTXt chunk
 
platform-edc $ screencapture  ~/Desktop/A$(date +%Y%m%d%H%M%S).png
libpng warning: zero length keyword
libpng warning: Empty language field in iTXt chunk
```

First one is "interactive" - Cmd-Shift-3 with selection tool, second is full screen

![](/images/20130923195517.png)
![](/images/A20130923195544.png)
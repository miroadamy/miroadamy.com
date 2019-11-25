---
title: "How to make unregistered files work in Quick View on OS-X"
date: 2012-04-08T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["osx"]
author: "Miro Adamy"
---

Out of the box Quick View (press Space in Finder) behaviour on unregistered files is not very useful: it shows huge Unix icon instead of content of file.

This is default for files like Makefile or build.gradle

This plugin makes it go away and show text file for all UTIs that are plain text: 
<http://whomwah.github.com/qlstephen/>

Installation:
* open the DMG file
* copy QLStephen.qlgenerator to `/Users/<<USERNAME>>/Library/QuickLook/QLStephen.qlgenerator`

That's it.

Now it looks like this:

![](/images/image2012-4-8 1_21_23.png)

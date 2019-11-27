---
title: "Folder action to autorename screenshots"
date: 2014-04-22T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["applescript","osx"]
author: "Miro Adamy"
---


## Move the location of the screenshots

I do not want to have `~/Desktop` polluted with files. Thus

```
mkdir -p ~/Documents/Screenshots
defaults write com.apple.screencapture location ~/Documents/Screenshots
killall SystemUIServer
```

Test the screenshot - it does it

## Automator based auto-rename

* Create Folder action for `~/Documents/Screenshots`

![](/images/autorename-1.png)

It has 3 actions

![](/images/autorename-2.png)

```
s/Screen Shots //
s/./-/g
s/ at /_/
```

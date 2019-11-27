---
layout: post
title: VMWare and slow clocks
date: 2009-01-04 23:51:35.000000000 -05:00
type: post
published: true
status: publish
categories: ["programming"]
tags: []
author: "Miro Adamy"
---
<p>I have noticed recently that most of our VMWare instances (and we are running decent fleet of them for the ATG Lab as well as internal system) if left without time synchronization, will loose get late quite a bit: some of them as much as hour or more a week.</p>
<p>Unix date command unfortunately belongs to those commands that I am having troubles to remember and everytime I have to use it with parameters, I end up googling for examples ...</p>
<p>The following snippet is useful when correcting only time portion:</p>

```
[tkuser@jci-app ~]$ date
Sat Jan 3 11:28:12 EST 2009

[tkuser@jci-app ~]$ sudo date -s "13:45"
Password:
Sat Jan 3 13:45:00 EST 2009

[tkuser@jci-app ~]$ date
Sat Jan 3 13:45:04 EST 2009
```

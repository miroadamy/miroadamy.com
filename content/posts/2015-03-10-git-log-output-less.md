---
layout: post
title: How to keep git log and less output on the screen
date: 2015-03-10 00:57:35.000000000 -05:00
type: post
published: true
status: publish
comments: true
categories: ["lifehacks"]
tags:
- osx
- git
author: "Miro Adamy"
---

When git uses less as pager the output of commands like git log disappears from the console screen when you exit from less. This is not convenient in many cases so here is how to fix this.

Just for git commands:

```
git config --global --replace-all core.pager "less -iXFR"
```

For less globally (including git) - add to .bashrc / .zshrc / etc:

```
export LESS=-iXFR
```


The options we set for less are:

```
* -i - ignore case when searching (but respect case if search term contains uppercase letters)
* -X - do not clear screen on exit
* -F - exit if text is less then one screen long
* -R - was on by default on my system, something related to colors
```

Source: [http://serebrov.github.io/html/2014-01-04-git-log-and-less-keep-output.html](http://serebrov.github.io/html/2014-01-04-git-log-and-less-keep-output.html)



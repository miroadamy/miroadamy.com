---
title: "Using MacVim as git editor"
date: 2012-04-09T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git","vim","osx"]
author: "Miro Adamy"
---

## Add this to .bashrc

> export GIT_EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim -g -f '
 
The key is -f, without it git will abort because of empty commit message.
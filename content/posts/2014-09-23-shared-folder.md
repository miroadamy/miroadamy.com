---
title: "How to access shared folder in Linux guest in VirtualBox"
date: 2014-09-23T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["virtualbox", "linux"]
author: "Miro Adamy"
---

Make sure the VBOx extensions are installed. 

Go here for details:

## Add share

In VirtualBox, Device add transient shared folder:

![](/images/virt-box.png)

This one has made available path /Users/Shared/ATG-11 under the name ATG-11

## Mount it

```
sudo mount -t vboxsf ATG-11 /media
 
 
$ ll /media/Unix/
total 19M
drwxr-xr-x. 1 root  408 Sep 12 16:02 ATG11-1
drwxr-xr-x. 1 root  272 Sep 12 16:02 ATG11-docs
-rw-rw-r--. 1 root  675 May 13 23:46 atg-platform-mac.userlibraries
-rw-rw-r--. 1 root  787 May 13 23:17 atg-platform-vm.userlibraries
-rwxr--r--. 1 root  19M Feb 15  2013 jrebel-5.1.3-nosetup.zip
-rw-r--r--. 1 root 1020 May 15 15:36 jrebel.lic
-rw-r--r--. 1 root  582 May 15 14:58 rebel.xml
drwxr-xr-x. 1 root  272 Apr  6 01:33 security
drwxr-xr-x. 1 root  306 Jun  9 22:34 servers
-rwxr--r--. 1 root  349 Dec 17  2013 users.txt
drwxr-xr-x. 1 root  340 Sep  3 16:10 xrebel
```
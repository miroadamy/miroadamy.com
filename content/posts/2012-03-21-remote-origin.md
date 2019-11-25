---
title: "How to fix the remote origin from read only"
date: 2012-03-21T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git","ssh"]
author: "Miro Adamy"
---

## Issue

In dotvim repo, I used readonly URL for cloning the repository. Now I have created local branch ( linux-vm ) to track Linux specific font settings and need them to push up.

After creating new SSH pair and adding to GitHub, does not work

```
[tkuser@cplx-dev-vf .vim]$ git status
# On branch linux-vm
nothing to commit (working directory clean)[tkuser@cplx-dev-vf .vim]$ git push origin linux-vm
fatal: remote error:
 You can't push to git://github.com/radegast/dotvim.git
 Use git@github.com:radegast/dotvim.git
 
[tkuser@cplx-dev-vf .vim]$ git remote show origin
* remote origin
 Fetch URL: git://github.com/radegast/dotvim.git
 Push URL: git://github.com/radegast/dotvim.git
 HEAD branch: master
 Remote branch:
 master tracked
 Local branch configured for 'git pull':
 master merges with remote master
 Local ref configured for 'git push':
 master pushes to master (up to date)
 
[tkuser@cplx-dev-vf .vim]$ git remote set-url --push origin git@github.com:radegast/dotvim.git
 
[tkuser@cplx-dev-vf .vim]$ git remote show origin
* remote origin
 Fetch URL: git://github.com/radegast/dotvim.git
 Push URL: git@github.com:radegast/dotvim.git
 HEAD branch: master
 Remote branch:
 master tracked
 Local branch configured for 'git pull':
 master merges with remote master
 Local ref configured for 'git push':
 master pushes to master (up to date)
 
[tkuser@cplx-dev-vf .vim]$ git push origin linux-vm
Enter passphrase for key '/home/tkuser/.ssh/id_rsa':
Counting objects: 5, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 306 bytes, done.
Total 3 (delta 1), reused 0 (delta 0)
To git@github.com:radegast/dotvim.git
 * [new branch] linux-vm -> linux-vm

```

The important line is

> git remote set-url --push origin git@github.com:radegast/dotvim.git

## Notes:

* creating the pair: http://help.github.com/linux-set-up-git/

### Keygen

```
[tkuser@cplx-dev-vf ~]$ ssh-keygen -t rsa -C "miro.adamy+cplx-dev-vf-osx@gmail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/tkuser/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/tkuser/.ssh/id_rsa.
Your public key has been saved in /home/tkuser/.ssh/id_rsa.pub.
The key fingerprint is:
4e:17:89:ea:b3:57:51:78:e3:27:dc:d2:b1:2a:0e:86 miro.adamy+cplx-dev-vf-osx@gmail.com

```

Validation

```
[tkuser@cplx-dev-vf .ssh]$ cd
[tkuser@cplx-dev-vf ~]$ ssh -T git@github.com
Enter passphrase for key '/home/tkuser/.ssh/id_rsa':
Hi radegast! You've successfully authenticated, but GitHub does not provide shell access.
```
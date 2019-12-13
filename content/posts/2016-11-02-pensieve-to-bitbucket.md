---
title: "Process for transferring Git repo from Gitolite to Bitbucket"
date: 2016-11-02T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["git", "gitolite", "bitbucket"]

author: "Miro Adamy"
---

## Task
Transfer full Git history (all branches, tags, etc) to Bitbucket so that development can continue from there

## User setup

* List all keys in Gitolite
* must have access to Gitolite admin interface

```
cd $ADMIN_HOME/pensieve/PRJ-admin/gitolite-admin
 
 
➜  gitolite-admin git:(master) ll keydir
total 144K
-rw-r--r-- 1 miro 401 Jun 29  2015 alter.pub
-rw-r--r-- 1 miro 397 Jun 29  2015 codereview.pub
-rw-r--r-- 1 miro 400 Apr 18  2016 hybris.pub
-rw-r--r-- 1 miro 400 Apr 19  2016 hybris2.pub
-rw-r----- 1 miro 398 Mar 30  2016 irae.pub
... DELETED ...
-rw-r--r-- 1 miro 401 Jun 29  2015 miro.pub
-rw-r--r-- 1 miro 411 Jun 29  2015 tkuser.jenkins0.pub
-rw-r--r-- 1 miro 411 Jun 29  2015 tkuser.jenkins2.pub
```

These will be split to 5 usergroups

* Administrators (admin access) - all projects
* Developers - write access to all branches except master and develop, this project only
* Leads - write access to all branches, this project only
* Support - read only access - all projects
* Agents - read only access (jenkins etc)

## Bitbucket project creation

* create project - PRJ
* create empty repository PRJ in this project
* create user groups:
* PRJ-developers
* PRJ-leads
* assign the access to repo

Assign the branch privileges (master: leads only write, develop: write leads only, developers via PR)

## Repository transfer

The steps for actually moving the code - that work without loosing anything

### clean clone the repository (standard way)

`git clone prj@pensieve.thinkwrap.com:prj.git prj-normal`

### run the statistics

```
cd prj-normal
➜  prj-normal git:(master) git branch -a | wc -l
892
➜  prj-normal git:(master) git branch -r | wc -l
891
➜  prj-normal git:(master) git rev-list --all --count
5527
➜  prj-normal git:(master) git tag | wc -l
3
```

### mirror clone the repo

```
cd ..
git clone --mirror prj@pensieve.thinkwrap.com:prj.git prj-mirror 
```

### Difference between normal and mirror clone

```
➜  prj-normal git:(master) ll
total 8.0K
-rw-r--r--  1 miro 1.6K Oct 31 17:01 Dockerfile
-rw-r--r--  1 miro  714 Oct 31 17:01 docker-compose.yml
drwxr-xr-x 17 miro  578 Oct 31 17:01 prjbackoffice
drwxr-xr-x 16 miro  544 Oct 31 17:01 prjcockpits
drwxr-xr-x 21 miro  714 Oct 31 17:01 prjcore
drwxr-xr-x 18 miro  612 Oct 31 17:01 prjctpayment
drwxr-xr-x 18 miro  612 Oct 31 17:01 prjfacades
drwxr-xr-x 16 miro  544 Oct 31 17:01 prjfulfilmentprocess
drwxr-xr-x 19 miro  646 Oct 31 17:01 prjinitialdata
drwxr-xr-x 19 miro  646 Oct 31 17:01 prjintegration
drwxr-xr-x 15 miro  510 Oct 31 17:01 prjproject
drwxr-xr-x  6 miro  204 Oct 31 17:01 prjsampledata
drwxr-xr-x 17 miro  578 Oct 31 17:01 prjstorefront
drwxr-xr-x 16 miro  544 Oct 31 17:01 prjtest
drwxr-xr-x 20 miro  680 Oct 31 17:01 prjuserregistrationaddon
drwxr-xr-x 11 miro  374 Oct 31 17:01 twdeploy
drwxr-xr-x 17 miro  578 Oct 31 17:01 twvoucheraddon
drwxr-xr-x 18 miro  612 Oct 31 17:01 twwishlistaddon

➜  prj-mirror git:(master) ll
total 100K
-rw-r--r--  1 miro  23 Oct 31 17:10 HEAD
-rw-r--r--  1 miro 257 Nov  2 09:08 config
-rw-r--r--  1 miro  73 Oct 31 17:06 description
drwxr-xr-x 11 miro 374 Oct 31 17:06 hooks
drwxr-xr-x  3 miro 102 Oct 31 17:06 info
drwxr-xr-x  4 miro 136 Oct 31 17:06 objects
-rw-r--r--  1 miro 88K Oct 31 17:10 packed-refs
drwxr-xr-x  4 miro 136 Oct 31 17:06 refs

➜  prj-normal git:(master) git branch -a | tail -10
  remotes/origin/release/1.21
  remotes/origin/release/1.22
  remotes/origin/release/1.3
  remotes/origin/release/1.4
  remotes/origin/release/1.5
  remotes/origin/release/1.6
  remotes/origin/release/1.7
  remotes/origin/release/1.8
  remotes/origin/release/1.9
  remotes/origin/release/prj-UAT_2016-05-05

➜  prj-mirror git:(master) git branch -a | tail -10
  release/1.21
  release/1.22
  release/1.3
  release/1.4
  release/1.5
  release/1.6
  release/1.7
  release/1.8
  release/1.9
  release/prj-UAT_2016-05-05


```

### re-run the statistics

```
➜  prj-mirror git:(master) git branch -a | wc -l
890
➜  prj-mirror git:(master) git branch -r | wc -l
0
➜  prj-mirror git:(master) git rev-list --all --count
5527
```

### Explanation of the differences

* mirror has no remote branches
* two missing branches are


```
cd prj-normal; git branch -a >../prjbranch-norm; cd ..
cd prj-mirror; git branch -a >../prjbranch-mirror; cd ..
 
 
cat prjbranch-norm | sed 's!remotes/origin/!!' >prjbranch-norm2
 
diff -u prjbranch-norm2 prjbranch-mirror
 
 
➜  tmp diff -u prjbranch-norm2 prjbranch-mirror
--- prjbranch-norm2 2016-10-31 17:24:14.000000000 +0100
+++ prjbranch-mirror    2016-10-31 17:23:25.000000000 +0100
@@ -1,6 +1,4 @@
-* master
   Cleanoverride
-  HEAD -> origin/master
   prjSTORE-1085-cart-update-message
   prjSTORE-1087-download-quantity
   prjSTORE-1142-unavailable-button-links
@@ -865,7 +863,7 @@
   hotfix/v2
   hotfix/v3
   hotfix/v4
-  master
+* master
   release/1.0
   release/1.1
   release/1.10
➜  tmp
```

Missing is local master branch and local reference HEAD pointing to master - this makes no sense for bare repository

change the upstream / upload

```
git remote set-url --push origin git@bitbucket.org:thinkwrap/prj.git

git push --mirror
```

### RE-clone from Bitbucket

> git clone git@bitbucket.org:thinkwrap/prj.git prj-bitbucket

### re-run the statistics

```
➜  prj-mirror git:(master) cd ../prj-bitbucket
➜  prj-bitbucket git:(master) git branch -a | wc -l
892
➜  prj-bitbucket git:(master) git branch -r | wc -l
891
➜  prj-bitbucket git:(master) git rev-list --all --count
5527
➜  prj-bitbucket git:(master) git tag | wc -l
3
```

## compare
=> same number of commits, branches, tags etc  

## Add Gitolite users to Bitbucket

* ask for BB account name
* assign to correct group

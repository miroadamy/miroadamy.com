---
title: "How to truncate Git history"
date: 2015-07-14T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

## The general idea

```
#!/bin/bash
# Parameter: tag or sha1
git checkout --orphan temp $1
git commit -m "Truncated history"
git rebase --onto temp $1 master
git branch -D temp
```

Requires Git 1.8+

Works well for mostly linear history (aka Git used for diff-ing of the catalog feeds).

## How it works

Starting repo (training):

```
➜  test git:(master) git last
fe4e396 2015-07-13 | Fix for BuildInfo in TDD, database connectivity works (HEAD, origin/dynamovies/main, master) [Miro Adamy]
f1b8636 2015-07-13 | Tables and database creation [Miro Adamy]
d4c182b 2015-07-13 | Added template of dynamovies module - with empty UI. No database yet [Miro Adamy]
f8df977 2015-07-13 | Enabling the Tomcat Manager (origin/d1-200/main) [Miro Adamy]
9f68fe9 2015-07-13 | Initial for Persons [Miro Adamy]
9bd92e3 2015-07-13 | BuildInfo returns String (tag: d1-160-end, origin/d1-160/main) [Miro Adamy]
d319c11 2015-07-12 | Experimenting with remote debug [ATG Training VM 11.1]
4d06a1c 2015-07-12 | Fix for TDD integration, BuildInfo [ATG Training VM 11.1]
af66abb 2015-07-12 | Added TDD + build works [ATG Training VM 11.1]
967e368 2015-07-12 | Added first source to test libraries [ATG Training VM 11.1]
83755b2 2015-07-12 | Libraries for Mac [Miro Adamy]
b805361 2015-07-12 | Eclipse project + userlib [ATG Training VM 11.1]
13a0b1c 2015-07-12 | Cleaner Manifest (tag: d1-160-start, tag: d1-150-end, origin/d1-150/main) [ATG Training VM 11.1]
246dd9f 2015-07-11 | Better way how to create tables [Miro Adamy]
41c626f 2015-07-11 | Resolved tomcat issues on Mac [Miro Adamy]
59c55c2 2015-07-11 | Runnable configuration [ATG Training VM 11.1]
f3649e6 2015-07-11 | Fixed dependencies (tag: d1-150-start, tag: d1-140-end, origin/d1-140/main) [ATG Training VM 11.1]
9007415 2015-07-11 | No classes.jar yet [ATG Training VM 11.1]
6d45bf5 2015-07-11 | Removed web modules, using DCS [ATG Training VM 11.1]
3acbc08 2015-07-11 | Introduced module structure - template [ATG Training VM 11.1]
365ce26 2015-07-11 | Fixed the table creation for usage counter (tag: d1-140-start, origin/master, origin/HEAD) [ATG Training VM 11.1]
e01305e 2015-07-11 | Added skeleton [ATG Training VM 11.1]
1672624 2015-07-11 | New module [ATG Training VM 11.1]
```

How it looks

![](/images/cut-git-1.png)

We will cut it off at commit d4c182b

```
git checkout --orphan temp d4c182b
```

This creates "unconnected" branch 'temp' starting from the named commit and prepared this state for initial commit:

```
➜  test git:(master) git checkout --orphan temp d4c182b
Switched to a new branch 'temp'
➜  test git:(temp) ✗ git status
On branch temp
Initial commit
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
    new file:   .gitignore
    new file:   .project
    new file:   META-INF/MANIFEST.MF
    new file:   TDD/.classpath
    new file:   TDD/.gitignore
    new file:   TDD/.project
    new file:   TDD/META-INF/MANIFEST.MF
    new file:   TDD/Notes.txt
    new file:   TDD/build.bat
    new file:   TDD/build.properties
    new file:   TDD/build.sh
    new file:   TDD/build.xml
    new file:   TDD/config/CONFIG.properties
... Deleted ...
  
➜  test git:(temp) ✗ git commit -m "Truncated history"
[temp (root-commit) 5eaf635] Truncated history
 214 files changed, 17643 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 .project
 create mode 100644 META-INF/MANIFEST.MF
 create mode 100644 TDD/.classpath
 create mode 100755 TDD/.gitignore
 create mode 100644 TDD/.project
 create mode 100644 TDD/META-INF/MANIFEST.MF
 create mode 100644 TDD/Notes.txt
 create mode 100644 TDD/build.bat
 create mode 100644 TDD/build.properties
 create mode 100755 TDD/build.sh
 create mode 100644 TDD/build.xml
 create mode 100644 TDD/config/CONFIG.properties
...Deleted ...
  
➜  test git:(temp) git last
5eaf635 2015-07-14 | Truncated history (HEAD, temp) [Miro Adamy]
```

We have now two unconnected lines of history:

![](/images/cut-git-2.png)
![](/images/cut-git-3.png)


Next step is to copy all commits after the starting one onto new line:

```
➜  test git:(temp) git rebase --onto temp d4c182b master
First, rewinding head to replay your work on top of it...
Applying: Tables and database creation
Applying: Fix for BuildInfo in TDD, database connectivity works
  
➜  test git:(master) git last
92a19bb 2015-07-13 | Fix for BuildInfo in TDD, database connectivity works (HEAD, master) [Miro Adamy]
9dd9267 2015-07-13 | Tables and database creation [Miro Adamy]
5eaf635 2015-07-14 | Truncated history (temp) [Miro Adamy]
```

Now we are on master but it is really short:

![](/images/cut-git-4.png)

![](/images/cut-git-5.png)

Now we can delete temp and invoke GC

```
git branch -D temp
git gc
  
# We can do even better
git repack -Ad
```


---
title: "Using Gitolite for code sharing setup"
date: 2012-06-21T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["git","gitolite"]
author: "Miro Adamy"
---


## General setup of code sharing host

The code sharing host (**Pensieve**) is dedicated Linux server in DMZ, accessible from external locations as well as from internal network 
(dual homed) - for the build server access.

### Main features

* multiple users
* each user represent a client:
  * e.g. users client1

### Users are separated by Unix permissions:

* access rights to /home/USER are 0700 - no access except the dedicated user
* only ThinkWrap has root access or sudo access
* the access via ssh for the user is blocked - the user client1 cannot log in using ssh and get shell, only use git to pull or push changes

### Inside each user, there are multiple projects.

These projects will have multiple repositiories and will follow the naming convention:

* PROJECT\_BASE\_NAME-DEV\_NAME
* PROJECT\_BASE\_NAME-RELEASE or PROJECT\_BASE\_NAME-THINKWRAP

The PROJECT\_BASE\_NAME-THINKWRAP is the "blessed" repository from Integration manager workflow.

The external developers will be pulling from this repo, merging on their local workstations and pushing their released changes to their respective repositories in CodeShare

Inside each user there is ACL layer (Gitolite) which allows read-only or read-write access to repository.

Only ThinkWrap integration managers will have write access (push) to blessed repositories.

External developers will have push access only to their own external repository on CodeShare
All external developers will have pull (read-only) access to blessed repository.

Depending on project setup, external developers may or may not have pull access to each other repositories
(for sharing code before it goes through integration).

Internal counterpart for the code sharing

### Pensieve and CodeServer

Internally, we will have per-project area on internal repositories host - **CodeServer** 

Each project code area will follow exactly same naming convention:

* PROJECT_BASE_NAME-DEV_NAME
* PROJECT_BASE_NAME (the RELEASE - internal "blessed" repository)

These developer's repositories are external repositories of the team members and BLESSED is integration repository which receives code from developers

There will be similar ACL layer as in CodeShare, with somehow relaxed protection rules (tradeoff security for practicality):

* all projects will be probably using same internal "hosting" user
* internal developers will be able to have read (pull) access to

Depending on project needs / size / requirements, we can support wide variety of control over code release repository

* strict model - developers push to their external repositories, only team lead / integration manager can push to RELEASE
* relaxed model: some or all developers can push directly to release repository, IM handles external code transfers
* "minimized" model - there is only RELEASE repository on CodeServer and developers push directly to it (aka Subversion model).

Team lead or IM is responsible to handle code transitions between Pensieve and CodeServer

All this access magic is possible because of the combination of the SSH and Gitolite (see <http://sitaramc.github.com/gitolite/master-toc.html>)

### How Gitolite works

Everything is described in the manual, MAKE SURE you read these parts:

* <http://sitaramc.github.com/gitolite/ssh.html>
* <http://sitaramc.github.com/gitolite/glssh.html> - how it uses SSH
* <http://sitaramc.github.com/gitolite/auth.html>

Gitolite provide access to repositories using single "hosting user" - this is the only Unix user that actually exists. 
In documentation, this hosting user is called git.

In our setup, this hosting user is customer user - e.g. client1. Consequently, there are many hosting users.

For each hosting user, we will have separate Gitolite configuration - it is very litlle overhead, all that Gitolite is bunch of Perl scripts
two data directories and one small administration Git repository.

So there will be separate Gitolite setup for client1, where user 'client1' will play the role of 'git user', separate and completely
independent Gitolite setup for client2, where unix user 'client2' will play the role 'git user' etc etc. This can be easily scaled up
to using separate hosts for customers if required.

### How external developers access CodeShare

The only access mode is using the public key and SSH. We do not support

* logging in using password
* https access

All developers (including the Integration manager) are "virtual" identities. All will have to provide their public keys and the 
account admin (the person setting up Gitolite for the account, e.g. client1) will be responsible to

* add these keys to account's gitolite database
* create empty repositories for users
* set up access rights (read / write) for the repositories

The Integration Manager can be the same person managing the account but it does not have to be. It is easy to allow 
multiple developers with write access to blessed repositories. Unlike the identity of the account admin (which is determined
when Gitolite is set up for the account), these users can be added or removed at any time.

The setup of Gitolite is described here: <http://sitaramc.github.com/gitolite/qi.html> - it described "single account" hosting.

To make sure that everybody understands how does this translate to our situation, here is detailed step-by-step walkthrough to
both setting up one user account and simulation of the development .

### Security and packability - Sidenote

The only way how to use Git is ssh with public key and we will not provide shell access, only git access. This makes sure that nobody from external developers can log into CodeShare and poke around in the repositories he/she does not have access to  or even trying to gain root access or access othe accounts.

Keeping very long password and rotating it can further increase security. For really paranoid customers, we can disable login shell access in `/etc/passwd`, but this will cause additional work the system administrator to make sure file ownership and permission are correct (when using root access).

## Detailed walkthrough of setup

This guide is using "temporary" VM named jenkins0 (the playground for build server) playing the role of CodeShare and shows all steps for setting up Gitolite on Jenkins0 for user client1.

Main reason for this detailed log is to allow somebody else administer it and help my memory after the vacation !

### On CodeShare

I have created users:

* client1
* client2
* client3

This setup describes process for client1 and can be repeated for any other.

#### Step one - setup Gitolite

Gitolite is distributred as Git repo, so we clone into home directory of hosting user (==client1)

```
[client1@jenkins0 ~]$ pwd
/home/client1
[client1@jenkins0 ~]$ git clone git://github.com/sitaramc/gitolite
Cloning into gitolite...
remote: Counting objects: 8267, done.
remote: Compressing objects: 100% (2829/2829), done.
remote: Total 8267 (delta 5682), reused 7848 (delta 5318)
Receiving objects: 100% (8267/8267), 2.52 MiB | 1.12 MiB/s, done.
Resolving deltas: 100% (5682/5682), done.
```

It creates directory '~/gitolite' which contains few scripts
```
[client1@jenkins0 ~]$ ll
total 16
drwxr-xr-x 6 client1 client1 4096 Jun 17 16:38 gitolite
-rw-r--r-- 1 client1 client1 393 Jun 17 12:02 luke.pub
-rw-r--r-- 1 client1 client1 401 Jun 13 16:07 miro-radegast.pub
drwxrwxr-x 5 client1 client1 4096 Jun 17 12:09 projects
```


Pre-requisites for next step are:

* existing `~/bin` directory
* this directory as part of PATH

#### Create bin directory

```
[client1@jenkins0 ~]$ mkdir ~/bin
[client1@jenkins0 ~]$ export PATH=$PATH:~/bin
[client1@jenkins0 ~]$ echo $PATH
/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/client1/bin:/home/client1/bin
[client1@jenkins0 ~]$
```

#### Install it:

The install just creates symlink in `~/bin`

```
[client1@jenkins0 ~]$ gitolite/install -ln
[client1@jenkins0 ~]$ ll ~/bin/
total 0
lrwxrwxrwx 1 client1 client1 35 Jun 17 16:40 gitolite -> /home/client1/gitolite/src/gitolite
```
**Next part is to setup Gitolite admin account.**

We need a public key of the person that will be admininistering this hosting account.

It must satisfy few requirements:

* it must be in file `USERNAME.pub`, where `USERNAME` is actually username on admin's system (which is stored in public key file)
* it MUST NOT be already in `~/.ssh/authorized_keys`

As we have freshly created the user 'client1', the `~/.ssh/authorized_keys` is empty

I have already copied my public key to jenkins0 - it is there as file 'miro.pub'

Inside this file, there is username@hostname - it is important that you name the file properly (I found out the hard way)

`ssh-rsa AAAAB3NzaC..... DELETED .... d9jajwIsLnJjw== miro``@Radegast``.local`

#### Add private key:

```
[client1@jenkins0 ~]$ gitolite setup -pk miro.pub
Initialized empty Git repository in /home/client1/repositories/gitolite-admin.git/
Initialized empty Git repository in /home/client1/repositories/testing.git/
[client1@jenkins0 ~]$
```

This created two Git repositories: gitolite-admin (which will be used for all administration) and test one.

It also adds user 'miro' as admin of the gitolite with write access (push) to gitolite-admin repo

**Under the hood:**

* it adds public key of user 'miro' to authorized\_keys, but forces all communication using "command ...." syntax (check the ssh documentation for details). 
This command causes that whenever user with this public key logs in, instead of getting shell access, gitolite intercepts and executes commands on its behalf.
* The setup also adds special hooks to gitolite-admin repository that help enforce access and trigger additional action after pushing changes.

All this had to be done on jenkins0 (the CodeShare host)

### On Client

On workstation from which the public key originated, I will need to clone the gitolite-admin repo:

I am in the temp working directory 'gitolite-on-jenkins0', and 'gs' is an alias for 'git status'

```
gitolite-on-jenkins0 $ git clone client1@192.168.16.144:gitolite-admin.git
Cloning into 'gitolite-admin'...
remote: Counting objects: 6, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (6/6), done.
```

Please note that I have used url 'client1@hostname' format - not 'miro@hostname'.
We always connect using host identity.

Here is what happens under the hood:

* client tries to connect to hostnama as user 'client1' and sends the default public key (from ~/.ssh/id\_rsa.pub)
This is the same key we set up on hostname
* ssh finds the key in authorized\_keys and because there is command clause, hands over control to gitolite
* gitolite retrieves the name of the "virtual user" (miro), checks ACL list and allows / disallows the action

The cloned repository has two areas:

* keydir/ directory
* gitolite config files

To add user for the hosting account, all you need to do is to copy properly named public key file under keydir/, add it and push the change.

Here I have added <tkuser@luke.pub> (note that this naming is OK - see Gitolite docs for details).

The other file I am adding is from third VM and has weird name. I wanted to test the third format with two @ signs but get to it. Ignore this file.

After copying the files, we add them in git, commit locally and push

```
gitolite-admin $ gs
# On branch master
# Untracked files:
# (use "git add <file>..." to include in what will be committed)
#
# keydir/miro.adamy+client3-dev-vf-osx@gmail.com@client3-dev-vf.pub
# keydir/tkuser@luke.pub
nothing added to commit but untracked files present (use "git add" to track)
gitolite-admin $ git add keydir/
gitolite-admin $ gs
# On branch master
# Changes to be committed:
# (use "git reset HEAD <file>..." to unstage)
#
# new file: keydir/miro.adamy+client3-dev-vf-osx@gmail.com@client3-dev-vf.pub
# new file: keydir/tkuser@luke.pub
#
gitolite-admin $ git commit -m"Added 2 users"
[master 18caa3d] Added 2 users
2 files changed, 2 insertions(+), 0 deletions(-)
create mode 100644 keydir/miro.adamy+client3-dev-vf-osx@gmail.com@client3-dev-vf.pub
create mode 100644 keydir/tkuser@luke.pub
```

#### Next step will be editing gitolite.conf

```
gitolite-admin $ vi conf/gitolite.conf
gitolite-admin $ cat conf/gitolite.conf
repo gitolite-admin
RW+ = miro
repo testing
RW+ = @all
repo projectOne projectTwo
RW+ = tkuser
RW+ = miro
repo projectOne-Blessed
R = tkuser
RW+ = miro
```

I will create two repositories for project named unimaginatively 'projectOne'.

The projectOne repository (yes, I know this is not according naming convention - there should have been two repos named projectOne-tkuser, and projectOne-SomeOther developer. I will be cheating a bit and use "projectOne"
as developer repository shared by two developers: tkuser@luke, and miro@radegast.

User miro@radegast will be wearing second hat as integration manager and will also have access to "blessed" repository named "projectOne-Blessed".

OK, this is also not according naming convention - which I have created AFTER this exercise.

***Please do what I say to do, not what I do :-D***

The syntax is documented in Gitolite, but here is the idea: but just naming the repositories, they will be created when we push gitolite-admin repo.

```
gitolite-admin $ gs
# On branch master
# Your branch is ahead of 'origin/master' by 1 commit.
#
# Changes not staged for commit:
# (use "git add <file>..." to update what will be committed)
# (use "git checkout -- <file>..." to discard changes in working directory)
#
# modified: conf/gitolite.conf
#
no changes added to commit (use "git add" and/or "git commit -a")
gitolite-admin $ git add conf/gitolite.conf
gitolite-admin $ git commit -m"Some repos"
[master 35789bb] Some repos
1 files changed, 10 insertions(+), 0 deletions(-)
```

When we push, lost of magic happens on the other end:

```
gitolite-admin $ git push
Counting objects: 13, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (8/8), done.
Writing objects: 100% (9/9), 1.46 KiB, done.
Total 9 (delta 0), reused 0 (delta 0)
remote: Initialized empty Git repository in /home/client1/repositories/projectOne.git/
remote: Initialized empty Git repository in /home/client1/repositories/projectOne-Blessed.git/
remote: Initialized empty Git repository in /home/client1/repositories/projectTwo.git/
To client1@192.168.16.144:gitolite-admin.git
ca335c9..35789bb master -> master
```

Also, worth noticing that miro.pub found its way into keydir - even if it was never added (the setup action copied it there).

```
gitolite-admin $ ll keydir/
total 24
-rw-r--r-- 1 miro staff 418B 17 Jun 17:04 miro.adamy+client3-dev-vf-osx@gmail.com@client3-dev-vf.pub
-rw-r--r-- 1 miro staff 401B 17 Jun 16:54 miro.pub
-rw-r--r-- 1 miro staff 393B 17 Jun 17:01 tkuser@luke.pub
```

### Time to simulate some development.

I am still on Macbook, wearing my "developer" hat, go to directory where I work with client1 project and clone: (the directory is empty as we are just starting):

```
client1 $ pwd
/Users/miro/Projects/Thinkwrap/Infrastructure/git-repos/client1
client1 $ ll
client1 $ git clone client1@192.168.16.144:projectOne
Cloning into 'projectOne'...
warning: You appear to have cloned an empty repository.
```


Again, I used 'client1@hostname' to connect.

Note that the url does contain just repository name, while on server side the repos are stored in folder 'repositories' and the directory is named 'projectOne.git'. This is OK.

I will also clone the blessed repository (now wearing my Integration manager hat):

```
client1 $ git clone client1@192.168.16.144:projectOne-Blessed
Cloning into 'projectOne-Blessed'...
warning: You appear to have cloned an empty repository.
client1 $ ll
total 0
drwxr-xr-x 3 miro staff 102B 17 Jun 17:12 projectOne
drwxr-xr-x 3 miro staff 102B 17 Jun 17:12 projectOne-Blessed
```
Lets set up some content for the team to work on:

I work in blessed - create 2 files, commit locally and push

```
client1 $ cd projectOne-Blessed/
projectOne-Blessed $ ll
projectOne-Blessed $ ll ~/bin >bin-dir.txt
projectOne-Blessed $ ll .. >this-dir.txt
projectOne-Blessed $ gs
# On branch master
#
# Initial commit
#
# Untracked files:
# (use "git add <file>..." to include in what will be committed)
#
# bin-dir.txt
# this-dir.txt
nothing added to commit but untracked files present (use "git add" to track)
projectOne-Blessed $ git add .
projectOne-Blessed $ git commit -m"2 files"
[master (root-commit) 4ecde6e] 2 files
2 files changed, 45 insertions(+), 0 deletions(-)
create mode 100644 bin-dir.txt
create mode 100644 this-dir.txt
```

For the first push, you MUST specify the upstream repo and branch. Here is what happens if you do not:

```
projectOne-Blessed $ git push
No refs in common and none specified; doing nothing.
Perhaps you should specify a branch such as 'master'.
fatal: The remote end hung up unexpectedly
error: failed to push some refs to 'client1@192.168.16.144:projectOne-Blessed'
```


OK then, I will push to origin (this is where I got the blessed repo from) and push the only branch - master

```
projectOne-Blessed $ git push origin master
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 1.21 KiB, done.
Total 4 (delta 0), reused 0 (delta 0)
To client1@192.168.16.144:projectOne-Blessed
* [new branch] master -> master
```

Now it works.

#### Second developer

Now, second developer joined project. I will simulate him from Luke. His name is tkuser and his public key was already added to gitolite-admin

I ssh to Luke - checkout the ProjectOne, connect upstream ProjectOne-blessed, add some files / modify some

```
[tkuser@LUKE temp]$ git clone client1@192.168.16.144:projectOne
Cloning into projectOne...
warning: You appear to have cloned an empty repository.
[tkuser@LUKE temp]$ cd projectOne/
[tkuser@LUKE projectOne]$ ll
total 0
[tkuser@LUKE projectOne]$ ll ~ >my-home.txt
[tkuser@LUKE projectOne]$ git add .
 
[tkuser@LUKE projectOne]$ git commit -m "tkuser started"
[master (root-commit) ac41962] tkuser started
Committer: Thinknostic User <tkuser@LUKE.(none)>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly:
git config --global user.name "Your Name"
git config --global user.email you@example.com
After doing this, you may fix the identity used for this commit with:
git commit --amend --reset-author
1 files changed, 16 insertions(+), 0 deletions(-)
create mode 100644 my-home.txt
```

From first commit (as there was never any development from Luke, I just installed Git there today), we get message that Git has trouble determining committer info and is using Thinknostic User \<tkuser@LUKE.(none)\>

**We can fix this easily:**

```
[tkuser@LUKE projectOne]$ git config --global user.name "ThinkWrap User"
[tkuser@LUKE projectOne]$ git config --global user.email tkuser.luke@thinkwrap.net
```
The next commit will be better
```
[tkuser@LUKE projectOne]$ git commit -m "tkuser started"
# On branch master
nothing to commit (working directory clean)
 
 
[tkuser@LUKE projectOne]$ git status
# On branch master
nothing to commit (working directory clean)
[tkuser@LUKE projectOne]$ ll
total 8
-rw-rw-r-- 1 tkuser tkuser 1040 Jun 17 17:17 my-home.txt
[tkuser@LUKE projectOne]$ pwd
/home/tkuser/temp/projectOne
```

As we see, two commits to local repo have different indentities. I could fix that by ammending the commit, and I would in real project, but lets move on:

```
[tkuser@LUKE projectOne]$ git log
commit ac419625e9bef60a8bfb4f78c676eb25b7dc85b9
Author: Thinknostic User <tkuser@LUKE.(none)>
Date: Sun Jun 17 17:18:41 2012 -0400
tkuser started
```


OK, some more hard development:

```
[tkuser@LUKE projectOne]$ vim my-home.txt
[tkuser@LUKE projectOne]$ git status
# On branch master
# Changes not staged for commit:
# (use "git add <file>..." to update what will be committed)
# (use "git checkout -- <file>..." to discard changes in working directory)
#
# modified: my-home.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
[tkuser@LUKE projectOne]$ git commit -a -m "tkuser second"
[master a6cbdf9] tkuser second
1 files changed, 6 insertions(+), 0 deletions(-)
[tkuser@LUKE projectOne]$ git log
commit a6cbdf9b3459c91572741c9ca2f5272e761b120f
Author: ThinkWrap User <tkuser.luke@thinkwrap.net>
Date: Sun Jun 17 17:20:56 2012 -0400
tkuser second
commit ac419625e9bef60a8bfb4f78c676eb25b7dc85b9
Author: Thinknostic User <tkuser@LUKE.(none)>
Date: Sun Jun 17 17:18:41 2012 -0400
tkuser started
```

Now we will share the code with the users on the CodeShare:

```
[tkuser@LUKE projectOne]$ git push origin master
Counting objects: 6, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (6/6), 867 bytes, done.
Total 6 (delta 1), reused 0 (delta 0)
To client1@192.168.16.144:projectOne
* [new branch] master -> master
```


What we have forgotten to do was to integrate code coming from ThinkWrap and shared in blessed repo.

Let's hook up the blessed to my local repository on Luke:

```
[tkuser@LUKE projectOne]$ git remote add blessed client1@192.168.16.144:projectOne-Blessed
[tkuser@LUKE projectOne]$ git remote -v
blessed client1@192.168.16.144:projectOne-Blessed (fetch)
blessed client1@192.168.16.144:projectOne-Blessed (push)
origin client1@192.168.16.144:projectOne (fetch)
origin client1@192.168.16.144:projectOne (push)
```

This is "read-only" link even if it does not say so. We can now fetch the changes from blessed (I could have named it anything, it is just name).

```
[tkuser@LUKE projectOne]$ git fetch blessed master
warning: no common commits
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 4 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (4/4), done.
From 192.168.16.144:projectOne-Blessed
* branch master -> FETCH_HEAD
```

This would be ideal situation if I want just to see what is going on, without impacting my local master.

More practical would be to merge the changes into my master, which is what pull does. Again, for first time I must be explicit what do I want to pull - here is what happens if I am not:

```
[tkuser@LUKE projectOne]$ git pull blessed
From 192.168.16.144:projectOne-Blessed
* [new branch] master -> blessed/master
You asked to pull from the remote 'blessed', but did not specify
a branch. Because this is not the default configured remote
for your current branch, you must specify a branch on the command line.
```

OK, we want master:

```
[tkuser@LUKE projectOne]$ git pull blessed master
From 192.168.16.144:projectOne-Blessed
* branch master -> FETCH_HEAD
Merge made by recursive.
bin-dir.txt | 42 ++++++++++++++++++++++++++++++++++++++++++
this-dir.txt | 3 +++
2 files changed, 45 insertions(+), 0 deletions(-)
create mode 100644 bin-dir.txt
create mode 100644 this-dir.txt
 
 
[tkuser@LUKE projectOne]$ gs
ESP Ghostscript 815.02 (2006-04-19)
Copyright (C) 2004 artofcode LLC, Benicia, CA. All rights reserved.
This software comes with NO WARRANTY: see the file PUBLIC for details.
GS>
```

Eventually, I will get annoyed by GhostScript and kill it by defining my favorite alias:

```
[tkuser@LUKE projectOne]$ alias gs='git status'
[tkuser@LUKE projectOne]$ gs
# On branch master
# Your branch is ahead of 'origin/master' by 2 commits.
#
nothing to commit (working directory clean)
```

So we are fine. All is merged, but only locally. Git indicates we need to push to origin.

I have all files:

```
[tkuser@LUKE projectOne]$ ll
total 24
-rw-rw-r-- 1 tkuser tkuser 2704 Jun 17 17:24 bin-dir.txt
-rw-rw-r-- 1 tkuser tkuser 1070 Jun 17 17:20 my-home.txt
-rw-rw-r-- 1 tkuser tkuser 130 Jun 17 17:24 this-dir.txt
```

Let's push (now there is no need to say 'master'):

```
[tkuser@LUKE projectOne]$ git push origin
Counting objects: 7, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 1.48 KiB, done.
Total 6 (delta 1), reused 0 (delta 0)
To client1@192.168.16.144:projectOne
a6cbdf9..5d8d73b master -> master
```

What would happen if I wanted to short circuit the wait for integration manager and see my changes published right away in blessed repo ? Let's try of Gitolite access control works:

```
[tkuser@LUKE projectOne]$ git push blessed
FATAL: W any projectOne-Blessed tkuser DENIED by fallthru
(or you mis-spelled the reponame)
fatal: The remote end hung up unexpectedly
[tkuser@LUKE projectOne]$ cd ..
```

As it looks like, it does :-D

I will not give up - in addition to link the blessed repo from my projectOne, I will try to clone it locally (which I can do as I have read access and push it back:

```
[tkuser@LUKE projectOne]$ cd ..
[tkuser@LUKE temp]$ git clone client1@192.168.16.144:projectOne-Blessed
Cloning into projectOne-Blessed...
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 4 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (4/4), done.
```

OK, let's hack it:

```
[tkuser@LUKE temp]$ cd projectOne-Blessed/
[tkuser@LUKE projectOne-Blessed]$ ll
total 16
-rw-rw-r-- 1 tkuser tkuser 2704 Jun 17 17:31 bin-dir.txt
-rw-rw-r-- 1 tkuser tkuser 130 Jun 17 17:31 this-dir.txt
[tkuser@LUKE projectOne-Blessed]$ vim bin-dir.txt
[tkuser@LUKE projectOne-Blessed]$ git add .
[tkuser@LUKE projectOne-Blessed]$ gs
# On branch master
# Changes to be committed:
# (use "git reset HEAD <file>..." to unstage)
#
# modified: bin-dir.txt
```

Local commit will work fine:

```
[tkuser@LUKE projectOne-Blessed]$ git commit -m"Changing Blessed"
[master eefd800] Changing Blessed
1 files changed, 2 insertions(+), 1 deletions(-)
[tkuser@LUKE projectOne-Blessed]$ gs
# On branch master
# Your branch is ahead of 'origin/master' by 1 commit.
#
nothing to commit (working directory clean)
```

But push will fail:

```
[tkuser@LUKE projectOne-Blessed]$ git push origin
FATAL: W any projectOne-Blessed tkuser DENIED by fallthru
(or you mis-spelled the reponame)
fatal: The remote end hung up unexpectedly
```

### Back to Macbook and put on my Integration Manager hat:

Int Manager on MBP - working with local clone of blessed repo

```
projectOne-Blessed $ hostname
Radegast.local
projectOne-Blessed $ pwd
/Users/miro/Projects/Thinkwrap/Infrastructure/git-repos/client1/projectOne-Blessed
projectOne-Blessed $
```

Integration manager has better tools so I use SourceTree from Atlassian to

* attach developer1 repository on CodeShare (the projectOne tkuser used), fetch the changes
* review them,
* merged developer1/master
* pushed to BLESSED

![](/images/sharing-1.png)

###  Back on Luke, I am tkuser now:

```
[tkuser@LUKE projectOne]$ git pull blessed master
From 192.168.16.144:projectOne-Blessed
* branch master -> FETCH_HEAD
Already up-to-date.
```

OK, this may be surprising: how come that IM pushed changes to blessed and tkuser does not see them ?

What happened here is that the merge in Blessed was fast forward to latest and the latest is already in projectOne rep (as it originated from there). So nothing really changed just few references were moved.

We can verify that we do have the latest commit by checking the sha1

```
[tkuser@LUKE projectOne]$ git log
commit 5d8d73b7f24307482edbfc4ca1328dabdfcf8353
Merge: a6cbdf9 4ecde6e
Author: ThinkWrap User <tkuser.luke@thinkwrap.net>
Date: Sun Jun 17 17:24:13 2012 -0400
Merge branch 'master' of 192.168.16.144:projectOne-Blessed
commit a6cbdf9b3459c91572741c9ca2f5272e761b120f
Author: ThinkWrap User <tkuser.luke@thinkwrap.net>
Date: Sun Jun 17 17:20:56 2012 -0400
tkuser second
commit ac419625e9bef60a8bfb4f78c676eb25b7dc85b9
Author: Thinknostic User <tkuser@LUKE.(none)>
Date: Sun Jun 17 17:18:41 2012 -0400
tkuser started
commit 4ecde6eebd93448628c6475e12da380a962aecc9
Author: Miro Adamy <miro.adamy@thinkwrap.com>
Date: Sun Jun 17 17:15:04 2012 -0400
2 files
```

Or we can even see the fancy ASCII-Artsy graph:
```
[tkuser@LUKE projectOne]$ git log --graph
* commit 5d8d73b7f24307482edbfc4ca1328dabdfcf8353
|\ Merge: a6cbdf9 4ecde6e
| | Author: ThinkWrap User <tkuser.luke@thinkwrap.net>
| | Date: Sun Jun 17 17:24:13 2012 -0400
| |
| | Merge branch 'master' of 192.168.16.144:projectOne-Blessed
| |
| * commit 4ecde6eebd93448628c6475e12da380a962aecc9
| Author: Miro Adamy <miro.adamy@thinkwrap.com>
| Date: Sun Jun 17 17:15:04 2012 -0400
|
| 2 files
|
* commit a6cbdf9b3459c91572741c9ca2f5272e761b120f
| Author: ThinkWrap User <tkuser.luke@thinkwrap.net>
| Date: Sun Jun 17 17:20:56 2012 -0400
|
| tkuser second
|
* commit ac419625e9bef60a8bfb4f78c676eb25b7dc85b9
Author: Thinknostic User <tkuser@LUKE.(none)>
Date: Sun Jun 17 17:18:41 2012 -0400
 
tkuser started
[tkuser@LUKE projectOne]$
```

## Sharing external repo among developers

For the final part, lets create scenario that does not happen if every developer has his/her own external repo on CodeShare, but which will certainly happen in the setup where multiple developer push to same external repo - kinda centralized mode.

I will start by add local change to projectOne repo on MBPro by Miro. Back on Macbook:

```
projectOne-Blessed $ cd ../projectOne
projectOne $ ll
total 24
-rw-r--r-- 1 miro staff 2.6K 17 Jun 17:47 bin-dir.txt
-rw-r--r-- 1 miro staff 1.0K 17 Jun 17:47 my-home.txt
-rw-r--r-- 1 miro staff 130B 17 Jun 17:47 this-dir.txt
projectOne $ vim this-dir.txt
projectOne $ git commit -a -m"local by Miro"
[master c62dd90] local by Miro
1 files changed, 1 insertions(+), 1 deletions(-)
projectOne $ git push
Counting objects: 5, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 297 bytes, done.
Total 3 (delta 2), reused 0 (delta 0)
To client1@192.168.16.144:projectOne
5d8d73b..c62dd90 master -> master
```

At the same time, tkuser on luke did also change something - starting from same starting code as miron on Radegast: attempt to push will this time end up with conflict

```
[tkuser@LUKE projectOne]$ ll
total 24
-rw-rw-r-- 1 tkuser tkuser 2704 Jun 17 17:24 bin-dir.txt
-rw-rw-r-- 1 tkuser tkuser 1070 Jun 17 17:20 my-home.txt
-rw-rw-r-- 1 tkuser tkuser 130 Jun 17 17:24 this-dir.txt
[tkuser@LUKE projectOne]$ vim my-home.txt
[tkuser@LUKE projectOne]$ git commit -a -m"Changing my home on Luke"
[master deb5d23] Changing my home on Luke
1 files changed, 0 insertions(+), 1 deletions(-)
```

Note that local commit is always OK, it will be the push that fails:

```
[tkuser@LUKE projectOne]$ git push
To client1@192.168.16.144:projectOne
! [rejected] master -> master (non-fast-forward)
error: failed to push some refs to 'client1@192.168.16.144:projectOne'
To prevent you from losing history, non-fast-forward updates were rejected
Merge the remote changes (e.g. 'git pull') before pushing again. See the
'Note about fast-forwards' section of 'git push --help' for details.
```

Git was nice enough to tell me what to do. Let's pull:

```
[tkuser@LUKE projectOne]$ git pull
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 2), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From 192.168.16.144:projectOne
5d8d73b..c62dd90 master -> origin/master
Merge made by recursive.
this-dir.txt | 2 +-
1 files changed, 1 insertions(+), 1 deletions(-)
```

Merge resulted in new commit - it was done right away as there were no conflicts. We can push again:

```
[tkuser@LUKE projectOne]$ git push
Counting objects: 8, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 618 bytes, done.
Total 5 (delta 2), reused 0 (delta 0)
To client1@192.168.16.144:projectOne
c62dd90..e031acf master -> master
[tkuser@LUKE projectOne]$
```

## Security and hackability

Last note is on security. The hacker's soul in tkuser wants to see what else except projectOne is on CodeShare. Let's log on.

### Attempt to bypass the security by logging on as hosting user

```
[tkuser@LUKE ~]$ ssh client1@192.168.16.144
hello tkuser, this is client1@jenkins0 running gitolite3 v3.03-34-ga171053 on git 1.7.7.1
R W projectOne
R projectOne-Blessed
R W projectTwo
R W testing
Connection to 192.168.16.144 closed.
```

Bummer. Gitolite was nice enough to show all repos made available for the user, but rejected the login.

Therefore: **public key is the only supported way how to access CodeShare repo.**

For admins and such who know the password the ssh is still there (unless we change it git-shell).

I will prove this by logging in with different identity (to prevent my public key being sent) - I will use my public key I use for github:

```

client1 $ ssh -i ~/.ssh/github_rsa.pub client1@192.168.16.144
client1@192.168.16.144's password:
Last login: Sun Jun 17 14:38:57 2012 from 192.168.16.108
[client1@jenkins0 ~]$
```


In this case, it asks for password and logs me in

And that is end of the walkthrough

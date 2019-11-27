---
title: "Gitolite Administration Guide"
date: 2012-08-06T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["gitolite","git"]
author: "Miro Adamy"
---

## How to setup new client

You need to be **pensieve admin** to do this. 
You will have to login as service user (non-host account) and su to root.

* create new Linux user on pensieve
* setup gitolite:
  * `git clone <git://github.com/sitaramc/gitolite>`
  * `mkdir bin; export PATH=$PATH:~/bin`
  * `gitolite/install -ln`
* add own public key to gitolite to get access to gilotile-admin repo (note the naming restrictions!!)
  * `gitolite setup -pk miro.pub`
* get public key for the client account admin and add it (there can be multiple admins)
* clone the gitolite-admin repo from workstation whose pub key was added
  * `git clone <client@pensieve.thinkwrap>.[com:gitolite-admin.git](http://comgitolite-admin.git/)`
  * add the key to the repo
    * `cd gitolite-admin`
    * `cp ~/mykey.pub keydir`
    * `vim conf/gitolite conf`
    * add the newly added account admit to repos, create new repos if required

All gitolite installs are independent so modification in one hosting user have zero impact on others.

# Project administration

This assumes that you are account administrator - your public key has write (push) priviledge to gitolite-admin repository for your account.

If this is not true, please ask pensieve admin to add you to the account first - you must have access to gitolite-admin repo for your clients account

Clone the gitolite-admin repo:

```
git clone ACCOUNT@pensieve.thinkwrap.com:gitolite-admin.git
```

Make sure you use proper account name for the URL.

All administration tasks are performed upon this gitolite-admin repo. By pushing the committed changes upstream, gitolite will "replay" and execute the changes.

There are three types of changes:

* add new users/remove users
* create new repositories
* administer access of users to repositories

### How to add new repository

Go to gitolite-admin repository clone and edit the cong/gitolite.conf file

Add new repo name with access rights - example:

```
$ cat gitolite-admin/conf/gitolite.conf 
 
repo gitolite-admin
    RW+     =   miro
    RW+     =   alter
 
repo tmsp-release
    RW+     =  alter
    R       = @all
 
repo tmsp-dev
    RW+     = @all
 
repo testing
    RW+     =   @all
```

Each block starting with "repo" defines new repository.

Add new block to file, e.g. foobar

```
... PREVIOUS REPOS ...
repo foobar
    RW+     =  developer1
    R       =  @all
```

Commit and push.

Gitolite will create new repository (located at `$HOSTING_USER_HOME/repositories/foobar.git`), make it available for push ONLY to developer1, allow everybody (all defined developers with public keys) to pull.

The URL of the repo will be `HOSTING_USER_NAME@pensieve.thinkwrap.com:foobar.git` Note that there is no repositories (or .git) in the URL. The later is optional.

### How to add new user to your project

* Get the public key from the developer to be added
* Make sure the naming convention works: if the name of the user (comment at the end of the file) is dev123@noteboook, store it in file dev123.pub.
* Add it to gitolite-admin/keydir (or subdirectory if there is a name conflict)
* Perform local commit and push

### How to administer access rights for a repository

* make sure all users are added to the hosting account (see above)
* edit and push the `gitolite-admin/conf/gitolite.conf`

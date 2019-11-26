---
title: "How to fix Jenkins build issues related to Git connectivity"
date: 2015-06-18T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["git","jenkins"]
author: "Miro Adamy"
---

## Symptoms:

* build fails
* cannot checkout / connect to GIT

## Validate this is the case

* ssh to jenkins2 
* assume identity of jenkins user (VERY IMPORTANT)
* go to `/home/projects/workspace/PROJECTNAME` directory 

This directory is repository clone. Try 'git status' in that directory. If you see something like
```
-bash-3.2$ git status
fatal: unable to read tree 2d0456480112e9f9a8508bb47dc3863112cc6253
```

the git repo is corrupted and needs to be reloaded.

# Step 1 - Get the remote repo URL

```
-bash-3.2$ git remote -v
origin  client@pensieve.thinkwrap.com:client-store.git (fetch)
origin  client@pensieve.thinkwrap.com:client-store.git (push)
```

# Step 2 - Clone the repo to /tmp location

```
-bash-3.2$ git clone client@pensieve.thinkwrap.com:client-store.git /tmp/client-store
Cloning into /tmp/client-store...
remote: Counting objects: 129011, done.
remote: Compressing objects: 100% (36403/36403), done.
remote: Total 129011 (delta 80801), reused 124811 (delta 77481)
Receiving objects: 100% (129011/129011), 250.76 MiB | 30.13 MiB/s, done.
Resolving deltas: 100% (80801/80801), done.
```

The directory you clone into must not exist

# Step 3 - Erase corrupted '.git' repo

```
-bash-3.2$ pwd
/home/projects/workspace/PROJECTNAME
-bash-3.2$ rm -rf .git/
```

# Step 4 - move the fresly cloned '.git' directory  
We will steal the '.git' from the clone in /tmp/DIR

> -bash-3.2$ mv /tmp/client-store/.git .

# Step 5 - resynchronize '.git' and file tree
It is important to make sure that file tree does not have any modifications against the '.git'.

Simplest way is:
```
-bash-3.2$ git status
# On branch master
# Changes not staged for commit:
#   (use "git add/rm <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#   modified:   Store/config/client/integration/ups/UpsConfiguration.properties
#   modified:   Store/config/client/integration/ups/UpsManager.properties
#   deleted:    Store/config/client/ui/droplet/ShippingEstimateDroplet.properties
#   modified:   Store/j2ee/Store.war/css/theme.css
#   modified:   Store/src/com/client/integrations/ups/UpsConfiguration.java
#   modified:   Store/src/com/client/integrations/ups/UpsGateway.java
#   modified:   Store/src/com/client/integrations/ups/UpsManager.java
#   modified:   Store/src/com/client/integrations/ups/UpsRequestFactory.java
#   deleted:    Store/src/com/client/ui/ShippingEstimate.java
#   deleted:    Store/src/com/client/ui/droplet/ShippingEstimateDroplet.java
#   deleted:    WRFulfillment/src/com/client/fcc/formatter/AdditionalItemFeedGenerator.java
#   deleted:    WRFulfillment/src/com/client/fcc/formatter/ElectronicGiftCardItemFeedGenerator.java
#   deleted:    WRFulfillment/src/com/client/fcc/formatter/OrderDetailFeedGenerator.java
#   deleted:    WRFulfillment/src/com/client/fcc/formatter/OrderHeaderFeedGenerator.java
#   modified:   servers/wool-prod-mgmt/localconfig/client/feeds/images/ImagesImportScheduler.properties
#   modified:   servers/wool-prod-mgmt/localconfig/client/feeds/images/ImagesImportService.properties
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#   target/
no changes added to commit (use "git add" and/or "git commit -a")
```

As you see, this one does. We will blow it away. We are on branch master and use hard reset to remove all changes.

```
-bash-3.2$ git reset --hard HEAD
HEAD is now at 0a7f6c9 Client-824: Error handling
  
-bash-3.2$ git pull
Already up-to-date.
```
Now there are no local changes.

If your task is using different branch - that does not matter because Jenkins is using checkouts using absolute sha-1 anyway and as long there are no local modifications that would prevent this checkout it will work.


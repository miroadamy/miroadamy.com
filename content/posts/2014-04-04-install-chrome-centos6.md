---
title: "How to install Chrome in Centos 6.5"
date: 2014-04-04T11:22:48+08:00
published: true
categories: ["devops"]
tags: ["linux"]
author: "Miro Adamy"
---

# How to install Chrome in Centos 6.5

## Step 1. Add Google Yum Repository

Create a new yum repository using below instructions.

` sudo vim /etc/yum.repos.d/google.repo`

Add following content to this file

```
[google]
name=Google
baseurl=http://dl.google.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
```

## Step 2: Install/Update Google Chrome

Richard Lloid provided an shell script to grab libraries from a more recent Linux distro, put them in a tree (/opt/google/chrome/lib) exclusively picked up by Google Chrome and then you can indeed run Google Chrome on CentOS 6.4 or later. [Read More](http://chrome.richardlloyd.org.uk/)

```
# wget http://chrome.richardlloyd.org.uk/install_chrome.sh
# chmod +x install_chrome.sh
# sh install_chrome.sh
```

If you are using older version of Linux distribution, This script will prompt you for confirmation to upgrade system. As per Richard Lloid we need to upgrade system by typing yes to work properly.

## Step 3: Launch Google Chrome

Use following command to start Google Chrome from non root account.

```
$ google-chrome
or start process in background

$ google-chrome &
```

## How to Uninstall Google Chrome

If you have used above shell script to install Google chrome. Then you can use use following command to uninstall Google Chrome and its dependencies added by this script.

```
# sh install_chrome.sh -u
```

References: <http://chrome.richardlloyd.org.uk/>

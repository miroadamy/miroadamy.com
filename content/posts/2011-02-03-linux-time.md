---
title: "Configuring permanent time updates for Linux"
date: 2011-02-03T11:22:48+08:00
published: true
type: post
categories: ["sysadmin"]
tags: ["linux"]
author: "Miro Adamy"
---

## 1) make sure the DNS works

```
sudo vi /etc/resolv.conf
cat /etc/resolv.conf

nameserver 208.67.222.222
nameserver 208.67.220.220
nameserver 192.168.16.1
```

## 2) check that you have ntpd installed

> cat /etc/ntp.conf

## 3) make it work in all

```
/sbin/chkconfig --list | grep ntpd
sudo /sbin/chkconfig --level 2345 ntpd on

```

## 4) Initial sync

> sudo /usr/sbin/ntpdate pool.ntp.org

## 5) Start service / restart

> sudo /sbin/service ntpd start

---
layout: post
title: VMWare and slow clocks - take 2
date: 2009-01-09 14:37:46.000000000 -05:00
type: post
published: true
status: publish
category: programming
tags: []
author: "Miro Adamy"
---

The centos 4.x we are using as platform for the VMWare VMs (yes, I know there is version 5, but we need to be compliant with RHEL 4.x because of the ATG requirements) installs by default the NTP client.

Here is sequence of steps that needs to be performed to enable automatic synchronization of the clocks.

1) make sure the DNS works

```
cat /etc/resolv.conf
sudo vi /etc/resolv.conf
```

and check that nameservers point to something meaningfull, e.g:

```
nameserver 208.67.222.222
nameserver 208.67.220.220
nameserver 192.168.16.1
```

<p>2) check that you have ntpd installed</p>


`cat /etc/ntp.conf`

<p>- inspect the content of the file, it is quite well documented</p>
<p>3) make it work in runlevels 2345</p>

`/sbin/chkconfig --list | grep ntpd`

<p>- this will most likely show "off" for all runlevels</p>

`sudo /sbin/chkconfig --level 2345 ntpd on`

<p>4) Initial sync</p>

`sudo /usr/sbin/ntpdate pool.ntp.org`

<p>- do this twice, on second you should get very small difference</p>

<p>5) Start service / restart service</p>

`sudo /sbin/service ntpd start`

<p>Making this a blog post so that next time I need to do it I can easily find it :-). Maybe somebody else will find it useful as well.</p>

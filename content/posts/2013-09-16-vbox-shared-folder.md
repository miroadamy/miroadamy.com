---
title: "Case sensitivity and VirtualBox shared folder"
date: 2013-09-16T11:22:48+08:00
published: true
type: post
categories: ["Technology"]
tags: ["osx", "virtualbox"]
author: "Miro Adamy"
---

# Case sensitivity and VirtualBox shared folder

Weird but true behaviour:

I have the case sensitive encrypted disk (sparse bundle with HFSX type) mounted in VBox shared folders. All works fine, after VM starts:

```
touch zz zZ
```

creates two files, both "inside VM" `~/development/ATG/platform-edc` as well as in OS-X.

If the VM is suspended and resumed, it looses the case sensitivity inside the VM. 

The command

```
cd ~/development/ATG/platform-edc
touch zz zZ
```

will create just single file. Outside the VM, in OS-X file system is still case sensitive. 

It looks as if the wake-up remounted the volumen and normal HFS+ instead of HFSX
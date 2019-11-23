---
layout: post
title: Installing ATG on Fedora Core
date: 2007-11-08 15:56:30.000000000 -05:00
type: post
published: true
status: publish
category: programming
tags: [java, atg]
meta: {}
author: "Miro Adamy"
---
<p>Trying to install <a href="http://www.atg.com/">ATG</a> on the <a href="http://fedoraproject.org/wiki/Overview" target="_blank">Linux</a> platform turned out to be not completely hickup-free. The default installer died with the following message:</p>

```
    $ ./ATG2007.1.bin>
    Preparing to install...>
    Extracting the installation resources from the installer archive...>
    Configuring the installer for this system's environment...>
    awk: error while loading shared libraries: libdl.so.2: cannot open shared object file: No such file or directory>
    dirname: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory>
    /bin/ls: error while loading shared libraries: librt.so.1: cannot open shared object file: No such file or directory>
    basename: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory>
    dirname: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory>
    basename: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory[/sourcecode]>
    Fortunately, the fix was easy after I found out what went wrong: incorrect assumption about kernel version. To make it work, this "hack" helped:>
    [sourcecode language='css']>
    $ mv ATG2007.1.bin ATG2007.1.bin.orig>
    $ cat ATG2007.1.bin.orig | sed "s/export LD_ASSUME_KERNEL/#xport LD_ASSUME_KERNEL/" &gt;ATG2007-1.bin
```

None of this of course happens on Windows - oh, yes - the joys of not swimming with the crowd :-). You will encounter issues otherwise unknown - but also learn something in the process.</p>

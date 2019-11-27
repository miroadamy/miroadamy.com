---
title: "Dealing with 'Java Runtime SE 6' required error"
date: 2014-10-14T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["java","osx"]
author: "Miro Adamy"
---

When trying to start DBeaver (http://dbeaver.jkiss.org) I got this

![](/images/java6-1.png)

I do have Java 7 installed:

```
➜  Contents  java -version
java version "1.7.0_55"
Java(TM) SE Runtime Environment (build 1.7.0_55-b13)
Java HotSpot(TM) 64-Bit Server VM (build 24.55-b03, mixed mode)
 
➜  Contents  which java
java is /Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk/Contents/Home/bin/java
java is /usr/bin/java
```

which should be a superset. But it is not.

## Solution
Oracle seems to screw up the PLIST capabilities in JAva7 install

Go to

```
➜  ~  cd /Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk/Contents
 
 
➜  Contents  ll
total 8
drwxrwxr-x  15 root  wheel   510B 17 Mar  2014 Home
-rw-rw-r--   1 root  wheel   1.5K 17 Mar  2014 Info.plist
drwxrwxr-x   3 root  wheel   102B 21 Apr 12:07 MacOScode
```

And edit the Info.plist, adding following values to JVMCapabilities key (originally has just `<string>CommandLine</string>`)

![](/images/java6-2.png)
Afterwards, I had to restart the Pathfinder (or whatever shell you use).


## BEFORE

```
<key>JVMCapabilities</key> 
<array>
  <string>CommandLine</string>
</array>
```


## AFTER
```

<key>JVMCapabilities</key> 
<array>
  <string>JNI</string>
  <string>BundledApp</string>
  <string>WebStart</string>
  <string>Applets</string>
  <string>CommandLine</string>
 </array>
```
 
Source <http://crunchify.com/os-x-mavericks-eclipse-java-issue/>


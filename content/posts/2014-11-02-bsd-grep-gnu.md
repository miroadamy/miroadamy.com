---
title: "Replace BSD grep with GNU grep"
date: 2014-11-02T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

## If annoyed with:

```
➜  ~  echo $PATH | tr ':' '\n'
/usr/local/opt/coreutils/libexec/gnubin
/Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk/Contents/Home/bin
/opt/ant/bin
/opt/groovy/bin
/opt/gradle/bin
/Users/miro/bin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/usr/local/bin
/opt/X11/bin
/usr/texbin
  
# YEs I am using GNU core utils but grep is not there
  
# The issue
➜  ~  grep --version
grep (BSD grep) 2.5.1-FreeBSD
  

```

Here is the receipt

http://www.heystephenwood.com/2013/09/install-gnu-grep-on-mac-osx.html

Did not install it as the issue was not with grep:

Instead, use `findInJars.sh`

 ```
 ➜  ~  cat ~/bin/findInJars.sh
#!/bin/bash
pattern=$1
shift
for jar in $(find $* -type f -name "*.jar")
do
  # echo Checking: $jar
  match=`jar -tvf $jar | grep $pattern`
  if [ ! -z "$match" ]
  then
    echo "Found in: $jar"
    echo "$match"
  fi
done
  
➜  ~  ~/bin/findInJars.sh atg.taglib.dspjsp.IncludeTag ~/ATG
Found in: /Users/miro/ATG/ACC11.0/10.1.2/DAS/lib/classes.jar
  1924 Thu Dec 13 05:02:52 EST 2012 atg/taglib/dspjsp/IncludeTag$DspIncludeResponseWrapper.class
  1081 Thu Dec 13 05:02:52 EST 2012 atg/taglib/dspjsp/IncludeTag$ReverseLayerMapInfo.class
 22844 Thu Dec 13 05:02:52 EST 2012 atg/taglib/dspjsp/IncludeTag.class
Found in: /Users/miro/ATG/ACC11.0/11.0/DAS/lib/classes.jar
  2537 Thu Dec 05 10:54:12 EST 2013 atg/taglib/dspjsp/IncludeTag$DspIncludeResponseWrapper.class
  1081 Thu Dec 05 10:54:12 EST 2013 atg/taglib/dspjsp/IncludeTag$ReverseLayerMapInfo.class
 24003 Thu Dec 05 10:54:12 EST 2013 atg/taglib/dspjsp/IncludeTag.class
 ```
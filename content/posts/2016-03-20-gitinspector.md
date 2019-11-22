---
title: Git project statistic tool
date: 2016-03-20 12:57:35.000000000 -05:00
type: post
published: true
status: publish
comments: true
category: programming
tags: 
  - osx
  - git
author: "Miro Adamy"
---

# Git project statistic tool

Python based, requires Python 2.6+

Works OOTB on Mac

## Installation

* Download TAR from [Github](https://github.com/ejwa/gitinspector) 
* unzipped to /opt

```bash
➜  ll /opt/gitinspector-0.3.2
total 52K
-rw-r--r--  1 miro  999 Jul 29  2013 DESCRIPTION.txt
-rw-r--r--  1 miro  32K Jun 14  2013 LICENSE.txt
-rw-r--r--  1 miro   78 Jul  2  2013 MANIFEST.in
-rw-r--r--  1 miro  681 Jan 13  2014 README.txt
drwxr-xr-x 45 miro 1.5K Mar 20  2015 gitinspector
-rw-r--r--  1 miro 1.9K Jan 14  2014 setup.py
-rw-r--r--  1 miro  110 Jul 27  2013 stdeb.cfg
```

* create symlink from ~/bin (or from whatever directory on $PATH)

```bash
ln -s /opt/gitinspector-0.3.2/gitinspector/gitinspector.py ~/bin/gitinspector.py
  
➜  ~  ll ~/bin | grep gitin
lrwxr-xr-x 1 miro   52 Mar 20 16:06 gitinspector.py -> /opt/gitinspector-0.3.2/gitinspector/gitinspector.py
```

## Example

Look at scala sources - git@github.com:scala/scala.git

```
➜  scala git:(2.12.x) gitinspector.py -Tlr --since=2014-01-01
The following historical commit information, by author, was found in the repository:

Author                     Commits    Insertions      Deletions    % of changes
Adriaan Moors                    6            69           7365            9.81
Antoine Gourlay                  6            98           7391            9.88
David Hoepelman                  1            30             25            0.07
EECOLOR                          1             1              5            0.01
Eitan Adler                      1             2              2            0.01
Felix Mulder                    12           776           6272            9.30
Janek Bogucki                    1             2              2            0.01
Jason Zaugg                     26           617            263            1.16
Kato Kazuyoshi                   3            12             12            0.03
Lukas Rytz                      22          7400          44785           68.87
Marcin Kubala                    1            95             35            0.17
Mariot Chauvin                   1             6             29            0.05
Michał Pociecha                  1             1              1            0.00
Pim Verkerk                      1             1              1            0.00
Seth Tisue                       1             0             38            0.05
Simon Ochsenreither              3           246             71            0.42
Viktor Klang                     1            19             44            0.08
mpociecha                        1            26             26            0.07

Below are the number of rows from each author that have survived and are still intact in the current revision:

Author                     Rows       % in comments
Adriaan Moors                29               10.34
Antoine Gourlay              18               38.89
David Hoepelman              30               10.00
EECOLOR                       1                0.00
Felix Mulder                616               11.36
Janek Bogucki                 2                0.00
Jason Zaugg                 430                8.84
Kato Kazuyoshi                5                0.00
Lukas Rytz                34620                1.20
Marcin Kubala                49                2.04
Pim Verkerk                   1                0.00
Simon Ochsenreither         245                5.31
mpociecha                     2              100.00

The following history timeline has been gathered from the repository:

Author                  2014-02    2014-03    2014-05    2014-06    2014-07    2014-08    2014-09    2014-10    2014-11    2014-12    2015-02
Adriaan Moors                ++          -                                                                                           ----++++
Antoine Gourlay                                                              ---------  +++++++++
Jason Zaugg           +++++++++          +          .  +++++++++  +++++++++                                .  +++++++++
Kato Kazuyoshi                                                                       .
Lukas Rytz                                   ++++++++                                .         ++                                .
Marcin Kubala                     --++++++
Simon Ochsenreither                                                                                     ++++
Viktor Klang                                                                                        ------++
mpociecha                                                                                                                 ----++++
Modified Rows:               95        174       4028          7          1       7414         91         94         10         54          4

Author                  2015-03    2015-04    2015-05    2015-06    2015-07    2015-08    2015-09    2015-10    2015-11    2015-12    2016-01
Adriaan Moors                                                 ++  ---------
Antoine Gourlay               .                                                          ++++++++
EECOLOR                       .
Eitan Adler                                                                                                                                 .
Felix Mulder                                                                                                              ---+++++  ---------
Janek Bogucki                                                                                                  ----++++
Jason Zaugg             +++++++          .          .          +          .                        +++++++++                                .
Kato Kazuyoshi                .          .
Lukas Rytz             ++++++++  ---------  ---------   ++++++++       ++++
Mariot Chauvin                                                            .
Michał Pociecha                                                                      .
Seth Tisue                                                                   ---------
Simon Ochsenreither                      .                                                                                                  .
Modified Rows:              642      12953      31781         62      10763         40         12          6          4        173       5694

Author                  2016-02    2016-03
David Hoepelman                          +
Felix Mulder           ----++++         -+
Jason Zaugg                      ---------
Lukas Rytz                    .
Pim Verkerk                              .
Modified Rows:             1255        411

The following repsonsibilties, by author, were found in the current revision of the repository (comments are exluded from the line count, if
possible):

Adriaan Moors is mostly responsible for:
    12 test/files/pos/t9356/MyAnnotation.java
     3 test/files/pos/t6169/Skinnable.java
     3 test/files/pos/t6169/ExistIndir.java
     3 test/files/pos/t6169/ExistF.java
     3 test/files/pos/t6169/Exist.java
     1 test/files/pos/t6169/Skin.java
     1 test/files/pos/t6169/OP.java

Antoine Gourlay is mostly responsible for:
     8 test/files/pos/t9239/Usage.java
     1 test/files/neg/t4851/J2.java
     1 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/index.js
     1 spec/public/scripts/highlight.pack.js

David Hoepelman is mostly responsible for:
    27 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/template.js

EECOLOR is mostly responsible for:
     1 src/library/scala/runtime/BoxesRunTime.java

Felix Mulder is mostly responsible for:
   395 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/index.js
    74 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/template.js
    49 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/scheduler.js
    26 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/diagrams.js
     1 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/jquery.panzoom.min.js
     1 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/jquery.mousewheel.min.js

Janek Bogucki is mostly responsible for:
     1 src/library/scala/reflect/ScalaSignature.java
     1 src/library/scala/reflect/ScalaLongSignature.java

Jason Zaugg is mostly responsible for:
    45 test/files/run/t7741a/GroovyInterfaceDump.java
    45 test/files/run/t7741a/GroovyInterface$1Dump.java
    43 src/library/scala/runtime/StructuralCallSite.java
    29 src/library/scala/runtime/LambdaDeserialize.java
    20 src/library/scala/runtime/SymbolLiteral.java
    16 test/files/run/indy-via-macro-with-dynamic-args/Bootstrap.java
    15 test/files/run/indy-via-macro/Bootstrap.java
    12 test/files/run/t9268/Java.java
    11 test/files/pos/t5165b/TestAnnotation_1.java
    10 test/files/pos/t9393/NamedImpl_2.java

Kato Kazuyoshi is mostly responsible for:
     5 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/template.js

Lukas Rytz is mostly responsible for:
   495 src/library/scala/runtime/java8/JFunction2.java
   495 src/library/scala/runtime/java8/JFunction2$mcZJJ$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZJI$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZJD$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZIJ$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZII$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZID$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZDJ$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZDI$sp.java
   495 src/library/scala/runtime/java8/JFunction2$mcZDD$sp.java

Marcin Kubala is mostly responsible for:
    47 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/template.js
     1 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/index.js

Pim Verkerk is mostly responsible for:
     1 src/scaladoc/scala/tools/nsc/doc/html/resource/lib/scheduler.js

Simon Ochsenreither is mostly responsible for:
   117 spec/public/scripts/toc.js
    55 spec/public/scripts/main.js
    11 test/files/neg/t8700b/Baz_1.java
    11 test/files/neg/t8700a/Baz.java
     5 test/files/run/t4788/SAnnotation.java
     5 test/files/run/t4788/RAnnotation.java
     5 test/files/run/t4788/CAnnotation.java
     5 test/files/run/t4788-separate-compilation/SAnnotation_1.java
     5 test/files/run/t4788-separate-compilation/RAnnotation_1.java
     5 test/files/run/t4788-separate-compilation/CAnnotation_1.java

The extensions below were found in the repository history (extensions used during statistical analysis are marked):
rtf number x-build conf 0-M0 txt check xml [java] scala res json html yml css bnd tmpl sbt latex bib [js] SAMPLE awk html5 properties md bat sha1 svg script list sh flags

```


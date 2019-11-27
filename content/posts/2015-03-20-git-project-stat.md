---
title: "Git project statistic tool"
date: 2015-03-20T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

# Git Inspector

Python based, requires Python 2.6+

Works OOTB on Mac

## Installation

* Download TAR from <https://code.google.com/p/gitinspector/>
* unzipped to

```
/opt/gitinspector-0.3.2:
total 52K
-rw-r--r--  1 miro  999 Jul 29  2013 DESCRIPTION.txt
-rw-r--r--  1 miro  32K Jun 14  2013 LICENSE.txt
-rw-r--r--  1 miro   78 Jul  2  2013 MANIFEST.in
-rw-r--r--  1 miro  681 Jan 13  2014 README.txt
drwxr-xr-x 45 miro 1.5K Mar 20 16:06 gitinspector
-rw-r--r--  1 miro 1.9K Jan 14  2014 setup.py
-rw-r--r--  1 miro  110 Jul 27  2013 stdeb.cfg
```

* create symlink to it from `~/bin` (is on path)

```
ln -s /opt/gitinspector-0.3.2/gitinspector/gitinspector.py ~/bin/gitinspector.py
  
➜  ~  ll ~/bin | grep gitin
lrwxr-xr-x 1 miro   52 Mar 20 16:06 gitinspector.py -> /opt/gitinspector-0.3.2/gitinspector/gitinspector.py
```

# Example

```
➜  gitinspector git:(master) ~/bin/gitinspector.py -Tlr --since=2014-01-01 --until=2015-05-05
Statistical information for the repository 'gitinspector' was gathered on 2019/11/27.
The following historical commit information, by author, was found in the repository:

Author                     Commits    Insertions      Deletions    % of changes
Adam Waldenberg                 41           569            249           95.34
Chris Barry                      1             3              3            0.70
Christian Kastner                2             9              5            1.63
Diomidis Spinellis               2             3              3            0.70
Dmitry Dzhus                     1             3              3            0.70
Jon Warghed                      1             1              0            0.12
Yannick Moy                      1             4              3            0.82

Below are the number of rows from each author that have survived and are still intact in the current revision:

Author                     Rows      Stability          Age       % in comments
Adam Waldenberg             468           82.2          8.7                6.84
Chris Barry                   3          100.0          4.5                0.00
Christian Kastner             8           88.9          3.3                0.00
Diomidis Spinellis            1           33.3          4.0              100.00
Dmitry Dzhus                  3          100.0          2.6                0.00
Jon Warghed                   1          100.0          3.2                0.00
Yannick Moy                   3           75.0          3.7                0.00

The following history timeline has been gathered from the repository:

Author                  2014-01    2014-02    2014-03    2014-11    2014-12    2015-02
Adam Waldenberg        -+++++++   --++++++   ---+++++  ----+++++  --+++++++   -+++++++
Chris Barry                                                    .
Christian Kastner                                              .
Diomidis Spinellis                                             .
Dmitry Dzhus                                                              .
Jon Warghed                                                    .
Yannick Moy                                                    .
Modified Rows:              170        387          7        223         64          7

The following responsibilities, by author, were found in the current revision of the repository (comments are excluded from the line count, if possible):

Adam Waldenberg is mostly responsible for:
   128 gitinspector/metrics.py
    97 gitinspector/blame.py
    30 gitinspector/localization.py
    29 gitinspector/clone.py
    26 gitinspector/terminal.py
    26 gitinspector/basedir.py
    19 gitinspector/changes.py
    17 gitinspector/filtering.py
    16 gitinspector/format.py
    15 gitinspector/gitinspector.py

Chris Barry is mostly responsible for:
     2 gitinspector/format.py
     1 gitinspector/gravatar.py

Christian Kastner is mostly responsible for:
     5 gitinspector/basedir.py
     3 gitinspector/format.py

Dmitry Dzhus is mostly responsible for:
     3 gitinspector/comment.py

Jon Warghed is mostly responsible for:
     1 gitinspector/changes.py

Yannick Moy is mostly responsible for:
     3 gitinspector/comment.py

The extensions below were found in the repository history (extensions used during statistical analysis are marked):
1 css header html po pot [py] txt
```
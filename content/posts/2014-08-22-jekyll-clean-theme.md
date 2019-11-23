---
layout: post
title: "Third time is a charm"
date: 2014-08-22 16:25:06 -0700
comments: true
type: post
published: true
status: publish
category: general
tags: [blog]
author: "Miro Adamy"
---

As part of "back to basics" software minimalism movement, I have exported the old Wordpress blog
and loaded it into Jekyll with intention to publish it on my Github 

This contains almost 10 years worth of history of my posts, plus few not yet previously unpublished posts.

It is based on Jekyll Clean theme, 
created by Scott Emmons - see it / get it from [github](https://github.com/scotte/jekyll-clean).


If you are interested in the Jekyll Clean theme:

* See the [live demo](https://scotte.github.io/jekyll-clean).
* See it [in action on Scott's blog](https://scotte.org).

Migration process
=================

I exported the Wordpress using Admin export tool - which produced the huge XML file.

I forked the jekyll-clean and made sure it works

```
$ git clone git@github.com:miroadamy/jekyll-now.git
$ cd jekyll-now
$ jekyll build
$ jekyll serve
$ git remote add upstream git@github.com:scotte/jekyll-clean.git
```

The last one is to allow getting fixes from Scott.

Then I installed importer and few required gems to run the import

```
$ sudo gem install jekyll-paginate
$ sudo gem install github-pages
$ sudo gem install jekyll-import
$ sudo gem install hpricot
$ sudo gem install open_uri_redirections
$ mv ~/Downloads/miro039sworld.wordpress.2016-03-14.xml ..

$ ruby -rubygems -e 'require "jekyll-import"; JekyllImport::Importers::WordpressDotCom.run({ "source" => "/Users/miro/src/PLG/miro039sworld.wordpress.2016-03-14.xml" })'

$ git checkout -b master
$ git push origin master
$ git add .
$ git commit -m "Imported the old Wordpress blog from miroadamy.com"
```

Now browse to http://127.0.0.1:4000


Disqus Comments
===============

I have not set up comments yet as 
[documented here](https://help.disqus.com/customer/portal/articles/472138-jekyll-installation-instructions).


License
=======

The content of this theme is distributed and licensed under a
![License Badge](/images/cc_by_88x31.png)
[Creative Commons Attribution 4.0 License](https://creativecommons.org/licenses/by/4.0/legalcode)

    This license lets others distribute, remix, tweak, and build upon your work,
    even commercially, as long as they credit you for the original creation. This
    is the most accommodating of licenses offered. Recommended for maximum
    dissemination and use of licensed materials.

In other words: you can do anything you want with this theme on any site, just please
provide a link to [the original theme on github](https://github.com/scotte/jekyll-clean)
so I get credit for the original design. Beyond that, have at it!

This theme includes the following files which are the properties of their
respective owners:

* js/bootstrap.min.js - [bootstrap](http://getbootstrap.com)
* css/bootstrap.min.css - [bootstrap](http://getbootstrap.com)
* js/jquery.min.js - [jquery](https://jquery.com)
* images/cc_by_88x31.png - [creative commons](https://creativecommons.org)
* css/colorful.css - [iwootten/jekyll-syntax](https://github.com/iwootten/jekyll-syntax)

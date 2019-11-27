---
layout: post
title: Installation of Mongrel gem on JRuby
date: 2007-12-23 20:22:50.000000000 -05:00
type: post
published: true
status: publish
categories: ["programming"]
tags: [java,ruby]
meta: {}
author: "Miro Adamy"
---
<p>I bought the <a href="http://ola-bini.blogspot.com/" target="_blank">Ola Bini</a>'s <a href="http://www.apress.com/book/view/1590598814" target="_blank">eBook on JRuby</a> and started to work through the examples. The installation of the Mongrel gem in JRuby (trunk revision  5341 fails with the following error code:</p>
```
    $ jruby -S gem install -y mongrel>
    INFO:  `gem install -y` is now default and will be removed>
    INFO:  use --ignore-dependencies to install only the gems you list>
    Building native extensions.  This could take a while...>
    extconf.rb:1:in `require': no such file to load -- mkmf (LoadError)>
    ERROR:  Error installing mongrel:>
    	ERROR: Failed to build gem native extension.[/sourcecode]>
    This error is logged in JIRA with id JRUBY-1771Workaround (possibly applicable for other gems is to explicitly specify the plaform:>
    [sourcecode language='ruby']>
    $ jruby -S gem install -y mongrel --platform jruby>
    INFO:  `gem install -y` is now default and will be removed>
    INFO:  use --ignore-dependencies to install only the gems you list>
    Successfully installed mongrel-1.1.2>
    1 gem installed>
    Installing ri documentation for mongrel-1.1.2...>
    Installing RDoc documentation for mongrel-1.1.2...
```

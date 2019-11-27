---
layout: post
title: XCode annoyances
date: 2008-09-01 22:34:57.000000000 -04:00
type: post
published: true
status: publish
categories: ["programming"]
tags:
- objectivec
author: "Miro Adamy"
---
<p>I have started to seriously play with Objective C and XCode about week ago. So far it was very pleasant experience. I really like the language - feels like Ruby (or Smalltalk if you want) with rocket launcher: very powerful, blastingly fast and dangerous like hell. No array boundary checks as in Java :-).</p>
<p>The XCode was not bad experience either. Here my very long Eclipse and Visual Studio history is going a bit in the way, as the things often works quite different. Not necessarily worse, but different. It would be too early to judge it - not before I get more proficient in both Objective-C and XCode and learn more Cocoa goodness.</p>
<p>Two things however are so annoying, that I have to mention them right now:</p>
<p>1) Setting breakpoints was gamble - sometimes it worked, sometimes it did not. I could not figure out why, until I found <a href="http://kleymeyer.typepad.com/blog/2007/09/problem-with-br.html" target="_blank">here</a> that you must in Preferences -&gt; Debug switch off the 'Lazy loading symbols'. After re-entering the breakpoints, I finally got it to behave as expected.</p>
<p>2) Trying to add existing files to a projects crashes the XCode with the following:</p>
<p><img class="alignnone size-full wp-image-536" src="{{ site.baseurl }}/images/picture-11.png" alt="" width="450" height="194" /></p>
<p>The console window shows error:</p>

```
PM Xcode[34563] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '
*** -[NSAutoreleasePool stopObservingModelObject:]: unrecognized selector sent to instance 0x32da240'

```

<p>which is clearly a bug. I tried to reboot (it was about time after running for over two weeks anyway), no help.</p>
Weird is that I remember doing that before without any problems ... Workaround is use drag and drop, of course, but I wish Apple would fix this Really Soon, as it is plainly embarrassing ...</p>
<p>I have seen crashes like this in Visual Studio, but Eclipse was rock solid environment despite the very complex plugins ecosystem, so it is hard to go back to use something blowing under your hands ...</p>

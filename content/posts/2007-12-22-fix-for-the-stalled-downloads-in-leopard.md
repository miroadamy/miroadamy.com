---
layout: post
title: Fix for the stalled downloads in Leopard
date: 2007-12-22 23:12:18.000000000 -05:00
type: post
published: true
status: publish
tags: []
meta: {}
author: "Miro Adamy"
---
<p>I was experiencing the occasional weird behaviour on downloading large files in Leopard: the download would stall, but after stopping/restarting (which can be done in Safari and iTunes), the download would continue. It was not very consistent, and I suspected the NAT router or even Rogers - some sites were occasionally having this problem, while other sites would not.</p>
<p>While playing with JRuby over the weekend, this happened again and pretty much prevented the gem installation - because the multi-megabyte gem index would not download from http://gems.rubyforge.org/. Strangely enough, same download would work on Tiger, on Linux and on Windows using same router - which pretty much excluded router as a cause.</p>
<p>I found simple fix <a href="http://discussions.apple.com/thread.jspa?messageID=6079960" target="_blank">here</a> - big thanks to Chris D Searle. Run the following:</p>

```ruby
   sudo sysctl -w net.inet.tcp.rfc1323=0
```
(it replaces the default value of 1)</p>
<p>I do not know all the details of the fix - it switches off some TCP window optimization which may have been the cause of the problem. More on the parameter and how to set it in variety of OS-es can be found  <a href="http://proj.sunet.se/E2E/tcptune.html" target="_blank">in the TCP tuning handbook</a>.</p>
<p>To make change permanent, create (or edit) the file /etc/sysctl.conf with the content:</p>
```
   net.inet.tcp.rfc1323=0
```

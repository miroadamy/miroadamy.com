---
title: "logstash - known error"
date: 2014-09-16T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["logs","logstash", "elk"]
author: "Miro Adamy"
---

I have been trying to make this work for about 1.5 hr. 
Looks like there is open bug - <https://logstash.jira.com/browse/LOGSTASH-703>

Helpful link: <https://groups.google.com/forum/#!topic/logstash-users/sZM03po7HJE>

What should work:

```
grok {
   match => ["message", "regex to parse severity"],
   match => ["message", "regex to parse server IP"],
   match => ["message", "regex to parse user"]
}
```

What needs to be done instead

```
You _should_ be able to do exactly what you listed at the bottom of your email, 
except that you'd need `break_on_match => false` so that it would parse each snippet for each message 
instead of just parsing the first one that matches. 
Unfortunately, due to a bug (https://logstash.jira.com/browse/LOGSTASH-703), 
this doesn't work when you're matching against the same field in each match expression ("message" in your case). 
I was hoping to take a stab at fixing this bug (as several others have mentioned an interest in doing), 
but got distracted and haven't done it yet. It shouldn't be terribly hard to fix, just needs some time.
 
As a work-around, the following should work, but unfortunately the way that your tag_on_failure 
will end up working will be different 
because you have multiple Grok filters that could fail independently. 
It's probably slightly less efficient to do it this way because the event has to pass 
from one filter to the next through the pipeline, 
but my guess (based on absolutely no empirical data) is that it isn't significantly slower 
because the same work would need to be done by Regex either way, 

there's just more LogStash in the mix this way.
 
 
grok {
   match => ["message", "regex to parse severity"]
 
}
grok {
   match => ["message", "regex to parse server IP"]
}
grok {
   match => ["message", "regex to parse user"]
}
 
 
 
~Greg Mefford
```
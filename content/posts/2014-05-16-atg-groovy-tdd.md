---
title: "ATG Groovy TDD"
date: 2014-05-16T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["atg", "groovy", "tdd"]
author: "Miro Adamy"
---

Got it working. It is a bit rough around the edges, but functional.

The two components

* <http://localhost:8080/dyn/admin/nucleus/thinkwrap/twatg/script/GroovyDemoScript/>
* <http://localhost:8080/dyn/admin/nucleus/thinkwrap/twatg/script/GroovyScriptRunner/>

The are not started via Initial, but that is not a problem.

The script tested:

```java
class ThatsGroovyDude implements com.thinkwrap.twatg.script.RunnableScript {
    atg.nucleus.Nucleus nuc = atg.nucleus.Nucleus.getGlobalNucleus();
    public String run() {
  
       String s = "";
       nuc.configPathNames.each { s += "${it}\n" }
       return "Hello World!\n\n" + s;
   }
}
```

![](/images/atg-tdd-groovy.png)

![](/images/atg-tdd-groovy-2.png)


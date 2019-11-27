---
layout: post
title: Tomcat 5 not reloading changes in JSP
date: 2011-07-24 17:33:34.000000000 -04:00
type: post
published: true
comments: true
status: publish
categories: ["programming"]
tags:
- java
author: "Miro Adamy"
---
Part of the beauty of JSP development is the easy of trying out the change. All you have to do is edit the JSP file, save it and reload the page. Yesterday I got caught by surprise by not being able to do exactly that.
I saw some strange behaviour in an EL expression used JSP tag. As it was nothing ATG specific, I decided to try it out in plain old Tomcat rather than full ATG application. So I located the instance of Tomcat 5.5 (I always have couple of Tomcats lying around) and being lazy, I decided to inject the change into out-of the box jsp-examples Web application that comes with it.

I picked a victim JSP to be modified (jsp2/el/basic-comparison.jsp), made my change, reloaded page - nothing. I must have forgotten to save the file, did it again - nothing. Weird. Maybe browser caching. Cmd-Shift-R - nothing. Tried different browser - it showed unchanged file as before. Definitely not a browser issue.
The most logical explanation would be that I am editing different file than reloading: so I verified that the JSP file I edited is indeed under WebApps, that correct version of Tomcat was started. It was. There was no context redirection in place but to be sure, I unzipped pristine copy of apache-tomcat-5.5.31.zip (I have couple of those around as well), copied the JSP there, started it - same thing.

Really weird.

Few more experiments showed that no change to any JSP page under jsp-examples was visible. Removing JSP page caused 404 error as expected, but as soon as the page was there, it reappeared in original pristine version.
At this point, I started to suspect there is something fishy with the jsp-examples application itself. And it was. Brief check of the web.xml showed that it is quite long (24K) and that it contains declaration:

```
<servlet>
  <servlet-name>org.apache.jsp.jsp2.el.basic_002dcomparisons_jsp</servlet-name>
  <servlet-class>org.apache.jsp.jsp2.el.basic_002dcomparisons_jsp</servlet-class>
</servlet>
....
<servlet-mapping>
  <servlet-name>org.apache.jsp.jsp2.el.basic_002dcomparisons_jsp</servlet-name>
  <url-pattern>/jsp2/el/basic-comparisons.jsp</url-pattern>
</servlet-mapping>
```

and suddenly it all made sense.

As long as the JSP file was present (Tomcat checks), it's content was completely ignored and the request for /jsp2/el/basic-comparisons.jsp was served by COMPILED class /webapps/jsp-examples/WEB-INF/classes/org/apache/jsp/jsp2/el/basic_002dcomparisons_jsp.class - which of course did not contain any of the JSP file changes. When I removed file, Tomcat reported 404 a- the check for file existence comes before check for URL mapping apparently.

Moral of the story: being lazy causes one has to do more work but often learns something new. Had I created fresh new WebApp, none of these mappings were present and I would never realized what is Tomcat 5 doing behind the scenes.

Btw, in Tomcat 6 the mappings are gone and everything behaves as expected.
Although this is not technically a bug - but a feature - it is unfortunate that this optimization is used exactly in one application that can be used by newbie developer learning JSP for experimentation and not seeing it's change can confuse the hell out of them. Especially when googling the issue will very likely sending him/her in completely wrong direction - suggesting reconfiguring Jasper, playing with valves and internals of Tomcat configuration.

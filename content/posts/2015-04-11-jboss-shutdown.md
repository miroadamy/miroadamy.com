---
title: "Fixing the shutdown problem with JBoss"
date: 2015-04-11T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["java","jboss"]
author: "Miro Adamy"
---

Observed at QA environment. During automated shutdown sequence, the exception was thrown:

```
$ bin/gdi-qa-com1.sh stop
JBOSS_CMD_STOP = java -classpath /opt/jboss/jboss-as/bin/shutdown.jar:/opt/jboss/jboss-as/client/jnet.jar org.jboss.Shutdown --shutdown --user=admin --password=admin -s jnp://0.0.0.0:1099
Exception in thread "main" javax.naming.CommunicationException: Could not obtain connection to any of these urls: 0.0.0.0:1099 [Root exception is javax.naming.CommunicationException: Failed to connect to server /0.0.0.0:1099 [Root exception is javax.naming.ServiceUnavailableException: Failed to connect to server /0.0.0.0:1099 [Root exception is java.net.ConnectException: Connection refused]]]
    at org.jnp.interfaces.NamingContext.checkRef(NamingContext.java:1763)
    at org.jnp.interfaces.NamingContext.lookup(NamingContext.java:693)
    at org.jnp.interfaces.NamingContext.lookup(NamingContext.java:686)
    at javax.naming.InitialContext.lookup(InitialContext.java:392)
    at org.jboss.Shutdown.main(Shutdown.java:219)
Caused by: javax.naming.CommunicationException: Failed to connect to server /0.0.0.0:1099 [Root exception is javax.naming.ServiceUnavailableException: Failed to connect to server /0.0.0.0:1099 [Root exception is java.net.ConnectException: Connection refused]]
    at org.jnp.interfaces.NamingContext.getServer(NamingContext.java:335)
    at org.jnp.interfaces.NamingContext.checkRef(NamingContext.java:1734)
    ... 4 more
Caused by: javax.naming.ServiceUnavailableException: Failed to connect to server /0.0.0.0:1099 [Root exception is java.net.ConnectException: Connection refused]
    at org.jnp.interfaces.NamingContext.getServer(NamingContext.java:305)
    ... 5 more
Caused by: java.net.ConnectException: Connection refused
    at java.net.PlainSocketImpl.socketConnect(Native Method)
    at java.net.PlainSocketImpl.doConnect(PlainSocketImpl.java:351)
    at java.net.PlainSocketImpl.connectToAddress(PlainSocketImpl.java:211)
    at java.net.PlainSocketImpl.connect(PlainSocketImpl.java:200)
    at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:366)
    at java.net.Socket.connect(Socket.java:529)
    at org.jnp.interfaces.TimedSocketFactory.createSocket(TimedSocketFactory.java:97)
    at org.jnp.interfaces.TimedSocketFactory.createSocket(TimedSocketFactory.java:82)
    at org.jnp.interfaces.NamingContext.getServer(NamingContext.java:301)
    ... 5 more
To watch the log: tail -f /var/log/atg/gdi-qa-com1.log
```

The conflict of 1099 between Endeca and ATG was resolved according `Fixing port conflict on 1099 between out-of-the-box Endeca and JBOSS` - the actual port was 11199

![](/images/jboss-fix-1.png)

The environment variable for JBOSS instance were OK

```
[jboss@gdi-app-l1 ~]$ env | grep JBOSS
JBOSS_COM2_CONSOLE=/var/log/atg/gdi-qa-com2.log
JBOSS_LDR_CONF=gdi-qa-ldr
JBOSS_HOME=/opt/jboss/jboss-as
JBOSS_COM2_HOST=0.0.0.0
JBOSS_STG_CONSOLE=/var/log/atg/gdi-qa-stg.log
JBOSS_COM1_HOST=0.0.0.0
JBOSS_COM2_ADMINPORT=1199
JBOSS_COM1_CONSOLE=/var/log/atg/gdi-qa-com1.log
JBOSS_STG_CONF=gdi-qa-stg
JBOSS_STG_ADMINPORT=1299
JBOSS_STG_HOST=0.0.0.0
JBOSS_ADMINPASS=admin
JBOSS_LDR_CONSOLE=/var/log/atg/gdi-qa-ldr.log
JBOSS_USER=RUNASIS
JBOSS_LDR_ADMINPORT=1399
JBOSS_LDR_HOST=0.0.0.0
JBOSS_COM1_ADMINPORT=1099
JBOSS_COM1_CONF=gdi-qa-com1
JBOSS_COM2_CONF=gdi-qa-com2
```

but these are used only for shutdown.

The actual port used for communication was:

```
[jboss@gdi-app-l1 gdi-qa-com1]$ sudo netstat -tulpn | grep 27745 | grep 1099
tcp        0      0 0.0.0.0:11099               0.0.0.0:*                   LISTEN      27745/java
[jboss@gdi-app-l1 gdi-qa-com1]$ sudo netstat -tulpn | grep 27745 | grep 109
tcp        0      0 0.0.0.0:11098               0.0.0.0:*                   LISTEN      27745/java
tcp        0      0 0.0.0.0:11099               0.0.0.0:*                   LISTEN      27745/java
```

This port is set in JBOSS file 

> [jboss@gdi-app-l1 gdi-qa-com1]$ vim ./conf/bindingservice.beans/META-INF/bindings-jboss-beans.xml

I have switched both 11098 and 11099 to 1098 and 1099.

Afterwards, the shutdown works OK
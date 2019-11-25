---
title: "Endeca start scripts - Oracle way"
date: 2013-10-16T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["oracle","endeca"]
author: "Miro Adamy"
---

I have ported the Oracle VM style management scripts into the Loyalty VM.

The scripts are in the loyalty-endeca Git repo, originally in eVoucher branch but also merged into edc 

```
[tkuser@vm-lo1-hpr-ma endeca]$ ls -1
total 28
dev-check-environment.sh*
dev-deploy-endeca-app.sh*
dev-endeca-environmet.ini*
dev-remove-endeca-app.sh*
endeca-control*
endeca-vars.txt*
README.md*
RewardsEndc/
```

### dev-endeca-environmet.ini
This is environment setting script. 

```
### MUST BE SOURCED IN

source dev-endeca-environmet.ini

## or

. dev-endeca-environmet.ini

## NEVER

./dev-endeca-environmet.ini
```

### endeca-control

Main script that manages three components of the system named:

* platform
* em (the Workbench actually, but em is shorter)
* cas
* all - all three of them

Assumes the environment initialized by dev-endeca-environment.ini

Expects 2 arguments

```
endeca-control INSTANCE ACTION
```

where INSTANCE is one of (platform, em, cas, all) and ACTION is one of (start, stop, restart, kill)

#### Example

```
[tkuser@vm-lo1-hpr-ma endeca]$ ./endeca-control all start
STARTING PLATFORM ----
STARTING EXPERIENCE MANAGER ----
STARTING CAS ----
 
 
  
[tkuser@vm-lo1-hpr-ma endeca]$ ./endeca-control all kill
SHUTTING DOWN PLATFORM ----
Using ENDECA_ROOT:      /home/tkuser/endeca/PlatformServices/6.1.3
Using ENDECA_CONF:      /home/tkuser/endeca/PlatformServices/workspace
Using CATALINA_BASE:   /home/tkuser/endeca/PlatformServices/workspace
Using CATALINA_HOME:   /home/tkuser/endeca/PlatformServices/6.1.3/tools/server
Using CATALINA_TMPDIR: /home/tkuser/endeca/PlatformServices/workspace/temp
Using JRE_HOME:        /home/tkuser/endeca/PlatformServices/6.1.3/j2sdk
Using CLASSPATH:       /home/tkuser/endeca/PlatformServices/6.1.3/tools/server/bin/bootstrap.jar
SHUTTING DOWN EXPERIENCE MANAGER ----
Checking Workbench Environment Settings
Using ENDECA_TOOLS_ROOT: /home/tkuser/endeca/ToolsAndFrameworks/3.1.2
Using ENDECA_TOOLS_CONF: /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace
Using LOGGING_DIR:       /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace/logs
Using CATALINA_HOME:     /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/apache-tomcat-6.0.32
Using CATALINA_BASE:     /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace
Using JAVA_HOME:         /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/j2sdk
Using JRE_HOME:          /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/j2sdk
Using WORKING_DIR:       /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace/state
Using CATALINA_OPTS:      -Xms256m -Xmx1024m -XX:MaxPermSize=512m -Dcom.endeca.manager.endecaroot=/home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace
Using JAVA_OPTS:          -Djava.security.auth.login.config=/home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace/conf/Login.conf -Dorg.apache.catalina.SESSION_COOKIE_NAME=ESESSIONID -Dorg.apache.catalina.SESSION_PARAMETER_NAME=esessionid -XX:CompileCommand=exclude,org/apache/derby/impl/services/locks/LockControl,getLock -XX:CompileCommand=exclude,org/apache/derby/impl/services/locks/LockControl,addLock -XX:CompileCommand=exclude,org/apache/derby/impl/services/locks/LockControl,isGrantable -XX:+UnlockDiagnosticVMOptions -XX:-DisplayVMOutput
Stopping Workbench
Using CATALINA_BASE:   /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace
Using CATALINA_HOME:   /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/apache-tomcat-6.0.32
Using CATALINA_TMPDIR: /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/workspace/temp
Using JRE_HOME:        /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/j2sdk
Using CLASSPATH:       /home/tkuser/endeca/ToolsAndFrameworks/3.1.2/server/apache-tomcat-6.0.32/bin/bootstrap.jar
SHUTTING DOWN CAS ----
[tkuser@vm-lo1-hpr-ma endeca]$
```
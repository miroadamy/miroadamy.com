---
title: "Installing and running 'naked' hybris platform"
date: 2012-08-17T11:22:48+08:00
published: true
type: post
categories: ["ecommerce"]
tags: ["hybris"]
author: "Miro Adamy"
---

# Installing and running "naked" hybris platform

Log of an exercise to install and start the Hybris without all those fancy modules

Starting point: `hybris-platform-4.7.1.zip` 

Install point: `/opt/hybris-platform/hybris-platform-4.7.1`

## Start (with HSQLdb)

```
~ $ cd /opt/hybris-platform/hybris-platform-4.7.1
hybris-platform-4.7.1 $ cd bin/platform/
platform $ pwd
/opt/hybris-platform/hybris-platform-4.7.1/bin/platform
 
 
platform $ . ./setantenv.sh
Setting ant home to: /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/apache-ant-1.8.2
Apache Ant(TM) version 1.8.2 compiled on April 21 2011
platform $ ant clean all | tee ant-clean-all.log
```

=> Select `develop`

```
....
....
   
   [echo] [jspcompile] compiling.. /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6/work/Catalina/localhost/hmc
   [yjavac] Compiling 205 source files to /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6/work/Catalina/localhost/hmc
    [touch] Creating /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6/work/Catalina/localhost/hmc/jspcompile_touch
[stopwatch] [build: 43.686 sec]
server:
     [echo]
     [echo] Configuring server at /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6
     [echo] Using config set at /opt/hybris-platform/hybris-platform-4.7.1/config/tomcat
     [echo]            
    [mkdir] Created dir: /opt/hybris-platform/hybris-platform-4.7.1/log/tomcat
    [mkdir] Created dir: /opt/hybris-platform/hybris-platform-4.7.1/data/media
     [copy] Copying 8 files to /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6
     [copy] Copying 6 files to /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6
     [copy] Copying 1 file to /opt/hybris-platform/hybris-platform-4.7.1/bin/platform/tomcat-6/lib
     [echo]
     [echo] Embedded server does not seem to be running (no PID found). No restart necessary.
     [echo]                        
all:
     [echo] Build finished on 17-August-2012 19:43:22.
     [echo]        
BUILD SUCCESSFUL
Total time: 1 minute 26 seconds
```

Goto http://localhost:9001/ - redirects to http://localhost:9001/platform/init

## List of modules that goes up:

```
core
hmc
servicelayer
task
commons
cronjob
lucenesearch
impex
validation
variants
europe1
category
catalog
virtualjdbc
platformservices
workflow
processengine
ldap
comments
cockpit
mcc
advancedsavedquery
admincockpit
```

## Initialization log

```
Initialization
Dropping ALL tables ...
 
Initialize system ...
 
Please wait. This step can take some minutes to complete.
If you do not receive any feedback on this page in this time, consult the applicationserver logs for possible errors.
Dropping old and creating new empty system ...
>>> Remove objects ...
>>> Create types ...
>>> Modify types ...
>>> Create objects ...
>>> Setting licence ...
Restarting tenant ...
 
Clearing hmc configuration from database ...
 
 
Creating essential data ...
 
Creating essential data for core ...
Creating essential data for mediaweb ...
Creating essential data for maintenanceweb ...
Creating essential data for hmc ...
Creating essential data for servicelayer ...
Creating essential data for task ...
Creating essential data for paymentstandard ...
Creating essential data for deliveryzone ...
Creating essential data for commons ...
Creating essential data for cronjob ...
Creating essential data for lucenesearch ...
Creating essential data for impex ...
Creating essential data for validation ...
Creating essential data for variants ...
Creating essential data for europe1 ...
Creating essential data for category ...
Creating essential data for catalog ...
Creating essential data for virtualjdbc ...
Creating essential data for platformservices ...
Creating essential data for workflow ...
Creating essential data for processengine ...
Creating essential data for platformwebservices ...
Creating essential data for ldap ...
Creating essential data for hac ...
Creating essential data for comments ...
Creating essential data for cockpit ...
Creating essential data for mcc ...
Creating essential data for advancedsavedquery ...
Creating essential data for admincockpit ...
 
Localizing types ...
 
Creating project data ...
 
Creating project data for core ...
Creating project data for hmc ...
Creating project data for servicelayer ...
Creating project data for task ...
Creating project data for commons ...
Creating project data for cronjob ...
Creating project data for lucenesearch ...
Creating project data for impex ...
Creating project data for validation ...
Creating project data for variants ...
Creating project data for europe1 ...
Creating project data for category ...
Creating project data for catalog ...
Creating project data for virtualjdbc ...
Creating project data for platformservices ...
Creating project data for workflow ...
Creating project data for processengine ...
Creating project data for ldap ...
Creating project data for comments ...
Creating project data for cockpit ...
Creating project data for mcc ...
Creating project data for advancedsavedquery ...
Creating project data for admincockpit ...
 
 
FINISHED. The initialization took: 0d 00h:01m:08s:235ms
```

### Exploring

* look at the configuration parameters under <http://localhost:9001/platform/config>
* logging - <http://localhost:9001/platform/log4j>
* All loaded extensions - with their Web apps: <http://localhost:9001/platform/extensions>
  * <http://localhost:9001/virtualjdbc/>
  * AdminCockpit: <http://localhost:9001/admincockpit/index.zul>
  * MultiChannel Cockpit - <http://localhost:9001/mcc/index.zul>
  * Hybris Management Console - [http://localhost:9001/hmc/hybris?wid=MC0x0&prgrequest=true&MC0x2\_!DISPLAY=MC0x12](http://localhost:9001/hmc/hybris?wid=MC0x0&prgrequest=true&MC0x2_!DISPLAY=MC0x12)
  * Maintenance page: <http://localhost:9001/maintenance/>
  * Medias (??) <http://localhost:9001/medias/>
  * WS - <http://localhost:9001/ws410/>
    * Sample data must be loaded ? Q: How do I load sample data ?

### REST Client

```
$ cd /opt/restClient/
restClient $ ll
total 44280
-rw-r--r--@ 1 miro  staff   8.4M 17 Aug 20:15 restclient-cli-2.5-jar-with-dependencies.jar
-rw-r--r--@ 1 miro  staff    13M 17 Aug 20:16 restclient-ui-2.5-jar-with-dependencies.jar
restClient $ java -jar restclient-ui-2.5-jar-with-dependencies.jar
```

must enter admin/nimda into tool

Follow <http://localhost:9001/ws410/rest/countries>

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<countries xmlns:ns2="http://wadl.dev.java.net/2009/02" uri="http://localhost:9001/ws410/rest/countries">
<country isocode="DE" pk="8796093055010" uri="http://localhost:9001/ws410/rest/countries/DE"/>
</countries>
```


Interesting catalog tool - comparison:

* <http://localhost:9001/hmc/hybris?wid=MC1x745&prgrequest=true&null>

### Admin Cockpit

<http://localhost:9001/admincockpit/index.zul>

### Virtual JDBC

Available at <http://localhost:9001/virtualjdbc/>

This extension offers the functionality to connect to a database using a virtual JDBC connection.
This allows to create reports in real-time on live data without risks of corrupting data.

To connect via HTTP the jdbc url looks like:

```
[jdbc:hybris:sql:http://localhost:9001/virtualjdbc/service]()
[jdbc:hybris:flexiblesearch:http://localhost:9001/virtualjdbc/service;tenant=master]()
```

Detailed documentation can be found at [virtualjdbc Extension](https://wiki.hybris.com/x/waEFAw).


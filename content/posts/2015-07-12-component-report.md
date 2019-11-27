---
title: "How to get information about all ATG components"
date: 2015-07-12T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["atg","dynadmin"]
author: "Miro Adamy"
---

# How to get information about all ATG Nucleus components

Dyn Admin has useful feature - Configuration reporter: <http://localhost:8080/dyn/admin/atg/dynamo/admin/en/config-reporter-property-representation1.jhtml>


![](/images/da-1.jpeg)

There are two variations of the report: Property representation report - PRR (shorter version) and Bean representation report (BRR). The PRR does not report properties that have default values, while BRR is reporting current values of all properties. Compare the sizes

```
-rw-r--r-- 1 miro 2.2M Jul 12 14:07 bean1
-rw-r--r-- 1 miro 2.5M Jul 12 14:07 bean1.xml
 
 
-rw-r--r-- 1 miro 275K Jul 12 13:50 file1
-rw-r--r-- 1 miro 572K Jul 12 13:51 file1.xml
```

![](/images/da-2.jpeg)
![](/images/da-3.jpeg)

In both cases first creates binary file with properties and then transforms it to XML format:

![](/images/da-4.jpeg)
![](/images/da-5.jpeg)
Both files will be saved in the home directory of the JVM. 

In development, it will be most likely the ATG module directory - from where the Start script was run.

You can format it 

> xmllint --format file1.xml >file1-formatted.xml

after which it looks like this (PRR)

```
...
</component>
    <component NAME="/atg/devtools/ArchiveDirectoryCache">
      <property NAME="$scope"><![CDATA[global]]></property>
      <property NAME="directoryAgent"><![CDATA[./ContainerAppDirectoryAgent]]></property>
      <property NAME="loggingInfo"><![CDATA[true]]></property>
      <property NAME="logListeners"><![CDATA[atg/dynamo/service/logging/LogQueue,atg/dynamo/service/logging/ScreenLog]]></property>
      <property NAME="schedule"><![CDATA[every 30 minutes]]></property>
      <property NAME="stagingDirectoryRoot"><![CDATA[{serverHomeDirResource?resourceURI=j2ee/archive-cache}]]></property>
      <property NAME="$description"><![CDATA[server-side J2EE application and stand alone archived application cache]]></property>
      <property NAME="loggingWarning"><![CDATA[true]]></property>
      <property NAME="logging.logListeners"><![CDATA[atg/dynamo/service/logging/LogQueue,atg/dynamo/service/logging/ScreenLog]]></property>
      <property NAME="$class"><![CDATA[atg.ui.j2edit.model.CachingJ2eeArchiveDirectoryAgent]]></property>
      <property NAME="loggingError"><![CDATA[true]]></property>
      <property NAME="loggingDebug"><![CDATA[false]]></property>
      <property NAME="enabled^"><![CDATA[/atg/dynamo/Configuration.j2eeArchiveCachingEnabled]]></property>
      <property NAME="scheduler"><![CDATA[/atg/dynamo/service/Scheduler]]></property>
    </component>
    <component NAME="/atg/devtools/ComponentIndex">
      <property NAME="logging.logListeners"><![CDATA[atg/dynamo/service/logging/LogQueue,atg/dynamo/service/logging/ScreenLog]]></property>
      <property NAME="loggingWarning"><![CDATA[true]]></property>
      <property NAME="loggingDebug"><![CDATA[false]]></property>
      <property NAME="moduleManager"><![CDATA[/atg/modules/ModuleManager]]></property>
      <property NAME="loggingInfo"><![CDATA[true]]></property>
      <property NAME="excludeDirectories"><![CDATA[/docroot,/atg/dynamo/servlet/sessiontracking/SessionManager,/atg/dynamo/servlet/pipeline/RequestScopeManager,/atg/reporting/contentviewed,/atg/reporting/profilegroup,/atg/reporting/requests,/atg/reporting/userevents]]></property>
      <property NAME="componentIndexFile"><![CDATA[{serverHomeDirResource?resourceURI=data/componentIndex.ser}]]></property>
      <property NAME="$description"><![CDATA[Index of all configured global components in Nucleus]]></property>
      <property NAME="logListeners"><![CDATA[atg/dynamo/service/logging/LogQueue,atg/dynamo/service/logging/ScreenLog]]></property>
      <property NAME="loggingError"><![CDATA[true]]></property>
      <property NAME="componentManager"><![CDATA[ComponentManager]]></property>
      <property NAME="$class"><![CDATA[atg.ui.component.model.GlobalComponentIndex]]></property>
    </component>
    <component NAME="/atg/devtools/ComponentManager">
      <property NAME="loggingDebug"><![CDATA[false]]></property>
      <property NAME="loggingError"><![CDATA[true]]></property>
...
```
or this (BRR):
```
...
</component>
<component NAME="/atg/devtools/ArchiveDirectoryCache">
<property NAME="schedule"><![CDATA[schedule every 30 minutes without catch up]]></property>
<property NAME="loggingTrace"><![CDATA[loggingTrace false]]></property>
<property NAME="adminServlet"><![CDATA[adminServlet atg.nucleus.GenericService$1AdminServlet@5d6142fe]]></property>
<property NAME="loggingWarning"><![CDATA[loggingWarning true]]></property>
<property NAME="loggingDebug"><![CDATA[loggingDebug false]]></property>
<property NAME="nucleus"><![CDATA[nucleus /]]></property>
<property NAME="scheduler"><![CDATA[scheduler /atg/dynamo/service/Scheduler]]></property>
<property NAME="absoluteName"><![CDATA[absoluteName /atg/devtools/ArchiveDirectoryCache]]></property>
<property NAME="serviceConfiguration"><![CDATA[serviceConfiguration atg.nucleus.PropertyConfiguration@1c756197]]></property>
<property NAME="enabled"><![CDATA[enabled true]]></property>
<property NAME="purgeInterval"><![CDATA[purgeInterval 4]]></property>
<property NAME="nameContext"><![CDATA[nameContext /atg/devtools]]></property>
<property NAME="stagingDirectoryRoot"><![CDATA[stagingDirectoryRoot /Users/miro/src/TRAINING/twc-training2/servers/atg/training_dev01/j2ee/archive-cache]]></property>
<property NAME="logListenerCount"><![CDATA[logListenerCount 2]]></property>
<property NAME="running"><![CDATA[running true]]></property>
<property NAME="loggingInfo"><![CDATA[loggingInfo true]]></property>
<property NAME="adminServletUseServletOutputStream"><![CDATA[adminServletUseServletOutputStream false]]></property>
<property NAME="j2eeAppInfoCache"><![CDATA[j2eeAppInfoCache {/Users/miro/ATG/ATG11.1/PubPortlet/:PubPortlets.ear=atg.ui.j2edit.model.J2eeAppInfo@3f9e8e2f, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669459-30/:screenscraper=atg.ui.j2edit.model.J2eeAppInfo@4288d04a, /Users/miro/ATG/ATG11.1/Tomcat/apache-tomcat-7.0.37/webapps/:host-manager=atg.ui.j2edit.model.J2eeAppInfo@2422cc66, /Users/miro/ATG/ATG11.1/ATGDBSetup/j2ee-apps/:ATGDBSetup=atg.ui.j2edit.model.J2eeAppInfo@68994f12, /Users/miro/ATG/ATG11.1/Service11.1/Service/CRMIntegration/j2ee-apps/:getAgentPasswordHashAlgorithm.ear=atg.ui.j2edit.model.J2eeAppInfo@29165c64, /Users/miro/ATG/ATG11.1/twc-training/servers/tomcat/training_dev01/webapps/:dyn=atg.ui.j2edit.model.J2eeAppInfo@7b0bbe4e, /Users/miro/ATG/ATG11.1/WSRP/admin/:admin=atg.ui.j2edit.model.J2eeAppInfo@3ffb31fe, /Users/miro/ATG/ATG11.1/Portal/gear-template/helloworld_war/:helloworld.war=atg.ui.j2edit.model.J2eeAppInfo@48f3b83, /Users/miro/ATG/ATG11.1/TWC-TDD/j2ee-apps/:TDD.ear=atg.ui.j2edit.model.J2eeAppInfo@578c17cb, /Users/miro/ATG/ATG11.1/WSRP/producer/:producer=atg.ui.j2edit.model.J2eeAppInfo@2e6e3d54, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669406-28/:quicklinks=atg.ui.j2edit.model.J2eeAppInfo@477c6d9c, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669177-22/:exchange=atg.ui.j2edit.model.J2eeAppInfo@3a00416e, /Users/miro/ATG/ATG11.1/DCS-UI/Versioned/j2ee-apps/:DCS-UI-Versioned.ear=atg.ui.j2edit.model.J2eeAppInfo@66c7ba81, /Users/miro/ATG/ATG11.1/Service11.1/Service/CRMIntegration/j2ee-apps/:loginAgentUser.ear=atg.ui.j2edit.model.J2eeAppInfo@42a59fde, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676667174-7/:Fcc=atg.ui.j2edit.model.J2eeAppInfo@7a2ca01, /Users/miro/ATG/ATG11.1/twc-training/servers/tomcat/training_dev01/webapps/:dyn#admin=atg.ui.j2edit.model.J2eeAppInfo@507c0b91, /Users/miro/ATG/ATG11.1/BIZUI/j2ee-apps/:bizui.ear=atg.ui.j2edit.model.J2eeAppInfo@7fdb85de, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676668997-14/:alert=atg.ui.j2edit.model.J2eeAppInfo@2531f366, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669691-37/:xmlprotocol=atg.ui.j2edit.model.J2eeAppInfo@7262c09d, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669036-16/:bookmarks=atg.ui.j2edit.model.J2eeAppInfo@3153be16, /Users/miro/ATG/ATG11.1/Portal/slotgear/:slotgear-war=atg.ui.j2edit.model.J2eeAppInfo@70e4afa6, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676667067-4/:atg-bootstrap=atg.ui.j2edit.model.J2eeAppInfo@35c7f531, /Users/miro/ATG/ATG11.1/DPS-UI/j2ee-apps/:DPS-UI.ear=atg.ui.j2edit.model.J2eeAppInfo@5ab27f8c, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676666956-0/:orderapproval=atg.ui.j2edit.model.J2eeAppInfo@7cd3eed8, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669537-33/:soapclient=atg.ui.j2edit.model.J2eeAppInfo@3de5e6ee, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669140-21/:docexch=atg.ui.j2edit.model.J2eeAppInfo@409c3301, /Users/miro/ATG/ATG11.1/twc-training/servers/atg/training_dev01/j2ee/archive-cache/1436676669302-26/:settings=atg.ui.j2edit.model.J2eeAppInfo@4ed8a7ca, /Users/miro/ATG/ATG11.1/ContentMgmt-UI/j2ee-apps/:ContentMgmt-UI.ear=atg.ui.j2edit.model.J2eeAppInfo@71e
[DELETED the rest of line ...]
<property NAME="name"><![CDATA[name ArchiveDirectoryCache]]></property>
<property NAME="logListeners"><![CDATA[atg.service.configurationreporter.MultiValueProperty@76711470]]></property>
<property NAME="serviceInfo"><![CDATA[serviceInfo server-side J2EE application and stand alone archived application cache]]></property>
<property NAME="root"><![CDATA[root /]]></property>
<property NAME="cache"><![CDATA[cache {}]]></property>
<property NAME="adminServletOutputStreamEncoding"><![CDATA[adminServletOutputStreamEncoding UTF-8]]></property>
<property NAME="loggingError"><![CDATA[loggingError true]]></property>
<property NAME="class"><![CDATA[class class atg.ui.j2edit.model.CachingJ2eeArchiveDirectoryAgent]]></property>
<property NAME="directoryAgent"><![CDATA[directoryAgent /atg/devtools/ContainerAppDirectoryAgent]]></property>
</component>
<component NAME="/atg/devtools/ComponentIndex">
<property NAME="loggingTrace"><![CDATA[loggingTrace false]]></property>
<property NAME="adminServlet"><![CDATA[adminServlet atg.nucleus.GenericService$1AdminServlet@1a9a8c3d]]></property>
<property NAME="loggingWarning"><![CDATA[loggingWarning true]]></property>
<property NAME="loggingDebug"><![CDATA[loggingDebug false]]></property>
<property NAME="nucleus"><![CDATA[nucleus /]]></property>
<property NAME="absoluteName"><![CDATA[absoluteName /atg/devtools/ComponentIndex]]></property>
<property NAME="serviceConfiguration"><![CDATA[serviceConfiguration atg.nucleus.PropertyConfiguration@186d0670]]></property>
<property NAME="componentIndexFile"><![CDATA[componentIndexFile /Users/miro/src/TRAINING/twc-training2/servers/atg/training_dev01/data/componentIndex.ser]]></property>
<property NAME="enabled"><![CDATA[enabled true]]></property>
<property NAME="excludeDirectories"><![CDATA[atg.service.configurationreporter.MultiValueProperty@79f501cf]]></property>
<property NAME="moduleManager"><![CDATA[moduleManager /atg/modules/ModuleManager]]></property>
<property NAME="rebuilding"><![CDATA[rebuilding false]]></property>
<property NAME="nameContext"><![CDATA[nameContext /atg/devtools]]></property>
<property NAME="logListenerCount"><![CDATA[logListenerCount 2]]></property>
<property NAME="indexAvailable"><![CDATA[indexAvailable false]]></property>
<property NAME="running"><![CDATA[running true]]></property>
<property NAME="loggingInfo"><![CDATA[loggingInfo true]]></property>
<property NAME="adminServletUseServletOutputStream"><![CDATA[adminServletUseServletOutputStream false]]></property>
<property NAME="name"><![CDATA[name ComponentIndex]]></property>

```

The BRR file seems to have syntactic issues:

```
➜  dev01 git:(d1-150/main) ✗ xmllint --format bean1.xml
bean1.xml:10865: parser error : Char 0x0 out of allowed range
14:10:9f:1f:cd:04@fe80::1610:9fff:fe1f:cd04._apple-mobdev._tcp.local.,4500/4279,
                                                                               ^
bean1.xml:10865: parser error : CData section not finished
jmDNS   ---- Services -----
        Service: wanderlust.l
14:10:9f:1f:cd:04@fe80::1610:9fff:fe1f:cd04._apple-mobdev._tcp.local.,4500/4279,
                                                                               ^
bean1.xml:10865: parser error : Premature end of data in tag property line 10852
14:10:9f:1f:cd:04@fe80::1610:9fff:fe1f:cd04._apple-mobdev._tcp.local.,4500/4279,
                                                                               ^
bean1.xml:10865: parser error : Premature end of data in tag component line 10845
14:10:9f:1f:cd:04@fe80::1610:9fff:fe1f:cd04._apple-mobdev._tcp.local.,4500/4279,
                                                                               ^
bean1.xml:10865: parser error : Premature end of data in tag component_list line 95
14:10:9f:1f:cd:04@fe80::1610:9fff:fe1f:cd04._apple-mobdev._tcp.local.,4500/4279,
                                                                               ^
bean1.xml:10865: parser error : Premature end of data in tag repository line 1
14:10:9f:1f:cd:04@fe80::1610:9fff:fe1f:cd04._apple-mobdev._tcp.local.,4500/4279,
                                                                        ^
```
This offers very useful posibilities for using standard Unix text tools.

For example: list all components using other components:

```
grep -n '/atg/dynamo/service/jdbc/JTDataSource' file1-formatted.xml
255:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
1205:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
1344:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
1854:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
2335:    <component NAME="/atg/dynamo/service/jdbc/JTDataSource">
2370:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
5497:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
6229:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
6489:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
6536:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
6815:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
6833:      <property NAME="dataSource"><![CDATA[/atg/dynamo/service/jdbc/JTDataSource]]></property>
  
grep -n '/atg/dynamo/service/jdbc/JTDataSource' bean1.xml
785:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
7397:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
7756:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
9027:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
10605:<component NAME="/atg/dynamo/service/jdbc/JTDataSource">
10649:<property NAME="absoluteName"><![CDATA[absoluteName /atg/dynamo/service/jdbc/JTDataSource]]></property>
10732:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
19875:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
20312:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
20460:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
20608:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
30639:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
31097:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
31340:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
32131:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
32279:<property NAME="dataSource"><![CDATA[dataSource /atg/dynamo/service/jdbc/JTDataSource]]></property>
```

# Custom report

This allows possibility to report only part of hierarchy. You have to provide control file (complete hierarchy can be generated at

<http://localhost:8080/dyn/admin/atg/dynamo/admin/en/config-reporter-output-hierarchy-titled.jhtml?_DARGS=/atg/dynamo/admin/en/config-reporter-output-hierarchy-titled.jhtml.2&_dynSessConf=-8731147233557828105>

The file is not XML file, it contains lines for components and directories:

```
...
<component>/atg/userprofiling/RepositoryItemGroupRoleCacheAdapter</component>
<component>/atg/userprofiling/ProfileTools</component>
<component>/atg/userprofiling/UserCacheAdapter</component>
<component>/atg/userprofiling/PageEventTrigger</component>
<directory>/atg/userprofiling/email</directory>
<component>/atg/userprofiling/email/HtmlContentProcessor</component>
<component>/atg/userprofiling/email/TemplateEmailPersister</component>
<component>/atg/userprofiling/email/BatchEmailPeriodicService</component>
<component>/atg/userprofiling/email/TemplateEmailSender</component>
<component>/atg/userprofiling/email/TemplateEmailBatchPersister</component>
<component>/atg/userprofiling/email/TemplateEmailBatchServerPersister</component>
<component>/atg/userprofiling/ProfileRequestServlet</component>
<component>/atg/userprofiling/FolderCacheAdapter</component>
<component>/atg/userprofiling/ProfileUserDirectoryProperties</component>
<component>/atg/userprofiling/PropertyManager</component>
<component>/atg/userprofiling/ProfileSessionFailServiceSharable</component>
<component>/atg/userprofiling/FolderPathCache</component>
<component>/atg/userprofiling/ProfileItemFinder</component>
<component>/atg/userprofiling/DPSMessageSource</component>
<component>/atg/userprofiling/CookieManager</component>
<component>/atg/userprofiling/ExpiredPasswordService</component>
...
```
I have generated file, left only sub-tree of '/atg/userprofiling':

This file is then used as input. If you leave file in the directory it was generated in, that is the safest way how it will be found.

![](/images/da-6.jpeg)

Here is the output:

```
 -rw-r--r-- 1 miro 146K Jul 12 14:28 bean2
 -rw-r--r-- 1 miro 198K Jul 12 14:29 bean2.xml

```

## Weakness and issues

This tool would be much more useful if many important classes provided override 'toString' methods. 

For example, this is what you get from ProfileAdapterRepository's DatabaseTableInfo

```
...
<property NAME="databaseTableInfo"><![CDATA[databaseTableInfo atg.adapter.gsa.DatabaseTableInfo@74924b8c]]></property>
```

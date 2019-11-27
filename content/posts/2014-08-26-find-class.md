---
title: "Finding out the class in ATG installation"
date: 2014-08-26T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["atg","java","tools"]
author: "Miro Adamy"
---

# Java approach

Use the real time search with this JAR - https://jarscan.com/

```
➜  scripts git:(authoring) ✗ java -jar ~/bin/jarscan.jar
=========================
JarScan
written by Geoff Yaworski
gyaworski@hotmail.com
Version 2.0
=========================
Usage: java -jar jarscan.jar [-help | /?]
                    [-dir directory name]
                    [-zip]
                    [-showProgress]
                    <-files | -class | -package>
                    <search string 1> [search string 2]
                    [search string n]
Help:
  -help or /?           Displays this message.
  -dir                  The directory to start searching
                        from default is "."
  -zip                  Also search Zip files
  -showProgress         Show a running count of files read in
  -files or -class      Search for a file or Java class
                        contained in some library.
                        i.e. HttpServlet
  -package              Search for a Java package
                        contained in some library.
                        i.e. javax.servlet.http
  search string         The file or package to
                        search for.
                        i.e. see examples above
```

example

```
=========================
JarScan
written by Geoff Yaworski
gyaworski@hotmail.com
Version 2.0
=========================
  
Will start search from: /Users/miro/ATG/ATG11.0/DAS
  
Looking for class(es): [atg.nucleus.NucleusBeanInfo]
  
Processed 196 directories containing 895 files
found 115 libraries under the directory: /Users/miro/ATG/ATG11.0/DAS
  
1) batchconfig.jar [/Users/miro/ATG/ATG11.0/DAS/config/batchconfig.jar]
2) config.jar [/Users/miro/ATG/ATG11.0/DAS/config/config.jar]
3) dtmconfig.jar [/Users/miro/ATG/ATG11.0/DAS/config/dtmconfig.jar]
4) jspbatchconfig.jar [/Users/miro/ATG/ATG11.0/DAS/config/jspbatchconfig.jar]
5) oca-ldap.jar [/Users/miro/ATG/ATG11.0/DAS/config/oca-ldap.jar]
6) config.jar [/Users/miro/ATG/ATG11.0/DAS/configlayers/md5/config.jar]
7) das_ui_help.jar [/Users/miro/ATG/ATG11.0/DAS/help/das_ui_help.jar]
8) ldap.jar [/Users/miro/ATG/ATG11.0/DAS/LDAP/lib/ldap.jar]
9) atg-coherence-classes.jar [/Users/miro/ATG/ATG11.0/DAS/lib/atg-coherence-classes.jar]
10) atg-jaxb-invoker.jar [/Users/miro/ATG/ATG11.0/DAS/lib/atg-jaxb-invoker.jar]
11) axis-1.4.jar [/Users/miro/ATG/ATG11.0/DAS/lib/axis-1.4.jar]
12) bundle-support-standard-1.1.2.jar [/Users/miro/ATG/ATG11.0/DAS/lib/bundle-support-standard-1.1.2.jar]
13) cglib-nodep-2.1_3.jar [/Users/miro/ATG/ATG11.0/DAS/lib/cglib-nodep-2.1_3.jar]
14) classes.jar [/Users/miro/ATG/ATG11.0/DAS/lib/classes.jar]
15) coherence.jar [/Users/miro/ATG/ATG11.0/DAS/lib/coherence.jar]
16) commons-codec-1.3.jar [/Users/miro/ATG/ATG11.0/DAS/lib/commons-codec-1.3.jar]
17) commons-discovery-0.2.jar [/Users/miro/ATG/ATG11.0/DAS/lib/commons-discovery-0.2.jar]
18) commons-logging-1.1.1.jar [/Users/miro/ATG/ATG11.0/DAS/lib/commons-logging-1.1.1.jar]
19) ehcache-core-2.3.2.jar [/Users/miro/ATG/ATG11.0/DAS/lib/ehcache-core-2.3.2.jar]
20) filedist.jar [/Users/miro/ATG/ATG11.0/DAS/lib/filedist.jar]
21) groovy-all-1.7.2.jar [/Users/miro/ATG/ATG11.0/DAS/lib/groovy-all-1.7.2.jar]
22) hibernate-validator-4.3.1.Final.jar [/Users/miro/ATG/ATG11.0/DAS/lib/hibernate-validator-4.3.1.Final.jar]
23) httpclient-4.2.5.jar [/Users/miro/ATG/ATG11.0/DAS/lib/httpclient-4.2.5.jar]
24) httpcore-4.2.4.jar [/Users/miro/ATG/ATG11.0/DAS/lib/httpcore-4.2.4.jar]
25) ice.jar [/Users/miro/ATG/ATG11.0/DAS/lib/ice.jar]
26) jaxb-impl104.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jaxb-impl104.jar]
27) jaxb-libs104.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jaxb-libs104.jar]
28) jboss-logging-3.1.2.GA.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jboss-logging-3.1.2.GA.jar]
29) jline-0.9.94.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jline-0.9.94.jar]
30) jmdns-20.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jmdns-20.jar]
31) joda-time-2.2.jar [/Users/miro/ATG/ATG11.0/DAS/lib/joda-time-2.2.jar]
32) jsp-api.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jsp-api.jar]
33) juel-impl-2.2.5.jar [/Users/miro/ATG/ATG11.0/DAS/lib/juel-impl-2.2.5.jar]
34) jxl-2.6.6.jar [/Users/miro/ATG/ATG11.0/DAS/lib/jxl-2.6.6.jar]
35) min-ejb3-api.jar [/Users/miro/ATG/ATG11.0/DAS/lib/min-ejb3-api.jar]
36) mysql-connector-java-5.1.15-bin.jar [/Users/miro/ATG/ATG11.0/DAS/lib/mysql-connector-java-5.1.15-bin.jar]
37) asn1c.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/asn1c.jar]
38) glassfish.jaxb.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/glassfish.jaxb.jar]
39) javax.persistence.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/javax.persistence.jar]
40) dms.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.dms_11.1.1/dms.jar]
41) fmw_audit.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.iau_11.1.1/fmw_audit.jar]
42) identitystore.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.idm_11.1.1/identitystore.jar]
43) identityutils.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.idm_11.1.1/identityutils.jar]
44) arisId-stack-ovd.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.igf_11.1.1/arisId-stack-ovd.jar]
45) identitydirectory.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.igf_11.1.1/identitydirectory.jar]
46) igf_mbeans.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.igf_11.1.1/igf_mbeans.jar]
47) ojdbc6dms.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jdbc_11.1.1/ojdbc6dms.jar]
48) jacc-spi.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jacc-spi.jar]
49) jps-api.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-api.jar]
50) jps-audit.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-audit.jar]
51) jps-az-api.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-az-api.jar]
52) jps-az-common.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-az-common.jar]
53) jps-az-management.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-az-management.jar]
54) jps-az-rt.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-az-rt.jar]
55) jps-az-sspi.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-az-sspi.jar]
56) jps-common.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-common.jar]
57) jps-ee.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-ee.jar]
58) jps-internal.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-internal.jar]
59) jps-jboss-deployer.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-jboss-deployer.jar]
60) jps-jboss.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-jboss.jar]
61) jps-pep.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-pep.jar]
62) jps-platform.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-platform.jar]
63) jps-se.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-se.jar]
64) jps-tomcat.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-tomcat.jar]
65) jps-unsupported-api.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-unsupported-api.jar]
66) jps-was.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-was.jar]
67) jps-wls-trustprovider.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-wls-trustprovider.jar]
68) jps-wls.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/jps-wls.jar]
69) oracle.security.jps.was.deployment.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.jps_11.1.1/oracle.security.jps.was.deployment.jar]
70) ldapjclnt11.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.ldap_11.1.1/ldapjclnt11.jar]
71) orai18n-service.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.nlsgdk_11.1.0/orai18n-service.jar]
72) ojdl.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.odl_11.1.1/ojdl.jar]
73) osdt_cert.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_cert.jar]
74) osdt_core.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_core.jar]
75) osdt_restsec.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_restsec.jar]
76) osdt_saml.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_saml.jar]
77) osdt_saml2.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_saml2.jar]
78) osdt_ws_sx.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_ws_sx.jar]
79) osdt_wss.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_wss.jar]
80) osdt_xmlsec.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.osdt_11.1.1/osdt_xmlsec.jar]
81) config.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.ovd_11.1.1/config.jar]
82) ovd.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.ovd_11.1.1/ovd.jar]
83) plugins.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.ovd_11.1.1/plugins.jar]
84) oraclepki.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.pki_11.1.1/oraclepki.jar]
85) eclipselink.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.toplink_11.1.1/eclipselink.jar]
86) xmlparserv2_sans_jaxp_services.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/oracle.xdk_11.1.0/xmlparserv2_sans_jaxp_services.jar]
87) org.apache.neethi-2.0.4.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/org.apache.neethi-2.0.4.jar]
88) org.dom4j_1.6.1.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/org.dom4j_1.6.1.jar]
89) org.openliberty.arisId_1.1.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/org.openliberty.arisId_1.1.jar]
90) org.openliberty.arisIdBeans_1.1.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/org.openliberty.arisIdBeans_1.1.jar]
91) org.openliberty.openaz.azapi_1.1.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opss/modules/org.openliberty.openaz.azapi_1.1.jar]
92) opssclassloader.jar [/Users/miro/ATG/ATG11.0/DAS/lib/opssclassloader.jar]
93) orawsdl.jar [/Users/miro/ATG/ATG11.0/DAS/lib/orawsdl.jar]
94) protocol.jar [/Users/miro/ATG/ATG11.0/DAS/lib/protocol.jar]
95) resources.jar [/Users/miro/ATG/ATG11.0/DAS/lib/resources.jar]
96) servlet.jar [/Users/miro/ATG/ATG11.0/DAS/lib/servlet.jar]
97) slf4j-api-1.5.11.jar [/Users/miro/ATG/ATG11.0/DAS/lib/slf4j-api-1.5.11.jar]
98) slf4j-jdk14-1.5.11.jar [/Users/miro/ATG/ATG11.0/DAS/lib/slf4j-jdk14-1.5.11.jar]
99) spring-aop-1.2-rc1.jar [/Users/miro/ATG/ATG11.0/DAS/lib/spring-aop-1.2-rc1.jar]
100) subclassloader.jar [/Users/miro/ATG/ATG11.0/DAS/lib/subclassloader.jar]
101) tangosol.jar [/Users/miro/ATG/ATG11.0/DAS/lib/tangosol.jar]
102) validation-api-1.0.0.GA.jar [/Users/miro/ATG/ATG11.0/DAS/lib/validation-api-1.0.0.GA.jar]
103) coreTaglib1_0.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/coreTaglib/1.0/lib/coreTaglib1_0.jar]
104) dspjspTaglib1_0.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/dspjspTaglib/1.0/lib/dspjspTaglib1_0.jar]
105) json-taglib-0.4.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/json/0.4/lib/json-taglib-0.4.jar]
106) jaxen-full.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.0/lib/jaxen-full.jar]
107) jstl.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.0/lib/jstl.jar]
108) saxpath.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.0/lib/saxpath.jar]
109) standard.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.0/lib/standard.jar]
110) jstl.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.1/lib/jstl.jar]
111) standard.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.1/lib/standard.jar]
112) jstl-1.2.jar [/Users/miro/ATG/ATG11.0/DAS/taglib/jstl/1.2/lib/jstl-1.2.jar]
113) config.jar [/Users/miro/ATG/ATG11.0/DAS/Versioned/config/config.jar]
114) config.jar [/Users/miro/ATG/ATG11.0/DAS/Versioned/configlayers/stagingandprod/config.jar]
115) config.jar [/Users/miro/ATG/ATG11.0/DAS/Versioned/liveconfig/config.jar]
  
searching these jarfiles now ....
  
===============================================
Found: atg.nucleus.NucleusBeanInfo
Class: atg.nucleus.NucleusBeanInfo
Package: atg.nucleus
Library Name: classes.jar
Library Path: /Users/miro/ATG/ATG11.0/DAS/lib/classes.jar
===============================================
  
Search took: 162 milliseconds.
```

# Unix way

real time search - quick and dirty

```
#!/bin/bash
pattern=$1
shift
for jar in $(find $* -type f -name "*.jar")
do
  # echo Checking: $jar
  match=`jar -tvf $jar | grep $pattern`
  if [ ! -z "$match" ]
  then
    echo "Found in: $jar"
    echo "$match"
  fi
done
```

## Unix way - preloaded

The following script creates text file with map KEY=value, where KEY is name of the JAR file (relative to root == argument1) and VALUE is the classname.

### Example:

the script run as

> ./atgTool.sh $ATG_ROOT/DAS list


```
config/config.jar=atg.webservice.security.NucleusSecurityManager.properties
config/config.jar=atg.webservice.security.NucleusSecurityRepository.properties
config/config.jar=atg.webservice.security.RegisteredUsersOnly.properties
config/config.jar=atg.webservice.security.nucleusSecurity.xml
config/dtmconfig.jar=META-INF.MANIFEST.MF
config/dtmconfig.jar=atg.dynamo.transaction.TransactionManager.properties
config/jspbatchconfig.jar=META-INF.MANIFEST.MF
config/jspbatchconfig.jar=Initial.properties
config/jspbatchconfig.jar=Nucleus.properties
config/jspbatchconfig.jar=atg.dynamo.service.j2ee.ConnectorContainer.properties
config/jspbatchconfig.jar=atg.dynamo.service.j2ee.EJBContainer.properties
config/jspbatchconfig.jar=atg.dynamo.service.j2ee.J2EEContainer.properties
config/jspbatchconfig.jar=atg.dynamo.service.j2ee.WebContainer.properties
config/oca-ldap.jar=META-INF.MANIFEST.MF
config/oca-ldap.jar=CONFIG.properties
config/oca-ldap.jar=atg.adapter.ldap.InitialContextEnvironment.properties
config/oca-ldap.jar=atg.adapter.ldap.InitialContextPool.properties
config/oca-ldap.jar=atg.adapter.ldap.LDAPItemCache.properties
config/oca-ldap.jar=atg.adapter.ldap.LDAPItemCacheAdapter.properties
config/oca-ldap.jar=atg.adapter.ldap.LDAPQueryCache.properties
config/oca-ldap.jar=atg.adapter.ldap.LDAPQueryCacheAdapter.properties
config/oca-ldap.jar=atg.adapter.ldap.LDAPRepository.properties
config/oca-ldap.jar=atg.adapter.ldap.NDSPasswordHasher.properties
config/oca-ldap.jar=atg.adapter.ldap.ldapUserProfile.xml
configlayers/md5/config.jar=META-INF.MANIFEST.MF
configlayers/md5/config.jar=atg.dynamo.security.AdminAccountManager.properties
configlayers/md5/config.jar=atg.dynamo.security.AdminUserAuthority.properties
configlayers/md5/config.jar=atg.dynamo.security.passwordchecker.AdminPasswordRuleChecker.properties
configlayers/md5/config.jar=atg.dynamo.security.passwordchecker.ExpiredPasswordAdminService.properties
help/das_ui_help.jar=META-INF.MANIFEST.MF
help/das_ui_help.jar=about.html

```

## The script:

```
#!/bin/bash
atg=$1
action=$2
usage="Usage: $0 ATG_ROOT (list|expand)"
if [ "x$1" == "x" ] || [ "x$2" ==  "x" ]; then
   echo $usage
   exit 1
fi
echo Got ATG=$atg, action=$action
# All jars except of archived cache and taglibs which is everywhere
alljars=`find $atg -name '*.jar' | grep -v archive-cache | grep -v dspjspTaglib1_0.jar`
if [ "$2" == "list" ]; then
out_all_classes=`echo $atg | sed 's,/,_,g' | sed 's/^_//'`.txt
echo Creating list of classes into:$out_all_classes
echo Got `echo $alljars | wc -w` jars
for jar in $alljars; do
    archivename=`echo $jar | sed "s,^$atg/,,g"`
    echo Processing $jar = $archivename
    classes=`jar -tf $jar  | grep -v ".*/$" | sed 's,/,.,g'`
    for cls in $classes; do
        echo $archivename=$cls  >>$out_all_classes
    done
done
exit 0
fi # list
# This will explode all jar archives
if [ "$2" == "expand" ]; then
out_all_classes_base=`echo $atg | sed 's,/,_,g' | sed 's/^_//'`
echo Creating list of classes into:$out_all_classes_base
mkdir -p "./$out_all_classes_base"
for jar in $alljars; do
    archivename=`echo $jar | sed "s,^$atg/,,g" | sed "s,/,_,g" | sed 's,\.,-,g'`
    echo Processing $jar = $archivename
    mkdir -p "./$out_all_classes_base/$archivename"
    unzip $jar -d "./$out_all_classes_base/$archivename"
done
exit 0
fi
echo "Invalid action: $2"
echo $usage
exit 1
```
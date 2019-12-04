---
title: "ATG Module Diagram Generator"
date: 2018-02-10T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["atg","ecommerce", "groovy", "plantuml"]
author: "Miro Adamy"
---

I have found local clone of this repo while cleaning up the disk. The source was originally residing in private repo on Bitbucket which I moved to GitHub: https://github.com/miroadamy/atgdiagram


## What it does

Groovy scripts:

* https://github.com/miroadamy/atgdiagram/blob/master/src/listATGModules.groovy
* https://github.com/miroadamy/atgdiagram/blob/master/src/ATGModule.groovy

that scan local ATG installation, discover modules and generate the PlantUML file representing it,
for example - https://github.com/miroadamy/atgdiagram/blob/master/uml/test2.uml

```
Using ATG_ROOT from environment variable $ATG_ROOT: /opt/ATG/ATG10.0.2
Using /opt/ATG/ATG10.0.2 installation
Dependants of module TWeStore.eStore => [DCS.Search.Query, B2CCommerce, DAF.Search.Query, DAF.Search.Base, DCS.Search.common, DPS.Search.Index, DAF.Search.common, DAS-UI, DCS.Search.Index, DPS, DCS, DCS.Search.CustomCatalogs, DCS.Search.CustomCatalogs.Query, DCS.Search.CustomCatalogs.Index, DAF.Search.Routing, DCS.Search.CustomCatalogs.common, DAF.Search.Index, DSS, DCS.CustomCatalogs, DAS]
@startuml
Object TWeStore_eStore
Object DCS
Object B2CCommerce
Object DCS_Search_CustomCatalogs
Object DAF_Search_Routing
Object DCS_CustomCatalogs
Object DPS
Object DCS_Search_CustomCatalogs_Query
Object DAF_Search_Base
Object DCS_Search_CustomCatalogs_Index
Object DSS
Object DAS_UI
Object DCS_Search_Query
Object DCS_Search_CustomCatalogs_common
Object DAS
Object DCS_Search_Index
Object DAF_Search_Query
Object DCS_Search_common
Object DPS_Search_Index
Object DAF_Search_Index
Object DAF_Search_common
TWeStore_eStore <|-- DCS
TWeStore_eStore <|-- DCS_CustomCatalogs
TWeStore_eStore <|-- B2CCommerce
TWeStore_eStore <|-- DCS_Search_CustomCatalogs
TWeStore_eStore <|-- DAF_Search_Routing
DCS <|-- DPS
DCS <|-- DSS
B2CCommerce <|-- DCS
DCS_Search_CustomCatalogs <|-- DCS_Search_CustomCatalogs_Index
DCS_Search_CustomCatalogs <|-- DCS_Search_CustomCatalogs_Query
DAF_Search_Routing <|-- DAS_UI
DAF_Search_Routing <|-- DAF_Search_Base
DCS_CustomCatalogs <|-- DCS
DPS <|-- DAS
DCS_Search_CustomCatalogs_Query <|-- DCS_Search_Query
DCS_Search_CustomCatalogs_Query <|-- DCS_Search_CustomCatalogs_common
DAF_Search_Base <|-- DAS_UI
DCS_Search_CustomCatalogs_Index <|-- DCS_Search_Index
DCS_Search_CustomCatalogs_Index <|-- DCS_Search_CustomCatalogs_common
DSS <|-- DPS
DAS_UI <|-- DAS
DCS_Search_Query <|-- DAF_Search_Query
DCS_Search_Query <|-- DCS_Search_common
DCS_Search_Query <|-- DCS
DCS_Search_CustomCatalogs_common <|-- DCS_Search_common
DCS_Search_CustomCatalogs_common <|-- DCS_CustomCatalogs
DCS_Search_Index <|-- DPS_Search_Index
DCS_Search_Index <|-- DCS_Search_common
DCS_Search_Index <|-- DCS
DAF_Search_Query <|-- DAF_Search_common
DCS_Search_common <|-- DAF_Search_common
DCS_Search_common <|-- DCS
DPS_Search_Index <|-- DPS
DPS_Search_Index <|-- DAF_Search_Index
DAF_Search_Index <|-- DAS_UI
DAF_Search_Index <|-- DAF_Search_Base
DAF_Search_common <|-- DAS_UI
DAF_Search_common <|-- DAF_Search_Base
DAF_Search_common <|-- DAF_Search_Routing
@enduml
```

This UML file is the processed by PlantUML

```
#!/bin/sh
PLANTUML_HOME=/opt/diagrams

if [ ! -e $PLANTUML_HOME ]
then
    echo There is no PLANT UML installation at \$PLANTUML_HOME=$PLANTUML_HOME
    exit 1

fi

if [ "x" == "x$1" ]
then
    echo Usage: $0 UML-FILE-TO-PROCESS
    exit 2
fi

java -Xmx1024m -jar $PLANTUML_HOME/plantuml.jar $1
```

and renders this

![](/images/atgdiagram.png)


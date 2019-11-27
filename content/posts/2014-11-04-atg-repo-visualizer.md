---
title: "ATG Repository structure visualizer"
date: 2014-11-04T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["atg","groovy","plantuml"]
author: "Miro Adamy"
---

The groovy script does parse the XML files (scraped from dyn-admin, or output of the XML combine) and produces file in the syntax of Plant UML - http://plantuml.sourceforge.net

```
 if (args.size() == 0) {
    println "Usage: groovy extractItems.groovy XMLFILE-IN-GSA-FORMAT.xml"
    System.exit(1)
}
def gsaFile = new XmlSlurper().parseText(new File(args[0]).text)
def desc = gsaFile.'item-descriptor'
def processItemDescriptor(myDesc) {
    def info = [:]
    def tables = []
    def props = [:]
    def descriptors = [:]
    for (table in myDesc.table) {
        String tableName = table.@name.text()
        tables += tableName
        // collect table's properties
        for (prop in table.property) {
            String name = "${prop.@name.text()}(${tableName})".replaceAll(/[ -]/, '_')
            props[name] = [:]
            if ("${prop.@'required'.text()}" != "") {
                props[name]['required'] = "${prop.@'required'.text()}"
            }
            if ("${prop.@'hidden'.text()}" != "") {
                props[name]['hidden'] = "${prop.@'hidden'.text()}"
            }
 
            if ("${prop.@'item-type'.text()}" != "") {
                props[name]['item-type'] = "${prop.@'item-type'.text()}"
                descriptors["${prop.@name.text()}"] = "${prop.@'item-type'.text().replaceAll(/[ -]/, '_')}"
            }
        }
    }
    info['tables'] = tables
    // scan for properties outside of tables
    for (prop in myDesc.property) {
        String name = "${prop.@name.text()}".replaceAll(/[ -]/, '_')
        props[name] = [:]
        if ("${prop.@'item-type'.text()}" != "") {
            props[name]['item-type'] = "${prop.@'item-type'.text()}"
        }      
        }
    info['properties'] = props
    info['descriptors'] = descriptors
    return info
}
 
println "Got ${desc.size()} item-descriptors"
 
println "@startuml"
for (idesc in desc) {
    def info = processItemDescriptor(idesc)
    def name = "${idesc.@name.text().replaceAll(/[ -]/, '_')}"
    println "\nclass  ${name} {"
    for (p in info.tables)
        println "\t"+p
    println ".."   
    for (p in info.properties)
        println "\t"+p
    println "}"
    for (p in info.descriptors?.keySet())
        println "\t ${name} *-- ${info.descriptors[p]} : ${p}"
}
println "@enduml"
```

The generation (requires installed dot tools)

```
groovy ./extractItems.groovy pricing-generated.xml >pricing.uml
groovy ./extractItems.groovy catalog-generated.xml >catalog.uml
  
java -jar /opt/diagram/plantuml.jar catalog.uml
java -jar /opt/diagram/plantuml.jar pricing.uml
```

The files I used:

* catalog-generated.xml
* Output - catalog.uml

Here is the generated image:

![](/images/catalog.png)

## What is included

Every item descriptor contains

* list of database tables used
* list of properties. If property is from table, it has its name as parameter
* links between descriptors are rendered and annotated by the property that holds it

See also GitHub - <https://github.com/miroadamy/atg-repository-visualizer>
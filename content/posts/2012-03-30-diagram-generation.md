---
title: "Diagram generation - plain text approach"
date: 2012-03-30T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["tools","plaintext"]
author: "Miro Adamy"
---

## GraphViz

* installed from package
* See <http://www.graphviz.org/>

```
Radegast:diagrams miro$ dot -V
dot - graphviz version 2.28.0 (20110509.1545)
 
 
Radegast:diagrams miro$ which dot
dot is /usr/local/bin/dot
```

## SchemaSpy

* installed in /opt/diagrams
* see <http://schemaspy.sourceforge.net/>

```
Radegast:schemaSpy miro$ java -jar ./schemaSpy_5.0.0.jar -cp .:/Users/miro/lib/java/jdbc/mysql-connector-java-5.1.7-bin.jar -t mysql -o library -host localhost -u twt_dX_core -db twt_dX_core -p twt_dX_core
Using database properties:
  [./schemaSpy_5.0.0.jar]/net/sourceforge/schemaspy/dbTypes/mysql.properties
Gathering schema details....................................................................................................................................................................................................................................................................................................................................................(36sec)
Writing/graphing summary.....
.......(353sec)
Writing/diagramming details.................................................................................................................................................................................................................................................................................................................................................(104sec)
Wrote relationship details of 337 tables/views to directory 'library' in 494 seconds.
View the results by opening library/index.html
Radegast:schemaSpy miro$
Radegast:schemaSpy miro$ ll
total 904
```

## PlantUML

* installed in /opt/diagrams
* manual is attached: PlantUML Language Reference Guide.pdf
* See http://plantuml.sourceforge.net/classes.html
* in /opt/plantUML-DEMO/ there are sample files

```
@startuml img/sequence_img009.png   
  
Alice -> Bob: Authentication Request
alt successful case
    Bob -> Alice: Authentication Accepted
     
else some kind of failure
    Bob -> Alice: Authentication Failure
 
    group My own label
    Alice -> Log : Log attack start
        loop 1000       times
            Alice -> Bob: DNS Attack
        end
    Alice -> Log : Log attack end
    end
     
else Another type of failure
   Bob -> Alice: Please repeat
    
end
@enduml
```

![](/images/sequence_img009.png)

## PlantUML Dependency Reverse Engineering

Processes source code and generates the PlantUML Class description file

```
You can run PlantUML Dependency using the following simplest command :
java -jar plantuml-dependency-1.0.1.jar -o plantuml.txt
 
This will look for all java source files into the current directory recursively, creating a plantuml.txt file describing the PlantUML class diagram description. 
 
For processing an other directory, you can use :
java -jar plantuml-dependency-1.0.1.jar -b "~/directory1"
  
To filter source files to parse, you can use ANT patterns to include or exclude files :
java -jar plantuml-dependency-1.0.1.jar -i **/*Test*.java -e **/*Generated*.java
  
To change the output file path, you can use :
java -jar plantuml-dependency-1.0.1.jar -o "/directory1/test-plantuml.txt"
```

### Running it from Ant source tree

```
Radegast:platUml-DEMO miro$ java -jar ../plantuml-dependency-1.1.0-jar-with-dependencies.jar -b /Users/miro/src/apache-ant-1.8.1/src/main -o ant-sources.txt

## ... edit ant-sources.txt to include img/target.png and make it smaller
  
java -Xmx3096m -jar ../plantuml.jar ant-sources.txt
```

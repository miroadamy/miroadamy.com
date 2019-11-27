---
title: "Recreate txt base graph generator"
date: 2014-09-09T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["commandline","plaintext", "documentation","groovy","atg","graphviz"]
author: "Miro Adamy"
---


## Graphviz
This time using brew

```
➜  DPS  brew install graphviz
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/graphviz-2.38.0.mavericks.bottle.tar.gz
######################################################################## 100.0%
==> Pouring graphviz-2.38.0.mavericks.bottle.tar.gz
🍺  /usr/local/Cellar/graphviz/2.38.0: 469 files, 68M
➜  DPS  dot -V
dot - graphviz version 2.38.0 (20140413.2041)
➜  DPS
```

## Schema Spy
From <http://sourceforge.net/projects/schemaspy/files/schemaspy/SchemaSpy%205.0.0/>

To `/opt/diagram`

Run: 

> diagram  java -jar ./schemaSpy_5.0.0.jar -cp .:/Users/miro/lib/jdbc/mysql-connector-java-5.1.26-bin.jar -t mysql -o library -host localhost -u training -db training_dev01 -p training

It produces HTML documentation for tables

![](/images/graph-1.jpeg)
![](/images/graph-2.jpeg)
![](/images/graph-3.jpeg)


Size is about 51 M for a small ATG install

## PlantUML

Also installed in /opt/diagram

<http://plantuml.sourceforge.net/running.html>

See <http://www.planttext.com>

### Command Line
```
You can also run PlantUML using the following command :java -jar plantuml.jar file1 file2 file3
 
This will look for @startuml into file1, file2 and file3. (For each diagram, it will create a .png file).
For processing a whole directory, you can use:
java -jar plantuml.jar "c:/directory1" "c:/directory2"
 
This command will search for @startuml and @enduml into .c, .h, .cpp, .txt, .pu, .tex, .html, .htm or .java files of the c:/directory directory. 
(For each diagram, it will create a .png file).
```

### From Groovy

Since calling Java from Groovy is pretty simple, the only thinks to do is to copy PlantUML.jar file to the classpath (for exemple, ../Groovy/Groovy-1.7.6/lib directory).The following script print the current PlantUML version, and encode a URL:
 
```
 
println net.sourceforge.plantuml.version.Version.version() 
println net.sourceforge.plantuml.code.TranscoderUtil.getDefaultTranscoder().encode("Bob->Alice:hello")
 
 
If you want to generate an image from a description:

s = new net.sourceforge.plantuml.SourceStringReader("@startuml\nBob->Alice:hello\n@enduml")
FileOutputStream file = new FileOutputStream("c:/testGroovy2.png")
s.generateImage(file);
file.close()
```

# Examples:

```
@startuml
start
if (multiprocessor?) then (yes)
  fork
    :Treatment 1;
  fork again
    :Treatment 2;
  end fork
else (monoproc)
  :Treatment 1;
  :Treatment 2;
endif
 
@enduml
```

![](/images/graph-4.png)

```
@startuml
package "Some Group" {
  HTTP - [First Component]
  [Another Component]
}
  
node "Other Groups" {
  FTP - [Second Component]
  [First Component] --> FTP
}
cloud {
  [Example 1]
}
 
database "MySql" {
  folder "This is my folder" {
    [Folder 3]
  }
  frame "Foo" {
    [Frame 4]
  }
}
 
[Another Component] --> [Example 1]
[Example 1] --> [Folder 3]
[Folder 3] --> [Frame 4]
@enduml
```

![](/images/graph-5.png)


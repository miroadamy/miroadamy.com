---
title: "Tutorial on Elastic"
date: 2014-08-28T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["search","elastic","tutorial"]
author: "Miro Adamy"
---

## Running elastic 

(see Elastic search and Kibana - getting started)

> Use case: building a employee directory for Megacorp

* each document - type of 'employee'
* everything in megacorp index

## Populating

```
# Delete the `megacorp` index in case it already exists
DELETE /megacorp
# Index document 1, type "employee", in the
# "megacorp" index
PUT /megacorp/employee/1
{
    "first_name" : "John",
    "last_name" :  "Smith",
    "age" :        25,
    "about" :      "I love to go rock climbing",
    "interests": [ "sports", "music" ]
}
# Index two more documents
PUT /megacorp/employee/2
{
    "first_name" :  "Jane",
    "last_name" :   "Smith",
    "age" :         32,
    "about" :       "I like to collect rock albums",
    "interests":  [ "music" ]
}
PUT /megacorp/employee/3
{
    "first_name" :  "Douglas",
    "last_name" :   "Fir",
    "age" :         35,
    "about":        "I like to build cabinets",
    "interests":  [ "forestry" ]
}
```

In server

```
2014-08-28 13:58:02,769][INFO ][cluster.metadata         ] [Sea Urchin] [megacorp] creating index, cause [auto(index api)], shards [5]/[1], mappings []
[2014-08-28 13:58:02,858][INFO ][cluster.metadata         ] [Sea Urchin] [megacorp] update_mapping [employee] (dynamic)
[2014-08-28 13:58:16,319][INFO ][cluster.metadata         ] [Sea Urchin] [megacorp] deleting index
[2014-08-28 13:58:18,891][INFO ][cluster.metadata         ] [Sea Urchin] [megacorp] creating index, cause [auto(index api)], shards [5]/[1], mappings []
[2014-08-28 13:58:18,964][INFO ][cluster.metadata         ] [Sea Urchin] [megacorp] update_mapping [employee] (dynamic)
```

## Retrieve

```
# Retrieve the updated document
GET /megacorp/employee/1
  
{
   "_index": "megacorp",
   "_type": "employee",
   "_id": "1",
   "_version": 1,
   "found": true,
   "_source": {
      "first_name": "John",
      "last_name": "Smith",
      "age": 25,
      "about": "I love to go rock climbing",
      "interests": [
         "sports",
         "music"
      ]
   }
}
```

## Get all

```
# Search for all employees in the megacorp index:
# By default, returns to 10 results
GET /megacorp/employee/_search
```

## URL based search

```
# Search for all employees in the megacorp index
# who have "Smith" in the last_name field
GET /megacorp/employee/_search?q=last_name:Smith
```

## Query DSL

```
# Same query as above, but using the Query DSL
GET /megacorp/employee/_search
{
  "query": {
    "match": {
      "last_name": "smith"
    }
  }
}
```

## Filtering

Combines filter (age > 30) and query within filter (last name = Smith)

```
# Find all employees whose `last_name` is Smith
# and who are older than 30
GET /megacorp/employee/_search
{
    "query" : {
        "filtered" : {
            "filter" : {
                "range" : {
                    "age" : { "gt" : 30 }
                }
            },
            "query" : {
                "match" : {
                    "last_name" : "smith"
                }
            }
        }
    }
}
  
{
   "took": 5,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 1,
      "max_score": 0.30685282,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "2",
            "_score": 0.30685282,
            "_source": {
               "first_name": "Jane",
               "last_name": "Smith",
               "age": 32,
               "about": "I like to collect rock albums",
               "interests": [
                  "music"
               ]
            }
         }
      ]
   }
}
```

## Text queries with OR

```
# Find all employees who enjoy "rock" or "climbing"
GET /megacorp/employee/_search
{
    "query" : {
        "match" : {
            "about" : "rock climbing"
        }
    }
}
```

Note the OR and how relevance is different

```
{
   "took": 5,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 2,
      "max_score": 0.16273327,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "1",
            "_score": 0.16273327,
            "_source": {
               "first_name": "John",
               "last_name": "Smith",
               "age": 25,
               "about": "I love to go rock climbing",
               "interests": [
                  "sports",
                  "music"
               ]
            }
         },
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "2",
            "_score": 0.016878016,
            "_source": {
               "first_name": "Jane",
               "last_name": "Smith",
               "age": 32,
               "about": "I like to collect rock albums",
               "interests": [
                  "music"
               ]
            }
         }
      ]
   }
}
```

Elasticsearch can search within full text fields and return the most relevant results first.

## Exact phrase

```
# Find all employees who enjoy "rock climbing"
GET /megacorp/employee/_search
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    }
}
```

Gives back higher score 

```
{
   "took": 4,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 1,
      "max_score": 0.23013961,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "1",
            "_score": 0.23013961,
            "_source": {
               "first_name": "John",
               "last_name": "Smith",
               "age": 25,
               "about": "I love to go rock climbing",
               "interests": [
                  "sports",
                  "music"
               ]
            }
         }
      ]
   }
}
```

## Highlight 

```
GET /megacorp/employee/_search
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    },
    "highlight": {
        "fields" : {
            "about" : {}
        }
    }
}
```

## See the HTML highlight

```
{
   "took": 18,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 1,
      "max_score": 0.23013961,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "1",
            "_score": 0.23013961,
            "_source": {
               "first_name": "John",
               "last_name": "Smith",
               "age": 25,
               "about": "I love to go rock climbing",
               "interests": [
                  "sports",
                  "music"
               ]
            },
            "highlight": {
               "about": [
                  "I love to go <em>rock</em> <em>climbing</em>"
               ]
            }
         }
      ]
   }
}
``` 

## Analytics

* not recalculated
* on the fly

```
# Calculate the most popular interests for all employees
GET /megacorp/employee/_search
{
  "aggs": {
    "all_interests": {
      "terms": {
        "field": "interests"
      }
    }
  }
}
  
  
{
   "took": 1,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 3,
      "max_score": 1,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "3",
            "_score": 1,
            "_source": {
               "first_name": "Douglas",
               "last_name": "Fir",
               "age": 35,
               "about": "I like to build cabinets",
               "interests": [
                  "forestry"
               ]
            }
         },
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "1",
            "_score": 1,
            "_source": {
               "first_name": "John",
               "last_name": "Smith",
               "age": 25,
               "about": "I love to go rock climbing",
               "interests": [
                  "sports",
                  "music"
               ]
            }
         },
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "2",
            "_score": 1,
            "_source": {
               "first_name": "Jane",
               "last_name": "Smith",
               "age": 32,
               "about": "I like to collect rock albums",
               "interests": [
                  "music"
               ]
            }
         }
      ]
   },
   "aggregations": {
      "all_interests": {
         "buckets": [
            {
               "key": "music",
               "doc_count": 2
            },
            {
               "key": "forestry",
               "doc_count": 1
            },
            {
               "key": "sports",
               "doc_count": 1
            }
         ]
      }
   }
}
```

Can be combined with Query

```
# Calculate the most popular interests for
# employees named "Smith"
GET /megacorp/employee/_search
{
  "query": {
    "match": {
      "last_name": "smith"
    }
  },
  "aggs": {
    "all_interests": {
      "terms": {
        "field": "interests"
      }
    }
  }
}

```

REsult

```
{
   "took": 1,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 2,
      "max_score": 0.30685282,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "1",
            "_score": 0.30685282,
            "_source": {
               "first_name": "John",
               "last_name": "Smith",
               "age": 25,
               "about": "I love to go rock climbing",
               "interests": [
                  "sports",
                  "music"
               ]
            }
         },
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "2",
            "_score": 0.30685282,
            "_source": {
               "first_name": "Jane",
               "last_name": "Smith",
               "age": 32,
               "about": "I like to collect rock albums",
               "interests": [
                  "music"
               ]
            }
         }
      ]
   },
   "aggregations": {
      "all_interests": {
         "buckets": [
            {
               "key": "music",
               "doc_count": 2
            },
            {
               "key": "sports",
               "doc_count": 1
            }
         ]
      }
   }
}
```

Aggregation with average computation:

## Hierarchical roll-ups

```

# Calculate the average age of employee per interest
GET /megacorp/employee/_search
{
    "aggs" : {
        "all_interests" : {
            "terms" : { "field" : "interests" },
            "aggs" : {
                "avg_age" : {
                    "avg" : { "field" : "age" }
                }
            }
        }
    }
}
```

```
{
   "took": 1,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 3,
      "max_score": 1,
      "hits": [
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "3",
            "_score": 1,
            "_source": {
               "first_name": "Douglas",
               "last_name": "Fir",
               "age": 35,
               "about": "I like to build cabinets",
               "interests": [
                  "forestry"
               ]
            }
         },
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "1",
            "_score": 1,
            "_source": {
               "first_name": "John",
               "last_name": "Smith",
               "age": 25,
               "about": "I love to go rock climbing",
               "interests": [
                  "sports",
                  "music"
               ]
            }
         },
         {
            "_index": "megacorp",
            "_type": "employee",
            "_id": "2",
            "_score": 1,
            "_source": {
               "first_name": "Jane",
               "last_name": "Smith",
               "age": 32,
               "about": "I like to collect rock albums",
               "interests": [
                  "music"
               ]
            }
         }
      ]
   },
   "aggregations": {
      "all_interests": {
         "buckets": [
            {
               "key": "music",
               "doc_count": 2,
               "avg_age": {
                  "value": 28.5
               }
            },
            {
               "key": "forestry",
               "doc_count": 1,
               "avg_age": {
                  "value": 35
               }
            },
            {
               "key": "sports",
               "doc_count": 1,
               "avg_age": {
                  "value": 25
               }
            }
         ]
      }
   }
}

```

# Experiments with loaded logs

```
GET /_all/logs/_search
{
  "query": {
    "match_all": {}
  }
}
 
 
GET /_all/logs/_search
{
  "query": {
    "match": {
      "level": "ERROR"
    }
  }
}
```

## Retrieve document:

```
GET /website/blog/123?pretty
 
# only source, no metadata
GET /website/blog/123/_source
 
# only some fields
GET /website/blog/123?_source=title,text
```

## Existence check

```
curl -i -XHEAD http://localhost:9200/website/blog/123
 
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Content-Length: 0
 
curl -i -XHEAD http://localhost:9200/website/blog/124
 
HTTP/1.1 404 Not Found
Content-Type: text/plain; charset=UTF-8
Content-Length: 0
```

## Update
whole doc - same index API

```
PUT /website/blog/123
{
  "title": "My first blog entry",
  "text":  "I am starting to get the hang of this...",
  "date":  "2014/01/02"
}
 
# note new version, created false
{
  "_index" :   "website",
  "_type" :    "blog",
  "_id" :      "123",
  "_version" : 2,
  "created":   false 
}
```

Internally, Elasticsearch has marked the old document as deleted and added an entirely new document. The old version of the document doesn’t disappear immediately, although you won’t be able to access it. Elasticsearch cleans up deleted documents in the background as you continue to index more data.

## Create

let the ES generate new ID

```
POST /website/blog/
{ ... }
 
# or force our ID but want to allow create only, not update
 
PUT /website/blog/123?op_type=create
{ ... }
 
# another way
PUT /website/blog/123/_create
{ ... }
 
# will error if it exists:
 
{
  "error" : "DocumentAlreadyExistsException[[website][4] [blog][123]:
             document already exists]",
  "status" : 409
}
```

## Delete

```
GET /logstash-2014.08.21/_search
 
{
   "took": 1,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 1,
      "max_score": 1,
      "hits": [
         {
            "_index": "logstash-2014.08.21",
            "_type": "logs",
            "_id": "cjV9RKSBS5K5pRh7QlfllQ",
            "_score": 1,
            "_source": {
               "message": "asdasdasd asasdasd",
               "@version": "1",
               "@timestamp": "2014-08-21T21:41:46.016Z",
               "host": "Miros-MacBook-Pro-2.local"
            }
         }
      ]
   }
}
 
 
DELETE /logstash-2014.08.21/logs/cjV9RKSBS5K5pRh7QlfllQ
 
{
   "found": true,
   "_index": "logstash-2014.08.21",
   "_type": "logs",
   "_id": "cjV9RKSBS5K5pRh7QlfllQ",
   "_version": 2
}
 
GET /logstash-2014.08.21/_search
 
{
   "took": 0,
   "timed_out": false,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   },
   "hits": {
      "total": 0,
      "max_score": null,
      "hits": []
   }
}
```

afterwards, index still exist:

``` 

➜  elasticsearch-1.3.2  es -v indices
status name                pri rep size    bytes   docs
yellow logstash-2014.08.21   5   1         11946      0
yellow shakespeare           5   1      19087632 111396
yellow logstash-2014.08.22   5   1         47220     18
yellow megacorp              5   1         11067      3
yellow logstash-2014.08.27   5   1      24996521  14490
yellow logstash-2014.08.28   5   1      36012778  22645
yellow kibana-int            5   1         36253      3
yellow .marvel-kibana        5   1          3586      1
yellow .marvel-2014.08.28    1   1      16360673   7980
yellow logstash-2013.12.11   5   1          9943      1
```
---
title: "Native OS-X Docker (Beta) - not quite there yet"
date: 2016-05-17T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["docker","osx"]
author: "Miro Adamy"
---

I was intrigued by convenience of using Docker natively on Mac, without dealing with differences localhost != dockerhost, so I subscribed for Beta and installed it.

### Good news 1
 
It can coexist with previous Docker installation (mostly) - see the note at the end. As long as you do not try to run native Docker and docker-machine at the same time, things coexist.

### Good news 2
It works for several images I tried. And it is really convenient, seems to be faster (personal perception, not result of a measurement or a benchmark).

### Not so good news
Not ready for Hybris. 

I was trying to use Docker container for Oracle-XE to setup a PUQ environment (see Oracle DB on a Mac). The same container was run in native Docker and then in docker-machine setup.

The initialization in docker-machine succeeded.

The initialization in Native docker failed with network related errors:

```
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 | [m[0;31mERROR [ImpExWorker<2/4>] [][][] (junit) (00000000-ImpEx-Import) [ConnectionImpl] error resetting AutoCommit
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 | [mjava.sql.SQLRecoverableException: Closed Connection
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at oracle.jdbc.driver.PhysicalConnection.setAutoCommit(PhysicalConnection.java:3711)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.jdbcwrapper.ConnectionImpl.doSetAutoCommit(ConnectionImpl.java:431)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.jdbcwrapper.ConnectionImpl.restoreAutoCommit(ConnectionImpl.java:185)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.jdbcwrapper.ConnectionImpl.unsetTxBound(ConnectionImpl.java:175)
  
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 | [0;31mERROR [ImpExWorker<2/4>] [][][] (junit) (00000000-ImpEx-Import) [Transaction] line 17 at main script: error rolling back transaction: Closed Connection
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 | [mde.hybris.platform.tx.TransactionException: Closed Connection[VC:-1]
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 | NESTED: java.sql.SQLRecoverableException: Closed Connection
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.tx.Transaction.toTransactionException(Transaction.java:819)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.tx.Transaction.rollbackOuter(Transaction.java:1080)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.tx.Transaction.rollback(Transaction.java:1028)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.tx.Transaction.finishExecute(Transaction.java:1238)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.tx.Transaction.execute(Transaction.java:1205)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.tx.Transaction.execute(Transaction.java:1160)
INFO   | jvm 1    | main    | 2016/05/17 09:47:01.156 |     at de.hybris.platform.impex.jalo.imp.DefaultImportProcessor.processInsertUpdateLine(DefaultImportProcessor.java:423)

```
It would seem that native Docker, when under heavy load (as initialization does) starts closing connections.

## Version mismatch after update 

After stopping native docker, the docker-machine did not work:

```
➜  platform docker-machine version
docker-machine version 0.7.0, build a650a40
 
 
➜  platform docker-machine start default
Starting "default"...
(default) Check network to re-create if needed...
(default) Waiting for an IP...
Machine "default" was started.
Waiting for SSH to be available...
Detecting the provisioner...
Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.
 
 
➜  platform docker-machine env
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/miro/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env)
 
 
➜  platform eval $(docker-machine env)
 
 
➜  platform docker ps
Error response from daemon: client is newer than server (client API version: 1.23, server API version: 1.22)
```

## Fix

Run docker-machine upgrade

```
➜  platform docker-machine upgrade
Waiting for SSH to be available...
 
 
Detecting the provisioner...
Upgrading docker...
Stopping machine to do the upgrade...
Upgrading machine "default"...
Default Boot2Docker ISO is out-of-date, downloading the latest release...
Latest release for github.com/boot2docker/boot2docker is v1.11.1
Downloading /Users/miro/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v1.11.1/boot2docker.iso...
0%....10%....20%....30%....40%....50%....60%....70%....80%....90%....100%
Copying /Users/miro/.docker/machine/cache/boot2docker.iso to /Users/miro/.docker/machine/machines/default/boot2docker.iso...
Starting machine back up...
(default) Check network to re-create if needed...
(default) Waiting for an IP...
Restarting docker...
 
 
➜  platform eval $(docker-machine env)
 
 
➜  platform docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
 
 
  
➜  platform docker run -d -p 2222:22 -p 1521:1521 -p 8080:8080 --name=oracle-xe alexeiled/docker-oracle-xe-11g
b70600578607f57d179c887cc62d9503cdf39618296e831c857b6f67dc84917c
 
 
➜  platform docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                                                                  NAMES
b70600578607        alexeiled/docker-oracle-xe-11g   "/bin/sh -c /start.sh"   5 seconds ago       Up 4 seconds        0.0.0.0:1521->1521/tcp, 0.0.0.0:8080->8080/tcp, 0.0.0.0:2222->22/tcp   oracle-xe
  
➜  platform docker-machine version
docker-machine version 0.7.0, build a650a40
```
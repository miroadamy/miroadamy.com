---
title: "Docker - getting started"
date: 2015-12-11T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["docker", "osx"]
author: "Miro Adamy"
---

## After the reboot

```
docker version
Client:
 Version:      1.9.1
 API version:  1.21
 Go version:   go1.4.3
 Git commit:   a34a1d5
 Built:        Fri Nov 20 17:56:04 UTC 2015
 OS/Arch:      darwin/amd64
Cannot connect to the Docker daemon. Is the docker daemon running on this host?
  
➜  gitolite-admin git:(master) docker-machine active
No active host found
 
 
➜  gitolite-admin git:(master) docker-machine env default
Error checking TLS connection: default is not running. Please start it in order to use the connection settings
 
 
➜  gitolite-admin git:(master) docker-machine start
Error: Expected to get one or more machine names as arguments
 
 
➜  gitolite-admin git:(master) docker-machine start default
(default) Starting VM...
Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.
 
 
  
➜  gitolite-admin git:(master) docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/miro/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval "$(docker-machine env default)"
 
 
➜  gitolite-admin git:(master) eval "$(docker-machine env default)"
  
➜  gitolite-admin git:(master) docker version
Client:
 Version:      1.9.1
 API version:  1.21
 Go version:   go1.4.3
 Git commit:   a34a1d5
 Built:        Fri Nov 20 17:56:04 UTC 2015
 OS/Arch:      darwin/amd64
Server:
 Version:      1.9.1
 API version:  1.21
 Go version:   go1.4.3
 Git commit:   a34a1d5
 Built:        Fri Nov 20 17:56:04 UTC 2015
 OS/Arch:      linux/amd64
  
```

## Useful guide 

See <https://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide>
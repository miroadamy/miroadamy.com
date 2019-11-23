---
layout: post
title: Fixing docker-machine error after upgrade
date: 2016-03-16 12:57:35.000000000 -05:00
type: post
published: true
status: publish
comments: true
category: devops
tags: 
  - docker
  - osx
author: "Miro Adamy"
---

# Fixing docker-machine error after upgrade

I had to upgrade docker toolbox on Yosemite to get latest docker-compose additions. 

After installing the new package, I was not able to connect to docker machine:

```
➜  ~ docker-machine status
Stopped
➜  ~ docker-machine start default
Starting "default"...
(default) Check network to re-create if needed...
(default) Waiting for an IP...
Machine "default" was started.
Waiting for SSH to be available...
Detecting the provisioner...
Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.
➜  ~ docker-machine env default
Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.99.100:2376": tls: DialWithDialer timed out
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which will stop running containers.
```

Regenerating the certificates did not solve the problem. Neither did reboot.

Tried

```
docker-machine --debug regenerate-certs -f default
```

## Fix

What worked for me was dropping and recreating the virtual machine Docker uses to run.

```
➜  ~ docker-machine rm default
About to remove default
Are you sure? (y/n): y
Successfully removed default

➜  ~ docker-machine create --driver virtualbox default
Running pre-create checks...
Creating machine...
(default) Copying /Users/miro/.docker/machine/cache/boot2docker.iso to /Users/miro/.docker/machine/machines/default/boot2docker.iso...
(default) Creating VirtualBox VM...
(default) Creating SSH key...
(default) Starting the VM...
(default) Check network to re-create if needed...
(default) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env default

➜  ~ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/miro/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env default)

➜  ~ eval $(docker-machine env default)

➜  ~ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
➜  ~ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

Unfortunate (or fortunate ?) side effect is that all containers and images were blown away and I can start from scratch with lots of free disk space :-)


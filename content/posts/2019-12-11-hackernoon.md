---
title: "On harvesting credit card numbers and passwords"
date: 2019-12-11T21:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["security","hacking"]
author: "Miro Adamy"
---

This is the scariest thing I have read since spring 2018:

https://hackernoon.com/im-harvesting-credit-card-numbers-and-passwords-from-your-site-here-s-how-9a8cb347c5b5

written by @david.gilbertson.

It pretty sure what he describes is actually happening, has been happening before he described it and will be happening going on - just obviously not in the named module. The ecosystem of Node modules is so vast and so unstable that considerable number of project do not do enough to catch behaviour like this.

Why is this important: security is not optional and project budgets simply do not count on extensive investigation over transitive closure of all dependencies. What makes it even worse, it is not a job that can be done and checked off for the duration of the product. Unless the depencies and their dependencies are frozen, it is very easy to grab newer version of a second or third level dependency that may infected.

And also, it is not Node issue only. I can imagine Python will suffer same issues with its ecosystem as rich and as dynamic as it is today. Not everybody is using pipenv and freezing the library versions. And the same can be true for Java and JARs.

Docker of course add completely different level to this by shipping binary images which can contain pretty much anything. Unless you use commercially scanned and validated images, verify SHA1 and review every source docker file and every package installed, you are not safe.

Reviewing dockerfile is not enough - as it is trivial to run clean and safe container, install something malicious and the commit the changes. If you cleverly tag the container, it may be picked up and spread.

One does not really need to doctor the image - all that is necessary is to find an exploit in useful Linux utility and then search which docker images installed it - and which images are using the contaminated one as base

And when Kubernetes really becomes "OS of the cloud", the new opportunities will emerges. Just check how many system or infrastructure containers you have when you install Istio, Dashboard, ArgoCD, Traefik etc etc. Can you be sure you trust these and know what is really running inside your cluster ?

We are living in dangerous times.
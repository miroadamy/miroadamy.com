---
title: "All Day DevOps 2019"
date: 2019-11-07T11:22:48+08:00
published: true
type: post
categories: ["devops", "events"]
tags: ["gitops", "k8s", "aws"]
author: "Miro Adamy"
---

# All Day DevOps 2019 - Notes

I have attended the All Day Devops - <https://www.alldaydevops.com/> on 06 Nov 2019 - an event that runs for 24 hours and has multiple tracks of content organized in 4 blocks.

The tracks:

* Keynotes
* Cultural Change
* DevSecOps
* SRE
* CI/CD
* Everything Cloud

The complete list is here: <https://www.alldaydevops.com/2019-live-schedule> - the play button points to the block video.

## The Video URLs

### Channel 1

* [https://www.youtube.com/watch?v=sHNgvs\_lVzg](https://www.youtube.com/watch?v=sHNgvs_lVzg)
* <https://www.youtube.com/watch?v=Nu5KLZwmYRI>
* [https://www.youtube.com/watch?v=zc9z2\_ZwP4o](https://www.youtube.com/watch?v=zc9z2_ZwP4o)
* <https://www.youtube.com/watch?v=EXMND7WCiLc>
* <https://www.youtube.com/watch?v=56aA3A9igvw>

### Channel 2

* <https://www.youtube.com/watch?v=-JuPprlGb48>
* [https://www.youtube.com/watch?v=D38NGcjLH\_g](https://www.youtube.com/watch?v=D38NGcjLH_g)
* <https://www.youtube.com/watch?v=aIHaLiUw8oM>
* <https://www.youtube.com/watch?v=zTRN120Uu28>
* <https://www.youtube.com/watch?v=gOLQ-7tL4v8>
* [https://www.youtube.com/watch?v=qu9\_HyW2uRM](https://www.youtube.com/watch?v=qu9_HyW2uRM)

### Channel 3

* <https://www.youtube.com/watch?v=lZTMkEA7jws>
* <https://www.youtube.com/watch?v=jn8Xv8SiisM>
* <https://www.youtube.com/watch?v=Zyj0DgnseEg>
* <https://www.youtube.com/watch?v=khFkvYIFiIA>
* <https://www.youtube.com/watch?v=uymSPlasd6U>
* <https://www.youtube.com/watch?v=nYTGKeVzUBs>

### Channel 4

* <https://www.youtube.com/watch?v=xtNx1t6lxQE>
* <https://www.youtube.com/watch?v=Xzbk2pt0ilk>
* <https://www.youtube.com/watch?v=PVli8qvXgkM>
* <https://www.youtube.com/watch?v=YS0Axx5SggY>
* <https://www.youtube.com/watch?v=Bs-rzOmxa48>

### Channel 5

* <https://www.youtube.com/watch?v=ike3vQbE4zc>
* <https://www.youtube.com/watch?v=WXINx5rEl4Q>
* <https://www.youtube.com/watch?v=a5J3CRWSOXA>
* [https://www.youtube.com/watch?v=N\_A2uJzVZ8c](https://www.youtube.com/watch?v=N_A2uJzVZ8c)
* <https://www.youtube.com/watch?v=6GO9h1VsXc4>
* <https://www.youtube.com/watch?v=HmjvBIuC-BQ>

Alltogether this represents about 5 x ~ 20 =~ over 100 hours of content.

# Noteworthy and 100% relevant to == my top 3

This is subjective selection of those presentation that I managed to see and considered interesting plus with quick note why

### 10:00 AM - Can Kubernetes Keep a Secret? - Omer Levi Hevroni

Link - <https://www.youtube.com/watch?v=xtNx1t6lxQE>

Addresses issue we are having: Secret in YAML =\> base 64 =\> not secure =\> not in Git

```
Evaluated:

Helm Secrets
Sealed Secrets
Kubeseal
Seal = single key pair

Helm secrets = Mozila Mops
== coupled to cluster

Required: Gitops, Native, secure
vaultproject.io => $$$, access control, no gitops flow => imperfect
Travis encrypted secrets => only for given repo
```

SOLUTION: Kamus => Soluto (Kamus == secret in Hebrew)
<https://github.com/Soluto/kamus> 
 
* encrypt secrets for specific app, only that can decrypt it => on AWS KMS, HSM support
* CRD support
* Application identity: service account, token 

```
helm install kamus soluto/kamus
```

### 11:00 AM - What You See Is What You Get For AWS Infrastructure - Anton Babenko
Awesome extension of Cloudcraft.io that genarates Terraform and Terragrunt code

* https://www.youtube.com/watch?v=xtNx1t6lxQE
* https://github.com/antonbabenko/modules.tf-lambda ‑  
* https://github.com/antonbabenko/modules.tf-demo ‑ 
 
### Gitops FTW
https://www.youtube.com/watch?v=EXMND7WCiLc&feature=youtu.be&t=3843

=> Our current workflow is based on GitOps

## Noteworthy and interesting 

* 10:00 AM - Multi Cloud "Day to Day" DevOps Power Tools- Ronen Freeman
* 10:30 AM - Bring Back the Power of the IDE: Debugging Apps Running in Kubernetes Jeff Knurek

# Bunch of notes and links

(should be sorted out - work in progress, saving them here)

```
Concourse - deliver, extensible with bash
Helm

https://github.com/Darillium/addo-demo

https://www.slideshare.net/TanyaJanca/devsecops-with-owasp-devslop-190667649

----

Fergal Dearle (EC)

https://www.linkedin.com/in/fergaldearle/

Templating for CFN
https://github.com/Sceptre/sceptre

-----
Jeff - travel audience

https://github.com/jeff-knurek/all-day-devops-2019

Armador == docker compose for K8s

Voting apps

Telepresence => tunnel from K8s to machine
 
ksync vapor-ware

squash solo-io

skaffold

cloud code

----

Kris Buytaert

https://www.youtube.com/watch?v=lZTMkEA7jws
'Bunch of guys go/nogo'
7 tools => implement all tools

-----

Rene van Osnabrugge

-----

Jason Gwartz
https://www.ecosia.org/

----

Derek Weeks

dependencies
downloaded
----

Mohamed Labouardy
https://github.com/mlabouardy/alldaydevops-ui-2019
https://github.com/mlabouardy/alldaydevops-engine-2019
https://github.com/mlabouardy/nexususerconference-infrastructure
https://www.alldaydevops.com/blog/ci/cd-for-serverless-applications-on-aws


====

Ariane Gadd

AWS Fargate
KPMG CloudOps, 70% AWS
 
-----

Sean O'Dell
https://www.cloudjourney.io/

AWS functions
https://github.com/theseanodell
Amplify
https://github.com/vmwarecloudadvocacy/cloudhealth-lambda-functions
https://www.slideshare.net/SeanODell8/automate-everyday-tasks-with-functions-191076868

------
https://www.youtube.com/watch?v=Xzbk2pt0ilk
Jesse Butler
https://noti.st/jlbutler

https://noti.st/explore

Stateful apps - https://www.youtube.com/watch?v=PVli8qvXgkM
Bahubali Shet
https://www.slideshare.net/BahubaliShetti/how-to-manage-state-with-a-kubernetes-application


AKS - https://www.kubeflow.org/docs/notebooks/why-use-jupyter-notebook/


Jenkins - David Malett
https://github.com/dmaillet63/sample/blob/master/Jenkinsfile
file:///Users/miro/Downloads/ADDO_2019_CICD_Flexibility%20with%20Groovy-DavidMaillet.pdf


J2EE Docker
https://github.com/m-reza-rahman/javaee-docker


3 Musketeers: Jenkins, Terraform, Vault
https://youtu.be/PVli8qvXgkM?t=5725
```
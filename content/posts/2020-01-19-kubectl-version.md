---
title: "Kubectl client and server version mismatch"
date: 2020-01-19T11:12:38+08:00
published: true
type: post
categories: ["devops"]
tags: ["kubernetes","kubectl", "k8s"]
author: "Miro Adamy"
---

# Accessing Rancher cluster

I was doing update on Kubernetes cluster I had not touch in a while when I noticed weird behaviour:

* the output of get command was incomplete
* the -o wide option had no effect on the command output

(IP addresses are masked)

```
➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get nodes
NAME                                             AGE
ip-172-xx-xx-xx.ca-central-1.compute.internal    613d
ip-172-xx-xx-xx.ca-central-1.compute.internal    628d
ip-172-xx-xx-xx.ca-central-1.compute.internal    558d
```

and 

```
➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get nodes -o wide
NAME                                             AGE
ip-172-xx-xx-xx.ca-central-1.compute.internal    613d
ip-172-xx-xx-xx.ca-central-1.compute.internal    628d
ip-172-xx-xx-xx.ca-central-1.compute.internal    558d
```

Same behaviour can be seen for pods, svc etc

```
➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get pods | head -2
NAME                                   AGE
admin-deployment-c47f669fb-cnf2d       95d

➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get pods -o wide | head -2
NAME                                   AGE
admin-deployment-c47f669fb-cnf2d       95d

➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get svc | head -2
NAME         AGE
admin        503d

➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get svc -o wide | head -2
NAME         AGE
admin        503d

➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get deploy -o wide | head -2
NAME                  AGE
admin-deployment      503d
```

However, the `-o yaml` format works

```
➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat get pods -o yaml | head -10
apiVersion: v1
items:
- apiVersion: v1
  kind: Pod
  metadata:
    annotations:
      deploymentDate: 2018-11-08T12:56:27+0000
      kubernetes.io/limit-ranger: 'LimitRanger plugin set: cpu request for container
        admin'
    creationTimestamp: "2019-10-12T01:30:33Z"
    ....
    ....
 ```
 
## Root cause and solution

The cluster was built in 2018 using kops and has not been upgraded since. 

While we were working on other projects, the my local kubectl was upgraded few times and and currently the client is newer than server.   

```
➜  .kube git:(master) ✗ kubectl --kubeconfig dropship-dev-uat version
Client Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.3", GitCommit:"b3cbbae08ec52a7fc73d334838e18d17e8512749", GitTreeState:"clean", BuildDate:"2019-11-14T04:24:34Z", GoVersion:"go1.12.13", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"9", GitVersion:"v1.9.3", GitCommit:"d2835416544f298c919e2ead3be3d0864b52323b", GitTreeState:"clean", BuildDate:"2018-02-07T11:55:20Z", GoVersion:"go1.9.2", Compiler:"gc", Platform:"linux/amd64"}
```

The newer version of client does not seem to work with older server version - it would look like regression testing was not 100% complete.

I started to install older versions of the clients, going backwards. 

The version 1.11.7 from January 2019 works OK

```
VER=v1.11.7
curl -LO <https://storage.googleapis.com/kubernetes-release/release/${VER}/bin/darwin/amd64/kubectl>
mv kubectl kubectl1117
chmod +x kubectl1117

➜  .kube git:(master) ✗ ./kubectl1117 --kubeconfig dropship-dev-uat version
Client Version: version.Info{Major:"1", Minor:"11", GitVersion:"v1.11.7", GitCommit:"65ecaf0671341311ce6aea0edab46ee69f65d59e", GitTreeState:"clean", BuildDate:"2019-01-24T19:32:00Z", GoVersion:"go1.10.7", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"9", GitVersion:"v1.9.3", GitCommit:"d2835416544f298c919e2ead3be3d0864b52323b", GitTreeState:"clean", BuildDate:"2018-02-07T11:55:20Z", GoVersion:"go1.9.2", Compiler:"gc", Platform:"linux/amd64"}

➜  .kube git:(master) ✗ ./kubectl1117 --kubeconfig dropship-dev-uat get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-172-xx-xx-xx.ca-central-1.compute.internal    Ready     node      1y        v1.9.3
ip-172-xx-xx-xx.ca-central-1.compute.internal    Ready     master    1y        v1.9.3
ip-172-xx-xx-xx.ca-central-1.compute.internal    Ready     node      1y        v1.9.3

# IP's masked
➜  .kube git:(master) ✗ ./kubectl1117 --kubeconfig dropship-dev-uat get nodes -o wide
NAME                                             STATUS    ROLES     AGE       VERSION   INTERNAL-IP     EXTERNAL-IP     OS-IMAGE                      KERNEL-VERSION   CONTAINER-RUNTIME
ip-172-xx-xx-xx.ca-central-1.compute.internal    Ready     node      1y        v1.9.3    172.xx.xx.xx    35.xx.xx.171   Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
ip-172-xx-xx-xx.ca-central-1.compute.internal   Ready      master    1y        v1.9.3    172.xx.xx.xx   35.xx.xx.175   Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
ip-172-xx-xx-xx.ca-central-1.compute.internal     Ready    node      1y        v1.9.3    172.xx.xx.xx     52.xx.xx.218    Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2

➜  .kube git:(master) ✗ ./kubectl1117 --kubeconfig dropship-dev-uat get pods | head -3
NAME                                   READY     STATUS             RESTARTS   AGE
admin-deployment-c47f669fb-cnf2d       1/1       Running            0          95d
admin-deployment-c47f669fb-qtldc       1/1       Running            0          95d

➜  .kube git:(master) ✗ ./kubectl1117 --kubeconfig dropship-dev-uat get pods -o wide | head -3
NAME                                   READY     STATUS             RESTARTS   AGE       IP             NODE                                            NOMINATED NODE
admin-deployment-c47f669fb-cnf2d       1/1       Running            0          95d       100.xx.xx.xx   ip-172-xx-xx-xx.ca-central-1.compute.internal    <none>
admin-deployment-c47f669fb-qtldc       1/1       Running            0          95d       100.xx.xx.xx  ip-172-xx-xx-xx.ca-central-1.compute.internal    <none>
```

The alternative solution (better one) would be upgrading the cluster to latest version of Kubernetes. However, this is much more time consuming and it would require to bring all clusters to same version - DEV, UAT and PROD and would require thorough testing. This quick workaround allowed us to move ahead.

Writting it down in case somebody else has same issue.


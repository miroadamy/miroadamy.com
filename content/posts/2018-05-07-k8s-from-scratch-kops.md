---
title: "Creating Kubernetes Cluster in AWS from scratch with kops"
date: 2018-05-07T11:22:48+08:00
published: true
type: post
categories: ["DevOps"]
tags: ["aws","kubernetes", "kops"]
author: "Miro Adamy"
---

This describes creation of K8s cluster in AWS environment from scratch as done for microservices based eCommerce project.

## Pre-requisites

* AWS account access - IAM with Admin privileges
* AWS CLI installed - https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html
* CLI credentials (secret key + api Key) - https://docs.aws.amazon.com/cli/latest/reference/iam/index.html
* Kubectl and Kops local install
** see https://github.com/kubernetes/kops and https://kubernetes.io/docs/tasks/tools/install-kubectl/

## Test of access

```
➜  etc git:(feature/kubernetes) aws --version
aws-cli/1.11.180 Python/3.6.4 Darwin/17.5.0 botocore/1.7.38
 
➜  etc git:(feature/kubernetes) kubectl version
Client Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.1", GitCommit:"d4ab47518836c750f9949b9e0d387f20fb92260b", GitTreeState:"clean", BuildDate:"2018-04-13T22:27:55Z", GoVersion:"go1.9.5", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"9", GitVersion:"v1.9.3", GitCommit:"d2835416544f298c919e2ead3be3d0864b52323b", GitTreeState:"clean", BuildDate:"2018-02-07T11:55:20Z", GoVersion:"go1.9.2", Compiler:"gc", Platform:"linux/amd64"}
 
➜  etc git:(feature/kubernetes) kops version
Version 1.9.0
 
➜  etc git:(feature/kubernetes) aws --profile twfulfill-miro iam list-users | jq '.Users[].UserName'
.. DELETED ...
"twfulfillment.prod.miro.adamy"
....
```

## Set the environment variables

These will be used by subsequent kops / aws commands

```
➜  etc git:(feature/kubernetes) export AWS_ACCESS_KEY_ID=<YOUR-ACCESS-KEY>
➜  etc git:(feature/kubernetes) export AWS_SECRET_ACCESS_KEY=<YOUR-SECRET-KEY>
 
## Optional - if using ~/.aws/config + ~/.aws/credentials
➜  etc git:(feature/kubernetes) export AWS_PROFILE=twfulfill-miro
 
## Validate
➜  etc git:(feature/kubernetes) env | grep AWS_
AWS_ACCESS_KEY_ID=.....
AWS_SECRET_ACCESS_KEY=S..................t
AWS_PROFILE=twfulfill-miro
```

## Create kops IAM group + attach policies

```
➜  etc git:(feature/kubernetes) aws iam create-group --group-name kops
{
    "Group": {
        "Path": "/",
        "GroupName": "kops",
        "GroupId": "AGPAJWJNXBDYEPXP3VTJW",
        "Arn": "arn:aws:iam::125911927208:group/kops",
        "CreateDate": "2018-05-07T15:13:38.493Z"
    }
}
 
➜  etc git:(feature/kubernetes) aws iam list-group-policies --group-name kops
{
    "PolicyNames": []
}

➜  etc git:(feature/kubernetes) aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops

➜  etc git:(feature/kubernetes) aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops

➜  etc git:(feature/kubernetes) aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops

➜  etc git:(feature/kubernetes) aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops

 
➜  etc git:(feature/kubernetes) aws iam list-attached-group-policies --group-name kops
{
    "AttachedPolicies": [
        {
            "PolicyName": "AmazonEC2FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
        },
        {
            "PolicyName": "IAMFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/IAMFullAccess"
        },
        {
            "PolicyName": "AmazonS3FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonS3FullAccess"
        },
        {
            "PolicyName": "AmazonVPCFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
        },
        {
            "PolicyName": "AmazonRoute53FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
        }
    ]
}
 
## However - list of group policies is still empty (== explicit policies)
➜  etc git:(feature/kubernetes) aws iam list-group-policies --group-name kops
{
    "PolicyNames": []
}
```

## Create kops user

```
## Before
➜  etc git:(feature/kubernetes) aws iam list-users | jq ".Users[].UserName" 
"twfulfillment.prod.miro.adamy"
... DELETED ...
 
# Create kops user
➜  etc git:(feature/kubernetes) aws iam create-user --user-name kops
{
    "User": {
        "Path": "/",
        "UserName": "kops",
        "UserId": "AIDAJHZVKEPICOZOMHNHK",
        "Arn": "arn:aws:iam::125911927208:user/kops",
        "CreateDate": "2018-05-07T15:22:05.574Z"
    }
}
 
## Check if created
➜  etc git:(feature/kubernetes) aws iam list-users | jq ".Users[].UserName"
"kops"
"twfulfillment.prod.miro.adamy"
... DELETED ...

## Add to the group
➜  etc git:(feature/kubernetes) aws iam add-user-to-group --user-name kops --group-name kops
 
## Verify adding to the group
➜  etc git:(feature/kubernetes) aws iam list-groups-for-user --user-name kops
{
    "Groups": [
        {
            "Path": "/",
            "GroupName": "kops",
            "GroupId": "AGPAJWJNXBDYEPXP3VTJW",
            "Arn": "arn:aws:iam::125911927208:group/kops",
            "CreateDate": "2018-05-07T15:13:38Z"
        }
    ]
}
```

## S3 Buckets

Kops needs dedicated S3 bucket to store artifacts.

We will create one for each environment now: DEV, UAT, PROD.

Naming convention: PROJECT-k8s-ENVIRONMENT

```
## List existing buckets
➜  etc git:(feature/kubernetes) aws s3api list-buckets
{
    "Buckets": [],
    "Owner": {
        "DisplayName": "twfulfillment.aws",
        "ID": "f4d3f1f61cb382de98ebf5b7d58306b66ad6108cdd1916cdd3cce94e88aeeb47"
    }
}
 
## For buckets not in us-east-1 we need location constraint
 
➜  etc git:(feature/kubernetes) aws s3api create-bucket --bucket twfulfillment-k8s-uat --region us-east-1
{
    "Location": "/twfulfillment-k8s-uat"
}
➜  etc git:(feature/kubernetes) aws s3api create-bucket --bucket twfulfillment-k8s-dev --region us-east-1
{
    "Location": "/twfulfillment-k8s-dev"
}
➜  etc git:(feature/kubernetes) aws s3api create-bucket --bucket twfulfillment-k8s-prod --region us-east-2  --create-bucket-configuration LocationConstraint=us-east-2
{
    "Location": "http://twfulfillment-k8s-prod.s3.amazonaws.com/"
}
 
➜  etc git:(feature/kubernetes) aws s3api list-buckets
{
    "Buckets": [
        {
            "Name": "twfulfillment-k8s-dev",
            "CreationDate": "2018-05-07T15:34:10.000Z"
        },
        {
            "Name": "twfulfillment-k8s-prod",
            "CreationDate": "2018-05-07T15:34:29.000Z"
        },
        {
            "Name": "twfulfillment-k8s-uat",
            "CreationDate": "2018-05-07T15:33:55.000Z"
        }
    ],
    "Owner": {
        "DisplayName": "twfulfillment.aws",
        "ID": "f4d3f1f61cb382de98ebf5b7d58306b66ad6108cdd1916cdd3cce94e88aeeb47"
    }
}
 
## Enable versioning on all 3
➜  etc git:(feature/kubernetes) aws s3api put-bucket-versioning --bucket twfulfillment-k8s-prod  --versioning-configuration Status=Enabled
➜  etc git:(feature/kubernetes) aws s3api put-bucket-versioning --bucket twfulfillment-k8s-uat  --versioning-configuration Status=Enabled
➜  etc git:(feature/kubernetes) aws s3api put-bucket-versioning --bucket twfulfillment-k8s-dev  --versioning-configuration Status=Enabled
 
## ... and verify
➜  etc git:(feature/kubernetes) aws s3api get-bucket-versioning --bucket twfulfillment-k8s-dev
{
    "Status": "Enabled"
}
➜  etc git:(feature/kubernetes) aws s3api get-bucket-versioning --bucket twfulfillment-k8s-uat
{
    "Status": "Enabled"
}
➜  etc git:(feature/kubernetes) aws s3api get-bucket-versioning --bucket twfulfillment-k8s-prod
{
    "Status": "Enabled"
}
```


## Set up cluster using kops
From now on, make SURE the AWS_xxx env variables are defined.

Generate key pairs
```
➜  etc git:(feature/kubernetes) cd k8s
➜  k8s git:(feature/kubernetes) ll
 
## Location of keys for DEV and UAT. See
➜  k8s git:(feature/kubernetes) pwd
/Users/miro/src/TWC/fragrm-integ/etc/k8s
 
##
ssh-keygen -t rsa -C twfulfillment-dev-ssh
ssh-keygen -t rsa -C twfulfillment-uat-ssh

ssh-keygen -t rsa -C twfulfillment-prod-ssh

## Check the keys 
➜  k8s git:(feature/kubernetes) ✗ ll
total 48
-rw-------  1 miro  staff   1.6K  7 May 17:42 twfulfillment-dev-ssh
-rw-r--r--  1 miro  staff   403B  7 May 17:42 twfulfillment-dev-ssh.pub
-rw-------  1 miro  staff   1.6K  7 May 17:42 twfulfillment-prod-ssh
-rw-r--r--  1 miro  staff   404B  7 May 17:42 twfulfillment-prod-ssh.pub
-rw-------  1 miro  staff   1.6K  7 May 17:42 twfulfillment-uat-ssh
-rw-r--r--  1 miro  staff   403B  7 May 17:42 twfulfillment-uat-ssh.pub
```

# Creating the clusters

We will be creating 2 clusters in us-east-1

The instances used will be 3x t2.medium per cluster - 1x master + 2 worker nodes. We need t2.medium for Java processes and Kuberneters recommends the master to be at least t2.medium (or t2.large for larger number of worker nodes).


The command

```
kops create cluster --zones us-east-1a,us-east-1b --name twfulfillment-uat.k8s.local --ssh-public-key=./twfulfillment-uat-ssh.pub --state=s3://twfulfillment-k8s-uat --kubernetes-version 1.9.3 --node-count 2 --node-size t2.medium --master-size t2.medium
```

## Preview

```
➜  k8s git:(feature/kubernetes) kops create cluster --zones us-east-1a,us-east-1b --name twfulfillment-uat.k8s.local --ssh-public-key=./twfulfillment-uat-ssh.pub --state=s3://twfulfillment-k8s-uat --kubernetes-version 1.9.3 --node-count 2 --node-size t2.medium --master-size t2.medium
I0507 18:22:46.988689   59427 create_cluster.go:1318] Using SSH public key: ./twfulfillment-uat-ssh.pub
I0507 18:22:48.416794   59427 create_cluster.go:472] Inferred --cloud=aws from zone "us-east-1a"
I0507 18:22:49.245107   59427 subnets.go:184] Assigned CIDR 172.20.32.0/19 to subnet us-east-1a
I0507 18:22:49.245129   59427 subnets.go:184] Assigned CIDR 172.20.64.0/19 to subnet us-east-1b
Previewing changes that will be made:
 
I0507 18:22:53.266660   59427 apply_cluster.go:456] Gossip DNS: skipping DNS validation
I0507 18:22:53.284804   59427 executor.go:91] Tasks: 0 done / 79 total; 30 can run
I0507 18:22:54.411940   59427 executor.go:91] Tasks: 30 done / 79 total; 25 can run
I0507 18:22:55.653767   59427 executor.go:91] Tasks: 55 done / 79 total; 20 can run
I0507 18:22:56.531068   59427 executor.go:91] Tasks: 75 done / 79 total; 3 can run
W0507 18:22:56.663831   59427 keypair.go:140] Task did not have an address: *awstasks.LoadBalancer {"Name":"api.twfulfillment-uat.k8s.local","Lifecycle":"Sync","LoadBalancerName":"api-twfulfillment-uat-k8s-hqhbfl","DNSName":null,"HostedZoneId":null,"Subnets":[{"Name":"us-east-1a.twfulfillment-uat.k8s.local","Lifecycle":"Sync","ID":null,"VPC":{"Name":"twfulfillment-uat.k8s.local","Lifecycle":"Sync","ID":null,"CIDR":"172.20.0.0/16","AdditionalCIDR":null,"EnableDNSHostnames":true,"EnableDNSSupport":true,"Shared":false,"Tags":{"KubernetesCluster":"twfulfillment-uat.k8s.local","Name":"twfulfillment-uat.k8s.local","kubernetes.io/cluster/twfulfillment-uat.k8s.local":"owned"}},"AvailabilityZone":"us-east-1a","CIDR":"172.20.32.0/19","Shared":false,"Tags":{"KubernetesCluster":"twfulfillment-uat.k8s.local","Name":"us-east-1a.twfulfillment-uat.k8s.local","SubnetType":"Public","kubernetes.io/cluster/twfulfillment-uat.k8s.local":"owned","kubernetes.io/role/elb":"1"}},{"Name":"us-east-1b.twfulfillment-uat.k8s.local","Lifecycle":"Sync","ID":null,"VPC":{"Name":"twfulfillment-uat.k8s.local","Lifecycle":"Sync","ID":null,"CIDR":"172.20.0.0/16","AdditionalCIDR":null,"EnableDNSHostnames":true,"EnableDNSSupport":true,"Shared":false,"Tags":{"KubernetesCluster":"twfulfillment-uat.k8s.local","Name":"twfulfillment-uat.k8s.local","kubernetes.io/cluster/twfulfillment-uat.k8s.local":"owned"}},"AvailabilityZone":"us-east-1b","CIDR":"172.20.64.0/19","Shared":false,"Tags":{"KubernetesCluster":"twfulfillment-uat.k8s.local","Name":"us-east-1b.twfulfillment-uat.k8s.local","SubnetType":"Public","kubernetes.io/cluster/twfulfillment-uat.k8s.local":"owned","kubernetes.io/role/elb":"1"}}],"SecurityGroups":[{"Name":"api-elb.twfulfillment-uat.k8s.local","Lifecycle":"Sync","ID":null,"Description":"Security group for api ELB","VPC":{"Name":"twfulfillment-uat.k8s.local","Lifecycle":"Sync","ID":null,"CIDR":"172.20.0.0/16","AdditionalCIDR":null,"EnableDNSHostnames":true,"EnableDNSSupport":true,"Shared":false,"Tags":{"KubernetesCluster":"twfulfillment-uat.k8s.local","Name":"twfulfillment-uat.k8s.local","kubernetes.io/cluster/twfulfillment-uat.k8s.local":"owned"}},"RemoveExtraRules":["port=443"],"Shared":null,"Tags":{"KubernetesCluster":"twfulfillment-uat.k8s.local","Name":"api-elb.twfulfillment-uat.k8s.local","kubernetes.io/cluster/twfulfillment-uat.k8s.local":"owned"}}],"Listeners":{"443":{"InstancePort":443}},"Scheme":null,"HealthCheck":{"Target":"SSL:443","HealthyThreshold":2,"UnhealthyThreshold":2,"Interval":10,"Timeout":5},"AccessLog":null,"ConnectionDraining":null,"ConnectionSettings":{"IdleTimeout":300},"CrossZoneLoadBalancing":null}
I0507 18:22:57.252182   59427 executor.go:91] Tasks: 78 done / 79 total; 1 can run
I0507 18:22:57.438067   59427 executor.go:91] Tasks: 79 done / 79 total; 0 can run
Will create resources:
  AutoscalingGroup/master-us-east-1a.masters.twfulfillment-uat.k8s.local
    MinSize                 1
    MaxSize                 1
    Subnets                 [name:us-east-1a.twfulfillment-uat.k8s.local]
    Tags                    {k8s.io/role/master: 1, Name: master-us-east-1a.masters.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup: master-us-east-1a}
    Granularity             1Minute
    Metrics                 [GroupDesiredCapacity, GroupInServiceInstances, GroupMaxSize, GroupMinSize, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances]
    LaunchConfiguration     name:master-us-east-1a.masters.twfulfillment-uat.k8s.local
 
  AutoscalingGroup/nodes.twfulfillment-uat.k8s.local
    MinSize                 2
    MaxSize                 2
    Subnets                 [name:us-east-1a.twfulfillment-uat.k8s.local, name:us-east-1b.twfulfillment-uat.k8s.local]
    Tags                    {Name: nodes.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup: nodes, k8s.io/role/node: 1}
    Granularity             1Minute
    Metrics                 [GroupDesiredCapacity, GroupInServiceInstances, GroupMaxSize, GroupMinSize, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances]
    LaunchConfiguration     name:nodes.twfulfillment-uat.k8s.local
 
  DHCPOptions/twfulfillment-uat.k8s.local
    DomainName              ec2.internal
    DomainNameServers       AmazonProvidedDNS
    Shared                  false
    Tags                    {Name: twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned}
 
  EBSVolume/a.etcd-events.twfulfillment-uat.k8s.local
    AvailabilityZone        us-east-1a
    VolumeType              gp2
    SizeGB                  20
    Encrypted               false
    Tags                    {k8s.io/etcd/events: a/a, k8s.io/role/master: 1, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned, Name: a.etcd-events.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local}
 
  EBSVolume/a.etcd-main.twfulfillment-uat.k8s.local
    AvailabilityZone        us-east-1a
    VolumeType              gp2
    SizeGB                  20
    Encrypted               false
    Tags                    {k8s.io/etcd/main: a/a, k8s.io/role/master: 1, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned, Name: a.etcd-main.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local}
 
  IAMInstanceProfile/masters.twfulfillment-uat.k8s.local
 
  IAMInstanceProfile/nodes.twfulfillment-uat.k8s.local
 
  IAMInstanceProfileRole/masters.twfulfillment-uat.k8s.local
    InstanceProfile         name:masters.twfulfillment-uat.k8s.local id:masters.twfulfillment-uat.k8s.local
    Role                    name:masters.twfulfillment-uat.k8s.local
 
  IAMInstanceProfileRole/nodes.twfulfillment-uat.k8s.local
    InstanceProfile         name:nodes.twfulfillment-uat.k8s.local id:nodes.twfulfillment-uat.k8s.local
    Role                    name:nodes.twfulfillment-uat.k8s.local
 
  IAMRole/masters.twfulfillment-uat.k8s.local
    ExportWithID            masters
 
  IAMRole/nodes.twfulfillment-uat.k8s.local
    ExportWithID            nodes
 
  IAMRolePolicy/masters.twfulfillment-uat.k8s.local
    Role                    name:masters.twfulfillment-uat.k8s.local
 
  IAMRolePolicy/nodes.twfulfillment-uat.k8s.local
    Role                    name:nodes.twfulfillment-uat.k8s.local
 
  InternetGateway/twfulfillment-uat.k8s.local
    VPC                     name:twfulfillment-uat.k8s.local
    Shared                  false
    Tags                    {Name: twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned}
 
  Keypair/apiserver-aggregator
    Signer                  name:apiserver-aggregator-ca id:cn=apiserver-aggregator-ca
    Subject                 cn=aggregator
    Type                    client
    Format                  v1alpha2
 
  Keypair/apiserver-aggregator-ca
    Subject                 cn=apiserver-aggregator-ca
    Type                    ca
    Format                  v1alpha2
 
  Keypair/apiserver-proxy-client
    Signer                  name:ca id:cn=kubernetes
    Subject                 cn=apiserver-proxy-client
    Type                    client
    Format                  v1alpha2
 
  Keypair/ca
    Subject                 cn=kubernetes
    Type                    ca
    Format                  v1alpha2
 
  Keypair/kops
    Signer                  name:ca id:cn=kubernetes
    Subject                 o=system:masters,cn=kops
    Type                    client
    Format                  v1alpha2
 
  Keypair/kube-controller-manager
    Signer                  name:ca id:cn=kubernetes
    Subject                 cn=system:kube-controller-manager
    Type                    client
    Format                  v1alpha2
 
  Keypair/kube-proxy
    Signer                  name:ca id:cn=kubernetes
    Subject                 cn=system:kube-proxy
    Type                    client
    Format                  v1alpha2
 
  Keypair/kube-scheduler
    Signer                  name:ca id:cn=kubernetes
    Subject                 cn=system:kube-scheduler
    Type                    client
    Format                  v1alpha2
 
  Keypair/kubecfg
    Signer                  name:ca id:cn=kubernetes
    Subject                 o=system:masters,cn=kubecfg
    Type                    client
    Format                  v1alpha2
 
  Keypair/kubelet
    Signer                  name:ca id:cn=kubernetes
    Subject                 o=system:nodes,cn=kubelet
    Type                    client
    Format                  v1alpha2
 
  Keypair/kubelet-api
    Signer                  name:ca id:cn=kubernetes
    Subject                 cn=kubelet-api
    Type                    client
    Format                  v1alpha2
 
  Keypair/master
    AlternateNames          [100.64.0.1, 127.0.0.1, api.internal.twfulfillment-uat.k8s.local, api.twfulfillment-uat.k8s.local, kubernetes, kubernetes.default, kubernetes.default.svc, kubernetes.default.svc.cluster.local]
    Signer                  name:ca id:cn=kubernetes
    Subject                 cn=kubernetes-master
    Type                    server
    Format                  v1alpha2
 
  LaunchConfiguration/master-us-east-1a.masters.twfulfillment-uat.k8s.local
    ImageID                 kope.io/k8s-1.8-debian-jessie-amd64-hvm-ebs-2018-02-08
    InstanceType            t2.medium
    SSHKey                  name:kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01 id:kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01
    SecurityGroups          [name:masters.twfulfillment-uat.k8s.local]
    AssociatePublicIP       true
    IAMInstanceProfile      name:masters.twfulfillment-uat.k8s.local id:masters.twfulfillment-uat.k8s.local
    RootVolumeSize          64
    RootVolumeType          gp2
    SpotPrice
 
  LaunchConfiguration/nodes.twfulfillment-uat.k8s.local
    ImageID                 kope.io/k8s-1.8-debian-jessie-amd64-hvm-ebs-2018-02-08
    InstanceType            t2.medium
    SSHKey                  name:kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01 id:kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01
    SecurityGroups          [name:nodes.twfulfillment-uat.k8s.local]
    AssociatePublicIP       true
    IAMInstanceProfile      name:nodes.twfulfillment-uat.k8s.local id:nodes.twfulfillment-uat.k8s.local
    RootVolumeSize          128
    RootVolumeType          gp2
    SpotPrice
 
  LoadBalancer/api.twfulfillment-uat.k8s.local
    LoadBalancerName        api-twfulfillment-uat-k8s-hqhbfl
    Subnets                 [name:us-east-1a.twfulfillment-uat.k8s.local, name:us-east-1b.twfulfillment-uat.k8s.local]
    SecurityGroups          [name:api-elb.twfulfillment-uat.k8s.local]
    Listeners               {443: {"InstancePort":443}}
    HealthCheck             {"Target":"SSL:443","HealthyThreshold":2,"UnhealthyThreshold":2,"Interval":10,"Timeout":5}
    ConnectionSettings      {"IdleTimeout":300}
 
  LoadBalancerAttachment/api-master-us-east-1a
    LoadBalancer            name:api.twfulfillment-uat.k8s.local id:api.twfulfillment-uat.k8s.local
    AutoscalingGroup        name:master-us-east-1a.masters.twfulfillment-uat.k8s.local id:master-us-east-1a.masters.twfulfillment-uat.k8s.local
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-bootstrap
    Location                addons/bootstrap-channel.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-core.addons.k8s.io
    Location                addons/core.addons.k8s.io/v1.4.0.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-dns-controller.addons.k8s.io-k8s-1.6
    Location                addons/dns-controller.addons.k8s.io/k8s-1.6.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-dns-controller.addons.k8s.io-pre-k8s-1.6
    Location                addons/dns-controller.addons.k8s.io/pre-k8s-1.6.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-kube-dns.addons.k8s.io-k8s-1.6
    Location                addons/kube-dns.addons.k8s.io/k8s-1.6.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-kube-dns.addons.k8s.io-pre-k8s-1.6
    Location                addons/kube-dns.addons.k8s.io/pre-k8s-1.6.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-limit-range.addons.k8s.io
    Location                addons/limit-range.addons.k8s.io/v1.5.0.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-rbac.addons.k8s.io-k8s-1.8
    Location                addons/rbac.addons.k8s.io/k8s-1.8.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-storage-aws.addons.k8s.io-v1.6.0
    Location                addons/storage-aws.addons.k8s.io/v1.6.0.yaml
 
  ManagedFile/twfulfillment-uat.k8s.local-addons-storage-aws.addons.k8s.io-v1.7.0
    Location                addons/storage-aws.addons.k8s.io/v1.7.0.yaml
 
  Route/0.0.0.0/0
    RouteTable              name:twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    InternetGateway         name:twfulfillment-uat.k8s.local
 
  RouteTable/twfulfillment-uat.k8s.local
    VPC                     name:twfulfillment-uat.k8s.local
    Shared                  false
    Tags                    {Name: twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned, kubernetes.io/kops/role: public}
 
  RouteTableAssociation/us-east-1a.twfulfillment-uat.k8s.local
    RouteTable              name:twfulfillment-uat.k8s.local
    Subnet                  name:us-east-1a.twfulfillment-uat.k8s.local
 
  RouteTableAssociation/us-east-1b.twfulfillment-uat.k8s.local
    RouteTable              name:twfulfillment-uat.k8s.local
    Subnet                  name:us-east-1b.twfulfillment-uat.k8s.local
 
  SSHKey/kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01
    KeyFingerprint          16:58:c0:9f:cd:99:22:53:72:95:4a:3b:85:1e:e1:28
 
  Secret/admin
 
  Secret/kube
 
  Secret/kube-proxy
 
  Secret/kubelet
 
  Secret/system:controller_manager
 
  Secret/system:dns
 
  Secret/system:logging
 
  Secret/system:monitoring
 
  Secret/system:scheduler
 
  SecurityGroup/api-elb.twfulfillment-uat.k8s.local
    Description             Security group for api ELB
    VPC                     name:twfulfillment-uat.k8s.local
    RemoveExtraRules        [port=443]
    Tags                    {Name: api-elb.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned}
 
  SecurityGroup/masters.twfulfillment-uat.k8s.local
    Description             Security group for masters
    VPC                     name:twfulfillment-uat.k8s.local
    RemoveExtraRules        [port=22, port=443, port=2380, port=2381, port=4001, port=4002, port=4789, port=179]
    Tags                    {Name: masters.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned}
 
  SecurityGroup/nodes.twfulfillment-uat.k8s.local
    Description             Security group for nodes
    VPC                     name:twfulfillment-uat.k8s.local
    RemoveExtraRules        [port=22]
    Tags                    {Name: nodes.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned}
 
  SecurityGroupRule/all-master-to-master
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    SourceGroup             name:masters.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/all-master-to-node
    SecurityGroup           name:nodes.twfulfillment-uat.k8s.local
    SourceGroup             name:masters.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/all-node-to-node
    SecurityGroup           name:nodes.twfulfillment-uat.k8s.local
    SourceGroup             name:nodes.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/api-elb-egress
    SecurityGroup           name:api-elb.twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    Egress                  true
 
  SecurityGroupRule/https-api-elb-0.0.0.0/0
    SecurityGroup           name:api-elb.twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    Protocol                tcp
    FromPort                443
    ToPort                  443
 
  SecurityGroupRule/https-elb-to-master
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    Protocol                tcp
    FromPort                443
    ToPort                  443
    SourceGroup             name:api-elb.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/master-egress
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    Egress                  true
 
  SecurityGroupRule/node-egress
    SecurityGroup           name:nodes.twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    Egress                  true
 
  SecurityGroupRule/node-to-master-tcp-1-2379
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    Protocol                tcp
    FromPort                1
    ToPort                  2379
    SourceGroup             name:nodes.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/node-to-master-tcp-2382-4000
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    Protocol                tcp
    FromPort                2382
    ToPort                  4000
    SourceGroup             name:nodes.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/node-to-master-tcp-4003-65535
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    Protocol                tcp
    FromPort                4003
    ToPort                  65535
    SourceGroup             name:nodes.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/node-to-master-udp-1-65535
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    Protocol                udp
    FromPort                1
    ToPort                  65535
    SourceGroup             name:nodes.twfulfillment-uat.k8s.local
 
  SecurityGroupRule/ssh-external-to-master-0.0.0.0/0
    SecurityGroup           name:masters.twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    Protocol                tcp
    FromPort                22
    ToPort                  22
 
  SecurityGroupRule/ssh-external-to-node-0.0.0.0/0
    SecurityGroup           name:nodes.twfulfillment-uat.k8s.local
    CIDR                    0.0.0.0/0
    Protocol                tcp
    FromPort                22
    ToPort                  22
 
  Subnet/us-east-1a.twfulfillment-uat.k8s.local
    VPC                     name:twfulfillment-uat.k8s.local
    AvailabilityZone        us-east-1a
    CIDR                    172.20.32.0/19
    Shared                  false
    Tags                    {Name: us-east-1a.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned, kubernetes.io/role/elb: 1, SubnetType: Public}
 
  Subnet/us-east-1b.twfulfillment-uat.k8s.local
    VPC                     name:twfulfillment-uat.k8s.local
    AvailabilityZone        us-east-1b
    CIDR                    172.20.64.0/19
    Shared                  false
    Tags                    {Name: us-east-1b.twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned, kubernetes.io/role/elb: 1, SubnetType: Public}
 
  VPC/twfulfillment-uat.k8s.local
    CIDR                    172.20.0.0/16
    EnableDNSHostnames      true
    EnableDNSSupport        true
    Shared                  false
    Tags                    {Name: twfulfillment-uat.k8s.local, KubernetesCluster: twfulfillment-uat.k8s.local, kubernetes.io/cluster/twfulfillment-uat.k8s.local: owned}
 
  VPCDHCPOptionsAssociation/twfulfillment-uat.k8s.local
    VPC                     name:twfulfillment-uat.k8s.local
    DHCPOptions             name:twfulfillment-uat.k8s.local
 
Must specify --yes to apply changes
 
Cluster configuration has been created.
 
Suggestions:
 * list clusters with: kops get cluster
 * edit this cluster with: kops edit cluster twfulfillment-uat.k8s.local
 * edit your node instance group: kops edit ig --name=twfulfillment-uat.k8s.local nodes
 * edit your master instance group: kops edit ig --name=twfulfillment-uat.k8s.local master-us-east-1a
 
Finally configure your cluster with: kops update cluster twfulfillment-uat.k8s.local --yes
```

## Actual creation

```
➜  k8s git:(feature/kubernetes) kops get cluster
 
State Store: Required value: Please set the --state flag or export KOPS_STATE_STORE.
A valid value follows the format s3://<bucket>.
A s3 bucket is required to store cluster state information.
 
## Using explicit bucket
➜  k8s git:(feature/kubernetes) kops get cluster --state=s3://twfulfillment-k8s-uat
NAME                CLOUD   ZONES
twfulfillment-uat.k8s.local aws us-east-1a,us-east-1b
 
## GO!
➜  k8s git:(feature/kubernetes) kops update cluster twfulfillment-uat.k8s.local --state=s3://twfulfillment-k8s-uat --yes
I0507 18:25:34.350553   59477 apply_cluster.go:456] Gossip DNS: skipping DNS validation
I0507 18:25:35.281401   59477 executor.go:91] Tasks: 0 done / 79 total; 30 can run
I0507 18:25:36.844750   59477 vfs_castore.go:731] Issuing new certificate: "ca"
I0507 18:25:36.871653   59477 vfs_castore.go:731] Issuing new certificate: "apiserver-aggregator-ca"
I0507 18:25:40.134585   59477 executor.go:91] Tasks: 30 done / 79 total; 25 can run
I0507 18:25:41.669604   59477 vfs_castore.go:731] Issuing new certificate: "apiserver-aggregator"
I0507 18:25:41.713562   59477 vfs_castore.go:731] Issuing new certificate: "kubecfg"
I0507 18:25:41.745488   59477 vfs_castore.go:731] Issuing new certificate: "kubelet-api"
I0507 18:25:41.785588   59477 vfs_castore.go:731] Issuing new certificate: "kube-proxy"
I0507 18:25:41.826068   59477 vfs_castore.go:731] Issuing new certificate: "kops"
I0507 18:25:41.828162   59477 vfs_castore.go:731] Issuing new certificate: "kube-scheduler"
I0507 18:25:41.834064   59477 vfs_castore.go:731] Issuing new certificate: "kube-controller-manager"
I0507 18:25:41.918415   59477 vfs_castore.go:731] Issuing new certificate: "apiserver-proxy-client"
I0507 18:25:41.984042   59477 vfs_castore.go:731] Issuing new certificate: "kubelet"
W0507 18:25:44.563905   59477 executor.go:118] error running task "SecurityGroup/api-elb.twfulfillment-uat.k8s.local" (9m55s remaining to succeed): error listing SecurityGroups: InvalidGroup.NotFound: The security group 'sg-0747fcccc1c67f785' does not exist
    status code: 400, request id: 13a0c766-c04b-412b-bbbf-09ee76f11b72
I0507 18:25:44.563955   59477 executor.go:91] Tasks: 54 done / 79 total; 17 can run
I0507 18:25:46.226024   59477 executor.go:91] Tasks: 71 done / 79 total; 6 can run
I0507 18:25:48.356776   59477 executor.go:91] Tasks: 77 done / 79 total; 2 can run
I0507 18:25:49.685752   59477 vfs_castore.go:731] Issuing new certificate: "master"
W0507 18:25:50.745302   59477 executor.go:118] error running task "LoadBalancerAttachment/api-master-us-east-1a" (9m57s remaining to succeed): error attaching autoscaling group to ELB: ValidationError: Provided Load Balancers may not be valid. Please ensure they exist and try again.
    status code: 400, request id: 4d1ccf95-5213-11e8-92f5-11950813b91a
I0507 18:25:50.745339   59477 executor.go:91] Tasks: 78 done / 79 total; 1 can run
W0507 18:25:51.150152   59477 executor.go:118] error running task "LoadBalancerAttachment/api-master-us-east-1a" (9m57s remaining to succeed): error attaching autoscaling group to ELB: ValidationError: Provided Load Balancers may not be valid. Please ensure they exist and try again.
    status code: 400, request id: 4e822b8d-5213-11e8-aa30-b39cf8514ec9
I0507 18:25:51.150181   59477 executor.go:133] No progress made, sleeping before retrying 1 failed task(s)
I0507 18:26:01.154620   59477 executor.go:91] Tasks: 78 done / 79 total; 1 can run
I0507 18:26:02.115713   59477 executor.go:91] Tasks: 79 done / 79 total; 0 can run
I0507 18:26:02.405109   59477 update_cluster.go:291] Exporting kubecfg for cluster
kops has set your kubectl context to twfulfillment-uat.k8s.local
 
Cluster is starting.  It should be ready in a few minutes.
 
Suggestions:
 * validate cluster: kops validate cluster
 * list nodes: kubectl get nodes --show-labels
 * ssh to the master: ssh -i ~/.ssh/id_rsa admin@api.twfulfillment-uat.k8s.local
 * the admin user is specific to Debian. If not using Debian please use the appropriate user based on your OS.
 * read about installing addons at: https://github.com/kubernetes/kops/blob/master/docs/addons.md.
```

## Validation

```
➜  k8s git:(feature/kubernetes) kubectl cluster-info
Kubernetes master is running at https://api-twfulfillment-uat-k8s-hqhbfl-2093835009.us-east-1.elb.amazonaws.com
 
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
 
➜  k8s git:(feature/kubernetes) ✗ kops validate cluster twfulfillment-uat.k8s.local --state=s3://twfulfillment-k8s-uat
Validating cluster twfulfillment-uat.k8s.local
 
INSTANCE GROUPS
NAME            ROLE    MACHINETYPE MIN MAX SUBNETS
master-us-east-1a   Master  t2.medium   1   1   us-east-1a
nodes           Node    t2.medium   2   2   us-east-1a,us-east-1b
 
NODE STATUS
NAME                ROLE    READY
ip-172-20-39-188.ec2.internal   master  True
ip-172-20-54-148.ec2.internal   node    True
ip-172-20-89-163.ec2.internal   node    True
 
Your cluster twfulfillment-uat.k8s.local is ready
 
➜  k8s git:(feature/kubernetes) ✗ kubectl get nodes -o wide
NAME                            STATUS    ROLES     AGE       VERSION   EXTERNAL-IP     OS-IMAGE                      KERNEL-VERSION   CONTAINER-RUNTIME
ip-172-20-39-188.ec2.internal   Ready     master    2m        v1.9.3    52.91.56.212    Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
ip-172-20-54-148.ec2.internal   Ready     node      2m        v1.9.3    35.173.185.93   Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
ip-172-20-89-163.ec2.internal   Ready     node      2m        v1.9.3    34.201.19.66    Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
 
 
➜  k8s git:(feature/kubernetes) ✗ aws ec2 --region=us-east-1 describe-instances | jq '.Reservations[].Instances[] | .InstanceId + "  :  " + .KeyName + "  =>  " + .PublicIpAddress'
"i-0b681568fcfd88a9b  :  kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01  =>  52.91.56.212"
"i-0f48b0acc1ebb3444  :  kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01  =>  35.173.185.93"
"i-05fb02b4bdd61d9ae  :  dockercloud-2a3769a0-fa94-458c-9e19-b4da1525ece8  =>  52.91.149.121"
"i-064d2261b5610715f  :  twfulfill-dev-us-east-1  =>  "
"i-034013fb3730e284b  :  dockercloud-2a3769a0-fa94-458c-9e19-b4da1525ece8  =>  54.162.224.243"
"i-09268120fd4b2b95d  :  dockercloud-2a3769a0-fa94-458c-9e19-b4da1525ece8  =>  34.234.234.77"
"i-007a536fedbdd74bc  :  kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01  =>  34.201.19.66"
 
➜  k8s git:(feature/kubernetes) ✗ aws ec2 --region=us-east-1 describe-instances | jq '.Reservations[].Instances[] | .InstanceId + "  :  " + .Placement.AvailabilityZone + "  =>  " + .PublicIpAddress'
"i-0b681568fcfd88a9b  :  us-east-1a  =>  52.91.56.212"
"i-0f48b0acc1ebb3444  :  us-east-1a  =>  35.173.185.93"
"i-05fb02b4bdd61d9ae  :  us-east-1e  =>  52.91.149.121"
"i-064d2261b5610715f  :  us-east-1b  =>  "
"i-034013fb3730e284b  :  us-east-1e  =>  54.162.224.243"
"i-09268120fd4b2b95d  :  us-east-1b  =>  34.234.234.77"
"i-007a536fedbdd74bc  :  us-east-1b  =>  34.201.19.66"
```

We repeat the process for DEV environment cluster

```
➜  k8s git:(feature/kubernetes) ✗ kops create cluster --zones us-east-1c,us-east-1d --name twfulfillment-dev.k8s.local --ssh-public-key=./twfulfillment-dev-ssh.pub --state=s3://twfulfillment-k8s-dev --kubernetes-version 1.9.3 --node-count 2 --node-size t2.medium --master-size t2.medium
I0507 18:43:22.701155   59817 create_cluster.go:1318] Using SSH public key: ./twfulfillment-dev-ssh.pub
I0507 18:43:24.217861   59817 create_cluster.go:472] Inferred --cloud=aws from zone "us-east-1c"
I0507 18:43:25.002584   59817 subnets.go:184] Assigned CIDR 172.20.32.0/19 to subnet us-east-1c
I0507 18:43:25.002611   59817 subnets.go:184] Assigned CIDR 172.20.64.0/19 to subnet us-east-1d
Previewing changes that will be made:

... DELETED ...

➜  k8s git:(feature/kubernetes) ✗ kops get cluster --state=s3://twfulfillment-k8s-dev
NAME                CLOUD   ZONES
twfulfillment-dev.k8s.local aws us-east-1c,us-east-1d
 
➜  k8s git:(feature/kubernetes) ✗ kops update cluster twfulfillment-dev.k8s.local --state=s3://twfulfillment-k8s-dev --yes
I0507 18:45:09.825489   59851 apply_cluster.go:456] Gossip DNS: skipping DNS validation

... DELETED ...

➜  k8s git:(feature/kubernetes) ✗ kubectl config current-context
twfulfillment-dev.k8s.local
 
➜  k8s git:(feature/kubernetes) ✗ kops validate cluster twfulfillment-dev.k8s.local --state=s3://twfulfillment-k8s-dev
Validating cluster twfulfillment-dev.k8s.local
 
INSTANCE GROUPS
NAME            ROLE    MACHINETYPE MIN MAX SUBNETS
master-us-east-1c   Master  t2.medium   1   1   us-east-1c
nodes           Node    t2.medium   2   2   us-east-1c,us-east-1d
 
NODE STATUS
NAME                ROLE    READY
ip-172-20-54-25.ec2.internal    master  True
ip-172-20-61-51.ec2.internal    node    True
ip-172-20-82-210.ec2.internal   node    True
 
Your cluster twfulfillment-dev.k8s.local is ready

➜  k8s git:(feature/kubernetes) ✗ kubectl get nodes -o wide
NAME                            STATUS    ROLES     AGE       VERSION   EXTERNAL-IP      OS-IMAGE                      KERNEL-VERSION   CONTAINER-RUNTIME
ip-172-20-54-25.ec2.internal    Ready     master    1m        v1.9.3    54.159.165.112   Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
ip-172-20-61-51.ec2.internal    Ready     node      52s       v1.9.3    35.170.246.224   Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
ip-172-20-82-210.ec2.internal   Ready     node      50s       v1.9.3    34.224.71.154    Debian GNU/Linux 8 (jessie)   4.4.115-k8s      docker://17.3.2
 
➜  k8s git:(feature/kubernetes) ✗ aws ec2 --region=us-east-1 describe-instances | jq '.Reservations[].Instances[] | .InstanceId + "  :  " + .Placement.AvailabilityZone + "  =>  " + .PublicIpAddress'
"i-0b681568fcfd88a9b  :  us-east-1a  =>  52.91.56.212"
"i-039bc0f4b482127d6  :  us-east-1d  =>  34.224.71.154"
"i-033d8a11120288ad6  :  us-east-1c  =>  35.170.246.224"
"i-0f48b0acc1ebb3444  :  us-east-1a  =>  35.173.185.93"
"i-05fb02b4bdd61d9ae  :  us-east-1e  =>  52.91.149.121"
"i-064d2261b5610715f  :  us-east-1b  =>  "
"i-034013fb3730e284b  :  us-east-1e  =>  54.162.224.243"
"i-00fba10c6d2e2e9bb  :  us-east-1c  =>  54.159.165.112"
"i-09268120fd4b2b95d  :  us-east-1b  =>  34.234.234.77"
"i-007a536fedbdd74bc  :  us-east-1b  =>  34.201.19.66"
 
➜  k8s git:(feature/kubernetes) ✗ aws ec2 --region=us-east-1 describe-instances | jq '.Reservations[].Instances[] | .InstanceId + "  :  " + .KeyName + "  =>  " + .PublicIpAddress'
"i-0b681568fcfd88a9b  :  kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01  =>  52.91.56.212"
"i-039bc0f4b482127d6  :  kubernetes.twfulfillment-dev.k8s.local-3c:05:ac:2d:75:14:21:fa:ab:98:c7:3d:9d:68:8d:1d  =>  34.224.71.154"
"i-033d8a11120288ad6  :  kubernetes.twfulfillment-dev.k8s.local-3c:05:ac:2d:75:14:21:fa:ab:98:c7:3d:9d:68:8d:1d  =>  35.170.246.224"
"i-0f48b0acc1ebb3444  :  kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01  =>  35.173.185.93"
"i-05fb02b4bdd61d9ae  :  dockercloud-2a3769a0-fa94-458c-9e19-b4da1525ece8  =>  52.91.149.121"
"i-064d2261b5610715f  :  twfulfill-dev-us-east-1  =>  "
"i-034013fb3730e284b  :  dockercloud-2a3769a0-fa94-458c-9e19-b4da1525ece8  =>  54.162.224.243"
"i-00fba10c6d2e2e9bb  :  kubernetes.twfulfillment-dev.k8s.local-3c:05:ac:2d:75:14:21:fa:ab:98:c7:3d:9d:68:8d:1d  =>  54.159.165.112"
"i-09268120fd4b2b95d  :  dockercloud-2a3769a0-fa94-458c-9e19-b4da1525ece8  =>  34.234.234.77"
"i-007a536fedbdd74bc  :  kubernetes.twfulfillment-uat.k8s.local-c9:e4:2e:2e:a7:6d:f9:4b:d8:20:56:80:3b:2c:12:01  =>  34.201.19.66"

```

Kubectl in local docker now will show multiple options


![](/images/2018-05-07_18-45-52.png)


link to a <a href="{{< relref "2014-08-28-elastic-tutorial.md" >}}">post</a>

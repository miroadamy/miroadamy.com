---
title: "AWS Inspection"
date: 2019-10-03T11:22:48+08:00
published: true
type: post
categories: ["DevOps"]
tags: ["AWS", "cloud", "oneliners"]
author: "Miro Adamy"
---

## Bunch of one-liners for AWS

.. so that I find them faster next time 

```
aws --output=json ec2 describe-instances | jq -r '.Reservations[].Instances[] | "\n" + .InstanceId + "  :  " + .KeyName + "  =>  " + .PublicIpAddress + " | " + .PublicDnsName,  .Tags[] as $tt | "  ... " + $tt.Key +":"+ $tt.Value'

aws ec2 describe-instances | jq '.Reservations[].Instances[] | .InstanceId + "  :  " + .Placement.AvailabilityZone + "  =>  " + .PublicIpAddress'

aws iam list-group-policies --group-name kops

aws ec2 describe-vpcs | jq '.Vpcs[] | .VpcId + " " + .CidrBlock'

aws iam list-users | jq '.Users[].UserName'

aws --output=json --region=ca-central-1 ec2 describe-vpcs | jq -r '.Vpcs[] | .VpcId + " " + .CidrBlock,.Tags[] as $tt | "  .. " + $tt.Key +":"+$tt.Value'


aws ec2 describe-vpcs | jq -e --raw-output '.Vpcs[] | "\n" + .VpcId + "  :  " + .CidrBlock,  .Tags[] as $tt | "  ... " + $tt.Key +":"+ $tt.Value'

aws ec2 describe-subnets | jq -e --raw-output '.Subnets[] | "\n" + .VpcId + "  :  " + .CidrBlock +" : " + .AvailabilityZone,  .Tags[] as $tt | "  ... " + $tt.Key +":"+ $tt.Value'

aws ec2 authorize-security-group-ingress --group-id sg-bfa45bd4 --protocol tcp --port 31672 --cidr 204.101.219.210/31
```

## How many instances of each type do I have, and in what states?

- Considering buying reserved instances or thinking about migrating to a newly introduced class?

```
aws ec2 describe-instances | jq -r "[[.Reservations[].Instances[]|{ state: .State.Name, type: .InstanceType }]|group_by(.state)|.[]|{state: .[0].state, types: [.[].type]|[group_by(.)|.[]|{type: .[0], count: ([.[]]|length)}] }]"
```

## What CIDRs have Ingress Access to which Ports?

```
# This is helpful when you need to perform a survey or audit of your system boundaries. While such a task isn’t ever “easy”, it can go more smoothly with with a summary:

aws ec2 describe-security-groups | jq '[ .SecurityGroups[].IpPermissions[] as $a | { "ports": [($a.FromPort|tostring),($a.ToPort|tostring)]|unique, "cidr": $a.IpRanges[].CidrIp } ] | [group_by(.cidr)[] | { (.[0].cidr): [.[].ports|join("-")]|unique }] | add'

```

## Which Services am I using?

```
aws ce get-cost-and-usage --time-period Start=2019-08-01,End=2019-08-31  --granularity MONTHLY --metrics UsageQuantity --group-by Type=DIMENSION,Key=SERVICE | jq '.ResultsByTime[].Groups[] | select(.Metrics.UsageQuantity.Amount > 0) | .Keys[0]'


# How much they cost
aws ce get-cost-and-usage --time-period Start=2019-08-01,End=2019-08-31  --granularity MONTHLY --metrics USAGE_QUANTITY BLENDED_COST  --group-by Type=DIMENSION,Key=SERVICE | jq '[ .ResultsByTime[].Groups[] | select(.Metrics.BlendedCost.Amount > "0") | { (.Keys[0]): .Metrics.BlendedCost } ] | sort_by(.Amount) | add'

# Instances running

aws ec2 describe-instances | jq -r "[[.Reservations[].Instances[]|{ state: .State.Name, type: .InstanceType }]|group_by(.state)|.[]|{state: .[0].state, types: [.[].type]|[group_by(.)|.[]|{type: .[0], count: ([.[]]|length)}] }]"
```

## CIDR access to ports

```
aws ec2 describe-security-groups | jq '[ .SecurityGroups[].IpPermissions[] as $a | { "ports": [($a.FromPort|tostring),($a.ToPort|tostring)]|unique, "cidr": $a.IpRanges[].CidrIp } ] | [group_by(.cidr)[] | { (.[0].cidr): [.[].ports|join("-")]|unique }] | add'
```

## Lambda runtimes

```
aws lambda list-functions | jq ".Functions | group_by(.Runtime)|[.[]|{ runtime:.[0].Runtime, functions:[.[]|.FunctionName] }
]"
```

## Memory size

```
aws lambda list-functions | jq ".Functions | group_by(.Runtime)|[.[]|{ (.[0].Runtime): [.[]|{ name: .FunctionName, timeout: .Timeout, memory: .MemorySize }] }]"
```

## Lambda Environment variables

```
aws lambda list-functions | jq -r '[.Functions[]|{name: .FunctionName, env: .Environment.Variables}]|.[]|select(.env|length > 0)'

```


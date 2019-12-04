---
title: "Useful tool for Dockerhub"
date: 2018-10-24T11:22:48+08:00
published: true
type: post
categories: ["DevOps", "tools"]
tags: ["docker","commandline"]
author: "Miro Adamy"
---

# Skopeo

I have stumbled upon this tool: [https://github.com/containers/skopeo](https://github.com/containers/skopeo) - command line tools for manipulation with Docker images and Docker image registries.

It can work with OCI images as well as the original Docker v2 images.

## Installation

```
brew install skopeo
```

## Usage

```
➜  deploy-2018-10-24 skopeo --override-os=linux inspect docker://docker.io/fedora
{
    "Name": "docker.io/library/fedora",
    "Digest": "sha256:b41cd083421dd7aa46d619e958b75a026a5d5733f08f14ba6d53943d6106ea6d",
    "RepoTags": [
        "20",
        "21",
        "22",
        "23",
        "24",
        "25",
        "26-modular",
        "26",
        "27",
        "28",
        "29",
        "branched",
        "heisenbug",
        "latest",
        "modular",
        "rawhide"
    ],
    "Created": "2018-09-07T19:20:02.809176076Z",
    "DockerVersion": "17.06.2-ce",
    "Labels": null,
    "Architecture": "amd64",
    "Os": "linux",
    "Layers": [
        "sha256:565884f490d9ec697e519c57d55d09e268542ef2c1340fd63262751fa308f047"
    ]
}
```

It works with protected repos as well - as long as creds are provided

```
skopeo --override-os=linux inspect --creds=''${CREDS}'' docker://docker.io/thinkwrap/dropship-ui:uat | jq ".Digest"

"sha256:43f95207dafa7dbc034e5126a9f6b6952e47e162206e889c1071f6e06308f4f4"
```

The reason for `override-os` is running the client on MacOS. On Linux, this can be removed.

The double single quotes around `${CREDS}` is to make sure that special characters in password such as `;!| ` will not confuse shell.

### Getting information about all Tags

```
skopeo --override-os=linux inspect --creds=''${CREDS}'' docker://docker.io/thinkwrap/dropship-ui:uat | jq ".RepoTags[]"

"0.3.0"
"1.3.0-uat"
"1.3.1-uat"
"1.3.2-uat"
"1.4.0-uat"
"1.4.1-uat"
"1.4.2-uat"
"1.4.3-uat"
"1.4.4-uat"
"1.4.5-uat"
"1.4.6-uat"
"1.5.0-uat"
"1.5.1-uat"
"1.5.2-uat"
"1.5.3-uat"
"1.5.4-uat"
"1.5.5-uat"
"1.5.6-uat"
"development"
"uat"
```


Speaking of Docker container tools, see also: https://github.com/GoogleContainerTools/container-diff


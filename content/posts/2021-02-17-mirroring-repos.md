---
title: "How to mirror Github and Bitbucket repositories"
date: 2021-02-17T13:00:00+08:00
type: post
description: "Using Bitbucket and Github API to mirror repositories"
tldr: ""
categories: [ "DevOps", "Version Control", "HowTo" ] 
tags: ["git", "github", "bitbucket", "python", "API", "shell"]
image: "img/polina-kuzovkova-L452YQvckJQ-unsplash.jpg"
thumbnail: "img/polina-kuzovkova-L452YQvckJQ-unsplash.tn-500x500.jpg"
author: "Miro Adamy"
---

# Mirroring large number of GitHub or Bitbucket repositories

**Use case**: 

I want to create local clone of a large number of repositories from an organization in GitHub / Bitbucket. 


## Assumptions

* user has SSH key registered with the GH / BB - can clone using ssh protocol
* user has successfully cloned at least one repo from command line before (the /etc/hosts contains host entries for BB and GH)
* user has modern version of Python 3 installed (3.6 or better)
* user has local installation of a reasonably modern Git 

## Steps

First I use the `./bb-repo-links.sh` and `./gh-repo-links.sh` to generate list of repositories.
See these blog articles: [How to list repositories in Bitbucket]({{< relref "2021-02-15-bitbucket-list-repos.md" >}}) and [How to list repositories in github]({{< relref "2021-02-16-github-list-repos.md" >}})

These are text files and have the structure like this:

```txt
EXFO|git@bitbucket.org:thinkwrap/exfo-tw-docker-jenkins.git
FARO|git@bitbucket.org:thinkwrap/faro-infrastructure.git
H3|git@bitbucket.org:thinkwrap/headless-api-gateway.git
H3|git@bitbucket.org:thinkwrap/headless-cart-service.git
H3|git@bitbucket.org:thinkwrap/headless-catalog-service.git
H3|git@bitbucket.org:thinkwrap/headless-connector-atg.git
H3|git@bitbucket.org:thinkwrap/headless-connector-contentful.git
```

The first field is the project prefix, and the second is the SSH url for cloning the repository.  They are separated by the | character.

Cloning is trivial:

```sh
python3 ./process_repos.py NAME-OF-THE-CONTROL-FILE ....

```

e.g.

```sh
python3 ./process_repos.py pivotree_h3.bb-repo2 pvtrlabs.gh-repo 
```

The Python script uses `../MIRROR` as the starting point for the mirrored tree. 

This can be changed by exporting the variable `MIRROR_ROOT`

```sh 
export MIRROR_ROOT = '../MIRROR2'
```

The generated structure looks like this:

`PLAFORM > ACCOUNT > PROJECT > REPO`

where:

* PLATFORM is `bitbucket.org` or `github.com`
* Account is organization name within the platform
* PROJECT is project name for Bitbucket, defaults to 'src' for GitHub
* REPO is the repository name


NOTE: the names of some projects are < edited >.

```txt 
.
├── bitbucket.org
│   ├── pivotree_h3
│   │   ├── BrownBagExamples
│   │   │   └── apigateway
│   │   ├── DATA
│   │   │   └── sample-data-aws
│   │   ├── DIVE
│   │   │   ├── customer-mgmt-api
│   │   │   ├── data-science-practice
...
│   │   │   ├── pvt-admin-mgmt-api
│   │   │   └── sagemaker-microservices
│   │   ├── DIVE20
│   │   │   ├── dive-data-manager
...
│   │   │   └── tr-sgm-duplicates-svc
│   │   ├── DIVECX
│   │   │   ├── dive-cx-account
│   │   │   ├── dive-cx-account-fork
...
│   │   │   └── pvt-ssm-manager
│   │   └── starter
│   │       ├── pvt-node-module-starter
│   │       ├── pvt-node-starter
│   │       ├── pvt-pipeline-example
│   │       └── pvt-sls-starter
│   └── thinkwrap
│       ├── <PRJ>-CLOUD
│       │   └── <prj>-cloud
│       ├── Admin
│       │   └── tw-bitbucket-admin
│       ├── <PROJECT_1>
│       │   ├── <prj1>-infra
│       │   └── <prj1>-robot
│       ├── BOPIS
│       │   ├── bopis_automation_platform
│       │   └── pvt-bopis
│       ├── <PRJ2>
│       │   └── <prj2>-vtex-poc
│       ├── <PRJ3>
...
│       │   └── <prj4>-testautomation
│       ├── ZZZ-Archived-Repos
│       │   └── oneclick-starter
│       └── microbase
│           ├── micro-alexa-search
│           ├── micro-alexa-search-skill
│           ├── micro-backoffice
│           ├── micro-cart-service
│           ├── micro-catalog-service
│           ├── micro-customer-service
│           ├── micro-docker-nginx
│           ├── micro-docker-service
│           ├── micro-oauth-service
│           ├── micro-payment-service
│           ├── micro-promotion-service
│           ├── micro-recommendation-service
│           ├── micro-stock-service
│           ├── micro-tax-service
│           ├── microbase
│           └── www.microbase.io
└── github.com
    ├── pivotree-tech-blog
    │   └── src
    │       ├── hugo101
    │       ├── pivotree-tech-blog-source-poc
    │       ├── pivotree-tech-blog.github.io
    │       └── story
    ├── pvtrlabs
    │   └── src
    │       ├── action-skip-ci
    │       ├── at-aws-onelogin-multiapp
    │       ├── at-cloudhealth
    │       ├── at-opsgenie-integrations
....    
    │       ├── terraform-tfe-workspace
    │       ├── terraform-tfe-workspace-full
    │       ├── test-limited-tfc-access
    │       └── test-repo
    └── thinkwrap
        └── src
            ├── ML-Live-Beginner
            ├── ML-Live-Intermediate
            ├── Tiny-Python-3.6-Notebook
            ├── aaac-starter-template
            ├── aws-cost-and-usage-report
            ├── aws-ml-guide
            ├── blast-radius
            ├── docker-aws-cli
            ├── docker-kubernetes-cli
            ├── docker-kubernetes-cli-helm
            ├── docker-node-base-pipelines
            ├── docker-node-sls-pipelines
            ├── docker-node-sls-pipelines-aws
            ├── docker-python-base-pipelines
            ├── docker-sls-cli
            ├── docker-terraform-cli
            ├── docker-terraform-cli-helm
            ├── ecs-deep-dive-2018
            ├── kubernetes-in-action
            ├── programming-with-data
            ├── sgviz
            ├── ssm-parameter-store
            ├── terraform-ecs-fargate
            └── universal-recommender

549 directories, 0 files

```

## Updating

If the Python script encounters an existing repository, it tries to do an update by fetching the remote updates. It does NOT merge.

**NOTE**

This was also published on [our cloud team blog](https://blog.pivotree.cloud/2021-02-17-mirroring-repos/)

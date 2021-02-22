---
title: "How to monitor Bitbucket user and group permissions with API"
date: 2021-02-18T13:00:00+08:00
published: true
type: post
description: "Using command line tool to access Bitbucket API - 3"
tldr: ""
categories: ["DevOps", "Version Control", "HowTo"]
tags: ["git", "bitbucket", "API", "python", shell"]
image: "img/tomas-malik-TCJM2dF7FLM-unsplash.jpg"
thumbnail: "img/tomas-malik-TCJM2dF7FLM-unsplash.tn-500x500.jpg"
author: "Miro Adamy"
---

# How to manage users and groups in Bitbucket

**Use case**: 

I want to maintain users and groups and their access to repositories in an organization in Bitbucket. 
To make sure I do not miss newly changed admin access, I want to use the Bitbucket API to retrieve the list of permissions on repository basis and on user/group bases.

## Setup

Bitbucket requires a username and password to access the API. This information is stored in environment variables 
`BBUSER` and `BBPASSWORD`.  `BBPASSWORD` should be an access token / app password defined in the `App passwords` section
of the user settings:

![app password UI](/img/bbgh/app-password.png)

The variable `BB` represents the Bitbucket API URL

```sh
export BBUSER=<your-user-name>
export BBPASSWORD=<your-user-token>
export BB='https://api.bitbucket.org/2.0'
```

I am using a personal shortcut by creating the file `~/.ssh/bitbucket-token-work.secret` with the contents described above and importing them, unless the variables are already defined:

```sh
if [ -z "$BBUSER" ] || [ -z "$BBPASSWORD" ] ; then
  echo Using locally defined credentials from ~/.ssh/bitbucket-token-work.secret 
. ~/.ssh/bitbucket-token-work.secret
fi

```

## Get list of users

```sh
ENTRIES=$(curl -s --user $BBUSER:$BBPASSWORD ${BB}/teams/${org}/members  | jq .size)
PAGELEN=$(curl -s --user $BBUSER:$BBPASSWORD ${BB}/teams/${org}/members  | jq .pagelen)
PAGES=$(expr $ENTRIES / $PAGELEN "+" 1)


for i in $(seq 1 $PAGES)
    do 
    curl -s --user $BBUSER:$BBPASSWORD ${BB}/teams/${org}/members\?page\=${i}\&pagelen\=${PAGELEN}  | jq ".values[] | {nickname, account_id, "repos": .links.repositories.href}" > ${org}-USERS-${i}.json
done    
---
{
  "nickname": "Dxxxx Sxxxx Oxxx",
  "account_id": "557058:e8xxxxxxdf",
  "repos": "https://api.bitbucket.org/2.0/repositories/%7B13xxxxxef4%7D"
}
{
  "nickname": "Dxxx Axxx",
  "account_id": "55xxxxc0",
  "repos": "https://api.bitbucket.org/2.0/repositories/%7Ba76xxxxc9%7D"
}
...
```

Alternative format is to get all 3 fields on the same line:

```sh
curl -s --user $BBUSER:$BBPASSWORD https://api.bitbucket.org/2.0/workspaces/thinkwrap/permissions/repositories | jq '.values[] | .repository.name + "|" + .user.display_name + "|" + .permission'
---
"smw-hybris|Rxxx Oxxx Rxxx|read"
"smw-hybris|Source Bridge|admin"
"smw-hybris|Jxxxx Fxxxx|admin"
"smw-hybris|Yxxxx Lxxx|write"
"smw-hybris|buildmastertw|read"
....
```


## Get list of users group

For accessing group we need to use the legacy 1.0 API. The API is down since 2019 but the group related endpoints are still supported, because Atlassian did not deliver the proper 2.0 of that endpoint implementation yet.

This is the output text format for every group in ${org}

```sh
"BrownBagExamples|read|Yxxx Lxxx"
"QA-Heroes||Dxxx Bxxx Mxxx"
"sg-bitbucket-automation||sa-bitbucket"
"Platform Engineers||Dxxxx Axxx;Mxxx Mxxx"
"readonly|read|Source Bridge;Cxxxx Macxxxx;Read Only Source Access H3"
"Developers|write|Jxxxx J. Cxxxx;Pxxxx Yxxxx;Dxxxx Dxxxx;Brendan Sxxx;Brant Mxxx;Dave Axxx;David Bxxx Mxxx;"
....
```

There are three fields separated by '|' - group name, default access to new repositories (should be empty for non-admin and non-service accounts), and the list of member user names (separated by a ';').

Here is the code that produces that output:

```sh
if [ -z "$BBUSER" ] || [ -z "$BBPASSWORD" ] ; then
  echo Using locally defined credentials from ~/.ssh/bitbucket-token-work.secret 
. ~/.ssh/bitbucket-token-work.secret
fi

for org in $(./bb-teams.sh ); do
    curl -s --user $BBUSER:$BBPASSWORD https://api.bitbucket.org/1.0/groups/${org}/ | jq '.[] | .name + "|" + .permission + "|" + ([.members[].display_name] | join(";")) ' \
        | tee ${org}-group-access.txt
done
```

## Getting matrix of access rights per repository and user

User groups are the preferred way of managing permissions. At the repository level, the effective rights is a combination of the access assigned through
user groups and the access rights assigned directly to users - see the example

![user and group access](/img/bbgh/user-group-1.png)

We will produce a matrix of the information in 2 steps: at first, we will generate a linear
list of triplets in the form REPO-NAME|USER-NAME|access

```txt
"smw-hybris|Rxxx Oxxx Rxxx|read"
"smw-hybris|Source Bridge|admin"
"smw-hybris|Jxxxx Fxxxx|admin""
```
The API call that generates this list is

```sh
   curl -s --user $BBUSER:$BBPASSWORD "${BB}/workspaces/${org}/permissions/repositories?pagelen=${PAGELEN}&page=${i}" | jq '.values[] | .repository.name + "|" + .user.display_name + "|" + .permission' | tee ${org}-repo-users-${i}.txt
```

The script running the call for every repository in the workspace is `bb-repo-user.sh`

It expects single argument - a workspace name (e.g. `pivotree_h3`) and generates file named
`WORKSPACE-repo.permissions` (e.g. `pivotree_h3-repo.permissions`) with the structure above - sorted.

It can run long time a generates large number of temporary files.

It also generates output during run to see how far it proceeded.

```sh
./bb-repo-user.sh pivotree_h3

Logged on as user
{
  "account_id": "55xxxxxxda",
  "uuid": "{d8xxxxxx08}",
  "username": "miro-adamy-PVT",
  "display_name": "Miro Adamy",
  "snippets": "https://api.bitbucket.org/2.0/snippets/%7Bd8dxxxxxxx08%7D",
  "self": "https://api.bitbucket.org/2.0/users/%7Bd8xxxxxxxxx08%7D"
}
ENTRIES=2556, PAGELEN=100, PAGES=26
1 ... curl -s --user ...:... https://api.bitbucket.org/2.0/workspaces/pivotree_h3/permissions/repositories?pagelen=100&page=1
"dive-data-manager|Source Bridge|read"
"dive-data-manager|Pxxxxx Lxxxxg|admin"
"dive-data-manager|Dxxxx Dxxxx|admin"
...
2 ... curl -s --user ...:... https://api.bitbucket.org/2.0/workspaces/pivotree_h3/permissions/repositories?pagelen=100&page=2
"pvt-sgm-size-norm-prog|Source Bridge|read"
"pvt-sgm-size-norm-prog|Yxxxxx Lxxxxx|read"
...
```

The second step is to generate JSON files proving different views of this data. The pythin script expects as input one or more files in the format of
`WORKSPACE-repo.permissions` 

```bash
python3 generate_repo_stats.py pivotree_h3-repo.permissions
Processed 2556 lines
```

The script creates 4 files:

### REPO_BY_ACCESS.json

```json

{
  "ApiGateway": {
    "admin": [
      "Bxxxx Mxxxxx",
      "Bxxxx Sxxxxx",
    ],
    "read": [
      "User Name2",
      "User Name3",
    ],
    "write": [
      "User Name4",
      "User Name5",
    ]
  },
  "JIRA-voting": {
    "admin": [
      "User Name6",
      "User Name7",

    ],
    "read": [
      "User Name8",
      "User Name9",
    ],
    "write": [
      "User Name1",
      "User Name2",
    ]
  }
}
```

### REPO_BY_USER.json

```json
{
  "ApiGateway": {
    "User Name1": "admin",
    "User Name2": "read",
    "Read Only Source Access H3": "read",
    "Source Bridge": "read",
    "User Name3": "write"
  },
  "JIRA-voting": {
    "User Name1": "admin",
    "User Name3": "admin",
    "Read Only Source Access H3": "read",
    "Source Bridge": "read",
    "User Name5": "read"
  }
}

```

### USER_BY_ACCESS.json
```json
{
  "User Name1": {
    "admin": [
      "repo-1",
      "repo-2"
    ],
    "write": [
      "dive-testing-service"
    ]
  },
  "User Name2": {
    "read": [
      "pvt-sls-starter"
    ]
  }
}

```

### USER_BY_REPO.json

```json
{
  "User Name1": {
    "repo-1": "admin",
    "repo-2": "read"
  },
  "User Name2": {
    "pvt-sls-starter": "read"
  }
}
}
```

These can be easily processed using JQ to retrieve any type of information, and together with permission file it can be used to quickly find out answers to administration related questions

## Examples

What repos does Juan have admin ccess to ?

```shell
cat *.permissions | grep admin | grep 'Juan' | sed 's/"//g' | cut -d'|' -f1
dive-cx-account
dive-cx-js-sdk
dive-cx-ui
....
```

Who can access repo ApiGateway

```shell
 cat *.permissions | sed 's/"//g' | grep ApiGateway  | cut -d'|' -f2,3
User Name1|admin
User Name2|read
Miro Adamy|admin
Read Only Source Access H3|read
Source Bridge|read
....
```

**NOTE**

This was also published on [our cloud team blog](https://blog.pivotree.cloud/2021-02-18-bitbucket-user-groups/)
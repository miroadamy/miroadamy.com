---
title: "Accessing Terraform cloud Module registry programatically"
date: 2020-05-14T21:22:48+08:00
published: true
type: post
categories: ["DevOps"]
tags: ["iaac","terraform", "cli"]
author: "Miro Adamy"
---

First step is to get your personal token. Log on to Terraform Cloud, go to [https://app.terraform.io/app/settings/tokens](https://app.terraform.io/app/settings/tokens) and generate new token.

Note: it is important to save the token to safe place - this is only time you will see it.

![token](/images/terraform-token.png)

Export the token:

```bash
export TFE_TOKEN=<THE-TOKEN-VALUE>
```

The documentation for Terraform API is [here](https://www.terraform.io/docs/cloud/api/index.html)

It is OK documentation but not the greatest one, however. There are two versions of the API - v1 and v2 and this is not clearly described. It could also used better examples.

Here is some useful information one can do with the freshly acquired token:

```bash

# Get the account info
curl -s --header "Authorization: Bearer $TFE_TOKEN" --request GET  https://app.terraform.io/api/v2/account/details | jq .

{
  "data": {
    "id": "user-<DELETED>7",
    "type": "users",
    "attributes": {
      "username": "<DELETED>",
      "is-service-account": false,
      "avatar-url": "https://www.gravatar.com/avatar/db6b71<DELETED>?s=100&d=mm",
      "password": null,
      "enterprise-support": true,
      "is-site-admin": false,
      "is-sso-login": false,
      "two-factor": {
        "enabled": true,
        "verified": true
      },
      "email": "<DELETED>",
      "unconfirmed-email": null,
      "has-git-hub-app-token": false,
      "is-confirmed": true,
      "onboarding-status": null,
      "permissions": {
        <DELETED>
      }
    },
    "relationships": {
      "authentication-tokens": {
        "links": {
          "related": "/api/v2/users/user-<DELETED>/authentication-tokens"
        }
      }
    },
    "links": {
      "self": "/api/v2/users/user-<DELETED>"
    }
  }
}


export MY_ORG=<YOUR-ORG-IN-TERRAFORM-CLOUD-NAME>

# Get the teams for the organization
curl -s --header "Authorization: Bearer $TFE_TOKEN" --request GET  https://app.terraform.io/api/v2/organizations/$MY_ORG/teams | jq .

curl -s --header "Authorization: Bearer $TFE_TOKEN" --request GET  https://app.terraform.io/api/v2/organizations/$MY_ORG/workspaces | jq .

```

In order to list modules (my original intent), one must use V1 of the API:

```bash
curl -s --header "Authorization: Bearer $TFE_TOKEN" --request GET  https://app.terraform.io/api/registry/v1/modules | jq .
{
  "meta": {
    "limit": 15,
    "current_offset": 0,
    "next_offset": 15,
    "next_url": "//@/v1/modules?namespace=<DELETED>"
  },
  "modules": [
    {
      "id": "<DELETED/iam-role/aws/0.5.1",
      "owner": "",
      "namespace": "<DELETED>",
      "name": "iam-role",
      "version": "0.5.1",
      "provider": "aws",
      "description": "Terraform Module - AWS IAM Role",
      "source": "https://github.com/<DELETED>",
      "tag": "",
      "published_at": "2020-04-18T13:53:47.261884Z",
      "downloads": 1345,
      "verified": false
    },
    <DELETED>
  ]
}
```

In order to retrieve more than 15 , use the `limit` URL parameter:

```
curl -s --header "Authorization: Bearer $TFE_TOKEN" --request GET  https://app.terraform.io/api/registry/v1/modules\?limit\=100  
```

Here is example that lists only the names of the modules in the repository.

```
curl -s --header "Authorization: Bearer $TFE_TOKEN" --request GET  https://app.terraform.io/api/registry/v1/modules\?limit\=100  | jq '.modules[].id' | sort 
```
---
title: "Storing sensitive information in Git"
date: 2017-05-17T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

The purpose of this is to evaluate options and suggest possible approaches for handling the sensitive information in Git repositories such as database credentials, API credentials, passwords, keys, certificates etc. Joel asked this question a few weeks ago - this is part of Milos's security awareness program.

## The issue

Git repos store in cleartext all credentials, that may also be including PROD credentials.

Everybody who clones the repository - every developer has access to this information that should have been shared only with the support team that has legitimate access to production.

This is especially sensitive when project includes external parties that are collaborating on the project (partner development companies or subcontractors).

## Previous attempts to solve this

We have tried to address this in two ways with mixed success, using these approaches:

### Extracting the information from source code

The issue with this was necessity of manual steps on deployment, increased risk of human errors and more costly / fragile deployment process. Not only was this against the direction we wanted to go (DevOps and automation - towards continuous integration), it also removed version tracking and history from those critically important artifact

### Using two repositories

In a nutshell, in addition to "full" repo with all files (including secret files), there was a copy of the repository (dev-repo), containing a subset of the commits that had those sensitive files removed from history and from current worktree. 

Because of the way how Git internally works (the history is a tree of commits which are immutable), the dev-repo must always be a subset of full repo - all commits in dev-repo must eventually exist in full repo, but not the other way around.

The idea was that only the team lead / senior internal dev team would use the full repo, while everybody else would have access only to dev-repo.

*The main difficulties of this were*

* this approach required a complex and fragile manual merge from two upstream repos
* Git does not really support the concept of keeping two remotes non-synchronized
* human error in pushing could cause leaking of sensitive info to dev-repo
* the sync-merge was manual and time intensive
* the sync-merge had to be repeated before each release
* it was initially very labour intensive / costly to set-up two repositories so that the above process worked OK
* it did not 100% solve the problem as part of the DEV team still had full access to all credentials

# Research

I spent some time googling what others facing same challenge do.

Some of the relevant links:

* <http://www.twinbit.it/en/blog/storing-sensitive-data-git-repository-using-git-crypt>
* <http://blog.arvidandersson.se/2013/06/10/credentials-in-git-repos>
* <https://help.github.com/articles/removing-sensitive-data-from-a-repository/>
* John Resig of Javascript fame - <http://ejohn.org/blog/keeping-passwords-in-source-control/>
* <https://developer.rackspace.com/blog/protecting-sensitive-information-from-appearing-in-public-repos/>
* <https://www.agwa.name/projects/git-crypt/>
* <https://github.com/moby/moby/issues/13490> - this is about Docker but still relevant


## There are two main approaches to the issue:

### Exclude the secret information and deliver using different channel

Basically, our attempt #1. The methods used either special property file or environment variables.

#### The issues with this approach

* it requires changes in the source code as the values need to be retrieved from the other channel (e.g. read from file or accessed from ENV)
* it does not address maintaining the history / changes of the sensitive information. The file needs to be delivered /managed somehow or the .bash_profile needs to be managed
* the code retrieving the secret info may have issues / does not work well in heterogenous environment (developers using Windows, Macs, PROD using Linux)

### Encryption

This approach encrypts some of the files and decrypts them only in target environments.

#### Requirements for this to work OK are

* small number of files encrypted
* the secret files for different environment must be separated by path - e.g. connection credentials for DEV or QA or UAT must be available without decrypting the PROD specific file
* it must work with our build systems (ant/Jenkins based)

#### Challenges with this approach

* we need to make sure that the PROD credentials get decrypted before or during the deployment process. This can be performed either on the build server (assuming that they are properly secured) or in the PROD environment
* encryption / decryption key management

# Suggested approach

I suggest looking into two possible directions

## Reusing existing solution POC

Judging by the research, the promising approach seems to be open source project https://www.agwa.name/projects/git-crypt/

We need to do a proof of concept that will answer the following questions:

* does it work as described?
* is there any performance impact with repos ~ 1GB size?
* are there any issues with Bitbucket?
* what is the experience of the developer without key / without git-crypt when cloning the repo with protected files?
* can we easily extend the build workflow to add decryption?
* is there any issue with performing decryption from the PROD server (sysutil)?
* what is the key management logistic / process?

## POC of two independent repos with layered approach

This is a combination of removing the files (replacing with dummy credentials for PROD) and utilizing second - secret repository for protected resources.

### The key features of the solution

We do use two independent repositories.

The main repo contains placeholders for the protected files and is available to developers. The second repo contains only protected files, unencrypted, in pathnames corresponding to file locations in the first repo. This secret repo is available only to support or secured build server.

The build on non-PROD environment will work as before - connectivity to PROD would be prevented by false / fake credentials

The build in PROD would use the main repo, clone the secret repo in the different place and superimpose / overwrite files

The idea is very similar to the layered file system Docker uses - implemented by physical copy.

The script that will perform the overwrite will be part of the secret repo and will expect parameter - path to the root of the main repository

### Why this is better than what we tried before:

* there is no complex and fragile manual merge-sync required
* no danger of cross-copying commits - both repos are maintained separately
* no key management overhead

## Next steps

* review / feedback
* POC for git-crypt 
* POC for layered repos 
* decision
* implementation


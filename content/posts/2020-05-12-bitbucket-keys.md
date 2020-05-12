
---
title: "Using SSH keys with multiple Bitbucket accounts"
date: 2020-05-12T22:34:38+08:00
published: true
type: post
categories: ["devops"]
tags: ["bitbucket","git", "ssh"]
author: "Miro Adamy"
---

I have been using Bitbucket since 2012, long before my company moved from in-house hosted server running Gitolite and in-house instances of FishEye and Crucible to cloud based source control on Bitbucket Cloud. As legacy I was using my personal login with my gmail account as my Bitbucket identity.

With merge of 3 companies in 2018 and rebranding as Pivotree, we are in process of streamlining the identity management and using SSO for identification. Time has come to split my personal identity and work identity.

I have created second Bitbucket account with work email and added '-pvt' to my login to keep them separate, removed the old myself from work worspaces and added the new myself instead. So far so good. The problems started when I wanted to keep using git based urls and needed new keypair. One cannot register same public key with two different Bitbucket accounts, so I needed new key:

```bash
ssh-keygen -f ~/.ssh/bitbucket-pivotree
```

but cloning did not work (for repository visible in Web UI):

```bash
git clone -v git@bitbucket.org:thinkwrap/tw-bitbucket-admin.git
Cloning into 'tw-bitbucket-admin'...
Forbidden
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

An attempt to add key to ssh daemon `ssh-add  ~/.ssh/bitbucket-pivotree` did not solve the problem either.

## Solution

I had to define explicitly two different URLs for bitbucket in `~/.ssh/config` file:

```bash
Host work.bitbucket.org
  HostName bitbucket.org
  User git
  IdentityFile ~/.ssh/bitbucket-pivotree

Host bitbucket.org
  HostName bitbucket.org
  User git
  IdentityFile ~/.ssh/id_rsa
```

Now for cloning work repositories, I can use the 

```bash
git clone -v git@work.itbucket.org:thinkwrap/tw-bitbucket-admin.git
```

and the work key will be automatically used.

For existing - already cloned repos, here is simple way how to reset the remote URL:

```bash
git remote set-url origin $(git remote -v | grep fetch | awk '{print $2;}' | sed 's/git@bit/git@work.bit/')
```



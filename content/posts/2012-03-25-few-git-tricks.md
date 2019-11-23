---
title: "Few gitbits to remember"
date: 2012-03-25T15:43:48+08:00
lastmod: 2012-03-25T15:43:48+08:00
published: true
categories: ["Programming"]
tags: ["git"]
author: "Miro Adamy"
---

# Few gitbits to remember

## Pushing new local branch to remote repo:

Find a ref that matches experimental in the source repository (most likely, it would findrefs/heads/experimental), and update the same ref (e.g. refs/heads/experimental) in origin repository with it.

If experimental did not exist remotely, it would be created.

`git push origin experimental`
 
This is the same as:
 
`git push origin experimental:refs/heads/experimental`

Create the branch experimental in the origin repository by copying the current experimental branch.

This form is only needed to create a new branch or tag in the remote repository when the local name and the remote name are different; otherwise, the ref name on its own will work.

## Remove all Idea files

```
git rm --cached `find . -name "*.iml"`
```
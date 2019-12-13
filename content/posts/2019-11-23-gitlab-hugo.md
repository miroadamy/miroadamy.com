---
title: "Building Hugo as well on GitLab pages"
date: 2019-11-23T22:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["git", "blog", "hugo", "github", "gitlab"]
author: "Miro Adamy"
---

# Parallel building challenges

Unlike Github, Gitlab considers Hugo blogs first class citizens and does not impose any restrictions on repo naming.

I had 3 challenges to overcome related to co-existence of GH and GL versions:

1. I need to use same repo for both GH and GL
2. the submodule link for `public` does not work on GL
3. the site root is different - I have no custom domain forward for GitLab

## Using same repo

To separate the GH and GL, I have added 2 remotes to repo and special branch `gitlab-pages`.

So the local repo looks like this:

```
➜  miroadamy.com git:(master) ✗ git remote -v -v
github  git@github.com:miroadamy/miroadamy.com.git (fetch)
github  git@github.com:miroadamy/miroadamy.com.git (push)
origin  git@gitlab.com:miro.adamy/miroadamy.com.git (fetch)
origin  git@gitlab.com:miro.adamy/miroadamy.com.git (push)
```

The branch `gitlab-pages` is "superset" of master. This means that I am always merging `master => gitlab-pages` but never the other way around.

The consequence is that GL version can have more posts than GH and as GL version is private, it is OK.

## Publishing process and `public`

GL allows simple pipeline that generates the site into `public` folder. The submodule does not need to exist.
Actually, it cannot exists, as it would be breaking the build.

Here is the file `.gitlab-ci.yml`

```

image: monachus/hugo

variables:
  GIT_SUBMODULE_STRATEGY: recursive

pages:
  script:
  - mkdir -p public
  - hugo --baseURL https://miro.adamy.gitlab.io/miroadamy.com/
  artifacts:
    paths:
    - public
  only:
  - gitlab-pages
```

The pipeline runs ONLY for gitlab-pages branch and resulting pages can be seen at <https://miro.adamy.gitlab.io/miroadamy.com/> (this is currently private).

## Removing the submodules

I used this as opportunity to clean the unused themes from the blog:


```
# Step 1 - deinit repos

➜  miroadamy.com git:(gitlab-pages) ✗ git submodule deinit themes/ananke
Cleared directory 'themes/ananke'
Submodule 'themes/ananke' (https://github.com/budparr/gohugo-theme-ananke.git) unregistered for path 'themes/ananke'
➜  miroadamy.com git:(gitlab-pages) ✗ git submodule deinit themes/hugo-coder
Cleared directory 'themes/hugo-coder'
Submodule 'themes/hugo-coder' (https://github.com/luizdepra/hugo-coder.git) unregistered for path 'themes/hugo-coder'
➜  miroadamy.com git:(gitlab-pages) ✗ git submodule deinit public
Cleared directory 'public'
Submodule 'public' (git@github.com:miroadamy/miroadamy.github.io.git) unregistered for path 'public'

# Step 2 - delete the files

➜  miroadamy.com git:(gitlab-pages) ✗ rm -rf themes/ananke
➜  miroadamy.com git:(gitlab-pages) ✗ rm -rf themes/hugo-coder
➜  miroadamy.com git:(gitlab-pages) rm -rf public

# Step 3 - delete the parts of `.gitmodules`

From THIS

➜  miroadamy.com git:(gitlab-pages) ✗ cat .gitmodules
[submodule "themes/ananke"]
    path = themes/ananke
    url = https://github.com/budparr/gohugo-theme-ananke.git
[submodule "themes/hugo-coder"]
    path = themes/hugo-coder
    url = https://github.com/luizdepra/hugo-coder.git
[submodule "themes/even"]
    path = themes/even
    url = https://github.com/olOwOlo/hugo-theme-even
[submodule "public"]
    path = public
    url = git@github.com:miroadamy/miroadamy.github.io.git

To THIS

➜  miroadamy.com git:(master) ✗ cat .gitmodules
[submodule "themes/even"]
    path = themes/even
    url = https://github.com/olOwOlo/hugo-theme-even

# Step 4 

git add -u
git commit 
git push

```

# Result

* publishing to GH works as before => run './publish.sh'
* publishing to GL happens on any push to branch 'gitlab-pages'
* getting changes from GH to GL:

```
# Sync up master on both
git checkout master
git pull github
git push origin master

# Get the gitlab-pages
git checkout gitlab-pages
git pull origin
git merge master
git push origin gitlab-pages
# optionally, may want to push to GH as well
git push github gitlab-pages

```
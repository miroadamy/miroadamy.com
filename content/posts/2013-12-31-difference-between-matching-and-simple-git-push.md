---
layout: post
title: Difference between matching and simple Git push
date: 2013-12-31 16:41:38.000000000 -05:00
type: post
published: true
comments: true
status: publish
category: devops
tags:
- git
author: "Miro Adamy"

---

I started to see this message in some of my Git environments

```
Git 2.0 from 'matching' to 'simple'. To squelch this message
and maintain the current behavior after the default changes, use:
 
git config --global push.default matching
 
 
To squelch this message and adopt the new behavior now, use:
 
 
git config --global push.default simple
 
```

This is collection of information gathered from Stackoverflow, Git docs and various internet sources.
Putting it together so that I do not have to google it again.

### Options for push.default

* nothing - do not push anything.
* matching - push all matching branches. All branches having the same name in both ends are considered to be matching. This is the default.
* upstream - push the current branch to its upstream branch.
* tracking - deprecated synonym for upstream.
* current - push the current branch to a branch of the same name.

### From SOF
See http://stackoverflow.com/questions/11872984/what-is-the-difference-between-git-push-default-current-and-push-default-upstrea

* upstream pushes to the configured upstream branch, 
* current assumes the upstream branch has the same name, and pushes to that specific name.

In reality, there's no reason to assume a local branch's upstream tracking branch has the same name as the local branch itself.

For example, if you work in multiple repositories or across many shared developer remotes, you often end up tracking different forks of the same branch, such as allen-master or susan-master, both of which track the master branch in Allen and Susan's repos, respectively. In this case, current would be the incorrect setting, because those branch names don't exist on their remotes. upstream, however, would work just fine.

A more practical example might be tracking both a development and production repository. Your workflow might use a different mainline branch for each, but that might get confusing. Suppose you were a code integrator and wanted to track both repositories' master branches separately.

```
git checkout -b production --track production/master
git checkout -b development --track development/master
```

Now you've got two branches that track their respective repositories, neither of which use the masternaming convention at all. There's little confusion about the branch names: They explicitly describe what they track. Nevertheless, push.default = current wouldn't make any sense as neither remote contains a development or production branch.

### simple as push.default

Value of ```push.default``` defines the action git push should take if no refspec is explicitly given. 

Different values are well-suited for specific workflows. In a purely central workflow (i.e. the fetch source is equal to the push destination), upstream is probably what you want. 

Possible values are:

#### nothing 
do not push anything (error out) unless a refspec is explicitly given. This is primarily meant for people who want to avoid mistakes by always being explicit.

#### current 
push the current branch to update a branch with the same name on the receiving end. Works in both central and non-central workflows.

#### upstream 
push the current branch back to the branch whose changes are usually integrated into the current branch (which is called @{upstream}). This mode only makes sense if you are pushing to the same repository you would normally pull from (i.e. central workflow).

#### simple
in centralized workflow, work like upstream with an added safety to refuse to push if the upstream branch's name is different from the local one. When pushing to a remote that is different from the remote you normally pull from, work as current. This is the safest option and is suited for beginners. This mode will become the default in Git 2.0.

#### matching 
push all branches having the same name on both ends. This makes the repository you are pushing to remember the set of branches that will be pushed out (e.g. if you always push maint and master there and no other branches, the repository you push to will have these two branches, and your local maint and master will be pushed there).

To use this mode effectively, you have to make sure all the branches you would push out are ready to be pushed out before running git push, as the whole point of this mode is to allow you to push all of the branches in one go. If you usually finish work on only one branch and push out the result, while other branches are unfinished, this mode is not for you. Also this mode is not suitable for pushing into a shared central repository, as other people may add new branches there, or update the tip of existing branches outside your control.

This is currently the default, but Git 2.0 will change the default to simple.

## Note to self 
Changed the default to simple.

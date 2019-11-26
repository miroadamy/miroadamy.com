---
title: "Managing code in remote SVN repo"
date: 2017-05-10T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

This is based on J.'s' question in Slack:

> Do we have some customer where we are moving a git repo to svn in an automated fashion
> I just need to move the git repo into svn periodically nightly

The setup (as I understand it):

* on client side we have a worktree that is Git repository
* the files needs to be copied to SVN regularly

## Options


### Use git-svn bridge

Git client allows to "pretend" it is SVN and pull/push against remote SVN repo

The documenation for this is here: https://git-scm.com/docs/git-svn

This would be the simplest option if it works and can be automated.

#### Caveats

* it depends on the upstream SVN server version and structure of the repository whether it works - I have seen issues with older SVN software, needs to be tested
* dcommit uses rebase internally which leads to changing SHA1 of the commits - not recommended if repository is part of the normal Gitflow git based development
* this works reasonably well for simple structures on SVN side (no or few branches) and not frequent merges on Git side (using rebase to linearize histories)

#### Example

Tracking and contributing to the trunk of a Subversion-managed project (ignoring tags and branches):

```
# Clone a repo (like git clone):
    git svn clone http://svn.example.com/project/trunk
# Enter the newly cloned directory:
    cd trunk
# You should be on master branch, double-check with 'git branch'
    git branch
# Do some work and commit locally to Git:
    git commit ...
# Something is committed to SVN, rebase your local changes against the
# latest changes in SVN:
    git svn rebase
# Now commit your changes (that were committed previously using Git) to SVN,
# as well as automatically updating your working HEAD:
    git svn dcommit
# Append svn:ignore settings to the default Git exclude file:
    git svn show-ignore >> .git/info/exclude
```

Tracking and contributing to an entire Subversion-managed project (complete with a trunk, tags and branches):

```
# Clone a repo with standard SVN directory layout (like git clone):
    git svn clone http://svn.example.com/project --stdlayout --prefix svn/
# Or, if the repo uses a non-standard directory layout:
    git svn clone http://svn.example.com/project -T tr -b branch -t tag --prefix svn/
# View all branches and tags you have cloned:
    git branch -r
# Create a new branch in SVN
    git svn branch waldo
# Reset your master to trunk (or any other branch, replacing 'trunk'
# with the appropriate name):
    git reset --hard svn/trunk
# You may only dcommit to one branch/tag/trunk at a time.  The usage
# of dcommit/rebase/show-ignore should be the same as above.
```

### Using two independent clients

Basically, the work tree is independently managed by SVN client that does not see content of .git directory (it is in .svnignore) and git client that sees everything, including the .svn/ directory.

The workflow functions well as long as there is no or little merging on Subversion side.

#### Workflow:

* checkout code in SVN
* use Git for development / merging, normal pull/push Gitflow
* when is time to sync
    * use SVN client to add new files and checkin
    * all changes that are result of many Git commits / merges will appear as single commit in SVN
    * => it is same as if somebody would have edited the files manually without any Git present


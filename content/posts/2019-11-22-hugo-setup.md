---
title: "Current Hugo setup on Github Pages"
date: 2019-11-22T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["blog"]
author: "Miro Adamy"
---

# How does the blog setup and publishing work

Before I forget, here is how the current configuration works.

There are two repositories at play:

* source repo - <https://github.com/miroadamy/miroadamy.com>
* github pages repo (== GHPR) - <https://github.com/miroadamy/miroadamy.github.io>


The blog source repo contains only source files (.md, static media etc).
This repo has usual submodules under the `/themes` - e.g. `/themes/even` which is one currently used.

The Githup pages repo contains generated static site, with `index.html` that can be theoretically deployed in any hosting site or S3 bucket. Every push against the GHPR will be immediately visible.

As per Github pages requirements, the repository MUST have name USERNAME.github.io.

## Site generation

The Hugo generator processes the source code using configuration file and writes output - static generated site - under `./public` subfolder. 

To make things easier I have checked out the GHPR repository as submodule of source repo under `./public` in the source repo. The tree of the repos looks like this

```

➜  miroadamy.com git:(master) ✗ tree -F -L 1
.                             => github.com:miroadamy/miroadamy.com
├── archetypes/
├── config.toml
├── config.toml~
├── content/
├── data/
├── layouts/
├── public/                   => github.com:miroadamy/miroadamy.github.io.gi
├── resources/
├── static/
└── themes/
    ├── ananke/               => github.com:budparr/gohugo-theme-ananke.git (not used)
    ├── even/                 => github.com:olOwOlo/hugo-theme-even
    └── hugo-coder/           => github.com:luizdepra/hugo-coder.git (not used)
```

The `.gitmodules` files shows the same information

```
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
```

## Publishing new version of the blog

The generation step from source to GHPR is done locally - I want to test the result before publishing anyway so I need to have local Hugo setup

Steps

1. Edit the source 
2. Test locally - `hugo serve` - runs local server and allows to validate on <https://localhost:1313/>
3. Repeat

The start of Hugo is very fast < 1 sec. It generates site to temporary space and starts embedded webserver on port 1313

```
➜  miroadamy.com git:(master) ✗ hugo serve

                   | EN
+------------------+-----+
  Pages            | 527
  Paginator pages  | 149
  Non-page files   |   1
  Static files     | 200
  Processed images |   0
  Aliases          |  41
  Sitemaps         |   1
  Cleaned          |   0

Total in 541 ms
Watching for changes in /Users/miro/src/MIA/miroadamy.com/{archetypes,content,data,layouts,static,themes}
Watching for config changes in /Users/miro/src/MIA/miroadamy.com/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
``` 

During development, we can edit the source files and changes are immediately reflected in rendered site. This allows super fast development.

When the content looks good, we generate the static content into `./public`. This writes new content to the GHPR repo. Here are the steps used for this article:

```

# In the source repository
➜  miroadamy.com git:(master) ✗ pwd
/Users/miro/src/MIA/miroadamy.com

# Note the added file - we have validated that all is OK by running `hugo serve` and localhost:1313
➜  miroadamy.com git:(master) ✗ gss
?? content/posts/2019-11-22-hugo-setup.md

# Now we generate the site

➜  miroadamy.com git:(master) ✗ hugo

                   | EN
+------------------+-----+
  Pages            | 527
  Paginator pages  | 149
  Non-page files   |   1
  Static files     | 200
  Processed images |   0
  Aliases          |  41
  Sitemaps         |   1
  Cleaned          |   0

Total in 679 ms

# Note that there is additonal change - the `public` link has been modified

# We are now in context of source repo:

➜  miroadamy.com git:(master) ✗ git remote -v
origin  git@github.com:miro.adamy/miroadamy.com.git (fetch)
origin  git@github.com:miro.adamy/miroadamy.com.git (push)

# Go to public => here we will be in context of GHPR

➜  miroadamy.com git:(master) ✗ cd public
➜  public git:(master) ✗ git remote -v
origin  git@github.com:miroadamy/miroadamy.github.io.git (fetch)
origin  git@github.com:miroadamy/miroadamy.github.io.git (push)

# The generator modified  lots of files and added some. We need to commit these changes

➜  public git:(master) ✗ git add .
➜  public git:(master) ✗ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    modified:   categories/index.html
    modified:   categories/index.xml
    modified:   categories/programming/index.html
    modified:   categories/programming/index.xml
    modified:   index.html
    modified:   index.xml
    modified:   page/10/index.html
    modified:   page/11/index.html
    modified:   page/12/index.html
    modified:   page/13/index.html
    modified:   page/14/index.html
    modified:   page/15/index.html
    modified:   page/16/index.html
    modified:   page/17/index.html
    modified:   page/18/index.html
    modified:   page/19/index.html
    modified:   page/2/index.html
    modified:   page/20/index.html
    modified:   page/21/index.html
    modified:   page/22/index.html
    modified:   page/23/index.html
    modified:   page/24/index.html
    modified:   page/25/index.html
    modified:   page/26/index.html
    modified:   page/27/index.html
    modified:   page/28/index.html
    modified:   page/29/index.html
    modified:   page/3/index.html
    modified:   page/30/index.html
    modified:   page/31/index.html
    modified:   page/32/index.html
    modified:   page/33/index.html
    modified:   page/34/index.html
    modified:   page/35/index.html
    modified:   page/36/index.html
    modified:   page/37/index.html
    modified:   page/38/index.html
    modified:   page/39/index.html
    modified:   page/4/index.html
    modified:   page/40/index.html
    modified:   page/41/index.html
    modified:   page/42/index.html
    modified:   page/43/index.html
    modified:   page/44/index.html
    modified:   page/45/index.html
    modified:   page/46/index.html
    modified:   page/47/index.html
    modified:   page/48/index.html
    modified:   page/49/index.html
    modified:   page/5/index.html
    modified:   page/50/index.html
    modified:   page/51/index.html
    modified:   page/52/index.html
    modified:   page/53/index.html
    modified:   page/54/index.html
    modified:   page/55/index.html
    modified:   page/56/index.html
    modified:   page/57/index.html
    modified:   page/58/index.html
    modified:   page/59/index.html
    modified:   page/6/index.html
    modified:   page/60/index.html
    modified:   page/61/index.html
    modified:   page/62/index.html
    modified:   page/63/index.html
    modified:   page/64/index.html
    modified:   page/65/index.html
    modified:   page/66/index.html
    modified:   page/67/index.html
    modified:   page/68/index.html
    modified:   page/69/index.html
    modified:   page/7/index.html
    modified:   page/70/index.html
    modified:   page/71/index.html
    modified:   page/72/index.html
    modified:   page/73/index.html
    modified:   page/74/index.html
    modified:   page/75/index.html
    modified:   page/76/index.html
    modified:   page/77/index.html
    modified:   page/78/index.html
    modified:   page/79/index.html
    modified:   page/8/index.html
    modified:   page/80/index.html
    modified:   page/81/index.html
    modified:   page/82/index.html
    modified:   page/83/index.html
    modified:   page/84/index.html
    modified:   page/85/index.html
    modified:   page/86/index.html
    modified:   page/87/index.html
    modified:   page/88/index.html
    modified:   page/9/index.html
    modified:   posts/2019-11-20-from-jekyll-to-hugo/index.html
    new file:   posts/2019-11-22-hugo-setup/index.html
    new file:   posts/2029-01-01-post.md.template
    modified:   posts/index.html
    modified:   posts/index.xml
    modified:   posts/page/10/index.html
    modified:   posts/page/11/index.html
    modified:   posts/page/12/index.html
    modified:   posts/page/13/index.html
    modified:   posts/page/14/index.html
    modified:   posts/page/15/index.html
    modified:   posts/page/16/index.html
    modified:   posts/page/17/index.html
    modified:   posts/page/18/index.html
    modified:   posts/page/19/index.html
    modified:   posts/page/2/index.html
    modified:   posts/page/20/index.html
    modified:   posts/page/21/index.html
    modified:   posts/page/22/index.html
    modified:   posts/page/23/index.html
    modified:   posts/page/24/index.html
    modified:   posts/page/25/index.html
    modified:   posts/page/26/index.html
    modified:   posts/page/27/index.html
    modified:   posts/page/28/index.html
    modified:   posts/page/29/index.html
    modified:   posts/page/3/index.html
    modified:   posts/page/30/index.html
    modified:   posts/page/31/index.html
    modified:   posts/page/32/index.html
    modified:   posts/page/33/index.html
    modified:   posts/page/34/index.html
    modified:   posts/page/35/index.html
    modified:   posts/page/36/index.html
    modified:   posts/page/37/index.html
    modified:   posts/page/38/index.html
    modified:   posts/page/39/index.html
    modified:   posts/page/4/index.html
    modified:   posts/page/40/index.html
    modified:   posts/page/41/index.html
    modified:   posts/page/42/index.html
    modified:   posts/page/43/index.html
    modified:   posts/page/44/index.html
    modified:   posts/page/5/index.html
    modified:   posts/page/6/index.html
    modified:   posts/page/7/index.html
    modified:   posts/page/8/index.html
    modified:   posts/page/9/index.html
    modified:   sitemap.xml
    modified:   tags/blog/index.html
    modified:   tags/blog/index.xml
    modified:   tags/blog/page/2/index.html
    modified:   tags/blog/page/3/index.html
    modified:   tags/index.html
    modified:   tags/index.xml


# Make local commit

➜  public git:(master) ✗ git commit -m "Published the Hugo setup article"
[master cd95809] Published the Hugo setup article
 148 files changed, 3219 insertions(+), 2638 deletions(-)
 create mode 100644 posts/2019-11-22-hugo-setup/index.html
 create mode 100644 posts/2029-01-01-post.md.template

# Publish site on Github

➜  public git:(master) git push
Counting objects: 291, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (157/157), done.
Writing objects: 100% (291/291), 131.31 KiB | 0 bytes/s, done.
Total 291 (delta 150), reused 0 (delta 0)
remote: Resolving deltas: 100% (150/150), completed with 61 local objects.
To github.com:miroadamy/miroadamy.github.io.git
   676432b..cd95809  master -> master

# Now the static site was updated but the source needs to be as well

➜  miroadamy.com git:(master) ✗ git status
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   public (new commits)

Untracked files:
  (use "git add <file>..." to include in what will be committed)

    content/posts/2019-11-22-hugo-setup.md

no changes added to commit (use "git add" and/or "git commit -a")
```



---
title: "How to list Github repositories and users"
date: 2021-02-16T13:00:00+08:00
published: true
type: post
description: "Using command line tool to access Github/Bitbucket API - 2"
tldr: ""
categories: ["devops", "version control", "howto"]
tags: ["git", "github", "api", "shell"]
image: "img/dan-meyers-PB_B76Ps14Y-unsplash.jpg"
thumbnail: "img/dan-meyers-PB_B76Ps14Y-unsplash.tn-500x500.jpg"
author: "miro adamy"
---

# How to list repositories in GitHub

**Use Case**: 

I want to maintain repositories in an organization in GitHub.  To make sure I do not miss newly added ones, 
I want to use API access to retrieve the list of repositories in the organization.

## Setup

GitHub requires a token to access the API.  This token is stored in an environment variable 
`github_token` and can be generated in the user profile section - settings - developer settings. 

![app password ui](/img/bbgh/access-tokens.png)

The variable `gh` represents the GitHub API URL.
```sh
export gh=https://api.github.com
export github_token=<your-secret-token>
```

I am using a personal shortcut by creating the file `~/.ssh/github-token.secret` with the content described above and importing them, unless the variables are already defined:

```sh
if [ -z "$github_token" ] ; then
  echo importing the token from ~/.ssh/github-token.secret
. ~/.ssh/github-token.secret)
fi

if [ -z "$github_token" ] ; then
    echo "you must export variable github_token "
    exit 2
fi
```

## Retrieving the list of organizations

With the configuration done above, you can run this command:

```sh
curl -s -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" "${gh}/user/orgs" \
  | jq '.[].login' | sed 's/"//g'
---
thinkwrap
pvtrlabs
pivotree-tech-blog
```

The output is list of all organizations for the currently authenticated user.

the full script - `./gh-teams.sh`

```bash
if [ -z "$github_token" ] ; then
  echo using token github_token from ~/.ssh/github-token.secret
. ~/.ssh/github-token.secret
fi


if [ -z "$ghteams" ] ; then
#echo my teams
curl -s -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" "${gh}/user/orgs" \
  | jq '.[].login' | sed 's/"//g'
else
 echo "$ghteams"
fi

```
The output is list of all teams for the currently authenticated user.


example:

```
./gh-teams.sh
thinkwrap
pvtrlabs
pivotree-tech-blog

```


## Retrieving the list of repositories for an organization

With the configuration done above, you can run this command:

```sh
 curl -s  -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" \
        "${gh}/orgs/${username}/repos?per_page=${pagelen}&page=${i}
        
```

where `username` is the name of the organization or user that owns the repositories.

For this call we need to use paging because the default count of results GitHub returns is 30. 
We can retrieve the counts of repositories from the organization metadata.

We need to loop for every page and store the JSON retrieved in temporary files.  These JSON files are 
then processed and generate the `.gh-repos` file in the same format as the BitBucket case:

`projectname|git_url`

```txt
src|git@github.com:pivotree-tech-blog/hugo101.git
src|git@github.com:pivotree-tech-blog/pivotree-tech-blog-source-poc.git
src|git@github.com:pivotree-tech-blog/pivotree-tech-blog.github.io.git
src|git@github.com:pivotree-tech-blog/story.git
```


The script expects 1 argument - the name of the organization or user:


```bash
#!/bin/bash
set -e

progname=$(basename $0)

die() {
    echo "$progname: $*" >&2
    exit 1
}

usage() {
    if [ "$*" != "" ] ; then
        echo "error: $*"
    fi

    cat << eof
usage: $progname [option ...] gh-team-or-user-name
generate the list of the repositiories for given team or used
options:
-h, --help             display this usage message and exit
-d, --debug            set debug = true
eof

    exit 1
}

debug=0
username="undefined"

if [ $# -eq 0 ] ; then
    echo missing argument: github team
    usage
fi

while [ $# -gt 0 ] ; do
    case "$1" in
    -h|--help)
        usage
        ;;
    -d|--debug)
        debug=1
        ;;
    -*)
        usage "unknown option '$1'"
        ;;
    *)
        if [ "$username" = "undefined" ] ; then
            username="$1"
        else
            usage "too many arguments"
        fi
        ;;
    esac
    shift
done

if [ -z "$github_token" ] ; then
  echo importing the token from ~/.ssh/github-token.secret
. ~/.ssh/github-token.secret)
fi

if [ -z "$github_token" ] ; then
    echo "you must export variable github_token "
    exit 2
fi


# display info about the user

echo logged on as user
curl -s -h  -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" "${gh}/user" \
  | jq '{login, id, html_url, name, public_repos, total_private_repos}'


curl -s -h  -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" "${gh}/orgs/${username}" \
    > ${username}-ghteam-info.json

echo team info - see ${username}-ghteam-info.json

# produce list of the repositories in format slug=repo
# echo curl -s -u $creds "${bb}/${team}?pagelen=${pagelen}"
entries=$(curl -s -h  -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" "${gh}/orgs/${username}" | jq '[.total_private_repos, .public_repos] | add')
pagelen=100
pages=$(expr $entries / $pagelen "+" 1)

echo the team $username has $entries repos in $pages pages

for i in $(seq 1 $pages)
    do
      curl -s  -h "accept: application/vnd.github.v3+json" -h "authorization: token ${github_token}" \
        "${gh}/orgs/${username}/repos?per_page=${pagelen}&page=${i}" > ${username}-repo-${i}.json
done

for i in $(seq 1 $pages) 
do 
    jq '.[].ssh_url' < ${username}-repo-${i}.json | sed 's/"//g' | awk '{print "src|" $1 }' > ${username}-${i}.repos
done

rm -f ${username}-repo-*.json

# make sure the file is empty/none - we will append
rm -f ${username}.gh-repos

cat ${username}-*.repos | sort >>${username}.gh-repos

rm ${username}-*.repos

echo see ${username}.gh-repos
```

**NOTE**

This was also published on [our cloud team blog](https://blog.pivotree.cloud/2021-02-16-github-list-repos/)
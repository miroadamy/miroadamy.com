---
title: "Update all local branches in Git repo"
date: 2016-09-05T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

# Update all local branches in Git repo

Issue: The git pull updates just one current branch.

In DevOps I am following many Git repos and need to keep up to date for all local branches.

## git ffwd-update command

Source: <http://stackoverflow.com/questions/4318161/can-git-pull-all-update-all-my-local-branches>

Create file named git-ffwd-update somewhere on the path (in my case `~/bin`)

```
#!/bin/bash
 
main() {
  REMOTES="$@";
  if [ -z "$REMOTES" ]; then
    REMOTES=$(git remote);
  fi
  REMOTES=$(echo "$REMOTES" | xargs -n1 echo)
  CLB=$(git branch -l|awk '/^\*/{print $2}');
  echo "$REMOTES" | while read REMOTE; do
    git remote update $REMOTE
    git remote show $REMOTE -n \
    | awk '/merges with remote/{print $5" "$1}' \
    | while read line; do
      RB=$(echo "$line"|cut -f1 -d" ");
      ARB="refs/remotes/$REMOTE/$RB";
      LB=$(echo "$line"|cut -f2 -d" ");
      ALB="refs/heads/$LB";
      NBEHIND=$(( $(git rev-list --count $ALB..$ARB 2>/dev/null) +0));
      NAHEAD=$(( $(git rev-list --count $ARB..$ALB 2>/dev/null) +0));
      if [ "$NBEHIND" -gt 0 ]; then
        if [ "$NAHEAD" -gt 0 ]; then
          echo " branch $LB is $NBEHIND commit(s) behind and $NAHEAD commit(s) ahead of $REMOTE/$RB. could not be fast-forwarded";
        elif [ "$LB" = "$CLB" ]; then
          echo " branch $LB was $NBEHIND commit(s) behind of $REMOTE/$RB. fast-forward merge";
          git merge -q $ARB;
        else
          echo " branch $LB was $NBEHIND commit(s) behind of $REMOTE/$RB. reseting local branch to remote";
          git branch -l -f $LB -t $ARB >/dev/null;
        fi
      fi
    done
  done
}
 
main $@
```

Make sure the file is executable: `chmod +x ~/bin/git-ffwd-update`

## Test it out:

```
➜ git:(develop) ✗ git ffwd-update
Fetching origin
remote: Counting objects: 2786, done.
remote: Compressing objects: 100% (1385/1385), done.
remote: Total 2786 (delta 1447), reused 2023 (delta 888)
Receiving objects: 100% (2786/2786), 410.54 KiB | 0 bytes/s, done.
Resolving deltas: 100% (1447/1447), completed with 141 local objects.
From bitbucket.org:thinkwrap/XXXXXXX
   b060dd8..b72c54a  develop    -> origin/develop
 * [new branch]      feature/FDPCare-5 -> origin/feature/FDPCare-5
   f3f524c..3b7294e  feature/STRIPES-1036 -> origin/feature/STRIPES-1036
 * [new branch]      feature/STRIPES-1079 -> origin/feature/STRIPES-1079
 * [new branch]      feature/STRIPES-1098-createPriceRowProductIdError -> origin/feature/STRIPES-1098-createPriceRowProductIdError
 * [new branch]      feature/STRIPES-1104_sitemap_menu_items -> origin/feature/STRIPES-1104_sitemap_menu_items
 * [new branch]      feature/STRIPES-1105_sitemap_pos -> origin/feature/STRIPES-1105_sitemap_pos
 * [new branch]      feature/STRIPES-1106 -> origin/feature/STRIPES-1106
 * [new branch]      feature/STRIPES-1107 -> origin/feature/STRIPES-1107
 * [new branch]      feature/STRIPES-1108 -> origin/feature/STRIPES-1108
 * [new branch]      feature/STRIPES-1109 -> origin/feature/STRIPES-1109
 * [new branch]      feature/STRIPES-1112 -> origin/feature/STRIPES-1112
 * [new branch]      feature/STRIPES-1113 -> origin/feature/STRIPES-1113
 * [new branch]      feature/STRIPES-1114 -> origin/feature/STRIPES-1114
 * [new branch]      feature/STRIPES-1115 -> origin/feature/STRIPES-1115
 * [new branch]      feature/STRIPES-1116 -> origin/feature/STRIPES-1116
 * [new branch]      feature/STRIPES-1117 -> origin/feature/STRIPES-1117
 * [new branch]      feature/STRIPES-1124_Create_diagram_create_check -> origin/feature/STRIPES-1124_Create_diagram_create_check
 * [new branch]      feature/STRIPES-1135_Controller_for_GMMS -> origin/feature/STRIPES-1135_Controller_for_GMMS
 * [new branch]      feature/STRIPES-1140_autodiscount -> origin/feature/STRIPES-1140_autodiscount
 * [new branch]      feature/STRIPES-1142 -> origin/feature/STRIPES-1142
 * [new branch]      feature/STRIPES-1143 -> origin/feature/STRIPES-1143
 * [new branch]      feature/STRIPES-1145_GMMS.stripesCodeCredit_facade -> origin/feature/STRIPES-1145_GMMS.stripesCodeCredit_facade
 * [new branch]      feature/STRIPES-1149 -> origin/feature/STRIPES-1149
 * [new branch]      feature/STRIPES-1151 -> origin/feature/STRIPES-1151
 * [new branch]      feature/STRIPES-1152 -> origin/feature/STRIPES-1152
 * [new branch]      feature/STRIPES-1153 -> origin/feature/STRIPES-1153
 * [new branch]      feature/STRIPES-1154 -> origin/feature/STRIPES-1154
 * [new branch]      feature/STRIPES-1155 -> origin/feature/STRIPES-1155
 * [new branch]      hotfix/FDPCARE-72-2016-08-22 -> origin/hotfix/FDPCARE-72-2016-08-22
 * [new branch]      hotfix/STRIPES-1121-2016-08-18 -> origin/hotfix/STRIPES-1121-2016-08-18
 * [new branch]      hotfix/STRIPES-1133_on_side_issue -> origin/hotfix/STRIPES-1133_on_side_issue
   0352331..c2bec59  master     -> origin/master
   b4521ce..10a1d1d  release/fdp-prod -> origin/release/fdp-prod
 * [new tag]         3.0.2(HF)  -> 3.0.2(HF)
 * [new tag]         release/FDP-PROD_2016-08-18 -> release/FDP-PROD_2016-08-18
 * [new tag]         release/FDP-PROD_2016-08-22-hotfix -> release/FDP-PROD_2016-08-22-hotfix
 * [new tag]         release/FDP-UAT_2016-08-22-hotfix -> release/FDP-UAT_2016-08-22-hotfix
 * [new tag]         3.0.1(HF)  -> 3.0.1(HF)
 * [new tag]         release/FDP-PROD_2016-08-17 -> release/FDP-PROD_2016-08-17
 * [new tag]         release/FDP-UAT_2016-08-10 -> release/FDP-UAT_2016-08-10
 * [new tag]         release/FDP-UAT_2016-08-12 -> release/FDP-UAT_2016-08-12
 * [new tag]         release/FDP-UAT_2016-08-15 -> release/FDP-UAT_2016-08-15
 * [new tag]         release/FDP-UAT_2016-08-16 -> release/FDP-UAT_2016-08-16
 branch develop was 216 commit(s) behind of origin/develop. fast-forward merge
 branch feature/STRIPES-79-maintain-code-compliance-jan-2016 was 87 commit(s) behind of origin/feature/STRIPES-79-maintain-code-compliance-jan-2016. reseting local branch to remote
 branch master was 1336 commit(s) behind of origin/master. reseting local branch to remote
 branch release/fdp-dev was 436 commit(s) behind of origin/release/fdp-dev. reseting local branch to remote
 branch release/fdp-prod was 447 commit(s) behind of origin/release/fdp-prod. reseting local branch to remote
 branch release/fdp-uat was 68 commit(s) behind of origin/release/fdp-uat. reseting local branch to remote
 branch release/livelab was 14 commit(s) behind of origin/release/livelab. reseting local branch to remote
 ```

## Automation for multiple repositories

Most of my repos are living under `~/src/CLIENTS`. All except XYZ are accessed using ssh and public key

Create list of repos:

```
REPOS=$(find . -type d -name '.git' | sed 's!/.git!/!')
 
echo $REPOS | grep -v XYZ >repos-list
```

Edit the list if necessary. 

Use it to crawl

`for i in $(cat repos-list); do cd $i; echo Processing $i; git ffwd-update; cd -; done`


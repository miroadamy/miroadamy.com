---
title: "Merge conflict with deleted file"
date: 2013-04-13T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

I was merging the branch that removed / consolidated bunch of duplicate JSP files (corporate-ui-cleanup). 

In the meantime in master, some minor UI changes were made to these files whose content was now elsewhere.

Quick trick how to resolve it fast:

## Show branch

```
CineplexB2B $ git show-branch
! [bb-database-cleanup] Loading data with XML only: no constraints and tax_id (unused field) nullable
 ! [bb-gradle-build] Merge branch 'master' into bb-gradle-build
  * [bb-master] Merged in the last 5 days changes
   ! [corporate-ui-cleanup] Merged in the last 5 days changes
    ! [master] Merged in the last 5 days changes
-----
 -    [bb-gradle-build] Merge branch 'master' into bb-gradle-build
 ---- [bb-master] Merged in the last 5 days changes
 +*++ [bb-master^2] CPLXB2B-562, usageInfo/internalUsageInfo mapping in CFI
 +*++ [bb-master^2^] return order goes all the way to NEW: replaced SetPaymentGroupAmount, added ReturnFee calculator, added reusable jsp fragments for sales order pages
 +*++ [bb-master^2~2] Styling change to avoid disappearing links inside Terms and Conditions
 +*++ [bb-master^2~3] Dealing with consequences if INTERNAL split to INTERNAL_TRANSFER and INTERNAL_PURCHASE
 ---- [bb-master^2~4] Merge remote-tracking branch 'origin/master' into uat2-deploy
 ---- [bb-master^2~4^2] Merge branch 'master' of luke:cineplex-b2b
 +*++ [bb-master^2~4^2^] merged changes - fixed conflict
 +*++ [bb-master^2~4^2~2] CPLXBTOB-557 - fixed amount column to show proper currency
 ---- [bb-master^2~4^2~3] Merge branch 'master' of twgit@luke:cineplex-b2b.git
 +*++ [bb-master^2~4^2~4] CPLXBTOB-484 - fixed the spacing and comma issues
 +*++ [bb-master^2~5] Reverted 4d512ed - issue with recalculate. Must be solved selectively via Javascript
 +*++ [bb-master^2~6] Spacing in header
```

see also version with `--current`

```
CineplexB2B $ git show-branch --current master
! [master] Merged in the last 5 days changes
 * [bb-master] Merged in the last 5 days changes
--
-- [master] Merged in the last 5 days changes
```

For more, see <http://stackoverflow.com/questions/2255416/how-to-determine-when-a-git-branch-was-created>

## Find difference 

between 2 versions of the file which existed on master - since 13 commits ago

```
git diff master~13:cineplex/j2ee-apps/cineplex.ear/b2b.war/profile/gadgets/applicationReview_content.jsp master:cineplex/j2ee-apps/cineplex.ear/b2b.war/profile/gadgets/applicationReview_content.jsp
```

* Save the diff to file
* open the new location
* find "shared" part from the diff
* paste changed parts

To resolve the merge, one must remove the file and add the change in new file


---
title: "Gitolite permissions setup"
date: 2014-04-02T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["git","gitolite"]
author: "Miro Adamy"
---

This documents how to enforce the Gitolite permission to make LIVE branch writeable only by team leads

## How gitolite works

### Repository permission structure

This is general format of repo definition

```
REPO NAME
   rule line
   rule line
```
for example

```
@staff          =   dilbert alice wally bob
 
repo foo
    RW+         =   dilbert     # line 1
    RW+ dev     =   alice       # line 2
    -           =   wally       # line 3
    RW  temp/   =   @staff      # line 4
    R           =   ashok       # line 5
```


The Rule line has format:

`<permission> <zero or more refexes> = <one or more users/user groups>`

Permission:

* R - read (clone, fetch)
* RW - write (push)
* RW+ - forced write - push that overwrites the server side
* - => indicates to DENY access

REFEX:

* regular expression specifying branch or tag
* ' ' - space is every branch
* 'master$' - any branch whose name ends on master
* '^LIVE' - any branch starting on 'LIVE'
* '^FOO$' - branch named exactly 'foo'. 
  * the 'FOO' will match, 'FOOBAR' will not
* 'FOO' - branch that matches 'FOO'
  * both 'FOO' and 'FOOBAR' will match

USers or groups:

* names of users (pub key files) or groups (defined with @- sign)

### Evaluation of access

Because information may be in multiple files (includes etc), Gitolates accumulates the permissions and creates effective permission FIRST.

This is documented in [http://gitolite.com/gitolite/rules.html\#rule-accum](http://gitolite.com/gitolite/rules.html#rule-accum). Here is an example

This:

```
1  # we have 3 specifically named FOSS projects, but we also consider any
 2  # project in the foss/ directory to be FOSS.
 3  @FOSS-projects  =   git gitolite linux foss/..*
 
 4  # similarly for proprietary projects
 5  @prop-projects  =   foo bar baz prop/..*
 
 6  # our users are divided into staff, interns, and bosses
 7  @staff          =   alice dilbert wally
 8  @interns        =   ashok
 9  @bosses         =   PHB
 
10  # we have certain policies.  The first is that FOSS projects are readable
11  # by everyone
12  repo @FOSS-projects
13      R   =   @all
 
14  # the second is that bosses can read any repo if they wish to
15  repo @all
16      R   =   @bosses
 
17  # now we have specific rules for specific projects
18  repo git
19      RW+ =   junio
20      ...some other rules...
 
21  repo gitolite
22      RW+ =   sitaram
23      ...some other rules...
 
24  ...etc...
```


gets collapsed to this for the 'gitolite' repo

```
13      R   =   @all            # since it is a member of @FOSS-projects
16      R   =   @bosses         # since every repo is a member of @all anyway
22      RW+ =   sitaram         # from the gitolite-specific ruleset
23      ...some other rules...  # from the gitolite-specific ruleset
```

This accumulation happens BEFORE any check is done

### Pre-git phase (read access)

To check if user has access rights to particular repo, all accumulated rules for that repo and that user are scanned. 

If Gitolite finds rule with 'R' access, it is permitted. For each rule:

* skip the rule if it does not apply to this user
* if the rule contains an "R" (i.e., it is "R", "RW", or any variant of "RW"), allow access and stop checking rules

If no rule ends with a decision, ("fallthru"), deny access

By default, the DENY rules (one with '-' are ignored for Read access UNLESS YOU SPECIFY the 'deny-rule' option. Do not do that.

Details are at [http://gitolite.com/gitolite/rules.html\#access-rules](http://gitolite.com/gitolite/rules.html#access-rules)

### Write access

This is what we actually want: make sure that only designated people can push against protected branches.

Write access is checked twice, once before passing control to git-receive-pack, and once from within the update hook.

The first check is identical to the one for read access, except of course the permission field must contain a "W". As before, deny rules are ignored, and you can override that using the [deny-rules](http://gitolite.com/gitolite/rules.html#deny-rules) option. The [refex](http://gitolite.com/gitolite/refex.html) field is also ignored, because at this point we don't know what refs are going to be pushed.

The **second check** happens from within the update hook. Deny rules *are* considered, which in turn means the *sequence* of the rules matters.

Here's how the actual rule matching happens:

* go through the [accumulated](http://gitolite.com/gitolite/rules.html#rule-accum) rule list for the repo in the sequence they appear in the conf file
* for each rule:
  * skip the rule if it does not apply to this user
  * If the ref does not match the [refex](http://gitolite.com/gitolite/refex.html), skip the rule
  * If it's a deny rule, deny access and stop checking rules
  * If the permission field matches the specific [type of write](http://gitolite.com/gitolite/write-types.html) operation, allow access and stop checking rules
* If no rule ends with a decision, ("fallthru"), deny access

Because this is deeply logical, but not necessary intuitive, here are few examples:

```
@QA_team    =   QA_guy QA_gal
@Lead_devs  =   sitaram dilbert
@devs       =   @Lead_devs alice wally
  
repo    foo
    RW  refs/tags/v[0-9]        =   @QA_team
    RW+                         =   @Lead_devs
    RW  dev/                    =   @devs
```

A member of the QA team can only push tags which start with `v`, followed by a digit (optionally followed by anything else). This allows them to tag repository, but not actually commit new code.

A lead dev can push or rewind just about anything. (When you don’t supply a pattern between the permissions and the `=` sign, it means it matches any ref.) 

A normal dev can only push branches whose name starts with `dev/`.

All of these will have read access because deny rules do not work during that phase.

An example with deny rules.

```
repo    bar
    RW+ master                  =   @Lead_devs  # line 1
    -   master                  =   @devs       # line 2
    RW+                         =   @devs       # line 3
```


This example shows how to protect forced-rewind to anybody but Lead\_devs group.

When a normal dev (not a lead dev) tries to rewind-write to “master”, the first matching rule is Line 2, which says “deny”. If a lead dev tries it, though, Line 1 (which comes before Line 2) matches, and allows the access. 

Just as an exercise, think about what happens if you switch Lines 1 and 2. Since “lead” devs are also members of `@dev`, they will be denied any write access to “master” since the deny rule will be matched first!)

Devs will have read access to master because the deny rules are ignored during Read check.

Here is a problematic one:

```
# Gitolite permission test
 repo gitolite-permission-test
    RW master$     = dev1 lead tester
    RW LIVE$       = lead
    R LIVE$        = dev1 tester
    R vmonly$      = lead
    RW vmonly$     = dev1 tester
```

Here we want allow only for lead to push against LIVE and only for dev1 and tester against 'vmonly', while all can push against master.

This works OK, HOWEVER - nobody can create any new branch. Let's say lead creates UAT branch. The tests against rules will fail as none of the rules matches UAT.

Correct way how to achieve this would be

```
# Gitolite permission test
 repo gitolite-permission-test
    RW LIVE$       = lead
    RW vmonly$     = dev1 tester
    - LIVE$        = dev1 tester
    - vmonly$      = lead
    RW             = @all
```

Remember - read access is allowed because deny rules are ignored (we have no option set).

If lead is trying to push against 'vmonly', line 5 will stop him. If lead tries to push LIVE, it is allowed by explicit rule \#1

If dev1 or tester will try to push against vmonly, the rule \#2 allows it. If they try to push against LIVE, rule \#3 stops them

If anybody tries to push against master or any branch other than LIVE or vmonly, the rule \#5 will permit proceeding.

This is pretty much how we will implement it.

## Enforcing the access rights

The process of enforcement will consist of 

* defining the groups
* defining the protected branches
* testing

The general pattern is

```
repo gitolite-permission-test
    RW PROTECTED-BRANCH     = @privileged-group
    - PROTECTED-BRANCH      = @read-only-group
... repeat for all branches / groups
    RW                      = @all
```

## Template for repository rights

### Groups

In each Gitolite config, we will define

* developers = all that have read/write access to all non-privileged branches
* leads = non-rewind access to all branches
* readonly = read only access (this is Jenkins, Crucible and those without actual push access)
* admins = full access (rewind)

There always 

The protected branches are (for now)

* LIVE - anything containing LIVE

Later on, we may add UAT - some projects may want to run the UAT branches via 

So the template is

```
@admins     = miro admin2.name
@developers = dev1.name dev2.name
@leads      = lead1.name lead2.name
@readonly   = jenkins2 crucible
  
# All repositories sharing same access
repo repo1 repo2
    RW+           =  @admins
    RW LIVE       =  @leads
    - LIVE        =  @developers
    RW            =  @developers
    R             =  @readonly
```

There is also automagically defined '@all' group.

This should NOT be used - because it grants access to any uploaded key in keydir/ without having the named user listed in one of the groups above.

Slowly, we will migrate the existing repos to this structure.

## Sources, credits, attributions:

* [http://gitolite.com/gitolite/rules.html\#access-rules](http://gitolite.com/gitolite/rules.html#access-rules)
* <http://gitolite.com/gitolite/master-toc.html>
* <http://www.opensourceforu.com/2011/01/gitolite-specify-complex-access-controls-git-server/>
* <http://stackoverflow.com/questions/12980750/gitolite-permissions-on-branches>
* <http://gitolite.com/gitolite/refex.html>
* [http://gitolite.com/gitolite/rules.html\#rule-accum](http://gitolite.com/gitolite/rules.html#rule-accum)
* [http://gitolite.com/gitolite/rules.html\#how-are-the-rules-checked](http://gitolite.com/gitolite/rules.html#how-are-the-rules-checked)
---
title: 'How klassify.com went live: one static page, GitHub Pages and Route 53'
date: '2026-09-03 15:30:00 +02:00'
type: post
author: Miro Adamy
categories:
- general
tags:
- devops
- github-pages
- route53
- dns
- aws
---



My company, Klassify s.r.o., has had a domain for a long time before it was even registered (I registered klassify.com way back in early 2000 in Canada, but never actually did anything with it) - and a web page since this afternoon. For all that time klassify.com carried only my email - there was no A record at all, nothing was served, and whoever looked up the company from an invoice or a contract got a browser error and, I suppose, some doubts about whether the company exists. So here is how it got fixed in one afternoon, in the order it happened and with the reasoning. Nothing here is clever or sophisticated or the only/the best way. The point is the sequence of creation: there are two places in it where it is quite easy to break something that matters more than a web page.

I had two main reasons for doing this: one was that a company should have a web page. It was kinda weird when nothing showed up. The second reason was a non-trivial amount of catch emails in my Google Workspace for klassify.com, from some Indian company that apparently allocated a similar domain - klassify.io - and their customers kept using klassify.com to email them. These emails would arrive to me as a catch-up. At first I was trying to reply, then to autorespond, but it took too much time to review. This way, I kinda claimed the (virtual) lot.

## What I wanted (and what I did not)

One living company page - who Klassify is, what kind of engagements I take, certifications, links to the portfolio, the CV and this blog. Not a company website, nobody needs that. Plain hand-written index.html, no framework, no build step, no JavaScript, light and dark via prefers-color-scheme and that's it.

The important constraint was the mail. Google Workspace is live on the domain, and the MX record is the one thing in that DNS zone that must survive whatever I do with the web part. The second constraint was cost - I wanted this to cost exactly nothing beyond the yearly domain renewal, which is what GitHub Pages on a public repository gives you.

## The repository

See [klassify-com/klassify.com on GitHub](https://github.com/klassify-com/klassify.com).

Five files. The index.html itself, a CNAME file containing klassify.com (GitHub Pages reads this file and uses it as the custom domain), an empty .nojekyll (so that Pages serves the files as they are instead of running Jekyll over them), a README with the launch runbook so that future me knows what was done and why, and dns/route53-github-pages.json - the DNS change written as a Route 53 change batch.

That last one is a habit I recommend: commit the DNS change to the repo and it becomes something you can review, diff and repeat, instead of a memory of clicking around a console.

## Step 1 - create the repo and push

```bash
git add -A && git commit -m "Klassify landing page"
gh repo create klassify-com/klassify.com --public --source=. --remote=origin --push
```

The gh command creates the repository under the organisation, adds the remote and pushes main, all in one go.

## Step 2 - turn on Pages, from the API

```bash
echo '{"build_type":"legacy","source":{"branch":"main","path":"/"}}' \
  | gh api -X POST repos/klassify-com/klassify.com/pages --input -
```

"legacy" is what the web UI calls "Deploy from a branch". For a single static file that is all one needs, no Actions workflow.

Two things I learned here. The response already came back with cname: klassify.com - the CNAME file in the repository root had set the custom domain by itself, so there was no separate "add domain" step at all. And you can prove the deployment works before creating a single DNS record: a repository called klassify.com is a project site, so it lives at klassify-com.github.io/klassify.com/, and that URL answered with a 301 to http://klassify.com/. The root klassify-com.github.io returns 404, which is correct and which confused me for a minute or two.

## Step 3 - DNS, the step that can break mail

This is what GitHub wants for an apex domain:

| Name | Type | Value |
|---|---|---|
| klassify.com | A | 185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153 |
| klassify.com | AAAA | 2606:50c0:8000::153, 2606:50c0:8001::153, 2606:50c0:8002::153, 2606:50c0:8003::153 |
| www.klassify.com | CNAME | klassify-com.github.io |

The shape matters. A records on the apex, never a CNAME - a CNAME cannot coexist with any other record on the same name, so an apex CNAME would have quietly made the MX record unreachable and broken the mail. That is the whole reason why GitHub publishes fixed IP addresses for apex domains. The www name gets the CNAME, pointing at the organisation's Pages hostname (not at the repository path) - GitHub routes it by the CNAME file, and it redirects to the apex.

The change batch uses CREATE, not UPSERT. If any of the three record sets had already existed, Route 53 would reject the whole batch instead of overwriting it - cheap insurance in a zone with live mail. It is a great idea to `dig AAAA` against a site that is already on GitHub Pages to assure it returned the same four addresses as the docs. Ten seconds, one class of typo eliminated. TTL is 300 seconds, so a rollback would propagate in minutes.

```bash
aws route53 change-resource-record-sets \
  --hosted-zone-id "$ZONE" \
  --change-batch file://dns/route53-github-pages.json
```

Route 53 reported the change INSYNC in under a minute. Then the checks, in this order:
- MX still reads 1 smtp.google.com (good),
- http://klassify.com/ returns 200 with the right title,
- http://www.klassify.com/ redirects to the apex.
  
HTTPS still failed at this point with GitHub's own `*.github.io` wildcard certificate, which is expected - see the next step.

## Step 4 - the certificate that would not come

GitHub provisions a Let's Encrypt certificate for a custom domain automatically once the DNS resolves, and the documentation says it can take up to an hour. Forty minutes in, the Pages settings page of the repository said "DNS check successful" right next to "Enforce HTTPS - unavailable because a certificate has not yet been issued".

Re-saving the same domain through the API changed nothing, there was no CAA record blocking Let's Encrypt, and public resolvers all saw the right records. Everything was fine except the one thing I was waiting for.

The fix is in GitHub's troubleshooting docs and it is blunt: remove the custom domain and add it back.

```bash
echo '{"cname":null}'           | gh api -X PUT repos/klassify-com/klassify.com/pages --input -
echo '{"cname":"klassify.com"}' | gh api -X PUT repos/klassify-com/klassify.com/pages --input -
```

The certificate was approved within seconds of the second call, for klassify.com and www.klassify.com both, and https_enforced flipped to true on its own. The site was without its domain for about a second in between. Had I known, I would have done this after five minutes, not forty ;-)

## Step 5 - verify the domain for the organisation

A verified domain stops any other GitHub account from claiming klassify.com on Pages if this repository is ever deleted or renamed. Small thing, but the kind of small thing that is embarrassing when it happens.

It turns out there is no REST endpoint for this. I refreshed my token with the admin:org scope for nothing - the call returns 404 and the API docs for Pages and for Organisations simply do not list it. It is web UI only: Organisation settings, Pages, Verified domains, Add a domain.

GitHub shows a TXT record to create (`_github-pages-challenge-<org>` under the domain, with a one-time value), so that was a second change batch of the same CREATE-only shape. One detail that bites: the TXT value inside the JSON has to carry its own literal quotes, as in "\"value\"", otherwise the API rejects it. I waited until the record was visible from a public resolver, not only from the authoritative name server, and then clicked Verify. Verified on the first try.

## The checklist for next time

```bash
dig +short A klassify.com; dig +short AAAA klassify.com
dig +short CNAME www.klassify.com          # klassify-com.github.io.
dig +short MX klassify.com                 # 1 smtp.google.com.  (must never change)
curl -sI http://klassify.com/  | head -1   # 301 -> https
curl -sI https://klassify.com/ | head -1   # 200
curl -sI https://www.klassify.com/ | head -1 # 301 -> https://klassify.com/
gh api repos/klassify-com/klassify.com/pages \
  --jq '{status,cname,https_enforced,cert:.https_certificate.state}'
```

## If I had to do it again tomorrow

- Measure the zone before touching it - list every record and know where the mail is.
- Put the DNS change in a file in the repository, CREATE-only, and apply it from the CLI, the file is your audit trail.
- Prove the Pages deployment through the github.io project URL before the DNS exists.
- If the certificate has not shown up after a few minutes while the DNS check is green, remove and re-add the domain instead of waiting the hour.
- And verify the domain for the organisation in the browser, because the API cannot do it.

The whole thing was a pair session with Claude Code - it measured the starting state, drafted the change batches and the runbook, drove the GitHub API calls and handed me the DNS commands to run myself. Which is exactly where I wanted a human hand on the keyboard.

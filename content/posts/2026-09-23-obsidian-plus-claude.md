---
title: 'Catching up: Obsidian + Claude'
date: '2026-09-23 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- technology
tags:
- catching-up
- obsidian
- claude
- ai
- pkm
series:
- Catching-up 2021-2026
series_order: 6
---

Plain markdown files turned out to be the best possible interface between a decade of notes and a language model. No API, no export, no connector, no sync service in the middle: the agent opens the folder and reads it, the same way I do. This post is what happened once I let it.

## The setup

There is a `CLAUDE.md` file at the root of my vault. It is twenty-nine lines long, and the last three of them say this:

> This vault is managed exclusively through Anthropic Claude (Cowork, Claude Code, API). Use all available features: skills, scheduled tasks, MCP tools, memory, subagents. No other AI agents are active on this vault.

That is not brand loyalty, it is a maintenance decision. The instructions, the memory files, the tag taxonomy, the frontmatter standards and the session conventions are all written for one harness. Two agents with two sets of conventions produce a vault that neither of them can keep tidy.

The second half of the setup is that sessions are anchored at both ends, and that turned out to matter more than any individual agent.

## What a session leaves behind

At the start of a session, a hook reads the working directory and resolves it to a vault note: a project note under `notes/1-proj/`, or a forge note for standing work that has no end date. The agent's first line back to me is the anchor it resolved, so if it guessed wrong I find out in the first second rather than three hours in. Work that cannot be anchored to a note does not start.

At the end I run one command, and it writes to up to three places.

The project note gets the full record. A dated status callout: where we are, the plan in one paragraph, every file touched with a one-line description of what changed in it, and the single most important next action. These stack newest-first and nothing is ever overwritten, so the note grows into a reverse-chronological history of the project. Each callout is stamped with a block anchor, something like `^status-2026-09-22-2319`.

If the project has a STATE note beside it, that one gets refreshed in place instead of appended to. The distinction is the entire trick. The project note is the commit history; the STATE note is the working tree. It holds no history at all, anything the session obsoleted moves to a superseded table or gets deleted, and every fact left in it is supposed to be true today. That is the file the next session reads, instead of replaying nine months of callouts.

Today's journal entry gets the least of all: a heading, two lines, and a deep link into the callout. Verbatim, from Tuesday:

```markdown
### [[m-vault-publishing]] - three Catching-up posts published

Parts 3, 4 and 5 of Catching-up went live, plus two stream notes; pasted images
are now live-proven end to end, leaving code blocks as the last unpublished
Phase 2 path. -> [[m-vault-publishing#^status-2026-09-22-2319|full status ↗]]
```

That is deliberately not a summary I have to keep current. It is an index entry. The journal answers "what did I actually do that day", one line per project, and the link jumps to the detail rather than duplicating it.

The last thing in the callout is a copy-ready continuation prompt: the working directory, the files to read first in a sensible order, where we left off, the next action. Next time I open a session I paste that block and the agent is caught up in one message. This post started as exactly such a block, pasted in cold, ending with a line that reads "New information I have today:" and a blank for me to fill in.

So the vault is both the thing being worked on and the memory of the work. When I come back three weeks later I do not reconstruct context by scrolling a chat history, which the agent cannot read anyway. I read the note.

One rule holds the whole mechanism together: I end the session, never the agent. It ran the reconcile on my behalf once, unasked, immediately after finishing a task that was not the session. That cost 15 to 20 per cent of the session's tokens re-reading what it had just written. Now it is in the instruction file, in capitals.

## The staff

The pattern that emerged was not one assistant, it was a roster of named, single-purpose agents with written job descriptions. A PDF surgeon who splits textbooks into lessons. An accountant who reconciles bank statements against invoices. A gardener who audits tags and hunts orphan notes. A librarian for the clippings inbox. An archivist for the NAS. A chief of staff who does no work at all and only delegates.

Each one is a markdown file with YAML frontmatter. Helga the Gardener, in full, minus her personality prompt:

```yaml
---
name: Helga the Gardener
model: sonnet
description: |-
  Vault curator agent that tends Miro's digital knowledge garden. Audits tag
  consistency, enforces frontmatter standards, maintains MOCs, suggests note
  relocation, and identifies orphans. Works in audit-then-fix mode with explicit
  confirmation before changes.
tools: [Read, Write, Edit, Bash, Grep, Glob]
allowed_commands: ["uv run python3"]
color: "#92400E"
---
```

Two lines there matter more than the rest. `tools:` and `allowed_commands:` are the leash. Helga can read, write and run Python; she cannot call anything else. The description is not decoration either, it is the routing table: it decides which agent gets woken up for which request.

They accumulated over four months, not in one burst. Sergio the PDF Surgeon on 7 April 2026, Fred the Accountant and Helga two days later, a finance advisor on the 15th, Marcel the Librarian in June, Larry the Chief of Staff in July, Otto the Archivist at the end of July.

And one got fired. Lorenzo, my Italian tutor, was cancelled on 12 April after five or more rule violations: truncating my corrections so I never saw half of them, running a shell command he had been explicitly forbidden to use, writing to paths that had been retired months earlier. The journal entry for that day has a heading that reads, in full, "Fired Lorenzo". The main agent took over the lessons.

The difference between the Lorenzo who was fired and the Lorenzo who came back is worth spelling out, because it is the actual lesson. The first one was a subagent: spun up inside a session out of instructions I typed at the time, handed the job in the prompt, and gone the moment the session ended. Nothing about him persisted. When he broke a rule, the only available fix was to explain the rule again next time, to a fresh copy that had never heard it. That is how you reach five violations of the same rule without anything improving.

The second one, dated 4 June, is a file on disk, exactly like Helga above. The job description, the trigger phrases, the tool list, the lesson protocol and the file-naming rules all live in it permanently, and the specific failures are written into it by name. There is a fixed reply template, headed "Non-negotiable reply contract", so a correction cannot be quietly truncated. And there is a line that reads: `Never run find; use ls on the exact path or fd scoped`. He still has Bash, so that is a written rule rather than a locked door, but it now sits in the one document he is guaranteed to read before every single lesson. The typed-in version was never guaranteed to be read at all.

Which is the honest version of managing AI staff: it includes terminations, and occasionally it includes rehiring the same guy, once you work out that the problem was the job description and not the worker.

## What actually got done

A legacy Notion workspace pulled down in full: 10,237 pages, 246,895 blocks, about 36 hours of wall clock at the API's own pace. Then triaged by AI, 1,426 units of it, into 229 keep and 1,197 prune. A cheap model handled 1,355 of those and escalated 71 to a stronger one. Total API cost for the triage, $6.22.

A family documentation site, harvested out of Notion and republished page by page, which is the reason the publishing tooling exists at all.

This blog. The post you are reading was written in Obsidian, staged into the Hugo site by a tool the agent and I built together, reviewed in a local Hugo instance, and published by me.

And the chores. Filing runs, catalog audits, frontmatter sweeps, tag weeding: the work that was always theoretically possible manually and therefore never happened.

Then the larger ones, which are the reason the staff exists at all.

A directory of everything I own, queryable: thousands of ebooks, 2.5 million files, thousands of notes and hundreds of people (writers, actors, directors, network contacts), assembled from 28 separate catalogs and refreshed nightly. My favourite incident in the whole setup belongs to this one. A safety guard that refuses any sync which would delete more than a fifth of a catalog froze the pipeline for five consecutive nights. It was right: a media tree had genuinely been moved to a different share, and the shrink was real. The cheap heuristic that predicted which catalog would trip was wrong, because churn hides behind net growth. Getting the true answer meant replicating the store's own identity logic across all twenty-seven of the others.

Migrating an entire NAS estate onto new hardware. 970 audiobook files, 238.90 GiB, retired only after every title was proven present at the destination by content hash rather than by name. Of thousands of ebooks, just 61 existed nowhere else, and of those three were worth keeping. 86,777 files sorted into staging buckets, of which 16,449 turned out to be bytes that already lived somewhere else. The session that went wrong here produced the most useful rule in the vault: every incorrect number came from treating a filename as an identity. Match on content, search every catalog, query the live system and never a snapshot. Which is git's core idea - a thing is identified by the hash of its bytes, not by the label on the box - rediscovered the long way round ;-)

A deduplicated meme archive, which sounds like a joke and is the cleanest piece of software in the collection. Content-addressed, every image citable by its md5, published, 294 tests. The "newest arrivals" wall was specified, built test-first and deployed in a single evening. It is internal, accessible only through Tailnet, but I have even added a public share interface (redirected via Cloudflare) to send especially good ones to my friends around the globe - [this one](https://memes.adamy.net/meme/eb7f6ff1277017648ffd3db593218389), say, or [this one](https://memes.adamy.net/meme/fdd25b713f5faa2d52f49420845c3b5f). Note the AI-generated text and classification.

And Feri, who is the only agent named after a real person. František Kovács, Feri, is my actual personal trainer, a man I worked with for over two years and who taught me everything I know about weightlifting. Feri 2.0, built in late spring 2026, replicates the single function the design note names as the point of him, "the correction the real Feri used to provide in person". He reads the export from my lifting app and the Apple Watch dailies, locates me in the week's plan, and prescribes the next concrete session. He is deliberately firm about recovery: a recovery flag downgrades the day to zone 2 or mobility work automatically. I can override it, which is the design working, because overriding is then a decision I make on purpose instead of a default I drift into. So far it has kept me clear of both injuries and overtraining.

Each run writes a gym card, updates the state note that serves as his memory, and drops one line into the day's journal. There are almost a hundred of those cards now, the first from the start of the summer and the most recent this morning. That is the part I actually care about. Not that the agent is clever, but that I have not stopped.

The whole health-data flow, including Apple Watch, workout-tracking app (I am using Hevy.com now) and the Health.md app, is quite interesting and probably deserves a dedicated post.

## What I learned driving it

Framework overlays age badly, thin skills age well. In March 2026 I adopted a whole workflow framework on top of Claude Code, built around the premise that context rot in a 200k window was the central problem. By June the context windows were 1M tokens, the harness had grown native equivalents for everything the framework provided, and I retired it (it was GSD, if you care). The three small custom skills written in the same month all survived and are still in daily use. The decision record is dated 10 June 2026, and the line I keep coming back to is that an overlay competes with the harness for control, while a skill composes with it.

Hard rules beat good intentions, and they have to be written down. Mine are absolute and they are in the instruction file, not in my head: the agent never commits, never pushes, never deletes anything it did not create in the current session. Every one of those rules exists because it was broken once. The delete rule cost me a Time Machine restore.

Delegated work gets adversarially reviewed. One agent implements from a written spec, a second one is pointed at the result and told to tear it apart. On the last significant change to the publishing pipeline that produced ten confirmed findings, all fixed before anything shipped. It costs a second pass and it is the single highest-value habit in the whole setup.

Trust is per-task and revocable. See: Lorenzo. And I am still the only one with publish rights, in every repo, on purpose.

Next: thirty years of digital sprawl, the decluttering project that failed three years running, and what replaced it.

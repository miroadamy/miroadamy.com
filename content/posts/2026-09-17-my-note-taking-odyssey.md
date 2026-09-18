---
title: 'Catching up: My Note-Taking Odyssey'
date: '2026-09-17 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- tools
tags:
- catching-up
- pkm
- note-taking
- obsidian
series:
- Catching-up 2021-2026
series_order: 3
---



I have always taken notes. At first on paper - there are still many handwritten
notebooks somewhere in the archives - but for the last thirty years or so most of
them, if not all, have been digital. And digital always means an application and a
format. I have tried a lot of them.

While doing so I made pretty much every mistake one can make when it comes to
choosing an application and settling on a workflow. What follows is a tour of the
graveyard: a long line of tools, most of them now dead, and the lesson each one
charged me on the way out.


## Before the note apps

Before any of it, notes lived in whatever I happened to be writing documents
with. In my Microsoft era that meant Word, and before that WordPerfect. Later I
tried Google Docs for note-taking, and Apple Notes for the same job.

They failed me for much the same reasons every time. Search was poor. There was
no linking between documents, and no meaningful way to embed one thing inside
another. And there was no simple way to tell what had changed between two
versions, though that one did genuinely improve in the later releases of Word.
The end state was always the same: I was left holding binary blobs in a
proprietary format, entirely dependent on a piece of software that somebody else
was steering, usually in a direction I did not like.

## The stations

Here are some of the note taking applications I tried and eventually abandoned.

- Evernote - the original digital brain, era now hard to even date. Used to be nice, and fast. Then it started to grow features, and eventually became slow, bloated, with complicated user interface, and utterly dependent on a fast internet connectivity.
- Quiver - the programmer's notebook, and a good one for anything with code in it. What it could not do was live alongside anything else: hard to integrate with the other places my information already was, hard to tell how a note had changed over time, and synchronising it between machines was a problem that never really got solved.
- Curio (Mac) - visual boards, and genuinely good at them. The catch only shows up later: the work lives inside a bundle that nothing but Curio can open. Stop paying for it, or simply stop installing it, and the documents are still on disk and still out of reach.
- OneNote - I gave it an honest weekend, tutorials and all, and never came back to it. Part of what I was doing at the time was leaving the Microsoft ecosystem altogether, and OneNote was the one thing pulling me back towards Office 365 and the whole Microsoft online presence.
- Notion - home for my permanent notes for years, and it grew past ten thousand pages. It is really a collaboration tool rather than a pure note-taking one. The strange combination of tables and pages with pages embedded in them was very attractive at first, and the interface was lovely. Then the number of notes grew, search became slow, and it went the same way as Evernote: bloated, hard to track changes over time, hard to link, hard to embed. Unless you are part of a team working together inside Notion, a single note-taker gets more disadvantages out of it than advantages.
- Logseq - eleven months of real investment: templates, mobile, a publishing pipeline. The split I worked to back then was simple, permanent notes in Notion and fleeting notes in Logseq. I thought this was it. It appeared at the same time as Obsidian and looked like a purely open-source version of it. It was not. Technically it is an outliner, and not everything can be expressed as an outline. The learning curve was easier than Obsidian's, which is why I picked it when I evaluated the two. A year or two later the Obsidian ecosystem had exploded and Logseq was stagnating. But I was on the right track, because Logseq was the first tool that solved the problems all the others had left me with.

Never really adopted, for the record:
	- Roam (comparison articles only),
	- DEVONthink (evaluated as a document archive, not a note tool)

## The wiki detour

Work notes went a different way. For years they lived in wikis, and the wiki
always, sadly, ended up being Confluence from Atlassian.

I even tried running my own. There was a time when Atlassian offered a free
version for up to five users, for exactly this kind of experiment, so I took it,
and then used it far less than I had hoped. The problem was the same one Notion
has: the thing is built for collaboration first. Editing, at least in the early
days of Confluence, was essentially a text box in a web page, which is nothing to
get excited about. Capturing anything was full of friction, and the whole
experience smelled too much like work for something meant to hold my own notes.

That created an interesting problem later on: keeping my local notes, which were
markdown, in sync with the Confluence ones, which were in Atlassian's own format,
sitting in a database somewhere in their cloud. I did solve it, after a fashion,
but never to my full satisfaction, and all in all it created about as many
problems as it solved.

I tried the same idea for my personal notes too, and experimented with MoinMoin
and with TiddlyWiki. I liked MoinMoin's text format. What I did not like was
having to run a server for it, and the interface was, to put it politely,
unpolished. There was friction everywhere in the workflow, and keeping it part of
my daily routine was constant work. At the time I was living in two worlds, half
on Mac and half on Windows, running a Python server on both and trying to keep
them working and in sync with each other. That was simply too much trouble.
Running a server on your own notebook was not ideal either, and mind you, this
was before Node.js and Electron made exactly that the default way to ship an
application.

TiddlyWiki did not scale for me. I also had an uneasy feeling about entrusting
everything I knew to a single monster file interwoven with JavaScript code, and
diffing a TiddlyWiki file was no fun either.

I liked the wiki model, and the linking between notes most of all, but that is a
different story for a different post.

## The switch, to the day

- 2023-04-15: the last Logseq journal entry - and, the same day, the Obsidian vault repo is created. The two-brain split collapses into one tool overnight.
- Unbroken daily notes ever since
- August 2023, one late night: the migration-planning session - between 23:17 and 00:10, notes are created planning the transfer out of Evernote, Curio and Quiver. The graveyard gets an exhumation schedule.

## What the numbers say

- Notes created per year: 365 (2023) → 165 (2024) → 1,271 (2025) → 2,639 (2026, through August). The 2025-26 explosion has a reason - that's the AI post in this series.
- ~12,800 files in the vault today, plain markdown, in a git repo

## The lesson

Every one of those applications charged an exit tax on the way out, and the size
of the tax was set by one thing, the format.

Two requirements came out of that, and they have not changed since.

The first is format longevity. Nothing beats plain text. It is not proprietary,
and nothing comes close to it for diffing and tracking changes over time, which
is what git was invented for. If notes are going to outlive the application they
were written in, the format has to be future-proof, and future-proof means plain
text, or markdown, which is plain text.

The second is control and locality. Notes have to be local first. Syncing
between two machines is a secondary problem and can be solved on its own terms,
but access to your own notes must never depend on connectivity.

Why Obsidian answered both is the next post in this series.

---
title: 'Catching up: Why Obsidian Won'
date: '2026-09-20 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- tools
tags:
- catching-up
- obsidian
- pkm
series:
- Catching-up 2021-2026
series_order: 4
---



The pitch I once wrote for a conference talk still says it best: Obsidian has a cult following "not because it's clever software, but because of what it isn't: your notes are just plain markdown files in a folder on your computer. No database, no cloud lock-in, no proprietary format. Just files."

Nothing ages as well as plain text; it has been the same since, well, files were invented. Markdown is just a very thin layer that gives the plain text some structure, and allows it to be rendered and displayed in an aesthetically pleasing way.

For me it wasn't love at first sight; I actually tried Obsidian twice, and the first attempt didn't work. The problem with Obsidian is that the plain application isn't that appealing. The functionality, or at least most of the functionality I use today, lies in a combination of plugins. There are hundreds of them, and a proper setup can be quite intimidating. Also, unlike [Logseq](https://logseq.com/), which was the application that won the first round of the transition to plain text and markdown, the Obsidian core is not open source; most of the plugins are, but the application itself is not.

## What "just files" buys you

- Future proof: every previous tool in the odyssey (except Logseq) died holding my notes hostage and forced a rescue or conversion project - markdown files in a folder cannot die that way
- Git as time machine: full history, diffs, sync - the vault is a repo. As long as you know what to do with the repo, you are covered.
- Locality: your files are your files. On your computer, not in the cloud in somebody else's database.
- (as discovered in 2025) markdown is the native format for LLMs, and the cheapest one for them to consume and produce

Lesson learned: the tooling is replaceable; the data is not. Obsidian is the current *viewer* of a corpus that would survive it and a convenient way to edit it quickly, but exactly the same thing can be done inside Visual Studio Code, inside Neovim or any other editor or environment. Hell, it's just text.

## Ecosystem blessing and curse

In the beginning I made the same mistake that many people do: I overdid it with plugins. I installed lots of them, which didn't really help things a lot. Eventually I managed to find those that are actually useful for my workflow, by going over the installed list and weeding out the ones I never used or that contributed nothing. There are hundreds, if not thousands, of videos that tell you "this is absolutely a must-have set of plugins". Some of them are even good. I watched a lot of them, but the catch is that you end up spending more time fine-tuning your note-taking system than actually working with your notes. Don't go there. It's a trap.

## How it's actually organized (three years in)

I ended up with an adapted version of the [PARA system](https://fortelabs.com/blog/para/) of [Tiago Forte](https://fortelabs.com/about-forte-labs/). If you don't know it, read [the book](https://www.buildingasecondbrain.com/para). PARA stands for projects, areas, resources, and archive, plus a daily-note journal - unbroken since April 2023. I made a few adaptations; for example, I am prefixing the main folders of PARA with a number so that they sort the way I want them to - therefore I have 1-proj, 2-area and so on. I also added an area that incubates possible future projects. I call it "forge": creating a project is a commitment of sorts, and many ideas or thoughts never reach that stage. There is also an inbox area (0-inbox) where new notes land by default, and from where they are sorted and filed during a weekly review - something I borrowed from David Allen, "Getting things done".

I have my own standards of a frontmatter discipline: note types, tags taxonomy, a `growth:` field describing a permanent note lifecycle (stages acorn → seedling → evergreen → deadwood; 500+ notes were reclassified when this scale was introduced). Today this is maintained, enforced and checked by AI; my previous attempts to do that manually were not 100% successful, but that's a different story.

The plugin shortlist that earns its keep: Templater, Dataview, Tasks, Quick Add (more on it in a dedicated post). I deliberately try hard to resist plugin sprawl; so far it is a draw ;-).

The biggest improvement comes from AI-based vault governance, where every piece of work is anchored to a project and a session protocol makes sure the progress gets tracked properly. But that's, again, something for the next post.

## Second-guessing, resolved

In 2025 I experienced an Obsidian commitment crisis after overdoing it with plugins and reaching a kind of messy state. I did a serious Logseq re-evaluation resulting in a long comparison note. The result: Obsidian stays, the plugins got trimmed and AI-based automation was added (hint: that was the time I switched to Anthropic). Lesson learned - re-choosing a tool on purpose beats never questioning it.

## Where it's going

The Obsidian vault is working area, workbench and thinking pad as well as storage.

It is the single source of truth that *publishes outward*: shared content to Notion, this very blog post from a vault folder through a staging pipeline - that story is two posts ahead.

The quiet unexpected payoff: when AI tooling arrived, a decade of notes in plain text turned out to be the perfect substrate. That's the topic of the next post.

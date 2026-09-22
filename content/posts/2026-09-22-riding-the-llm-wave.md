---
title: 'Catching up: Riding the LLM Wave'
date: '2026-09-22 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- technology
tags:
- catching-up
- ai
- llm
- claude
- copilot
series:
- Catching-up 2021-2026
series_order: 5
---

This is a history of three years - from bookmarking ChatGPT articles to an AI-managed knowledge base; with a certification in the middle and one embarrassing self-assessment along the way.

## Spectator to User (2023)

I still remember my first interactions with ChatGPT (via the web, using the free version) sometime in early 2023. I wanted to have an episode guide of an excellent HBO series called Patria, a story of a Basque family during the ETA years. So I asked for it, and what ChatGPT produced was completely, utterly, unbelievably hallucinated: 12 episodes (the series has 8), a made-up story, randomly assigned actors, two thirds of them non-existent. One huge hallucination. I did not keep the transcript, but I remember it clearly. It was very disappointing, and my conclusion was: well, this is fun, but useless.

For most of 2023 (my vault holds the first ChatGPT bookmarks) I was mostly reading about it, not working with it. Then in October 2023 I started a GitHub Copilot trial: the first AI tool that actually touched my work. It was a real improvement and made autocomplete surprisingly usable. It still hallucinated, made-up API calls and function parameters were the norm, but the speed-up was no longer ignorable. So Copilot became a paid line item through 2024, bringing with it YouTube guides, later even the certification course.

## Kicking the tires (2024)

In 2024 I was still working for Pivotree, and one area where Copilot became really useful and really good was infrastructure code. The narrower the domain, the better were the results. Copilot and Terraform were something that worked together very well, and it significantly helped processing and consuming log files and identifying a production problem. Kubernetes upgrade sucked much less, and processing large YAML files and cloud formation was significantly more bearable. The company's position on using AI tools was evolving - we didn't have any enterprise-level subscription or corporate tools at that time yet.

I became a freelancer in the summer of 2024, but my first contract was with a financial institution that had very strict security guidelines, so there was little space there for using AI. They even tried to force me to use the corporate Windows laptop, locked down - something that I despised with passion. I still remember 2 JIRA tickets, three days wait and four people involved in order to get Visual Studio Code installed on that machine. Not surprisingly, the contract did not last long, and I made sure that banks and other financial institutions that insist on corporate notebooks are on my "sorry not interested" client list.

## Shopping phase (2025)

Being a freelancer who is not under financial pressure to find and accept the next contract is a very enviable position to be in. So I was very picky when searching for my next assignment; but eventually I found a startup that needed to convert its existing infrastructure into IaC. It was a great match and a great application area for really using language models. In addition to the GitHub Copilot subscription, I started to pay for Cursor and I was very impressed how much it improved my daily workflow.

I was aware of the new kid on the block, called Claude, but I was resisting the temptation for some time. My notes from that period reflect it. I was trying to justify to myself sticking with something that worked quite well, rather than jumping into completely new territory (especially when the new territory had a pretty big price tag) - notes about Cursor vs Claude Code comparisons piling up in the mid-2025 watchlists ("Why I QUIT Claude Code for Cursor" et al.)

Sometime around June 2025 I started to use MCPs, and after buying a new M4 MacBook Pro with 48 GB of RAM, to experiment with Ollama and local models.

Cursor did deliver, but also made me aware of its limitation: the ability to control the context and steer the code generation the right way. The recurrence of falling into the same traps and repeating the same mistakes over and over was what made me look around and start reading about Claude.

## Commitment phase (2026 - Hello Anthropic, take my money)

I started in December 2025 with Claude Code, properly this time - reading about it, taking courses, watching tutorials.

Unlike with Cursor, the key discovery with Claude was that I could use it not only for writing code, but for everything other than writing code, especially for my notes. The moment is captured on 2026-02-27, verbatim from the journal: "I've started to use Claude more inside my vault than for the code generation / review".

The money trail confirms the story: on 2026-03-06, an Anthropic Pro subscription. Capacity exhausted within a week. On 2026-03-13, Max 5x; from May 2026, Max 20x.

Claude became part of almost all of my workflows. I went from state "I am new to this" to Claude Certified Architect (Foundations) in nine months (June 2026).

## What settled it

To sum it up: Copilot was autocomplete; Cursor was an editor; Claude Code turned out to be a colleague - the difference is agency over files, tools and long tasks, not model quality alone.

I took on multiple concurrent projects with the ambitious goal of organizing, deduplicating and finishing my digital archives and universe for the first time in 40 years (some of them are [listed here](https://miro-adamy.gitlab.io/#contributions)).

Funny fact: one of the projects is the migration of most of my data away from US-based cloud providers (AWS, Google, Apple) to local-first storage, backed up inside the EU. And the standing irony, recorded the day the migration project started: "The irony of me using the US based LLMs to solve this problem is not lost on me :-)"

What "a virtual colleague" means in practice - agents, skills, a vault they co-manage - is the next post.

---
title: 'Catching up: Taming the Online Storages'
date: '2026-10-03 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- lifehacks
tags:
- catching-up
- cloud-storage
- declutter
- icloud
series:
- Catching-up 2021-2026
series_order: 10
---



In July 2023 I sat down to list every place my files lived. The list had eight entries - seven online storages and one line for "external volumes" - and at the bottom a checkbox: "Finish this list". It stayed unchecked for three years, which tells you everything about the problem.

In the [earlier post about reorganizing my digital life](/posts/2026-09-24-reorganizing-my-digital-life/) I described the big picture: the Data Map, the disk catalog, the new NAS. This one zooms in on the clouds, one by one.

## The zoo, as found

Two NAS boxes at home. A paid, end-to-end encrypted cloud ([Tresorit](https://tresorit.com/)). Two Google Drives, one personal and one for the company. [iCloud](https://www.apple.com/icloud/), [OneDrive](https://www.microsoft.com/en-us/microsoft-365/onedrive/online-cloud-storage), [Dropbox](https://www.dropbox.com/), a backup service ([Backblaze](https://www.backblaze.com/)), some files in [AWS S3](https://aws.amazon.com/s3/), and a [Notion](https://www.notion.com/) workspace. Plus 23 external disks in a drawer.

None of them was chosen for a purpose. Each one grew a purpose by accident: downloads landed wherever the browser pointed, and when I retired an old computer, its files went to whichever storage had free space that week. I always believed every kind of information should have its home. The homes just multiplied faster than the rules.

## What each one became

Tresorit is gone - almost. I copied every file to the NAS and verified each one by checksum: 35,219 of 35,220. The one that did not make it was an empty PDF that could not be read even at the source. I did not delete anything there; the subscription simply runs out at the end of October, so if something turns out to be missing, it is still there until the last day.

The irony is not lost on me: the most European of my cloud providers is the one I am leaving. I am generally trying to depend less on American providers, but this decision was purely pragmatic. I needed something with an API, something Claude can work with on its own. Tresorit, however good at security and privacy, is primarily a tool for mirroring a local disk to the cloud. Perfect for a person with one computer, but not for my grand plan of bringing several tiers of storage back together. No API and patchy support for NAS and Linux made it the latest victim, after Backblaze.

iCloud was the biggest surprise. I started it as a cleanup and it turned into a rescue. About 250 GB in 187,000 files, and 91% of them were only placeholders on my Mac, with the real content in the cloud. Much of it came from old computers I had copied there years ago, and some of it existed nowhere else. What made it manageable was realizing that the drive breaks down into about fifteen decisions, not 187,000 files. Each old machine, each photo dump, each project folder is one decision. Checked against the disk catalog, the amount of data that existed only in iCloud went from 114 GB in early August to 16.6 GB in early September. Nothing has been deleted yet, and the 2 TB family plan stays. Space was never the problem.

OneDrive lost its biggest job first. It held a 116 GB copy of my ebook library, which I deleted in July once the library had a proper home on the NAS. The surprise was on the Mac side: OneDrive also kept a hidden 44 GB local cache, which I only found when I went looking for missing disk space.

My company's Google Drive (Klassify) turned out to be much smaller than its plan. Measured, it held 7 GB, so it moved from the 2 TB plan to the smallest one. My personal Google Drive is the honest open item: it is still not catalogued, and for now it is only a fallback.

Backblaze was mercilessly cancelled. Its final export, 741 GB and 1.3 million files, sits on the NAS, now also in the offsite backup. Sorting what is actually in it is a project of its own, for later.

Dropbox and the Downloads folder are demoted to landing zones: things arrive there, and then they are supposed to drain into the NAS. "Supposed to" is doing a lot of work in that sentence - both cleanups are still on my list. The files in AWS S3 are on the same list.

Notion is transitional. The content I care about now lives in my Obsidian vault and gets published from there. The old workspace stays dormant; the family pages will be unshared, not deleted, once the family actually uses the new sites.

And the NAS is the master. Its shares are not split by content type but by how the content is used, and how sensitive it is: curated documents sit behind access control, while media is something any device I point at it may play. The old NAS is drained, and the disk catalog now knows about 10 million files, 12.8 TiB in total.

## The rules that made it converge

One home per class of data. Everything else is either a copy or a funnel into that home.

Nothing is deleted from any cloud until the NAS has a backup plan for that class of data. A rescue must never leave me with fewer copies than before. That is why the [offsite backup post](/posts/2026-10-01-offsite-backups-with-restic-and-hetzner/) comes before this one, and why the iCloud rescue has not deleted a single file yet.

Catalogs before decisions. You cannot triage what you cannot enumerate. Every exit started by comparing the cloud against the disk catalog, and most of the time the answer was "you already have this".

## Where it stands

Fewer storages, each with a job. One paid subscription is running out, another is already cancelled, and the drawer of disks is now a searchable catalog. Still open: the personal Google Drive, the Dropbox and Downloads cleanups, and the rest of iCloud.

And that checkbox from 2023? I can finally tick it - by deleting the list.

This was the last of the infrastructure posts. The two remaining parts of the series step away from disks and clouds. Part 11 goes back to the early 2000s, to a one-man company in Canada called Miro Adamy Software Solutions, and follows it through Thinknostic, Thinkwrap and an acquisition, back to a one-man company again. Part 12 is about what changed along the way, and what I want to do next.

Next in this series: full circle, from a one-man company to a one-man company.

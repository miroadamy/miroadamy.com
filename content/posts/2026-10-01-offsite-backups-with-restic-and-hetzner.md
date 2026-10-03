---
title: 'Catching up: Offsite Backups That Let Me Sleep'
date: '2026-10-01 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- devops
tags:
- catching-up
- backup
- restic
- hetzner
- synology
series:
- Catching-up 2021-2026
series_order: 9
---



Consolidating a digital life onto one NAS has an ugly side effect: everything now burns in the same fire. In the previous posts I described how I moved decades of files, photos and documents onto a single [Synology](https://www.synology.com/) box at home. This post is about the second half of that story - getting a copy of it out of the house, encrypted, in a way that lets me sleep.

## Picking the provider

The first lesson was that where a company keeps its servers and where it is registered are two different things. [Backblaze](https://www.backblaze.com/) has European data centers, but it is a Californian company, and the US CLOUD Act follows the company, not the building. For a family archive I wanted a European company in a European data center.

Price was the second filter, and the sticker price lies. AWS S3 Deep Archive looks like a great value - dollar per terabyte per month - until you want the family archive back, and two terabytes of restore cost $180 or more in retrieval and egress fees. Wasabi charges every object for a 90-day minimum, whether you keep it or not.

I ended up with a [Hetzner Storage Box](https://www.hetzner.com/storage/storage-box/): a German company, a data center in Falkenstein, and no traffic charges in either direction. A restore costs nothing, however big. It started as a 1 TB box for a few euros a month, and when I decided the audiobooks should go offsite too, it grew to 5 TB, for a bit over 13 euros a month.

## Picking the tool

I had just left a cloud vendor, so the question I asked every tool was: how hard is it to leave you? [restic](https://restic.net/) won on exactly that. The same repository format writes to SFTP, S3, Backblaze B2 and anything [rclone](https://rclone.org/) can reach, so changing provider later is a copy, not a new upload of everything. [Borg](https://www.borgbackup.org/) was the runner-up, but its repositories only live on hosts that run Borg itself. Choosing the tool with the narrowest exit right after escaping a vendor would have been the wrong lesson. [Kopia](https://kopia.io/) looked nice, but it is still at version 0.x, and for twenty years of family video I want the boring, mature option.

restic has no scheduler of its own, so [Backrest](https://github.com/garethgeorge/backrest) runs it on the NAS every night, and [healthchecks.io](https://healthchecks.io/) sends me an email when a run fails - or when it does not happen at all.

What about ransomware? The textbook answer is Object Lock, storage that cannot be overwritten. It turns out to be incompatible with deduplicating backup tools, because cleaning up old snapshots rewrites data files. Hetzner's own daily snapshots of the box cover that case instead. They can be deleted only from Hetzner's web console, and that login never touches the NAS.

## The architecture in five sentences

Everything is sorted by what is at stake: the irreplaceable first (family photos and videos, documents, my notes), then what is expensive to rebuild (the ebook and audiobook libraries), and only then the rest. Each top-level folder gets its own repository, its own storage sub-account and its own passphrase, so a leaked credential exposes exactly one of them, not all ten. Everything is encrypted on the NAS with AES-256 before it leaves the house, so Hetzner stores data it cannot read, subpoena included. The NAS backs itself up, never through a laptop that happens to have the share mounted, because an alarm must not share a failure domain with the thing it watches. And the upload is throttled to 2 MiB/s, so the household internet survives it.

That throttle has a consequence: the first upload is the project. On my line it took days per folder and a few weeks for all of it, 2.6 TB in the end. The nightly runs afterwards take minutes. And a restore comes back about eight times faster than the upload went.

## The laptop is a special case

The MacBook was the one machine I got wrong first. The obvious setup was Time Machine over SMB to the NAS, and I ran it that way for a while, over a wired connection. It was unusably slow. A full backup took the better part of a day, and whenever a backup was interrupted, which happens to a laptop that gets closed and carried around, Time Machine threw away its reference snapshot and spent the next fourteen hours re-reading the whole disk before it copied a single new byte. The problem is not bandwidth. Time Machine over a network share is bound by latency, one small round trip per file, and a million files on a developer's laptop add up to hours no matter how fast the cable is.

So the laptop now has two layers instead of one. The first is boring on purpose: an external SSD and plain Time Machine. It is the layer for the day the disk dies, because it restores the operating system, the applications and the home folder in one go, exactly the way Apple intended. The second layer is restic again, running on the Mac itself, not on the NAS, writing over SFTP into its own share on the NAS with a long list of exclusions for things that are already safe elsewhere or can be rebuilt. Where Time Machine over SMB crawled, restic saw the same files as a stream of content-addressed blocks and never asked the server about each one.

The offsite part of the laptop backup is then the NAS's job, not the laptop's. A second restic instance on the NAS copies the blocks of that repository to Hetzner, so the Mac never talks to the cloud at all, and the same rules apply as for every other tree: encrypted before it leaves the house, its own credentials, its own alarm. If the laptop is lost or stolen, the SSD brings back the system, and the Hetzner copy brings back the work.

## War stories, all earned

Estimates lie. My documents folder came in 93% over the size I had designed for. Measure, don't extrapolate.

Synology hides a trap for restic users. Deleted files go into a `#recycle` folder, and I excluded it in an exclude file. But in that file, a line starting with `#` is a comment, so the exclusion silently did nothing - while the next line, `@eaDir`, worked fine and made everything look correct. I confirmed it with a throwaway repository and now pass the excludes on the command line:

```bash
restic backup /volume1/REFERENCE --exclude '#recycle' --exclude '@eaDir'
```

Absence must alarm. My notes vault reaches the NAS through a separate copy job from my Mac. I found out that job had quietly run exactly once, six weeks earlier - so the offsite backup was faithfully protecting a stale copy. A success notification does not catch a job that never runs. Now the NAS refuses to back up that folder if the copy is older than 36 hours, and the refusal raises the same alarm. It has already fired for real: I was travelling, the Mac slept on battery, and the Tailscale connection from the [previous post](/posts/2026-09-29-tailscale-everywhere/) cannot wake a sleeping laptop.

The alarm itself is proven. Over the first weeks, all three ways it can go off actually happened: a run that failed, a run that started and did not finish in time, and a run that never started. Each alert arrived on the minute.

The passphrase is the real risk, not the provider. Lose it and the backup is gone as surely as in a fire. So escrow is part of the deliverable: the password manager, plus a printed sheet with hand-written passphrases, tested by typing one from paper on another machine and opening a repository with it.

A credential prompt is only ever typed into a real terminal. Once, a sub-account password ended up in an AI chat transcript instead of an SSH prompt. The damage was limited to one folder by design, and I changed the password the same evening. The design assumption "credentials leak eventually" paid its rent.

Deduplication has pleasant surprises. When I unzipped a few hundred audiobook archives, I expected to upload about 250 GB of new data. restic uploaded 72. Audio does not compress, so the bytes inside the zip files were almost the same as the extracted files, and restic recognized them. It also means reorganizing folders later costs almost nothing.

And finally, restore drills. Every folder except the newest one has already been restored from the cloud at least once, and a single lost document comes back in about three seconds. That number, not the upload speed, is what the whole project buys.

Next in this series: [taming the online storages](/posts/2026-10-03-taming-the-online-storages/).

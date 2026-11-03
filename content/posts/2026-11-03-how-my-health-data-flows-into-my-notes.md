---
title: How My Health Data Flows Into My Notes
date: '2026-11-03 00:00:00 +01:00'
type: post
author: Miro Adamy
categories:
- devops
tags:
- health
- apple-watch
- hevy
- obsidian
- automation
- ai
---



In the [post about Obsidian and Claude](/posts/2026-09-23-obsidian-plus-claude/) I said that the health-data flow deserves a post of its own, and the [last part of the series](/posts/2026-10-05-what-changed/) promised it again. Here it is: how numbers from the watch on my wrist and the app on my phone end up in my notes every morning, without me touching anything. The reason it has to be every morning is [Feri, my LLM coach](/posts/2026-10-27-feri-my-llm-coach/): he prescribes the next session from that morning's data, and he is only as good as what he is given.

## Why bother

The same way Sheldon Cooper from "The Big Bang Theory" likes trains, I like data. Maybe it is a professional deformation from the decades spent in DevOps, where data (read: log files) was the most important way to get information about pretty much everything. This information, plus an understanding of how things work, was critical for making adjustments, fixes and improvements to any system. Including the human body. So it will not come as a surprise that I like having, collecting and processing data about the body I am stuck with. Oh, and I also like trains, by the way.

I have worn an Apple Watch since 2016. It has been recording heart rate, HRV, sleep, VO2max and every workout the whole time, and for most of those years I looked at the numbers exactly the way Apple wants me to: in the Health app, one ring at a time (I'm on my third watch now, and the Ultra series are really good).

## Two sources, one destination

Two things produce the data.

The watch. Daily metrics and a heart-rate sample every few seconds during a workout.

The workout-tracking app. I logged every gym session in Strong for 3 years, and in July 2026 moved to [Hevy](https://hevy.com). The migration moved 5,371 sets and I checked the count on both sides. The main reason I switched was that Strong, great as its iPhone app is, was an iPhone app only. Period.

Hevy is also an iPhone app, but one backed by a website, and that website has an API. Which means that you or the LLM can create workouts, read the data, and essentially collaborate on preparing the training. With Strong all of this had to be done on the iPhone with human fingers, which was cumbersome, took a long time, and I didn't really like it.

All my notes live in Obsidian. All my planning is done in Obsidian. So I was looking for something that lets me have the data in Obsidian and do the planning there too. With an API and an LLM, you can do exactly that.

The vault is where the training plan, the exercise library and the coach live, so that is where the data had to land. Not in a dashboard somewhere else, in the same folder tree as everything else I think about.

## The constraint that shapes everything

There is always a catch (thank you Apple).

HealthKit, the store behind the Health app, can be read only on the iPhone. The Mac cannot open it at all; Apple disabled that on purpose. So every pipeline starts on the phone and has to find a way to land files on the Mac. That one fact rules out most of the clever options and explains the shape of what follows.

## Attempt one: the chore

The tool I picked in July 2026 is [Health.md](https://github.com/CodyBontecou/health-md), an open-source iOS app by Cody Bontecou that reads HealthKit and writes Obsidian-ready Markdown: one note per day, forty-odd metrics in the frontmatter, a readable body below. Markdown is not the only option - the tool note lists Health Auto Export plus a converter script (paid automations), healthkit-to-sqlite (good for a one-off backfill, not daily), and plain Shortcuts (clumsy for sleep stages and HRV).

The first version of the flow worked like this. Every day I opened Health.md on the phone, pushed yesterday's export to the Mac companion app over Wi-Fi, which wrote the note into the vault. Then I opened Hevy, exported the workout history as CSV into an iCloud folder. Then I ran a script. Then I asked the AI coach for the next session.

It worked. It also meant four manual steps a day, and by late August the pattern was clear: the days I skipped the export were the days I skipped the coach, and the coaching was the point.

## Attempt two: zero touch

On 27 August 2026, after a two-hour discussion with Fable, both inputs went hands-off in one evening.

Hevy first. Instead of exporting the CSV, a script pulls the workout history straight from the Hevy API: every workout changed since the last run, patched into a local cache, then written out as a CSV in exactly the shape the phone export used to have. I checked it against a real export, column by column, and the two parsed identical: same 14 columns, same local timestamps, 6,240 set rows at the time. Nothing downstream changed. The exercise notes, the coach, the charts all keep reading the same file; they just do not know anyone stopped exporting it.

Then the watch. Health.md has a scheduled export. Every day at ten the phone writes yesterday's daily note into a folder on iCloud Drive by itself, and the Mac sees it a few minutes later. A second scheduled export, a few minutes after the first, writes a small JSON file with the raw samples: every HRV reading the watch took, roughly one every two hours, and the full heart-rate series of every workout. A script turns those into a monthly note with time in each heart-rate zone per workout and the HRV readings grouped by time of day. That replaced the screenshots I used to take of the zone chart on the phone, which was the most annoying step of all.

![health-zones-note.jpg](/img/vpub/health-zones-note.jpg)

The Mac companion app is still installed. It is used for the occasional manual backfill and nothing else.

## What runs

One shell script, idempotent, safe to run any time.

1. Pull the Hevy history from the API, regenerate the canonical CSV.
2. Copy any new or newer daily note from the iCloud folder into the vault.
3. Parse the JSON samples into the zones note.
4. Regenerate the training-history block in every exercise note from the CSV: charts, summary, last twelve months. The human text above a marker line is never touched.
5. Recompute the dashboard: seven-day and thirty-day HRV, resting heart rate, VO2max and exercise minutes against an eighteen-month baseline, a count of hard days, and a recovery flag that says back off when HRV is low and resting heart rate is high at the same time.

Here is a snapshot of the PDF exported from Obsidian, the dashboard is intentionally made ridiculously small and unreadable so that it gives you an idea, but doesn't really reveal too much personal data.

![health-dashboard.jpg](/img/vpub/health-dashboard.jpg)

The daily notes go back to 2020. There are about 2,400 of them, and they are plain Markdown, so a query over six years of sleep or resting heart rate is a Bases table or a few lines of pandas, not an export from somebody's cloud.

## Things that went wrong

Three, all instructive.

The first scheduled JSON had no samples in it. I had read the documentation, concluded the plain export carried the HRV readings and heart-rate series, and built the parser against a one-off sample that did. The first unattended run proved me wrong: 11 KB, every sample array null. The arrays came only with the "lossless" setting, which also drags along over 30 MB of raw records per training day. The fix was a second export profile, heart and workouts only, zipped, into a subfolder. A few days later a new app version added a "detailed time series" level that carries exactly the arrays and nothing else, and two days of samples came to under 300 KB zipped, against 1.5 MB for a single lossless training day. Lesson: a parser written from one sample file knows about one sample file.

The subfolder setting was app-wide, not per profile. The day I set the second profile to write into a subfolder, the first profile's daily notes started landing there too, and my copy step only looked in the top folder. Two days of data sat unseen until the coach noticed the dailies had stopped. I found the reason in the app's source: one global value, read at export time by every profile. Lesson: when a setting misbehaves, read the code, not the settings screen.

Sleep belongs to the evening it starts. Apple files a night under the date you went to bed, so the morning export of "today" holds at most a nap, and the full night appears only when the day is exported again the next day. For a while the dashboard treated today's row as complete and reported a sleep collapse that never happened. Now today's row is excluded from every average and the coach is told never to gate recovery on it.

## What it is for

All of this exists so that one agent can read it. [Feri, my LLM coach](/posts/2026-10-27-feri-my-llm-coach/), is the point of the whole pipeline, and he is exactly as good as the data he is given. Every run of the coach reads the fresh dailies, the zones note and the Hevy history, locates the week in the plan, and prescribes the next concrete session as a card in the vault. On a stale export he prescribes for yesterday's body. I have not exported, uploaded or screenshotted anything for him since the end of August, and that, more than any single chart, is why the coaching has held.

Feri produces plan that has two parts: a brief one intended to read on the phone, and a detailed one that explains an an extends the information in the first one. Here is a screenshot of an example note that Feri produced

![feri-note.jpg](/img/vpub/feri-note.jpg)

And here is how the note looks on the phone in the gym:

![feri-gymn-card-phone.jpg](/img/vpub/feri-gymn-card-phone.jpg)

## What it is not

This is not a quantified-self project. I do not live by data and I do not look at the numbers daily, the agent does; the data is for decisions, not for a dashboard to admire.

The main idea is steering, capture the trend, and adjust before it's too late.

Best of all, the data sits in the files I own, in a folder I back up, in a format that will open in 2040.

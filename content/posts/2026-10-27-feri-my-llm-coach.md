---
title: Feri, My LLM Coach
date: '2026-10-27 00:00:00 +01:00'
type: post
author: Miro Adamy
categories:
- technology
tags:
- fitness
- coaching
- claude
- ai
- obsidian
---



In [the post about Obsidian and Claude](/posts/2026-09-23-obsidian-plus-claude/) Feri got one paragraph, as the only agent in my vault named after a real person. He deserves a post, because he is the reason the rest of the health machinery exists. The watch, the lifting app, the daily export, the scripts that turn it all into notes: none of that was the goal. The goal was to have a coach again.

## The real Feri

I got my first personal trainer in Spain. His name was Carles and he was fantastic. We originally started working on certain pains and injuries I had picked up while pushing myself to performance levels that were, in hindsight, obviously meant for younger and fitter bodies. Carles was very well versed in physiotherapy and his exercises worked.

What a good personal trainer does is not what the gym brochures say. He does not motivate you, and he does not design a programme once and hand it over. He stands next to you and corrects. He sees that the bar moved badly on the third rep and changes the weight. He notices that you came in tired and quietly swaps the plan. He stops you from doing the stupid thing you were about to do because you felt good that day, and he makes you do the boring thing you were about to skip. The programme is the smallest part of it. The correction is the job.

When we moved from Spain to Bratislava, I obviously lost Carles. By a fortunate coincidence, there was a gym about two minutes' walk from where we live, so I continued going there, first on my own. After several months of on-and-off attendance and a few self-inflicted muscle problems, I found Feri. His real name is František, Feri for short, and we worked together for over two years. He taught me a lot of useful tricks and pretty much everything I know about weightlifting.

The tricky part with a personal trainer is scheduling. It must work for both parties, and ideally avoid the gym's rush hours. Feri had a day job in shifts and I was on a variety of projects, with unpredictable emergencies, last-minute meetings and so on. To gain more flexibility and room for impromptu training, I started going part-time on my own and part-time with Feri. Then our lives diverged even more: my travelling, Feri's new job and his new family obligations made it fairly complicated.

When that stopped, I kept training, and the two things I lost were exactly the two a trainer provides: somebody who knew what I had done last time, and somebody who would tell me no.

## What I wanted back

Training along with the app, I was pretty much plateauing. I didn't really improve, didn't really fall off the wagon, and here and there I pulled a muscle or overdid something.

So in July 2026 I sat down with Claude and designed a replacement for the one function I missed. The design note is blunt about it: the point is "the correction the real Feri used to provide in person", and the failure modes it names are over-training and under-training, in that order. Not a chatbot to talk to about fitness. Not a dashboard. An agent that knows the data, the routines and the goals, prescribes the next concrete session after each day's data arrives, keeps track of progress, and says no when the numbers say no.

I called him Feri 2.0, and the name is not a joke. It is a specification.

## How a session gets prescribed

Feri runs when I ask him to, in the evening, after the day's data is in. He does not run on a schedule, because a card written before the day's export is written on yesterday's data and gets redone, which I learned the expensive way.

Each run does the same five things:

1. Read what came in: the Apple Watch daily note for today and the days since the last run, the lifting history from Hevy, the heart-rate zones for every workout, and whatever I dictated about how it felt.
2. Check recovery first. Morning heart-rate variability and resting heart rate against my own baseline, sleep, how many hard days in the last thirty, any flag I have raised about a sore back or a tired ankle.
3. Find where I am in the week. The weekly template has two strength sessions, two quality cardio sessions at least seventy-two hours apart, loaded commutes in between, and a daily ten minutes of mobility work.
4. Prescribe the next session, concretely. Exact weights and reps for a strength day, exact incline, speed and interval protocol for a cardio day, exact minutes and heart-rate band for an easy walk.
5. Write it down as a dated card in my Obsidian notes, so that I can read it on my phone in the gym, and update his own memory.

The card is the product. This is one of them:

![feri-gymn-card.jpg](/img/vpub/feri-gymn-card.jpg)

*A strength-day card on the phone, in the gym: the end of the mobility block, then the lifts with exact sets, and a fallback for every machine that might be busy or broken.*

Two things about the card matter more than its content. It has a section called "How it felt" that I fill in after the session, and that becomes the next run's input, so the loop closes on my words, not only on the watch. And it is written for a phone screen in the gym, not for an analyst: what to do, in what order, with the reasons at the bottom for when I want them.

The most verbose part of the card is meant to be read at the computer and gives me a high-level overview. The exercises are cross-linked to per-exercise Obsidian notes, which Claude created from his knowledge of each exercise, with YouTube videos and additional information on how to do it.

## What he is firm about

The design meeting made one decision I would make again every time: the recovery gate is firm. If the morning numbers say the body did not recover, the day is downgraded to an easy walk or mobility work, automatically, before I get a say. I can override it. The point of making the override explicit is that overriding is then a decision I take on purpose instead of a default I drift into.

The rest of the rule book he carries is short and came from the real world, not from a textbook:

- Two or three reps left in the tank, never to failure. The progression bar is two sets of ten at a weight, counted from the first set, before the weight goes up.
- Two quality cardio sessions a week, never three, and at least three days between them.
- A sore low back walks as much as it likes and carries nothing. A carry injury is re-injured by carries, so carries come back below the last working load, not at it.
- A hill hike of two hours and a few hundred metres of climbing is a quality session. It replaces the Sunday tempo, it never stacks on it.
- Medication is in the model: certain medication makes soreness linger, so the cool-down is not optional and lingering soreness is not a sign of overtraining.
- Anything that is not ordinary muscle soreness, anything that runs into a leg, anything that is worse on a morning after nothing, goes to the doctor, not to the coach.

None of this is novel. What is new is that it is applied every single day by something that never gets bored of applying it.

## His memory

A coach without memory is a brochure. Feri's memory is three plain-text notes in my vault, and the structure took two failures to get right.

The first version was one note that he read at the start of every run and appended to at the end. It outgrew a single read, so the session history now moves periodically into an archive he does not read unless asked to trace how a decision was made.

The rules that hold now are strict. The state note is capped at two hundred lines and says only what is currently true: open flags, the current working weights, this week and last week. A closed flag is deleted the run it closes. A lesson enters the rule book as one rule with a date and a link, never as a story. The story goes to the archive, verbatim, because it is my training history and I keep everything.

## Where he was wrong

He has been wrong, and the interesting thing is what kind of wrong.

He read a number as if it were a choice. Three times in the first weeks he criticised my walking volume, once for overshooting a fifteen-minute prescription by a third. I had to get to work, the office was further away than usual that day. The rule that came out of it: ask whether the route was mine to pick. Where I live, distance is often imposed.

He reported a recovery collapse that never happened. A morning note showed heart-rate variability dropping to 43.9, and the week's plan changed. The real value was 48.3, a mild dip. The export of "today" is always incomplete, because the night's sleep is filed under the date you went to bed and arrives a day late. The rule now: never gate recovery on today's note.

And once he was wrong because I was. His rule book lived inside a folder my own safety settings would not let the agent write to, so for nine days every "update the digest" step failed silently and he kept recommending a machine I had retired. The fix was to move the file, not to loosen the rule, and it produced a principle I now apply everywhere: a skill folder holds method, state lives in the notes.

Every one of those became a rule, and the rule has a date and a link to the day it was learned. That is the part a human coach cannot do. The real Feri corrected me in the moment and then could forget the correction by the following week, as any human would. This one does not.

## What changed in the training

To sum it up: the weights moved every three to four weeks instead of sitting still for months, and nothing hurt for long.

The one injury of the block is instructive. At the end of August I strained my lower back carrying something heavy in the garden, and re-aggravated it three days later carrying buckets. Neither was a session he prescribed; it happened outside his coaching, and he could neither cause it nor prevent it. What he did was respond like a trainer: an override rule the same day, everything loaded off the plan while the back was sore, walking kept, carries brought back five weeks later at a lower load than before, and a red line for when to stop coaching and go to a doctor. The back has been quiet since mid-September.

The other thing that changed is what counts as training. In October we moved gardens, which meant weeks of digging, a motor auger and root balls. Feri read the watch data from the first garden day, saw two hours at tempo heart rate with peaks well into the hard zone, and reclassified it: the garden is the training. Intervals paused, strength went to one short maintenance session a week, and the garden days got their own rules, a cap on active hours summed over the day. A human coach would have said the same thing. The difference is that this one saw it in the data before I thought to mention it.

## What he is not

He is not a doctor, and he knows the line. He is not motivation; I have never needed to be talked into training, I have needed to be talked out of it. He is not a conversation partner, I do not chat with him, I ask for the next session and read the card. And he is not autonomous: he runs when I ask, on data I own, and writes into files I can read and edit.

Oh, and by the way, inspired by Feri, my wife's also created her own Claude based running coach. He lives on her computer in a skill named Carles ;-). 

There is one condition on all of this. Feri is exactly as good as the data he reads, and no better. A card written on a stale export is a card for yesterday's body. The weeks he coached worst were not the weeks his rules were wrong, they were the weeks the data did not arrive property, because I had skipped the export, and the days I skipped the export were the days I skipped the coach. So the real engineering in this project was never the coach. It was making sure that every morning the watch, the lifting app and my own notes land in his folder without my lifting a finger. How that works, and what went wrong on the way, is the next post.

---
title: 'Talking to My Computer: Three Dictation Tools in One Year'
date: '2026-11-22 00:01:00 +01:00'
type: post
author: Miro Adamy
categories:
- tools
tags:
- dictation
- speech-to-text
- soniox
- tools
- ai
---



I talk to my computer for a living and for entertainment now. Not in meetings, I mean it literally: most of what I "type" into a terminal, into notes and into the chat window of an LLM, I say out loud. A year ago I typed all of it. This is the story of how I got from one to the other, through three tools, and what it ended up costing.

## Why dictate at all

Two reasons. The first is speed. I think faster than I type, and when the reader on the other end is a language model that needs context, the difference between a two-line prompt and a two-minute explanation is the difference between a mediocre answer and a good one. Nobody types the two-minute version. Everybody can say it.

The second reason is my particular problem: I do not speak one language. My working day is English, my private life is Slovak, there is Czech in my head from books and films, Spanish from the years in Valencia, and they do not stay in their lanes. A sentence that starts in Slovak and ends in English is normal for me. It is not normal for most speech recognition, and the outcome is often hilarious.

That second reason turned out to be the whole selection criterion.

## Attempt one: Wispr Flow

In the autumn of 2025 I started with Wispr Flow, the dictation app that every productivity video was recommending at the time. Hold a key, speak, and polished text appears wherever the cursor is. When it worked, it felt like the future.

When it did not work, it looked like this. I dictated a perfectly ordinary English sentence complaining that the tool had been erratic that day, and what landed in my note was Serbo-Croatian. Not a translation of what I said. Invented Serbo-Croatian.

I do not speak Serbo-Croatian. I assume the model heard a Slavic accent, decided which Slavic language it liked best, and filled in the rest. The next sentence came out in English again, as if nothing had happened.

In Slovak it was the other way round: a slang word or a Czech expression was enough to flip it into another language mid-sentence, and a phrase said a bit too fast came out as confident English nonsense. For someone who speaks one language cleanly, Wispr Flow is probably excellent. For me it was a tool I had to proofread every single time, and a dictation tool you have to proofread is slower than typing.

## Attempt two: Spokenly

In June 2026 I moved to Spokenly. The idea is the same, hold a key and speak, but Spokenly does not insist on one speech model. It offers a list: models that run on the Mac itself, models hosted by Spokenly, and models from other providers.

I took the Pro subscription, at $10 a month, and it was better straight away. The language switching mostly stopped. I would have stayed there, paying monthly, if I had not looked more closely at that list of models. I also had a nagging suspicion that $10 a month was paying for far more speech recognition than I could ever use.

## What I actually wanted: Soniox

One of the models on the list was from Soniox, a company that does one thing, speech recognition, and sells it by the hour of audio through an API. It was the one that handled my mixed sentences best. It simply writes down what I said, in whichever language each part of it was, and does not try to be clever.

And the app let me bring my own key. Instead of paying Spokenly a subscription to reach Soniox for me, I could open an account with Soniox, put ten dollars on it, paste the key into the app, and have my audio go from my Mac straight to them.

![dictation-spokenly-model.jpg](/img/vpub/dictation-spokenly-model.jpg)

So I did, on the same day. The subscription ran out a month later and I never renewed it.

Here is what five months of daily dictation cost.

![dictation-soniox-usage.jpg](/img/vpub/dictation-soniox-usage.jpg)

Ten dollars paid in June, 20 more added in November. By the end of November I had used 6.11 of them. That is a little over a dollar a month, for something I use many times every day. The subscription it replaced would have cost me $50 in the same period instead of less than $7.

I am not saying this to complain about subscriptions. A subscription pays for an app somebody has to build and maintain, and that is fair. But it is worth knowing what the thing underneath actually costs, because the gap is not ten percent. It is an order of magnitude.

## The catch

There is one, and it would be dishonest to leave it out.

The current version of Spokenly no longer offers this. The option to use your own Soniox key was removed in the spring; the changelog gives Soniox's terms of service as the reason. Spokenly still offers Soniox, but as one of the cloud models it runs for you inside the Pro subscription. If you install it today, you can bring your own key for several other speech providers, but not for this one.

I am still on an older version, and I know that is borrowed time. One day it will stop working, and then I will either pay for the subscription again, with no hard feelings, or move to another app.

## Where that leaves me

On the Mac, the question is settled for now: one key, hold it, speak, and the text is where the cursor is, in whatever mix of languages came out of my mouth. For recordings that already exist as files I use MacWhisper, which transcribes on the Mac itself. Apple's built-in dictation I have stopped using entirely; it follows the keyboard language, and my sentences do not.

The phone was another story. The iPhone version of Spokenly does not take a Soniox key, the transcription apps I tried were no better at my language soup than Wispr Flow had been, and for a long time my quick voice notes from the phone were a pile of audio files that nobody ever listened to again. Including me.

But once you have an API key that turns speech into text for about ten cents an hour, you start looking at every microphone you own differently. The next post is about what I built with it: one button on the phone, and the thought is in my notes half a minute later.

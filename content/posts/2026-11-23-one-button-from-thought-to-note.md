---
title: One Button From Thought to Note
date: '2026-11-23 00:02:00 +01:00'
type: post
author: Miro Adamy
categories:
- lifehacks
tags:
- dictation
- speech-to-text
- soniox
- iphone
- obsidian
- automation
---



In the [previous post](/posts/2026-11-22-talking-to-my-computer/) I described how I ended up with a speech-to-text service that understands my mixture of Slovak and English, and how little it costs when you pay for it directly. This post is the practical half: how I use it on the Mac, and what I built for the phone over one weekend.

## On the Mac: hold a key

There is not much to say, which is the point. I hold the right Command key and speak. When I let go, the text is where the cursor was. The audio goes to Soniox as I speak and the words come back while I am still talking.

I use this pretty much everywhere: in Obsidian, in Claude Code, in email, in Google Docs. The one exception is code. Dictating Rust or Python is weird and awkward, and you end up editing more than if you had typed it in the first place. But the moments when I type code myself, rather than prompt Claude to write it for me, are rare these days.

It works well enough that I stopped thinking about it. The phone was where I still had a problem.

## On the phone: a pile of recordings

I have had "quick capture" apps on my phone for years. One of them holds notes from 2021 and 2022 that I never looked at again, because nothing carried them anywhere. Another one was supposed to send notes straight into my vault and stopped delivering after I changed phones. Voice memos were worse: audio files that nobody, including me, ever listened to again.

The capture was never the problem. The other end was. A thought that lands in an app I do not open is a thought I have thrown away with extra steps.

What I wanted was simple to say. Press one button. Speak. Find the text in my notes, in the one inbox file I already go through every week. No app in the middle, nothing to open, nothing to remember.

## The chain

The new iPhone has a programmable button on the side, the Action button. Out of the box it starts Siri. (The new Siri is considerably smarter than the old one, but still leagues away from what Claude can do for me.)

On my phone, the button now does this:

1. The button runs an Apple Shortcut with three steps: record audio, save the file into a folder on iCloud Drive, show a notification.
2. iCloud Drive carries the file to a Mac mini at home that is switched on all the time.
3. A small script on the Mac mini notices the new file and sends it to Soniox.
4. The text comes back, and the script appends it as one dated line to the inbox file in my Obsidian vault.
5. Obsidian's own sync delivers that line to my laptop and back to the phone.

![capture-shortcut.jpg](/img/vpub/capture-shortcut.jpg)

That is the whole Shortcut. It works from a locked phone with a dark screen, which I did not expect and which is what makes it useful: I can do it while walking, without looking.

The recording itself is an ordinary audio file in an ordinary folder, so I can play it back in the Files app if I doubt what I said. Right next to it is a text file with the raw output of the transcription model.

![capture-shortcut-folders.jpg](/img/vpub/capture-shortcut-folders.jpg)

And this is what arrives:

```
- 2026-11-22 23:06 No tak dobre, tak ideme vyskúšať, mixing English and Slovak in the middle of the one- jednej nahrávky. Budeme skúšať prepínať back and forth, back and forth, and we will see ako to celé dopadne.
```

I said exactly that, switching languages in the middle of sentences on purpose. It is the most faithful transcription of my own speech I have ever seen from a machine.

## A deliberate choice: slow is fine

The phone does not transcribe anything. It only records. The text is not on the screen a second later; it is in my notes a little later.

I chose that on purpose. Transcription on the phone was the part that never worked for the way I mix languages, and I do not need to see the text immediately. I need it to be right and to be in the right place when I sit down. So the phone does the one thing it is good at, and a machine with a good connection and a proper speech model does the rest.

This is not to dismiss the phone's own abilities. As long as you stay within a single language, Apple's dictation on the phone is pretty darn good. But you *have to* select the language up front with the keyboard switcher and stick with it. That is why I have seven keyboards installed on my iPhone: Slovak, English, Czech, German, Spanish, Italian and Hungarian. With that I get an estimated 95 to 99% accuracy in every language I use, and the text appears right in the app I am in, whether that is Obsidian, Google Docs or Claude.

That is the fast path, and its price is staying in one language. If you want the freedom to switch languages mid-sentence, as I often do, you have to use the Shortcut, and the text arrives later.

How much later? On the first evening I measured three recordings. Two took about 34 seconds from the end of the recording to the line in the vault. One took four minutes, three of which were the phone taking its time to upload the file. That is a small sample, and iCloud does what it wants, but it is the right order of magnitude: half a minute when things are awake, a few minutes when they are not.

## Three things that went wrong

I built this in a conversation with Claude, over two evenings, and it did not work the first time. The failures were more instructive than the parts that worked.

We looked for the notes in the wrong place. The Mac mini has its own synced copy of my vault, but not in the folder where the laptop keeps it. The check came back "no vault here", and for a while the plan was being redesigned around a fact that was not true. Lesson: "I did not find it where I looked" is not "it is not there".

The script worked by hand and hung when the system ran it. Started from a terminal, it read the iCloud folder without complaint. Started by the scheduler in the background, it froze, silently, forever. macOS was showing a dialog on the Mac mini's screen asking whether Python may read iCloud Drive, and the Mac mini has no screen attached. One click through remote desktop fixed it. Lesson: on a Mac, "it works when I run it" and "it works unattended" are two different permissions.

The first automatic run crashed on a file that was not there yet. iCloud announces a file before it has downloaded it: the name and the size are visible, the content is still in the cloud. Reading it fails with an error message about a deadlock, which is as helpful as it sounds. The scheduler tried again a few seconds later and it worked, so nothing was lost, and now the script waits until the content has really arrived.

## The small stuff

Fillers. A faithful transcription includes every "ehm" and "uh". Soniox has no switch for that, so the script removes a short list of hesitation sounds before writing the line. The untouched transcript stays in the text file next to the audio. It does not rephrase anything. I do not want a machine tidying up my thoughts, only my throat-clearing.

Nothing is deleted. Processed recordings move to a "done" folder. If the transcription is ever wrong, the original is one tap away.

Cost. Recorded audio is billed at about ten cents an hour. One hundred notes a month, fifteen seconds each, come to roughly four cents.

## What it is not

It is not a to-do app and it is not a reminder. Something that has to happen today does not belong in a file I empty once a week.

It is also not finished. The same button could take typed text, or a link shared from another app, and the lines that turn out to be diary entries should end up in my journal and not in an inbox. Those are for another weekend.

But the main thing works, and it is the thing I never got from the apps I tried: I press a button, I say what I am thinking, in whatever languages it comes out, and it is waiting for me in my notes. The whole apparatus is a three-step Shortcut, one script of about three hundred lines, and a speech service that costs me cents a month.

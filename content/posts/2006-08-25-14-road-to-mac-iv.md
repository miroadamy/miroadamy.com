---
layout: post
title: 'Road to Mac IV: Getting accustomed'
date: 2006-08-25 22:51:19.000000000 -04:00
type: post
published: true
status: publish
category: programming
tags: [osx]
meta: {}
author: "Miro Adamy"
---
See also <a href="{{< ref 2006-08-22-road-to-mac-i-hard-decisions.md >}}">part I</a>, <a href="{{< ref 2006-08-23-road-to-mac-ii-ive-got-a-macbook.md >}}">part II</a>
and <a href="{{< ref 2006-08-24-road-to-mac-iii-the-culture-shock.md >}}">part III</a>

## August 10th


<p>That <a href="http://www.apple.com/macosx/features/spotlight/" title="Spotlight ">Spotlight</a> thing is just freaking fantastic :-). After few days of work, accumulating some files, emails etc, just for fun I typed Gabo’s last name to Command-Space search box. I did not even finish typing and first results were coming in the result list: all emails exchanged with Gabo, saved chats, text documents and as “best hit” Gabo’s contact card. Which was exactly right.</p>
<p>So what is so great on Spotlight ? What makes it any better than Google desktop or MS Search ? I cannot speak for MS Search, as I have not tested it, but I tried Google Desktop search on two different computers. What I <span>liked </span>on Google search was the extensibility - with custom plugins I was able to index almost every file format I was using. The only notable exception were old email archives in <a href="http://www.ritlabs.com/en/products/thebat/" title="TheBat!">TheBat!</a>   format - anybody has a suggestion?. What I did <span>not like </span>was the price paid for all this. Not the $$, Google desktop is of course free. The price was very noticeable slowdown of the system. I even had to uninstall it from notebook, because it became unbearable slow.</p>
<p>Here is my speculation why there is such difference in user experience: Google desktop is an add-on, not part of the OS and to find out which files were changed (and must be re-indexed) is has to crawl the filesystem to discover the changes. Spotlight on the other hand, is "well connected" and part of OS, it just sits idle, hooked to system notifications on file update system call and basically just handles events, never even looking on anything but changed files. With this aproach, the more files are on system, the bigger is Spotlight’s advantage. Difference in file system speed very likely also helps Spotlight. This is very subjective and I have never done any benchmarks, but whenever I was dealing with large directories (10000+ files) on Unix/Linux vs. on Windows systems (of comparable hardware parameters like RAM, CPU, disk size/speed), Linux systems always felt much faster and more responsive thank Windows. Yes, I know that 10000 files in single directory is crazy idea, but it changes nothing on the fact that Linux handled it better.</p>
<p>Spotlight was forced to do some heavy lifting after I copied some PDF and CHM files from network to local disk. “Some” is a bit understatement as it was about 30 GB of content. After that, you could tell that something is going on. The slowdown was hardly in the same league as Google did to my other notebook, but it was observable - the CPU load as well as the disk activity in <a href="http://en.wikipedia.org/wiki/Activity_Monitor" title="Activity monitor ">Activity monitor</a> was considerably higher and the machine felt warmer. Processing the 30 GB took about 4 hours.</p>
<p>Unlike Windows, Mac does not depend on Adobe Reader to open PDF file. PDF is handled natively, without any third party software, for both reading and writing. The Print dialog offers “Save as PDF” option for everything. I was little bit worried how will Preview handle the protected PDF’s I have purchased from APress. But they worked OK and looked so much better in Preview than in any reader on the PC. Why is it so ? Is it the fonts ? Or the screen ? Either way, avoiding Adobe Reader also on Mac is a great news. On Windows, I switched to <a href="http://www.foxitsoftware.com/pdf/rd_intro.php" title="Foxit Reader">Foxit Reader</a>   while ago(which does not need 25 second to just to start ;-)</p>
<p>Installing software on Mac turned out to be very simple and pleasant experience. Starting point is binary file with extension DMG (disk image). On doubleclick, Finder opens it, verifies content and mounts it as new disk - same way as you would mount a network drive or to see a newly inserted data DVD. After you open the disk, you see one or more icons. The whole install is drag and drop the to Applications folder and you are done. Uninstalling means dragging the icon to the trash. No installer formats to worry about (“is it MSI 1.0 or 2.0 ?”) or installing the installer before you install the application. What happens behind the scene is quite interesting. The single icon you are dragging/dropping, is in reality a folder, with application-specific structure underneath. You can even see it, by right-click (or ctrl-click) on the installed application and selecting “Show package content”. Application stores everything that is user specific under ~/Library directory, as ordinary files - so no registry is involved (and therefore nothing can get corrupted).</p>
<p>I started my installation marathon with text editor: <a href="http://smultron.sourceforge.net/" title="Smultron">Smultron</a>   with yummy icon. It is much more programmer’s editor than the <a href="http://en.wikipedia.org/wiki/TextEdit" title="TextEdit">TextEdit</a>  . It helped me for several days as my main editor, until I discovered <a href="http://www.hogbaysoftware.com/product/writeroom" title="WriteRoom">WriteRoom</a>   (see below). I tried and removed two <a href="http://www.ghisler.com/" title="TotalCommander">TotalCommander</a>   replacements: - <a href="http://www.madcommander.com/" title="MadCommander">MadCommander</a>   free tool written in Java and <a href="http://www.likemac.ru/english/" title="Disk Order">Disk Order</a>   (30 day eval version). The first one just did not felt right. Disk Order was OK but I found excellent free equivalent - <a href="http://www.kai-heitkamp.de/cms_en/main.php?content=9&amp;module=0" title="Xfolders">Xfolders</a>. The more I get familiar with the <a href="http://www.apple.com/macosx/features/finder/" title="Finder">Finder</a>   though, the less I think I will need it anyway.</p>
<p>I also installed excellent CHM reader <a href="http://chmox.sourceforge.net/" title="CHMox">CHMox</a> so I can read all my CHM books from Windows. Do not know why, but even MSDN in CHM format looks so much better and more readable on Mac … I also installed <a href="http://seashore.sourceforge.net/" title="SeaShore ">SeaShore</a> (image editor, which I do not use much), and Firefox with some of my favorite plugins: (Scrapbook, Linky, Delicious, Web Developer, DownThemAll and SessionSaver). I found out that Safari as browser is quite nice and so far I am using both of them. It is convenient for simulating two different logins to same Web site from same machine.</p>
<p>The most interesting find was probably simplest as far as functionality goes. It is - writeroom - “clean” editor. What I like about Writeroom is the concept. It is a channel between the your brain and the computer file. Writeroom presents very minimalist typing environment. It has no rich text capabilities, you just select single, aesthetically pleasing font and that’s it. If you want, you switch it (with ESC) into full screen mode, where it hides everything and presents one large document area with no menu’s, controls, windows or anything that would ask for attention or dilute your concentration. It is just you and the keyboard. Strangely enough, it helps. It really makes easier to keep your thoughts focused on the topic, the tasks ahead and very successfully fights the urge to open this file, click on that or (just for one minute…), open just received email, answer that bouncing icon in the dock or try out out that new program from the Utilies I have no idea what it does ;-).</p>
<p>Where does Writeroom store the text I am typing ? It never asks for any file name or anything. It quietly creates and manages writerooms - some sort of persistent buffers, named by the first sentence in them and keeps them (likely) in the Library - user specific section of the application program. It is very convenient but it takes some time to mentally adjust to it. Not being able to see where your stuff is saved (and verify that it is actually saved) is very disconcerting situation for a WG (windows guy). In Windows, everything is file centric and you almost always know where your stuff goes. You have to, as for many years working with Windows 3.x and 9x, you have learned that the operating system may explode and die any moment, so your left hand does automatically that unconscientious “Ctrl-S” movement every few minutes or even more often. In fact, I am still doing the same - only it does not work. Instead of Ctrl-S the secret combination is now Command-S (alias Apple alias Pretzel key - S). Yep, I did it again ;-).</p>
<p>Today, in the evening at Starbucks, I have experienced first “freeze” of the OS-X. I was copying some files from both USB drive as well as from my desktop at home, then I just closed the lid and left home. In Chapters, I noted that HERMES is still hanging in there and tried to “eject” it out. That was a mistake. It took about 2 minutes to recover (likely waiting some network operations to time out). The machine was not cold-frozen, but quite slow to react. I probably made it even worse when started panicking and clicking around, switching the network on and off, trying to call Expose and so on ….</p>
<p>Fortunately, it all came back nicely, without ugly measures (like reboot). Lesson learned: it is good idea to “eject” the network drive before going away - or at least, do not touch it while working offline.</p>
---
layout: post
title: Cure for crashing FourSquare and RunKeeper on iPhone
date: 2010-01-11 00:29:18.000000000 -05:00
type: post
published: true
status: published
comments: true
category: programming
tags: []
author: "Miro Adamy"
---
<p>Few weeks ago, first Foursquare application and then my favorite RunKeeper app started to fail. The symptoms were simple:</p>
<p>1) attempt to start</p>
<p>2) wait for for 2-10 seconds</p>
<p>3) exit</p>
<p>Analysis of the crash logs did not reveal anything obvious (see ~/Library/Logs/CrashReporter/MobileDevice/NAME:</p>

```
Process:         foursquare [374]
Path:            /var/mobile/Applications/7F37347B-......1663AA5/foursquare.app/foursquare
Identifier:      foursquare
Version:         ??? (???)
Code Type:       ARM (Native)
Parent Process:  launchd [1]
Date/Time:       2009-12-22 12:39:11.260 -0500
OS Version:      iPhone OS 3.1.2 (7D11)
Report Version:  104
Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Codes: KERN_INVALID_ADDRESS at 0x20294628
Crashed Thread:  0<
Thread 0 Crashed:
0   libobjc.A.dylib                   0x32668ecc 0x32665000 + 16076
1   CoreFoundation                    0x32d83d6a 0x32d4d000 + 224618
2   CoreFoundation                    0x32d4fc28 0x32d4d000 + 11304</p>
```

<p>What helped was to delete both applications from the phone, including data and let the iTunes install it back. No data is lost, because both services are cloud based - only minor inconvenience was to re-enter login information.</p>
<p>So, Nael - I am back in the game and cannot wait to claim back mayorships for all places I have been ousted :-)</p>

---
title: "Admin tool goodies"
date: 2012-05-29T11:22:48+08:00
published: true
type: post
categories: ["admin"]
tags: ["tools", "commandline", "osx"]
author: "Miro Adamy"
---

## tmutil

The tmutil - everything to know about Time machine backups. 
For example, why is the MBP backing up 4.3 GB ... again.

Lion only. See <http://www.macgurulounge.com/see-which-files-time-machine-backed-up/> for Snow Leopard and before.

```
547  tmutil
548  tmutil help
549  tmutil help listbackups
550  tmutil listbackups
551  tmutil uniquesize /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449
552  tmutil uniquesize /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-171551/
553  tmutil uniquesize /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/
554  tmutil uniquesize /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-130159/
555  tmutil uniquesize /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/ /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449
556  tmutil compare /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/ /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449
 ```

 ### here is why:


 ```
 ~ $ tmutil uniquesize /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-13
2012-05-27-130159/ 2012-05-27-131532/
~ $ tmutil compare /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/ /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449
! 5.4K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Application Support/CrashPlan/conf/service.model
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Application Support/CrashReporter
! 18.6K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist
! 7.2K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Application Support/CrashReporter/SubmitDiagInfo.domains
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Preferences
! 713B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Preferences/com.apple.TimeMachine.plist
! 503B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Library/Preferences/com.apple.applepushserviced.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Desktop
+ 55.2K                         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Desktop/Screen Shot 2012-05-27 at 1.36.29 PM.png
! 102.0K  (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Desktop/.DS_Store
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Documents/Microsoft User Data/Office 2011 AutoRecovery
- 15.8M                         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Documents/Microsoft User Data/Office 2011 AutoRecovery/PowerPoint Temp
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Downloads
- 271.5K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/Introduction To GIT.ppt
- 1.0M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/egit1-0-110705134610-phpapp02.odp
- 1.3M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/git-100618212852-phpapp01.zip
- 719.5K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/git-1212761677968831-9.pdf
- 2.7M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/git-presentation.pdf
- 709.5K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/gitandeclipsejena-100617100628-phpapp02.ppt
- 885.9K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/gitstartedwithgit-nhruby-090501133113-phpapp02 (1).pdf
- 885.9K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/gitstartedwithgit-nhruby-090501133113-phpapp02.pdf
- 645.7K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/introtogit-090518104200-phpapp02.pdf
- 5.4M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Downloads/progit.en.pdf
+ 330.3M                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Downloads/ECKHART TOLLE - Moc pritomnÇho okamziku - audiokniha.1
+ 122.2M                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Downloads/Eckhart Tolle - Stille spricht Hîrbuch
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/AddressBook
! 10B     (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/AddressBook/.database.lockN
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CalendarBar
! 2.3M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CalendarBar/GoogleCalendar.sqlite
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers
! 459B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/192.168.16.248.rdp
! 462B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/ATGHome - home en0.rdp
! 462B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/ATGMobile - 16.52.rdp
! 466B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/ATGMobile - Bonjour.rdp
! 462B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/ATGMobile - Rocket.rdp
! 455B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/Chewbaca.rdp
! 454B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/Chewbacca.rdp
! 452B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/Igor.rdp
! 437B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/New Server.rdp
! 453B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/TW_ATG.rdp
! 461B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CoRD/Servers/XP Pro VM Luke.rdp
! 13.3K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/CrashReporter/Intervals_5DE3241B-6882-529D-B8D6-404D684BE551.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Evernote/accounts/Evernote/miroadamy/promos
! 42B     (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Evernote/accounts/Evernote/miroadamy/promos/stats.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Evernote/skus
! 469B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Evernote/skus/www.evernote.com
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default
! 1.0M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Cookies
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Cookies-journal
! 1010.0K (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Current Session
! 906.8K  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Current Tabs
! 16.2M   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/History Index 2012-05
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Local Storage
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Local Storage/http_mediacdn.disqus.com_0.localstorage
! 3.0K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Local Storage/https_www.icloud.com_0.localstorage
! 58.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Login Data
! 4.5K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Login Data-journal
! 2.8M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Network Action Predictor
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Network Action Predictor-journal
! 94.2K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Preferences
! 200.0K  (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Shortcuts
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Shortcuts-journal
! 8.0M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Sync Data/SyncData.sqlite3
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Sync Data/SyncData.sqlite3-journal
! 400.0K  (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Top Sites
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Top Sites-journal
! 3.4K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/TransportSecurity
! 511.9K  (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Visited Links
! 1.1M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Web Data
! 16.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Default/Web Data-journal
! 12.3K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Google/Chrome/Local State
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Path Finder/Settings/Data Store
! 1.2M    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Path Finder/Settings/Data Store/directoryAttributes.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/Accounts/miro.adamy@gmail.com
! 27.2K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/Accounts/miro.adamy@gmail.com/avatar.tiff
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/LocalDrafts
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/camry2002ottawa@gmail.com.sparrowdb
! 1023.5K (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/camry2002ottawa@gmail.com.sparrowdb/messages.db-wal
! 899B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/camry2002ottawa@gmail.com.sparrowdb/syncdates.plist
! 775.7K  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/email.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@gmail.com.sparrowdb
! 1.0M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@gmail.com.sparrowdb/messages.db-wal
! 4.3K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@gmail.com.sparrowdb/syncdates.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FAll%20Mail
! 442B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FAll%20Mail/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FDrafts
! 440B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FDrafts/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FImportant
! 440B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FImportant/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FSent%20Mail
! 440B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FSent%20Mail/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FSpam
! 440B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FSpam/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FTrash
! 442B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/%5BGmail%5D%2FTrash/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/INBOX
! 440B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/INBOX/uids
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/spam-ish
! 440B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Cache/spam-ish/uids
! 68.6M   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Indexes/contents.index
! 11.4M   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Indexes/from.index
! 11.8M   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Indexes/recipient.index
! 11.6M   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/Indexes/subject.index
! 397.7M  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/contents-cache.db/data.tch
! 127.4M  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/conversations-cache.db/data.tch
! 310.6M  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/messages-cache.db/data.tch
! 54.3M   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/messages.db
! 1.2M    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/messages.db-wal
! 125.7M  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/preview-cache.db/data.tch
! 51.7M   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/search-metadata.db/data.tch
! 2.2K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/miro.adamy@thinkwrap.com.sparrowdb/syncdates.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/radegast4@gmail.com.sparrowdb
! 1023.5K (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/radegast4@gmail.com.sparrowdb/messages.db-wal
! 834B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/radegast4@gmail.com.sparrowdb/syncdates.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/tmp
! 6.3K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Application Support/Sparrow/uistate.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Google/GoogleSoftwareUpdate/Actives
- 0B                            /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-131532/Macintosh HD/Users/miro/Library/Google/GoogleSoftwareUpdate/Actives/com.google.GoogleDrive
! 0B      (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Google/GoogleSoftwareUpdate/Actives/com.google.Chrome
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Google/GoogleSoftwareUpdate/Stats
! 181B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Google/GoogleSoftwareUpdate/Stats/Keystone.stats
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Keychains
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences
! 2.2K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/.GlobalPreferences.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/ByHost
! 1.5K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/ByHost/.GlobalPreferences.5DE3241B-6882-529D-B8D6-404D684BE551.plist
! 434B    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/ByHost/com.apple.CrashReporter.5DE3241B-6882-529D-B8D6-404D684BE551.plist
! 526B    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/ByHost/com.apple.HIToolbox.5DE3241B-6882-529D-B8D6-404D684BE551.plist
! 190B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/ByHost/com.apple.SubmitDiagInfo.5DE3241B-6882-529D-B8D6-404D684BE551.plist
! 1.3K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/ByHost/com.apple.loginwindow.5DE3241B-6882-529D-B8D6-404D684BE551.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/Macromedia/Flash Player/#SharedObjects/CA7U5XUM
+ 0B                            /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/Macromedia/Flash Player/#SharedObjects/CA7U5XUM/media.miamiherald.com
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/Macromedia/Flash Player/#SharedObjects/CA7U5XUM/www.wimp.com
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/Macromedia/Flash Player/macromedia.com/support/flashplayer/sys
+ 91B                           /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/Macromedia/Flash Player/macromedia.com/support/flashplayer/sys/#media.miamiherald.com
! 2.6K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/Macromedia/Flash Player/macromedia.com/support/flashplayer/sys/settings.sol
! 124B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.apple.ATS.plist
! 623B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.apple.PreferenceSync.plist
! 443B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.apple.internetconfigpriv.plist
! 446B    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.apple.loginwindow.plist
! 24.3K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.apple.recentitems.plist
! 1.3K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.cleancutcode.CalendarBar.plist
! 76.7K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.cocoatech.PathFinder.plist
! 886B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.google.Keystone.Agent.plist
! 6.3K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.microsoft.Powerpoint.plist
! 254B    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.microsoft.error_reporting.plist
! 258.8K  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.microsoft.office.plist
! 18.9K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.sparrowmailapp.sparrow.plist
! 17.4K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/com.torusknot.SourceTree.plist
! 12.9K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/de.jinx.JollysFastVNC.Pro.plist
! 2.4K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/net.sf.cord.plist
! 2.0K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Preferences/org.vim.MacVim.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Safari
! 225.3K  (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Safari/History.plist
! 14.4K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Safari/LastSession.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Safari/LocalStorage
! 10.0K   (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Safari/LocalStorage/safari-extension_com.divx.wpa-kzyj7hj34p_0.localstorage
! 1.3K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Safari/TopSites.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Spelling
! 3.0K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/Spelling/dynamic-text.dat
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/SyncedPreferences
! 993B    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Library/SyncedPreferences/com.apple.syncedpreferences.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git
+ 5.8M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/Git-2a.pptx
+ 271.5K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/Introduction To GIT.ppt
+ 1.0M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/egit1-0-110705134610-phpapp02.odp
+ 1.3M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/git-100618212852-phpapp01.zip
+ 719.5K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/git-1212761677968831-9.pdf
+ 2.7M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/git-presentation.pdf
+ 709.5K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/gitandeclipsejena-100617100628-phpapp02.ppt
+ 2.4M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/gitintro-110722021214-phpapp02.ppt
+ 885.9K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/gitstartedwithgit-nhruby-090501133113-phpapp02 (1).pdf
+ 885.9K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/gitstartedwithgit-nhruby-090501133113-phpapp02.pdf
+ 645.7K                        /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/introtogit-090518104200-phpapp02.pdf
+ 5.4M                          /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/progit.en.pdf
! 10.3M   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/Users/miro/Projects/Training/Git/Git-1.pptx
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/etc/cups/certs
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/tmp
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db
! 1.1K    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/.TimeMachine.Results.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/BootCaches/FCD06070-6268-466A-A3D6-C697CA300BAC
+ 19.0K                         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/BootCaches/FCD06070-6268-466A-A3D6-C697CA300BAC/app.com.microsoft.error_reporting.playlist
! 21.2K   (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/BootCaches/FCD06070-6268-466A-A3D6-C697CA300BAC/app.com.microsoft.Powerpoint.playlist
! 20B     (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/SystemEntropyCache
! 616B    (size, mtime)         /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/com.apple.TimeMachine.SnapshotDates.plist
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/crls
! 3.2K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/crls/AC99EBF7D89822D3A424E7768D107BCD60A9A0F5.pem
! 3.2K    (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/crls/FE2FDB1DABD01758E9B204075DBB026D1D3E6B3B.pem
! 320.9K  (size)                /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/crls/crlcache.db
! 13.3K   (size)                /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/db/crls/ocspcache.db
!         (mtime)               /Volumes/Radegast2-TM/Backups.backupdb/Radegast/2012-05-27-162449/Macintosh HD/private/var/vm
-------------------------------------
Added:         475.1M
Removed:       30.1M
Changed:       1.2G
```

## Diff 

Which libs are in that Ant81 and not in Ant71 ?

```
[tkuser@jenkins2 opt]$ diff -q apache-ant-1.7.1/lib apache-ant-1.8.2/lib | grep jar | more
Files apache-ant-1.7.1/lib/ant-antlr.jar and apache-ant-1.8.2/lib/ant-antlr.jar differ
Files apache-ant-1.7.1/lib/ant-apache-bcel.jar and apache-ant-1.8.2/lib/ant-apache-bcel.jar differ
Files apache-ant-1.7.1/lib/ant-apache-bsf.jar and apache-ant-1.8.2/lib/ant-apache-bsf.jar differ
Files apache-ant-1.7.1/lib/ant-apache-log4j.jar and apache-ant-1.8.2/lib/ant-apache-log4j.jar differ
Files apache-ant-1.7.1/lib/ant-apache-oro.jar and apache-ant-1.8.2/lib/ant-apache-oro.jar differ
Files apache-ant-1.7.1/lib/ant-apache-regexp.jar and apache-ant-1.8.2/lib/ant-apache-regexp.jar differ
Files apache-ant-1.7.1/lib/ant-apache-resolver.jar and apache-ant-1.8.2/lib/ant-apache-resolver.jar differ
Only in apache-ant-1.8.2/lib: ant-apache-xalan2.jar
Files apache-ant-1.7.1/lib/ant-commons-logging.jar and apache-ant-1.8.2/lib/ant-commons-logging.jar differ
Files apache-ant-1.7.1/lib/ant-commons-net.jar and apache-ant-1.8.2/lib/ant-commons-net.jar differ
Files apache-ant-1.7.1/lib/ant-jai.jar and apache-ant-1.8.2/lib/ant-jai.jar differ
Files apache-ant-1.7.1/lib/ant.jar and apache-ant-1.8.2/lib/ant.jar differ
Files apache-ant-1.7.1/lib/ant-javamail.jar and apache-ant-1.8.2/lib/ant-javamail.jar differ
Files apache-ant-1.7.1/lib/ant-jdepend.jar and apache-ant-1.8.2/lib/ant-jdepend.jar differ
Files apache-ant-1.7.1/lib/ant-jmf.jar and apache-ant-1.8.2/lib/ant-jmf.jar differ
Files apache-ant-1.7.1/lib/ant-jsch.jar and apache-ant-1.8.2/lib/ant-jsch.jar differ
Only in apache-ant-1.8.2/lib: ant-junit4.jar
Files apache-ant-1.7.1/lib/ant-junit.jar and apache-ant-1.8.2/lib/ant-junit.jar differ
Files apache-ant-1.7.1/lib/ant-launcher.jar and apache-ant-1.8.2/lib/ant-launcher.jar differ
Files apache-ant-1.7.1/lib/ant-netrexx.jar and apache-ant-1.8.2/lib/ant-netrexx.jar differ
Only in apache-ant-1.7.1/lib: ant-nodeps.jar
Only in apache-ant-1.7.1/lib: ant-starteam.jar
Only in apache-ant-1.7.1/lib: ant-stylebook.jar
Files apache-ant-1.7.1/lib/ant-swing.jar and apache-ant-1.8.2/lib/ant-swing.jar differ
Files apache-ant-1.7.1/lib/ant-testutil.jar and apache-ant-1.8.2/lib/ant-testutil.jar differ
Only in apache-ant-1.7.1/lib: ant-trax.jar
Only in apache-ant-1.7.1/lib: ant-weblogic.jar
Only in apache-ant-1.7.1/lib: jsch-0.1.44.jar
Only in apache-ant-1.7.1/lib: xercesImpl.jar
Only in apache-ant-1.7.1/lib: xml-apis.jar
```

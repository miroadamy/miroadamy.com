---
title: "Accessing Keepass information from command line"
date: 2015-07-08T11:22:48+08:00
published: true
type: post
categories: ["tools"]
tags: ["keepass", "commandline", "perl"]
author: "Miro Adamy"
---

This is mainly for Linux and Mac as they do not have good client.

It requires relatively modern Perl - 5.1x should work. I have 

```
➜  ~  perl --version
This is perl 5, version 18, subversion 2 (v5.18.2) built for darwin-thread-multi-2level
(with 2 registered patches, see perl -V for more detail)
```

Get the kpcli distribution
Download from Sourceforge - <http://sourceforge.net/projects/kpcli/> or get the attached script kpcli-3.0.pl

Make it executable and put it on the path:

```
mv ~/Downloads/kpcli-3.0.pl ~/bin
chmod +x ~/bin/kpcli-3.0.pl
```

It will not work out of the box unless you install few Perl modules.

Easiest way is to use cpanm, which is installed using cpan

```
# Run CPAN and let it configure itself if run for the first time
cpan
  
# install cpanm using cpan
sudo cpan App::cpanminus
```

Now we can use cpanm to proceed

```
sudo cpanm Crypt::Rijndael
sudo cpanm Sort::Naturally
sudo cpanm Term::ShellUI
sudo cpanm File::KeePass
 
 
# I had issues with Readline::Gnu
sudo cpanm Term::ReadLine::Gnu
# so I installed Perl5 version instead
sudo cpanm Term::ReadLine::Perl5
  
sudo cpanm Clipboard
sudo cpanm Capture:Tiny
sudo cpanm Capture::Tiny
  
~/bin/kpcli-3.0.pl --help
```

Now it can be run and open file. After opening you can navigate in the password file as in file system (try pwd, cd, ls) and copy password to clipboard (try h)

```
➜  Sites git:(master) ✗ ~/bin/kpcli-3.0.pl --kdb ~/PASSWORDS/PAL.kdbx
Please provide the master password: *************************
KeePass CLI (kpcli-3.0) v3.0 is ready for operation.
Type 'help' for a description of available commands.
Type 'help <command>' for details on individual commands.
* NOTE: You are using Term::ReadLine::Perl5.
  Term::ReadLine::Gnu will provide better functionality.
kpcli-3.0:/> ls
=== Groups ===
PAL-Keypass/
kpcli-3.0:/> h
  attach -- Manage attachments: attach <path to entry|entry number>
      cd -- Change directory (path to a group)
      cl -- Change directory and list entries (cd+ls)
   clone -- Clone an entry: clone <path to entry> <path to new entry>
   close -- Close the currently opened database
     cls -- Clear screen ("clear" command also works)
    copy -- Copy an entry: copy <path to entry> <path to new entry>
    edit -- Edit an entry: edit <path to entry|entry number>
  export -- Export entries to a new KeePass DB (export <file.kdb> [<file.key>])
    find -- Finds entries by Title
    help -- Print helpful information
 history -- Prints the command history
   icons -- Change group or entry icons in the database
  import -- Import a password database (import <file> <path> [<file.key>])
      ls -- Lists items in the pwd or specified paths ("dir" also works)
   mkdir -- Create a new group (mkdir <group_name>)
      mv -- Move an item: mv <path to a group|or entries> <path to group>
     new -- Create a new entry: new <optional path&|title>
    open -- Open a KeePass database file (open <file.kdb> [<file.key>])
    pwck -- Check password quality: pwck <entry|group>
     pwd -- Print the current working directory
    quit -- Quit this program (EOF and exit also work)
  rename -- Rename a group: rename <path to group>
      rm -- Remove an entry: rm <path to entry|entry number>
   rmdir -- Delete a group (rmdir <group_name>)
    save -- Save the database to disk
  saveas -- Save to a specific filename (saveas <file.kdb> [<file.key>])
    show -- Show an entry: show [-f] [-a] <entry path|entry number>
   stats -- Prints statistics about the open KeePass file
     ver -- Print the version of this program
    vers -- Same as "ver -v"
      xp -- Copy password to clipboard: xp <entry path|number>
      xu -- Copy username to clipboard: xu <entry path|number>
      xw -- Copy URL (www) to clipboard: xw <entry path|number>
      xx -- Clear the clipboard: xx
Type "help <command>" for more detailed help on a command.
kpcli-3.0:/>
```

Enjoy
---
title: "ATG Development using 'hidden' VM"
date: 2013-04-22T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["atg","virtualbox","virtualization"]
author: "Miro Adamy"
---

Brief description of my latest setup I use for CPL and LCH - in case I forget it or somebody wants to replicate it.

Inspiration for the setup came from <https://www.youtube.com/watch?feature=player_embedded&v=cPt_1Vga-Nk>

## Motivation - issues with VMs

VMs are great - they allow "packaged" dev environment and quick start for the new member of the team. Start a VM on local or remote host, connect with VNC or Remote Desktop and you are in business.

For longer running projects, it is still suboptimal environment compared to "native" environments. Here is my list of issues with developing inside VM (running Eclipse, browsers and all tools in addition of ATG)

* UI comfort. Linux, especially the older Centos 4 and Centos 5 are nowhere close to UI comfort of OS-X, or even Windows 7 for that matter
* old tools, old libraries:
    * because of the older versions of clib, gclib, it is a problem to install recent versions of browsers (Chrome, FF), recent editors
* missing tools: some tools (like SourceTree, Curio) do not exist for Linux at all
* speed: you may have quacore notebook, but effective user responsiveness will be same as single core old PC 4 years back because everything competes for single CPU cycles: DB, ATG, Eclipse
* RAM: to run 2 instance of ATG with memory hungry Eclipse requires beefed up VM memory settings and that will slow down front end
* VPN: it is hard to access VPN from Linux. Using VNC remote desktop via VPN (when VM runs inside office) is an exercise in patience ...)


## Setup

I am using VM running primarily out of my notebook - on MacMini or on Chewbaca, but it can be used with local VM as well.

VM must be Linux based (to allow simple access via ssh) and does not need to run any UI after you configure it. VM must run Samba and export the home directory as writeable.

All my VMs are using layout with ATG installed in ~/opt/ATG and JBoss in ~/opt/jboss-something, with installed Oracle XE and samba out of the box.

If samba is not install, add it: `sudo yum install samba`

## Samba configuration

Simplest way is to use Administration Menu in Linux UI


![](/images/atgvm-1.png)
![](/images/atgvm-2.png)
![](/images/atgvm-3.png)
![](/images/atgvm-4.png)

Set up Samba user as tkuser / $PWD  

After this you can logout and kill VNC.

## Mac side setup

Map the Samba drive: 

![](/images/atgvm-5.png)

* use either mount_smbsf or GUI in PathFinder / Finder. The mapped drive will look like this: 
* create new Workspace in Eclipse referring the files on the `/Volumes/tkuser/opt/ATG/ATG10.0.3/ClientName`
* connect multiple SSH sessions to remote hosts that allow to run ant, start ATG, do Git operations and such
* create local terminal session to `/Volumes/tkuser/opt/...` to run Mac tools over source - Sublime Text, etc


## Hints and tricks

These are little things that make is more convenient:

Map the symbolic name of the VM in /etc/hosts

I am using convention CLIENT-VM-partialIP


![](/images/atgvm-6.png)

Use color coding in terminal (iTerm specific)

To tell which terminal is "local", I color them - the brownish ones are remotes, green is local


![](/images/atgvm-7.png)

Always create local workspace in Eclipse

## Using the setup and limitations

This setup can be used from Mac or Windows development station, with local or remote back-end VM. If you are on mac, you have everything. On Windows, you need install decent ssh client and terminal - both of which comes with Git Extensions

If you are on Windows, you need to use different "shell" for local terminal sessions and remote terminal sessions (if the command interpreter of Windows can be named "shell" ...)

In theory the VM could be Windows based - but instead of accessing it using ssh, you would have to start remote desktop client and open the command windows there ... and suffer with their limitations. You could not get rid of UI, but at least you could run Eclipse on local hardware without double-slowdown caused by VMWare and Windows.

 

## Linux -> Linux

This is very feasible alternative that allows to use older version of Linux kernel to run the ATG and modern Ubuntu with all the bells and whistles for running Eclipse. It also removes a need for customizing and reconfiguring/updating multiple versions of Eclipse for multiple VMs. 

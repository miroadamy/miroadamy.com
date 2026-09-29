---
title: 'Catching up: Tailscale Everywhere'
date: '2026-09-29 00:00:00 +02:00'
type: post
author: Miro Adamy
categories:
- devops
tags:
- catching-up
- tailscale
- networking
- homelab
series:
- Catching-up 2021-2026
series_order: 8
---



Seven devices, two of them NAS boxes, and a laptop that travels with me. For years, reaching any of them from outside the house was a small project every time. In July 2026 I put all of them on one private network, and the day every machine got one name that works from anywhere, half of my runbooks got shorter.

## Why a mesh VPN

My home fleet is not big, but it is spread out: two MacBooks, an iPhone, an iPad, a [Mac mini](https://www.apple.com/mac-mini/) that is always on and serves as a small home hub, and two [Synology](https://www.synology.com/) NAS boxes, an old one and a new one.

Before, the reality looked like this. Names like `nas.local` worked only at home - they come from mDNS, which never leaves the local network. Scripts had LAN IP addresses hardcoded in them. Remote access meant Synology's QuickConnect, or thinking about port forwarding on the router, which always made me a bit nervous. And many of my runbooks had two variants: one for when I am at home, one for when I am not.

[Tailscale](https://tailscale.com/) is a mesh VPN built on [WireGuard](https://www.wireguard.com/). Every device gets a stable address and can see all the others, no matter which network it is on. The coordination server only helps the devices find each other and exchange keys; the data itself flows directly between them, over the LAN when they are both at home. The Macs and the iPhone were on it first, and both NAS boxes joined on one busy day in July.

## The doctrine that came out of it

The most important decision was not a technical one. Every machine now has one name that is valid everywhere, and that name is the default in every document and script I write. The LAN name and the IP address are fallbacks only. No more "am I at home?" branching. It also fixed a real class of failures: scripts and AI agents running in a shell on my laptop could not reach the NAS, because they relied on names that only resolve at home.

The free tier is enough. [MagicDNS](https://tailscale.com/kb/1081/magicdns) (the short names), [Taildrop](https://tailscale.com/kb/1106/taildrop) (sending files between your own devices), exit nodes and subnet routing are all included. The paid tiers sell enterprise plumbing - user provisioning, device management, flow logs - that a household does not need. I tried the business trial for the custom domain, then settled on the free plan.

One neat privacy detail: the name of your tailnet is random on purpose. If it were derived from your domain, it would end up in the public certificate-transparency logs, and anyone could see whose network it is. A random name tells them nothing.

## Traps for the Synology owner (all hit personally)

Synology and Tailscale work well together once you know where the traps are. I stepped into every one of these.

On DSM 7, packages run in a sandbox. Without a small boot task, running as root, that gives the package access to the TUN device, only inbound connections work. You can reach the NAS, but the NAS cannot reach anything over the tailnet, and nothing tells you so. The older DSM 6 has no such problem. And once the TUN device is on, tailnet traffic goes through the DSM firewall, so the firewall needs a rule that allows the Tailscale address range (`100.64.0.0/10`) - otherwise you lock yourself out the moment you are away from home.

Synology's Package Center offered a Tailscale version about two years old. The fix is to download the package from Tailscale directly and [install it manually](https://tailscale.com/kb/1131/synology), but a manually installed package never updates itself. That makes it a recurring chore, worth a calendar entry.

And never upgrade DSM over a Tailscale connection. When the NAS restarts in the middle of the upgrade, your connection goes with it.

Two more for the Mac. The Tailscale app does not put its command-line tool on the PATH, and symlinking the binary into `/usr/local/bin` crashes it, because the app then cannot find its own bundle. A shell alias works:

```bash
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
```

Taildrop is push-only: you always send from the device that has the file, because a phone runs no services you could pull from. And the target needs a trailing colon, which I forgot more than once:

```bash
tailscale file cp report.pdf iphone:
```

## Roads deliberately not taken

Not everything Tailscale can do made it in.

An [exit node](https://tailscale.com/kb/1103/exit-nodes) would route all my traffic through home when I sit on some hotel or café wi-fi. The always-on Mac mini is the obvious candidate, but I parked the idea. It would be capped by my home upload speed anyway.

[Tailscale Funnel](https://tailscale.com/kb/1223/funnel) can publish a service from your tailnet to the open internet. I looked at it for sharing my ebook libraries with family, and rejected it. Family will not install a VPN, and Funnel puts no login gate in front of the service. The libraries now sit behind [Cloudflare Access](https://www.cloudflare.com/zero-trust/products/access/) instead, where a one-time code sent to an approved email address opens the door. Tailscale is for my machines, not for my audience.

A [subnet router](https://tailscale.com/kb/1019/subnets) would expose a whole local network to the tailnet, including devices that cannot run Tailscale themselves. I keep that one in reserve for a possible second location, where a small mini PC would make remote access feel the same as being on site.

If I had to name one lesson from all this: the value was never the VPN itself. It was one name per machine that works everywhere. Everything else followed from that.

Next in this series: offsite backups with restic and Hetzner.

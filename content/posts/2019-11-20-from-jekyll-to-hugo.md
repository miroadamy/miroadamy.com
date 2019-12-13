---
title: "From Jekyll to Hugo"
date: 2019-11-20T23:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["blog", "hugo", "jekyll", "plaintext"]
author: "Miro Adamy"
---

I have decided to consolidate all piecemeal versions of my blogpost uder one roof and at the same to do these four things

1. technology upgrade - from Jekyll to Hugo
2. visual refresh of the page
3. review tagging and categorization
4. merge hidden posts from Wikis to one place

## Why Hugo replaced Jekyll

The version 3 of my blog (see below for a bit of history) has been hosted on [Github pages](https://pages.github.com/) and using the default static site generators - [Jekyll](https://jekyllrb.com/). 


## A bit of history

I started to keep my notes on things of interest long long time ago - in 2006, shortly after we founded Thinknostic. 

### Version 1 - Wordpress

When I started blogging back in 2006, it was Thinknostic second year and we started to really grow:  we got our own space beyond small sales office in downtown we have had before, built some serious hardware infrastructure, employee numbers started to go into two digit territory and we landed our first 1 M$+ project. My blog at http://thinkwrap.wordpress.com/ was our unofficial presence in the social space. In 2006 I picked the login and account name “thinkwrap”, because it was – at that time – a word that kind-of expressed the approach we were using: something between methodology, best practices and a toolset.

In the three years, the same word ThinkWrap was selected as the new brand when Thinknostic in Ottawa and Pentura Solutions in Toronto (both “second life” companies of Montage origin) merged.  Now suddenly, with “thinkwrap” in URL,  my blog became whole lot more company-bound that I wanted. As everybody can see on dropping rate of contributions, I found pretty hard to post. I was never quite sure whether I really want to present my personal opinion to appear under ThinkWrap brand as something that the company would be saying. Even worse, now we were several times the size as before, with headcount of about 50 – who was I to speak for all these people, when there were so many smarter, more talented and more experienced than myself ?

As result, the whole blog thing came to a big halt – no posts for over 6 months. The only solution I could come up with was restart. Thus, a new, real corporate blog was created in 2009 that represented way more than single guy’s opinion. I was one of the contributors.

The blog <http://thinkwrap.wordpress.com/> is still out there and ends in 2009 with 
the post [The Fork at the end of this blog](https://thinkwrap.wordpress.com/2009/12/29/the-fork-at-the-end-of-this-blog/).

The <https://blog.thinkwrap.com/> evolved over years into something much more corporate-ish and enterprise-ish and eventually disappeared with Thinkwrap purchase by Tenzing. 


### Version 2 - 2 blogs in Wordpress 

After stoppin the use of <http://thinkwrap.wordpress.com/> for my personal stuff, I have exported and reimported the content into different WordPress blog and hooked it under domain that clearly indicates that it was my personal blog and personal opinions: <https://miroadamy.wordpress.com/>

This blog is still out there and it's "separate existence" started with [this post](https://miroadamy.wordpress.com/2009/12/30/blog-reloade/) in December 2009.

Compared with the first blog, there is much less content. I was not really writing less, but most of what I wrote ended up in Wiki's and Intranet and never made it to the blog. 

Also, Wordpress was more and more an obstacle - and the fact that my texts live in some form of database instead of a source control system was really bugging me. So in 2013 I made first attempt to leave Wordpress platform and switch to repository driven approach (today we would say "blog as a code").

During this time, I become bit fan of plain text and markup formats and lots of my notes, internal blogs etc were originating as Markdown or AsciiDoc - which turned up to be a good thing in the end.

### Version 2.5 - Gollum and Github Wiki

Well, the first attempt did not take. I tried to use Wiki pages in Github attached to the repository <https://github.com/miroadamy/miroadamy-dot-com>. It did not work well - wiki is NOT good platform for this kind of content - and after short time I learned how to use Github pages with custom domain. The miroadamy-dot-com is archived now.

### Version 3 - Jekyll and Github pages with custom domain 

The blog <https://www.miroadamy.com/> existed in Jekyll incarnation from 2013 to November 2019. The look and feel was a bit plain and lots of posts were not included in the public version. It worked OK (mostly). 

I had three major issues with with this setup:

* Jekyll is based on Ruby and I was trying to go away from the environments that need native modules / libraries (== gems) - I have enough headaches with Python libraries and JARs. Local development with Jekyll was a bit cumbersome and it was SLOW => regenerating site took tens of seconds. Not good.
* consolidation of the internal Markdown files would be quite unpleasant with the above
* I really wanted to try Hugo :-)

### Version 4 - Hugo with Github pages hosting

This is current state - site was migrated (see next post on technical details) and published in the place of the old site. For visual refresh, I settled for the theme Even - <https://github.com/olOwOlo/hugo-theme-even>. I do not know whether I will keep it or not, but before playing with themes I need to finish #4 and #3 above.


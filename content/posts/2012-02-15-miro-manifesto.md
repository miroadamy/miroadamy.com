---
title: "Miro Manifesto"
date: 2012-02-15T11:22:48+08:00
published: true
categories: ["Technology"]
tags: ["os-x", "virtualbox"]
author: "Miro Adamy"
---

# Miro Manifesto

Original text of the memo, written in February 2012 and shared with limited audience, until it surfaced up as main them of the planning meeting in December 2012.

This is an attempt to come up with better answers to the following questions:

* what issues and challenges I see on our way ahead from the technology point of view and what needs to be done to address them
* where do I see my professional and personal career go over next 12 to 18 months and in long run
* how to best align those two streams

In the spirit of my latest “back to the basics” obsession, it was written in Markdown format and in Vi, copied and pasted into Google Doc, btw.

Not that it matters.

`NOTE: I have removed the names of some of the 3rd parties. Just to be safe.`

# Challenges

My perspective of the "state of the union" is different from one that Steve or Mike has.

I deal with code, with production environments, with customers asking for features and our PM/AM/BAs providing the customer with SOW and estimates.

I am usually one of the data inputs for these estimates and (unlike AM, PM or BA) see most of these SOWs through their lifecycle: how the SOW document "spawns" code level artifacts and activities and eventually ends up as new version of EAR file running somewhere in production environment.

Therefore what I see are not numbers, bottom lines, sales funnels and summary hours in Dovico but classes, Ant scripts, SVN repository commits, filesystems in production and actual content **behind** the numbers in Dovico. I see challenges and issues we encountered while creating those classes and config files, unfinished things, quick hacks and duct-tapes fixes we have left behind, hardcoded paths and messy directories with duplicate content, crazy complex flows.

I also see elegance and design beauty, dotted i's and crossed t's - but not as often as I wish. I see empty Wiki pages and outdated unmaintained mess in documentation, next to work of art ready to save to PDF and publish. Between these broken windows code smells and chunks of awesomness I start to see trends and patterns and these patterns worry me.

Both as software engineer (or craftsman if you will) and as founder of the company.

We are in many aspect, as we grow, start to behave like the government: we are accumulating more and more debt and we are eating up our savings.

It is not money I mean, the debt being accumulated is technical debt and what is being spent are the ingredients that makes us different:

* experience
* quality
* passion and
* culture.

Here is what they are and how are they being consumed:

### Experience:

as we grow, we will add more and more people to work on highly complex solutions. People that will be less trained and less ready as the people we have had in 2009 when the ATG really started. These people will need to be coached, mentored and educated - before the job and on the job. Otherwise they will try to imitate what they see and "code by example".

If we had high quality code base, that would not be too bad. That is however not the case. Without countermeasure the number of "it works by coincidence" situations will grow a lot - simply because the people working on project will not have deep enough understanding of all details.

It is not only about growing the total sum of experience in the company, it is also about moving people in and out of projects, sharing knowledge and education. 
 We need to way more efficient way how to capture and share the experience: best practices (and worst ones to be avoided) project specific know-how required for the operations as well as vertical knowledge: payment gateways, inventory systems, toolkits and libraries. We need to move ahead the standardization and convergence of the codebases and processes, to increase the chance of reuse at all levels: concepts, patterns, integration points processes, tools and even code.

Now when we have pretty much solo focus on ATG and ecommerce, we need to become the best experts in ATG, better than Oracle and definitely better that everybody else. Big part of this will come out of project work as longs as we try to go deeper. What will not come automatically is identifying, capturing, processing and sharing this deep expertise knowledge.

### Quality

as we grow, quality goes down unless there is a dedicated effort to work against it. Quality will go down as result less experienced teams in general, imitation of bad code (broken windows syndrome) but mainly because without quality program and early feedback it makes no difference to developer: nobody sees his/her code and explains what is wrong with it.

We need to identify the bad pieces so that they will not be duplicated (and same mistake will not be made several times) and eventually those identified pieces can be refactored and fixed. We also need to identify the gems and pieces that deserve to be replicated and learned from them: we need to make documentation good enough that it will be less work to use the solution that to re-invent it.

When we started the ATG path in summer 2008, we did not really know much about ATG platform beyond the actual core (DAS+DPS+DSS) we used in our first projects. We were learning on our first assignments.

So we started with two large buckets of technical debt: one inherited mess from botched implementation and one with our own gaps and lack of experience from doing complex things we have not done before. As time progressed, we have added third bucket: code we wrote impacted by the inherited (bad) approaches. Examples are XYZ import process built on inflexible foundations.

The speed of us taking on new tasks and going into new areas is increasing. We are trying to define cookie cutter template that we will reuse. If this template is off, we will multiply the problem by using it, so it is in our deepest interest to get this RIGHT.

### Passion:

we have been lucky to have a pool of tested, above-average passionate employees that care available from Montage times. With more new hires and more younger generation, there will be likely less passion and less dedication.

To a degree, we already see it.

We need to create something that would at minimum prevent this from going down - or at minimum, that will keep the speed of decline to be slower than the speed of growth.

We need to have some mechanism that will keep the passion, the pride of craftsmanship and directions of evolution towards improvements and against the natural entropy. It is very hard to be proud when one works on crappy codebase or with tools / techniques inadequate, so the previous two are kinda pre-requisites.

### Culture:

when we started this company in early 2004, the basic urge to do it was to create a place where people would be looking forward to come to work every day, a kind of business-sane version of nerdvana where people can do great work, grow and help the customers to be successful.

I am very proud of what we achieved so far. The growth of the company amazes me and as shareholder it makes me very happy. The challenge now is how this culture (nerdvana plus all of the qualities above - experience, quality and passion ) can be preserved and transformed in a form that would work for the company sized from below 50 to company sized between 50 to 200.

The fundamental challenge is that we are growing much faster than improving - or the other way, we are improving too slow for our rate of growth. Last thing I want is to curb our growth ambitions - so I am trying to focus on how to improve our improvement process and make it to catch up with growth.

# Gaps that are the cause

The "spending of secret sauce" instead of creating and refining it is IMHO mainly caused by gaps.

Among many, here is what I see as most impacting for the delivery side of the business

## Operation / Support practice

Without operation or support practice, the projects kinda hang there and are supported by "best effort" rotation, usually victimizing the developers who were in the meantime transferred to new challenge.

Missing handover to operation process (as there nobody to hand over to) eliminates important check in project lifecycle - projects never make it to "real production" so the chaos and state of unfinishedness persists for the whole duration of the project.

The consequences are that project starts with technical debt (never got over the "production ready" gate) and whether the gaps in quality, functionality are filled during the operation, really depends on how generous is the support budget.

## (Lack of) Standardization

Every project is single silo of knowledge. To certain degree this is consequence of taking over legacy apps but even in projects who build from scratch the degree of standardization between any two projects really depends on how many people were working on both of them, how willing were they to push for the "tested" approach and well the others understood the intent.

There is no mechanism / program / initiative that would work towards alignment, sharing, unification of techniques and tools. Whether same problem will be solved same way between project A and B depends only on whether people involved understand the other solution well enough and are willing to share. Sometimes it is harder to “take out” the piece of functionality because the last step - documenting, packaging was not done and because the approaches taken in two projects are too different. If that is the case, we will end up with differing solutions of the same problem.

## (Lack of) knowledge sharing

As corollary to the above, the only way how knowledge is shared is by sharing people among projects. If there is enough overlap, this works to a degree, but it is very inefficient, creates additional load on the knowledge providers and makes them the bottleneck.

Most importantly, this has direct impact on our ability to scale up, deal with emergencies, people's absence or other personal issues. The likelihood of all of which will increase a lot with bigger company.

By not having proper documentation and knowledge base, we are not using the most precious learning and training tool. No formal training by ATG can be compared by detailed review of a properly done ATG project, that has good high level documentation.

## Incomplete Project Management

This is not my territory, but here is what I see. We spend a lot of time in producing guestimates and spend a lot of mental energy to make them to be more like estimates.

We end up with SOW and work breakdown that has certain tasks and allotted hours.

Our tracking of the real time spent on the tasks is awfully incomplete: we capture of part of the true costs. Because of the people overlap, lots of unfinished business we continue to fool ourselves that we did X in 100 hours, while in reality it was only 80% of X done, and of this 80% maybe 15% had to be refactored and fixed. Altogether we spent 150 hours, only the additional 50 hours was hidden as support fixes or (if we were lucky) got fixed as part of next CR. This way we are spending money out of our pockets.

We are also leaving money on the table by not identifying the parts of already done and using them.

The reason why is because there is not enough documentation, extraction and post-processing done on any given project. It can be argued who should carry the costs of this post-processing but it can be done both ways: if it is TW cost, TW can get the benefit of huge margin for the second sale. If customer, we can pass the benefit to customer. But back to the original: project management is incomplete because it does not have feedback about true cost and quality.

With this data, we would see

* misalignment between the time allotments and real effort
* mis-estimates
* undersold projects
* legacy impact

All this creates pressure and opportunities to cut corners. And boy, we sometimes do cut corners.

## (Lack of) Feedback

Not only project managers are victims of the little feedback. The more impacted are developers.

With no process to identify the quality issues there cannot be any proper professional feedback to developers - the quality is not part of career evaluation / personal reviews.

This also contributes to lack of excitement caused by impact of quality. When nobody notices what will make developers want to write a great code ? Add emergencies, stress and lack mentoring and coaching, and we will quickly become just another lackluster software development shop.

Absurdly enough, we are (to a certain degree) make developers responsible for their billable hours - something over which they have very little control.

We do not however make people responsible for the quality of their work - something they actually CAN control themselves.

Things that needs to be done to address the challenges above

Establish quality program with the following

* make code reviews non-optional part of the project lifecycle
* make architecture reviews non-optional condition for release
* environment / project reviews after major project event (release to production)
* feed information from reviews into documentation
* make quality part of the evaluation

### Create Operations / Support practice

* define “production ready” gate
  * code quality
  * environment quality
  * test pass
  * documentation availability
* define handover strategy between dev and prod
* run operations as operations, not as development shop

### Fix documentation issue

* make documentation part of the project completeness
* allow people circulation without impact to projects and clients
* define process of review and maintenance of documentation on the live projects
* move people between projects - the documentation must be used

### Education and Improvement programs

* make participation in these (both passive and active) part of evaluation
* establish process of rotation people between projects to give them exposure and to test the knowledge transfer
* derive experience from reviews

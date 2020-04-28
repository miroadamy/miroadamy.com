---
title: "History of Faith"
date: 2020-03-31T11:24:48+08:00
published: true
type: post
categories: ["DevOps", "startup-life"]
tags: ["kubernetes","k8s","aws","cloud"]
author: "Miro Adamy"
---


## The beginnings

Once upon a time - actually, in late 2017-early 2018 - there was a QA/DevOps engineer named José who liked containers, Docker and worked for a company named Thinkwrap (that soon would become Pivotree) in Valencia, Spain. 

José was responsible (among other things) for setting up integration and QA environments for multiple Hybris projects. Such environment, when being built in traditional way (from physical servers or VMs), normally requires quite a few pieces:

- at least one front-end server, running Web layer (Nginx or Apache or both)
- one or more application servers, running Tomcat with Hybris application
- usually one dedicated backend server, used for catalog management, cron jobs and other backoffice activities
- Solr server or cluster for search functionality (typically working in master slave setup in production)
- Jenkins server to run and administer pipelines that executed unit tests and integration tests
- Sonarqube server that provided code quality tools (internally consisting of Java based server and a database - usually PostgreSQL)


Setting up and maintaining this cuckoo-clock of servers and services and especially running multiple environments without going overboard with server management overhead was definitely not easy. It would take 1-2 days setting up such an environment from scratch (meaning start with OS). Just a single one environment ...

José did not have that amount of time and did not particularly like doing the same steps over and over. He also could not guarantee he would not never make a mistake or leave out and would not have to start over. In accordance with 3 virtues of Great Programmers (see http://threevirtues.com/), José decided to package and automate the hell out of that.

Thinkwrap Valencia office had good experience with using containers so José started there: using existing public images for Jenkins, Sonar, Solr, Nginx and database and Thinkwrap custom-built images for Hybris app servers he quickly managed to build working docker-compose setup that allowed him (and any developer brave enough to run Docker on her Mac) to spin up the multitude of containers that encapsulated all apps and configurations for the environment.

Yes, Macbooks are powerful beasts, but even on Quad-core i7 with 16 GB RAM the environment cannot run 6-7 docker images easily, when one or two of them are 6 GB monster Hybris containers. Other applications that are memory hogs (yes, I am looking at you - Chrome, Slack, Visual Studio Code and IntelliJ) will become annoyingly slow and using this environment will eventually become an exercise of patience. And do not even think of running two copies of the environment ...

So José started to search for a server. There is this place called AWS that has plenty of servers, but there is a small problem with them: they cost money. Unfortunately, most clients are rather unfriendly when asked for additional monthly funds to run something businesswise unimportant such as unit tests and code quality tools. As a consequence, most PMs were not brave enough to raise that topic with clients, so José had to look elsewhere.

As it happened, the partner company Tenzing (that was in process of acquiring Thinkwrap at that time) was a hosting company and had some free capacity in the datacenter. Friendly techie from Tenzing installed Openstack or rather generous hardware allocation: 400 GB of RAM, loooots of disk space and carved out 5 VMs with memory ranging from 128GB of RAM to 16 GB of RAM. José named them: Faith, Raiden, Deku, Quiet and yScout. The names may have something to do with comic books - ask younger people that are knowledgeable of geek culture of the late 90-ies. I am personally more like Hacker's Dictionary generation - https://en.wikipedia.org/wiki/Jargon_File

And this is how a server named Faith was born - an Ubuntu VM 128 GB or RAM and ~ 200 GB of disk space. 

Anyway, back to José and his problem. In addition to Docker, he was also intrigued with Kubernetes, and saw clearly how the declarative nature, namespaces and explicit constructs for Config and Secrets would help him. Thinkwrap at that time had already built 2 or 3 Kubernetes clusters in AWS for microservices projects related to eCommerce. These were however built using a tool called Kops (please remember this was before EKS became generally available) which was just at that time, just a Cloudformation generator and thus completely unusable outside of AWS. 

Full installation of Kubernetes "the hard way" would require access to and knowledge of low level networking tools and settings. To avoid that, José searched - and found - a tool that not only would bootstrap a full Kubernetes cluster inside a single node but also give him UI to deploy and manage that non-clustery cluster: Rancher. Yes, this solution did not have ANY high availability or failover capability and pretty much everything was a single point of failure.

There were few more challenges José had to address: the first one was DNS. Different Hybris instances require unique URLs to resolve to the address of a container. The solution was combination of free service XIP.IO that accepts URLs in form:  ANYTHING.AAA.BBB.CCC.DDD.xip.io and resolves it to IP address AAA.BBB.CCC.DDD - where AAA,BBB,CCC,DDD are decimal numbers 0-255. There was only one public IP, so every URL contained the same public IP + .xip.io and differed only in the ANYTHING portion. Beyond the public IP, there was Kubernetes Ingress that based on ANYTHING string routed the requests to proper internal service in a namespace.

The second challenge was the Docker-in-Docker problem with Jenkins. The Jenkins server was using pipelines that were both building Docker images as well as running them. This caused an issue when initiated from inside Docker. To solve this, a second VM (yScout) was used to operate as Jenkins slave, outside of Kubernetes cluster. The Jenkins master (inside Docker) controlled Jenkins slave - that was installed on Ubuntu - which could use and run Docker without any issues.

The solution worked, developers loved it - using Rancher console to access log files and to modify parameters of workloads was a piece of cake. Life was good.


## Troubles with Faith 

The PS business during 2017-2018 was great, the Valencia team grew and started to work on new projects. The developers loved the easy to use toolchain behind Rancher and automation they saw in use in existing projects - and wanted the new project to have the same. Eventually Faith ran out of capacity - at first, disk space. It turned out the original guesstimates for disk capacity were way too conservative. It was not a huge technical problem to add disk space as the datacenter still had some capacity, but it did require low level changes in VM parameters which required downtime. And downtime on a shared server is a big deal. As Murphy's law defines it took several weeks to find a window where all of the hosted projects were OK with their QA / Integration environment being down AND the scarce technical resource from Tenzing that had both the knowledge and the skills for making low level adjustments in OpenStack was available.

Meanwhile, José submitted his resignation and left the company. He tried his best to do knowledge transfer, but when there is nobody available to replace leaving engineers right away and multiple people are expected to "temporarily" own pieces of José's portfolio, a gap was created: there was nobody available who would own Faith's maintenance and upkeep for all projects. With multiple projects sharing the resource and none of them actually budgeting for it, there were no volunteers to finance it either. If the Faith setup was fully scripted and automated, it would have been easier - but with everything being setup via Rancher console, one would only see the end result and troubleshooting would require first hand knowledge of everything that happened to that particular configuration. That knowledge was gone, as José was enjoying steaks in Argentina and learning Google Cloud for his new DevOps gig.

All summed up, we have eventually upgraded Faith and after several iterations added the new projects. But it took several weeks of going back and forth, finding out broken things and searching for solutions. This must have been annoying for all project leads, experiencing downtime and some hiccups. Some projects soon wanted to add new features (like multi-branch parallel unit testing) which pushed the need for resources and there was real danger that the whole circus would have to repeat. The Faith still did not have a new owner - despite that new DevOps guy being hired and replacing José's work for CI/CD evolution, none of the projects had any realistic budget for infrastructure projects or resources.

To make things worse, the XIP.IO became flaky and unreliable and added even more interruption. People say "you get what you pay for" - so using free service ended up wasting lots of time (and money) by interruption and investigations that turned up leading nowhere as intermittent DNS failures have been causing a wide range of really interesting exceptions inside the pipelines.

Kubernetes, Rancher and Docker are very dynamic systems and since 2018 many new versions have come. We have never upgraded the Faith system though as it was near impossible to find a suitable window - and as nobody really wanted to bear the cost of this work.

Security was never the most important concern for development and non-production environments - the approach features first, hardening second makes sense when the deadlines are really tight and there is a need to make the next sprint demo. Some of the tools used inside stacks in projects are rather old and have their own share security issues. As the Faith have single external public IP, we had to start whitelisting the access to K8s cluster and to all hosted projects to hide these vulnerable tools (hello Jenkins, hello Sonarqube). Adding whitelisting created lots of issues for development teams working from home and 3rd parties collaboration. And it also took forever - because the management of the firewall layer was a manual process using MS services in different timezones. Because of that, sometimes simple addition of IP or opening additional ports took several iterations and sometimes days for something that is a matter of minutes if the system was hosted in an AWS VPC.

As of now (March 2020), all the projects that were added to Faith are still there (as long as they are active). Everything kinda works - for now - provided that XIP.IO is having a good day. There is still just a single cluster with a single Jenkins slave host - two big single points of failure. 


## Lessons Learned

There is a proverb about road to hell and good intentions, which is very much applicable in this case. Nobody did really anything wrong in the case of Faith, most decisions were best shots of all participants to solve urgent problems with available tools, taking immediate needs into account and spending as little time and dollars as possible. This series of seemingly correct tactical decisions created a big ball of technical debt that is now preventing progress and slowing us down.

With a hindsight, here is what we should have done differently:

1) We should have chosen AWS, not datacenter. This would have eliminated capacity problem and scaling, would allow to decide whether to add more servers when needed or even create duplicate of the setup if required.

2) Instead of taking provisioned servers and manually configuring them via Rancher console, we should have used automated tools “Infrastructure as a Code” such as CloudFormation or Terraform to create everything - so that the script would not only be source of all configuration, it would allow recreate it or create more copies. Note the #2 is possible only as consequence of #1 - the use of automation and IaaC inside the data center is quite limited.

3) Instead of combining projects, we should have gone with per project infrastructure, which would have simplified ownership issues from business point of view as well as eliminate single point of failure and downtime windows issue.

4) We should have avoided using free services (hello XIP.IO) and go with standard DNS, together with AWS network infrastructure. This would have allowed manage security efficiently on per project basis and freely cooperate with 3rd parties, while properly isolating both customers and development teams.

5) We should have considered self service by developers as one the most important features and avoid any workflows that would depend on specialized third party access or knowledge.

The psychological aspect of using or not using automation is also very important. If one puts lots of effort, sweat and time into configuring a server manually, he or she will be very hesitant to throw it away and will hang on to it. The answer to a question “the project goes on pause for next 2-3 weeks, could we shut the QA / Integration down to save some cost” will be clear and sound “Hell, NO !”. Not only because nobody remembers EXACTLY those little tweaks and fixes that were applied over weeks to get system to state where it is now, but also because *everybody* remembers very well the long hours spent to get it set up in the first place. This is well known as Escalation of Commitment - see https://en.wikipedia.org/wiki/Escalation_of_commitment. As a result, the once created servers are rarely touched or replaced voluntarily and let to slowly rot up to the point where external events like hardware failure will make everybody face a new reality they cannot change. Then the panic begins and another quick tactical decision is made to get things up and running ASAP, increasing the technical debt even more.

The key factor here is that properly automating something versus using some console or GUI to manually set it up *always* takes longer (usually several times longer) - just compare clicking away to get some AWS servers deployed vs. writing a proper Terraform script wrapped in a pipeline. If all you need is this ONE system and you completely ignore all the other factors - scalability, auditability, maintainability, extensibility, documentation, knowledge retention, it may even be a good approach.

This shortsightedness is the main cause of all duck-taped frankenservers I have seen out there. Just a quick fix,let’s put in a temporary solution when we will have more time and be out of time crunch. We will come back and fix it later. In 99% of the cases, LATER equ NEVER.

## Solution => OneClick

We have been working since few weeks on different approach, with working name "OneClick Development Environment"

The main objective is fully automated, GitOps inspired system that is able to create fully functioning Dev QA environment for Hybris (at first) but eventually any templatized project from scratch within 2 hours, including full infrastructure setup, QA tools, CI/CD pipeline and deployment of a functioning app.

With all the above mentioned history, automation will be the king. Apologies to you - cash - in this case you have to be dethroned. Automation dictates it must be IaaC based solution. The fact that we are living in 2020 dictates it needs to be cloud-native. Putting these together, results in an on-demand, create anytime, destroy anytime, pay-as-you go solution.

We use  EKS “bootstrap” install for small footprint K8s clusters to keep costs down.
Terraform state is hosted inside the AWS account (S3 + DynamoDB) to separate the DEV/QA world from production systems using the Terraform Enterprise backend. This way, there is no need to manually setup the accounts and we can keep dev teams out of production infrastructure territory.

Everything is pipeline driven - so no tooling on the developer's machine required. 

Developer uses the provided CLI tool to create project specific forks the infrastructure repo and an app template repo and adds values for variables. We assume that each project will have separate DEV AWS account created and team lead will enter the provided credentials to variables of the Bitbucket pipeline

The infrastructure pipelines creates full infrastructure, including all code quality tools and Jenkins installation, specific for a project. Everything is fully configured and available within ~ 20 minutes after the pipeline run. Instead of co-locating multiple projects, we host all Dev/QA environments for a single project in one cluster. This  allows running multiple versions of an application in different namespaces of the cluster - multibranch development and testing.

The application repository inherits all automation components from the app template. While the application contains the actual project specific code, the inherited pieces (detailed specification of the project build and deployment pipelines) are customized versions of the template shared within a group of projects - e.g. Hybris project app template.

The important prerequisite for this to happen is the “pre-containerization” of the project. The application template must contain Dockerfile for building images for all components of the running application and a Helm chart that defines topology and allow to run this application inside a Kubernetes cluster. This may represent significant effort for some classes of applications, however - with current trends seen in enterprise applications, everything is moving to containers in the cloud so having this ability is essential for the future anyway.

## Benefits of the new solution

Using infrastructure designed according to the principles stated above, maximizes the “on-demand-ness” - so that we can schedule shutdown of environments for 10/hrs a day and weekends and any developer with access to Bitbucket repo can bring it up if required. We can have as many environments as we need, with very short start time (< 2hrs) from zero, without any issues of clinging to and taking care of something that was very hard to get.

Even with overhead of per-project infrastructure, it may be the end cheaper than a shared large cluster running 24x7x365 because multiple projects depend on it.

It is much easier to keep the system up to date. Instead of maintenance or patching, we can simply use the latest version of images for tools such as Jenkins, Sonar and every new environment will automatically use them. To update an existing environment, we simply rebuild it - this is probably faster than patching and leads to better defined outcome.

By delegating the operation to developers via pipelines, we can eliminate the need for maintenance of these environments. All the beforehand had to be done by specialized resources, is now packaged and available to the development team - creation, configuration and whitelisting for remote access. And by using dedicated cloud accounts, there is no increased risk of allowing non-production teams accessing and modifying network resources that are shared between non-production and production accounts.

By using templates based infrastructure and project repositories, we are closer to unified structure of projects and have increased the reuse of the most recipes/scripts. This leads to less code, and ultimately to less maintenance.

Life is good, again :-)


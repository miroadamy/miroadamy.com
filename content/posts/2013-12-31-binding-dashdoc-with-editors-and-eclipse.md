---
layout: post
title: Binding DashDoc with editors and Eclipse
date: 2013-12-31 00:57:35.000000000 -05:00
type: post
comments: true
published: true
status: publish
category: programming
tags:
- osx
- java
- vim
author: "Miro Adamy"
---
If you use DashDoc (see http://kapeli.com/dash), it can be integrated with editor or Eclipse to allow automatically find selected text in Dash documentation sets:

### Sublime Text

This is easy - there is DashDoc plugin - https://sublime.wbond.net/packages/DashDoc  
The plugin is OS-X specific, because the DashDoc is

* Start Package Control (Cmd-Shift-P)
* select Install Package (type Install)
* select DashDoc

The Ctrl-H does the search

### Eclipse

There is opensource plugin for it at https://github.com/justinkb/DashLookup#readme.

* clone the repo - https://github.com/justinkb/DashLookup#readme
* Open Eclipse and Import project to Workspace
* Build it 
* Select 'Export deployable plugin and Fragments' and install to host:

![](/images/binding-dashdoc-with-editors-and-eclipse_5.png)

![](/images/binding-dashdoc-with-editors-and-eclipse_4.png)

![](/images/binding-dashdoc-with-editors-and-eclipse_3.png)

![](/images/binding-dashdoc-with-editors-and-eclipse_2.png)

Bind the command DashLookup (Preferences -> General -> Keys) to keys of your choice

### Vim

See https://github.com/rizzatti/dash.vim#readme

I am using Pathogen, so

```
cd ~/.vim/bundle
git clone https://github.com/rizzatti/funcoo.vim.git
git clone https://github.com/rizzatti/dash.vim.git
```

The submodule file needs to be edited with these locations:

```
.vim $ cat .gitmodules | pbcopy
 
[submodule "bundle/vim-fugitive"]
	path = bundle/vim-fugitive
	url = git://github.com/tpope/vim-fugitive.git
	ignore = untracked
[submodule "bundle/vim-pathogen"]
	path = bundle/vim-pathogen
	url = git://github.com/tpope/vim-pathogen.git
	ignore = untracked
[submodule "bundle/tlib_vim"]
	path = bundle/tlib_vim
	url = git://github.com/tomtom/tlib_vim.git
	ignore = untracked
[submodule "bundle/vim-unimpaired"]
	path = bundle/vim-unimpaired
	url = git://github.com/tpope/vim-unimpaired.git
	ignore = untracked
[submodule "bundle/funcoo.vim"]
	path = bundle/funcoo.vim
	url = https://github.com/rizzatti/funcoo.vim.git
	ignore = untracked
[submodule "bundle/dash.vim"]
	path = bundle/dash.vim
	url = https://github.com/rizzatti/dash.vim.git
	ignore = untracked
```

The new command is :Dash and the mapping to search word under cursor is

```
:nmap <silent> <leader>d <Plug>DashSearch
:nmap <silent> <leader>D <Plug>DashGlobalSearch
```

![](/images/binding-dashdoc-with-editors-and-eclipse_1.png)

The leader is '\'


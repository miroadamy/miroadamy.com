---
title: "Keepass-Node install"
date: 2014-10-03T11:22:48+08:00
published: true
type: post
categories: ["programming"]
tags: ["git"]
author: "Miro Adamy"
---

See <https://github.com/gesellix/keepass-node>

```
➜  keepass-node git:(master) pwd
/Users/miro/src/PLG/keepass-node
```

## Install


```
➜  keepass-node git:(master) ✗ sudo npm install
Password:
> dejavu@0.4.4 postinstall /Users/miro/src/PLG/keepass-node/node_modules/keepass.io/node_modules/dejavu
> node bin/post_install.js
Saving runtime configuration in /Users/miro/src/PLG/keepass-node/node_modules/keepass.io/.dejavurc
> keepass.io@1.0.5 install /Users/miro/src/PLG/keepass-node/node_modules/keepass.io
> (node-gyp rebuild 2>&1) || (echo 'DO NOT WORRY ABOUT THESE MESSAGES. KEEPASS.IO WILL FALLBACK TO SLOWER NODE.JS METHODS, SO THERE ARE NO LIMITATIONS EXCEPT SLOWER PERFORMANCE.'; exit 0)
\
Agreeing to the Xcode/iOS license requires admin privileges, please re-run as root via sudo.
Agreeing to the Xcode/iOS license requires admin privileges, please re-run as root via sudo.
 
gyp ERR! build error
gyp ERR! stack Error: `make` failed with exit code: 69
gyp ERR! stack     at ChildProcess.onExit (/usr/local/lib/node_modules/npm/node_modules/node-gyp/lib/build.js:267:23)
gyp ERR! stack     at ChildProcess.emit (events.js:98:17)
gyp ERR! stack     at Process.ChildProcess._handle.onexit (child_process.js:810:12)
gyp ERR! System Darwin 13.4.0
gyp ERR! command "node" "/usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js" "rebuild"
gyp ERR! cwd /Users/miro/src/PLG/keepass-node/node_modules/keepass.io
gyp ERR! node -v v0.10.31
gyp ERR! node-gyp -v v1.0.1
gyp ERR! not ok
DO NOT WORRY ABOUT THESE MESSAGES. KEEPASS.IO WILL FALLBACK TO SLOWER NODE.JS METHODS, SO THERE ARE NO LIMITATIONS EXCEPT SLOWER PERFORMANCE.
chai-as-promised@4.1.1 node_modules/chai-as-promised
underscore@1.7.0 node_modules/underscore
q@1.0.1 node_modules/q
compression@1.1.0 node_modules/compression
├── bytes@1.0.0
├── on-headers@1.0.0
├── vary@1.0.0
├── debug@2.0.0 (ms@0.6.2)
├── compressible@2.0.0 (mime-db@1.0.3)
└── accepts@1.1.1 (negotiator@0.4.8, mime-types@2.0.2)
chai@1.9.2 node_modules/chai
├── assertion-error@1.0.0
└── deep-eql@0.1.3 (type-detect@0.1.1)
express@4.9.5 node_modules/express
├── merge-descriptors@0.0.2
├── utils-merge@1.0.0
├── fresh@0.2.4
├── cookie@0.1.2
├── escape-html@1.0.1
├── range-parser@1.0.2
├── cookie-signature@1.0.5
├── media-typer@0.3.0
├── vary@1.0.0
├── finalhandler@0.2.0
├── parseurl@1.3.0
├── methods@1.1.0
├── serve-static@1.6.3
├── path-to-regexp@0.1.3
├── depd@0.4.5
├── qs@2.2.4
├── debug@2.0.0 (ms@0.6.2)
├── on-finished@2.1.0 (ee-first@1.0.5)
├── etag@1.4.0 (crc@3.0.0)
├── proxy-addr@1.0.3 (forwarded@0.1.0, ipaddr.js@0.1.3)
├── send@0.9.3 (destroy@1.0.3, ms@0.6.2, mime@1.2.11)
├── type-is@1.5.2 (mime-types@2.0.2)
└── accepts@1.1.1 (negotiator@0.4.8, mime-types@2.0.2)
mocha@1.21.4 node_modules/mocha
├── diff@1.0.7
├── growl@1.8.1
├── commander@2.0.0
├── mkdirp@0.3.5
├── debug@2.0.0 (ms@0.6.2)
├── jade@0.26.3 (commander@0.6.1, mkdirp@0.3.0)
└── glob@3.2.3 (inherits@2.0.1, graceful-fs@2.0.3, minimatch@0.2.14)
body-parser@1.9.0 node_modules/body-parser
├── bytes@1.0.0
├── media-typer@0.3.0
├── raw-body@1.3.0
├── depd@1.0.0
├── qs@2.2.4
├── iconv-lite@0.4.4
├── on-finished@2.1.0 (ee-first@1.0.5)
└── type-is@1.5.2 (mime-types@2.0.2)
coveralls@2.11.2 node_modules/coveralls
├── lcov-parse@0.0.6
├── log-driver@1.2.4
├── request@2.40.0 (json-stringify-safe@5.0.0, forever-agent@0.5.2, aws-sign2@0.5.0, oauth-sign@0.3.0, stringstream@0.0.4, tunnel-agent@0.4.0, qs@1.0.2, node-uuid@1.4.1, mime-types@1.0.2, tough-cookie@0.12.1, form-data@0.1.4, http-signature@0.10.0, hawk@1.1.1)
└── js-yaml@3.0.1 (esprima@1.0.4, argparse@0.1.15)
istanbul@0.3.2 node_modules/istanbul
├── abbrev@1.0.5
├── which@1.0.5
├── nopt@3.0.1
├── wordwrap@0.0.2
├── once@1.3.1 (wrappy@1.0.1)
├── async@0.9.0
├── resolve@0.7.4
├── mkdirp@0.5.0 (minimist@0.0.8)
├── fileset@0.1.5 (minimatch@0.4.0, glob@3.2.11)
├── esprima@1.2.2
├── escodegen@1.3.3 (estraverse@1.5.1, esutils@1.0.0, source-map@0.1.40, esprima@1.1.1)
├── handlebars@1.3.0 (optimist@0.3.7, uglify-js@2.3.6)
└── js-yaml@3.2.2 (esprima@1.0.4, argparse@0.1.15)
googleapis@1.0.14 node_modules/googleapis
├── async@0.9.0
├── multipart-stream@1.0.0 (inherits@2.0.1, sandwich-stream@0.0.4)
├── request@2.40.0 (json-stringify-safe@5.0.0, aws-sign2@0.5.0, forever-agent@0.5.2, oauth-sign@0.3.0, stringstream@0.0.4, tunnel-agent@0.4.0, qs@1.0.2, node-uuid@1.4.1, mime-types@1.0.2, form-data@0.1.4, tough-cookie@0.12.1, http-signature@0.10.0, hawk@1.1.1)
└── gapitoken@0.1.3 (jws@0.0.2)
keepass.io@1.0.5 node_modules/keepass.io
├── async@0.9.0
├── nan@1.2.0
├── xml2js@0.4.4 (sax@0.6.0, xmlbuilder@2.4.4)
└── dejavu@0.4.4 (amdefine@0.0.8, mout@0.4.0)
➜  keepass-node git:(master)
```

Kinda weird to ignore errors, but anyway ...

## Start

```
➜  keepass-node git:(master) npm start
> keepass-node@0.0.1 start /Users/miro/src/PLG/keepass-node
> node ./server.js
server is listening on port 8443
```

All kbdx files must be in /local/ directory.

Also supports loading from Google Drive

![](/images/2014-10-03_1-33-21.png)
![](/images/2014-10-03_1-33-37.png)



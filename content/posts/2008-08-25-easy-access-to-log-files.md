---
layout: post
title: Easy access to log files
date: 2008-08-25 22:04:04.000000000 -04:00
type: post
published: true
status: publish
category: programming
tags: []
author: "Miro Adamy"
---

Here is the scoop: I need to provide access to multiple log files spread across multiple directories of multiple machines. For example - the JBoss log files and nohup.out, ATG log files, and so on - so that the testers can see what happened on server side when something looks fishy on front end.

One option would be to write a document that contails IP's of the machines, create user accounts, make sure that they have just enough access rights to see the files but not disturb anything else ...

Other option is to leverage the already installed Python across all the servers. I wish it was Ruby, but one cannot have everything.

On each machine, I created directory - e.g. 

`~/webaccess` 

and made symbolic links to all log files or log directories required.


Then I placed this python script into the directory: 


```
#!/usr/bin/python

import SimpleHTTPServer
import SocketServer

# minimal web server.  serves files relative to the
# current directory.

PORT = 9999

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

Handler.extensions_map.update({
'': 'application/octet-stream', # Default
'.out': 'text/plain',
'.log': 'text/plain'
})
httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
```

and started it as

`nohup ./simpleserver.py &`

From this moment on, all files linked (actually all files in subtree of server directory) are accessible by going to 

`http://SERVERNAME:9999/` 

- which shows directory listing for linked files.</p>
<p>On one of the machine, I have placed additional file - index.html that contained links to all other server names.</p>
<p>Thanks to <a href="http://effbot.org/librarybook/simplehttpserver.htm" target="_blank">this page</a> for inspiration.</p>

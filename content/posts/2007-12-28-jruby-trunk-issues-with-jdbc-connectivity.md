---
layout: post
title: JRuby trunk - issues with JDBC connectivity
date: 2007-12-28 22:24:37.000000000 -05:00
type: post
published: true
status: publish
category: programming
tags: [ruby,java]
meta: {}
author: "Miro Adamy"
---
<p>Following the <a href="http://www.apress.com/book/view/1590598814" target="_blank">book on JRuby</a> I am discovering small differences when trying the examples. After installing activerecord-jdbc gem which is available in version 0.5, the shoplet application fails with Rails 2.0, as soon as you click on the 'About your application environment' link.</p>

```
    => Booting Mongrel (use 'script/server webrick' to force WEBrick)
    => Rails application starting on http://0.0.0.0:3000
    => Call with -d to detach
    => Ctrl-C to shutdown server
    ** Starting Mongrel listening at 0.0.0.0:3000
    ** Starting Rails with development environment...
    ** Rails loaded.
    ** Loading any Rails specific GemPlugins
    ** Signals ready.  TERM => stop.  USR2 => restart.  INT => stop (no restart).
    ** Rails signals registered.  HUP => reload (without restart).  It might not work well.
    ** Mongrel 1.1.2 available at 0.0.0.0:3000
    ** Use CTRL-C to stop.

    Processing InfoController#properties (for 127.0.0.1 at 2007-12-23 23:13:25) [GET]
    Session ID: BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo%0ASGFzaHsABjoKQHVzZWR7AA%3D%3D--9791be23205677745e457b5bf62c50eba6e3813f
    Parameters: {"controller"=>"rails/info", "action"=>"properties"}
    Exception in thread "Ruby Thread11043409" java.lang.NoSuchMethodError: org.jruby.runtime.builtin.IRubyObject.setInstanceVariable(Ljava/lang/String;Lorg/jruby/runtime/builtin/IRubyObject;)Lorg/jruby/runtime/builtin/IRubyObject;
    at JdbcAdapterInternalService.set_connection(JdbcAdapterInternalService.java:122)
    at JdbcAdapterInternalServiceInvoker$set_connection_FS1.call(Unknown Source)
    at org.jruby.runtime.callback.FastInvocationCallback.execute(FastInvocationCallback.java:55)
    at org.jruby.internal.runtime.methods.SimpleCallbackMethod.call(SimpleCallbackMethod.java:70)
    at org.jruby.runtime.CallSite$InlineCachingCallSite.call(CallSite.java:158)
    at org.jruby.runtime.CallSite$ArgumentBoxingCallSite.call(CallSite.java:103)
    at org.jruby.evaluator.ASTInterpreter.fCallNode(ASTInterpreter.java:1092)
    at org.jruby.evaluator.ASTInterpreter.evalInternal(ASTInterpreter.java:345)
    at org.jruby.evaluator.ASTInterpreter.blockNode(ASTInterpreter.java:626)
    at org.jruby.evaluator.ASTInterpreter.evalInternal(ASTInterpreter.java:293)
    at org.jruby.evaluator.ASTInterpreter.eval(ASTInterpreter.java:168)
    at org.jruby.internal.runtime.methods.DefaultMethod.call(DefaultMethod.java:147)
    at org.jruby.runtime.CallSite$InlineCachingCallSite.call(CallSite.java:158)
    at org.jruby.runtime.CallSite$ArgumentBoxingCallSite.call(CallSite.java:76)
    at org.jruby.evaluator.ASTInterpreter.vcallNode(ASTInterpreter.java:1734)
    at org.jruby.evaluator.ASTInterpreter.evalInternal(ASTInterpreter.java:474)
    at org.jruby.evaluator.ASTInterpreter.blockNode(ASTInterpreter.java:626)
    at org.jruby.evaluator.ASTInterpreter.evalInternal(ASTInterpreter.java:293)
    at org.jruby.evaluator.ASTInterpreter.rescueNode(ASTInterpreter.java:1499)
    at org.jruby.evaluator.ASTInterpreter.evalInternal(ASTInterpreter.java:442)
    at org.jruby.evaluator.ASTInterpreter.eval(ASTInterpreter.java:168)
```

I found out that there is newer version of activerecord-jdbc, which is also renamed to activerecord-jdbc-adapter. It is important to uninstall the old gem as well as install the new one, otherwise the application will not work.


```
    $ jruby -S gem install activerecord-jdbc-adapter
    Successfully installed activerecord-jdbc-adapter-0.7
    1 gem installed
    Installing ri documentation for activerecord-jdbc-adapter-0.7...
    Installing RDoc documentation for activerecord-jdbc-adapter-0.7...
    $ jruby -S gem install activerecord-jdbcmysql-adapter
    Successfully installed jdbc-mysql-5.0.4
    Successfully installed activerecord-jdbcmysql-adapter-0.7
    2 gems installed
    Installing ri documentation for jdbc-mysql-5.0.4...
    Installing ri documentation for activerecord-jdbcmysql-adapter-0.7...
    Installing RDoc documentation for jdbc-mysql-5.0.4...
    Installing RDoc documentation for activerecord-jdbcmysql-adapter-0.7...</p>
    $ jruby -S gem list activerecord</p>
    *** LOCAL GEMS ***</p>
    activerecord (2.0.2, 1.15.6)
    ActiveRecord-JDBC (0.5)
    activerecord-jdbc-adapter (0.7)
    activerecord-jdbcmysql-adapter (0.7)</p>
    $ gem uninstall ActiveRecord-JDBC
    Successfully uninstalled ActiveRecord-JDBC-0.5
    miroslav-adamys-macbook-pro:shoplet miro$ gem list ActiveRecord-JDBC</p>
    *** LOCAL GEMS ***</p>
    activerecord-jdbc-adapter (0.7)
    activerecord-jdbcmysql-adapter (0.7)</p>
```

After this, everything works and shoplet connects to database - as you can see from the console log.

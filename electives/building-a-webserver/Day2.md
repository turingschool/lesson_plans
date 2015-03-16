Building a webserver Day 2
==========================

## Recap

## See a web request.

```
$ curl -i http://google.com
curl -i http://google.com
HTTP/1.1 301 Moved Permanently
Location: http://www.google.com/
Content-Type: text/html; charset=UTF-8
Date: Mon, 02 Mar 2015 21:46:38 GMT
Expires: Wed, 01 Apr 2015 21:46:38 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 219
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Alternate-Protocol: 80:quic,p=0.08

<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

See a web response

```
$ nc -l 3000
```

Now go to "http://localhost:3000/a/b/c?def=123" in your browser.
Swap the port, eg 3001, if that one is taken by something like a Rails app.


## Sending and receiving web requests in Ruby

Start a TCP Server in one Ruby process

```ruby
$ pry -r socket
> server = TCPServer.new 3000
> client = server.accept
> client
> ls -v client
> client.gets
> client.print "hello, browser\r\n"
> client.close
```

In another shell, open pry,
and load [rest-client](https://rubygems.org/gems/rest-client),
which we'll use to make the request.

```ruby
$ pry -r socket -r rest-client
> socket = TCPSocket.new 'localhost', 3000
> socket.puts "hello, client"
> socket.gets
> socket.close
```

Last time we wrote our acceptance test right at the end,
lets [take a look](https://github.com/turingschool/lesson_plans/blob/f576012bdd48d0aac5aa67d029cb40fd1db20f8b/electives/building-a-webserver/server-from-class/spec/acceptance_spec.rb)
at it, and make sure we understand what it's doing.


# Implementing the server

## Normal TDD for a bit

See where our tests are at:

```sh
$ rspec
F

Failures:

  1) Acceptance test accepts and responds to a web request
     Failure/Error: server = MahWebserver.new(3000) do |request, response|
     NameError:
       uninitialized constant MahWebserver
     # ./spec/acceptance_spec.rb:7:in `block (2 levels) in <top (required)>'

Finished in 0.00045 seconds (files took 0.38584 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/acceptance_spec.rb:6 # Acceptance test accepts and responds to a web request
```

So, we need a server. The `&app` takes the block that we passed it,
and stores it in a local variable. We can execute it with `app.call`,
but we'll just store it for later, its job is to handle requests,
(eg a Rails app).

```ruby
class MahWebserver
  def initialize(port, &app)
    @port = port
    @app  = app
  end

  def start
  end
end
```

And now, we run it:

```
$ rspec
F

Failures:

  1) Acceptance test accepts and responds to a web request
     Failure/Error: response = RestClient.get 'localhost:3000/users'
     Errno::ECONNREFUSED:
       Connection refused - connect(2) for "localhost" port 3000
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:413:in `transmit'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:176:in `execute'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:41:in `execute'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient.rb:65:in `get'
     # ./spec/acceptance_spec.rb:14:in `block (2 levels) in <top (required)>'

Finished in 0.01661 seconds (files took 0.37544 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/acceptance_spec.rb:6 # Acceptance test accepts and responds to a web request
```

So, we need to actually accept the request now. We'll use our `TCPServer` code from earlier.

```ruby
require 'socket'

class MahWebserver
  def initialize(port, &app)
    @port = port
    @app  = app
  end

  def start
    @server = TCPServer.new 3000
    client  = @server.accept
  end
end
```

And now when we run it, we see the server hangs.
That's because it's just waiting for a request, so the method never returns.

## Execute code at the same time with threas

To get past this, we'll need threads,
which allow two pieces of code to execute at the same time.

```ruby
array  = []

thread = Thread.new do
  5.times do
    array << 1
    sleep rand(2)
  end
end

5.times do
  array << 2
  sleep rand(2)
end

# wait for `thread` to finish executing
thread.join

array # => [2, 1, 1, 2, 2, 1, 2, 1, 1, 2]
```


## Using this in our test

Lets update our test to put a thread around the server.
I don't know where it goes yet, so I'm putting it in the test itself.
When more requirements come in, it will be more obvious.

```ruby
# ...
server_thread = Thread.new { server.start }
response = RestClient.get 'localhost:3000/users'
server.stop
server_thread.join
# ...
```

When we run it again, it hangs.
This is because `RestClient` is waiting for the response
which never comes.
We need to go build out the server some more.

Lets put a `pry` in and run the tests to see what we can do.

```ruby
$ rspec

From: /Users/josh/code/jsl/lesson_plans/electives/building-a-webserver/server-from-class/lib/mah_webserver.rb @ line 13 MahWebserver#start:

     9: def start
    10:   @server = TCPServer.new 3000
    11:   client  = @server.accept
    12:   require "pry"
 => 13:   binding.pry
    14: end

[1] pry(#<MahWebserver>)> client.gets
=> "GET /users HTTP/1.1\r\n"

[2] pry(#<MahWebserver>)> client.gets
=> "Accept: */*; q=0.5, application/xml\r\n"

[3] pry(#<MahWebserver>)> client.gets
=> "Accept-Encoding: gzip, deflate\r\n"

[4] pry(#<MahWebserver>)> client.gets
=> "User-Agent: Ruby\r\n"

[5] pry(#<MahWebserver>)> client.gets
=> "Host: localhost:3000\r\n"

[6] pry(#<MahWebserver>)> client.gets
=> "\r\n"

[7] pry(#<MahWebserver>)> client.puts "zomg!"
=> nil

[8] pry(#<MahWebserver>)> exit
F

Failures:

  1) Acceptance test accepts and responds to a web request
     Failure/Error: response = RestClient.get 'localhost:3000/users'
     Net::HTTPBadResponse:
       wrong status line: "zomg!"
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:270:in `net_http_do_request'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:418:in `block in transmit'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:413:in `transmit'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:176:in `execute'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient/request.rb:41:in `execute'
     # /Users/josh/.gem/ruby/2.1.1/gems/rest-client-1.7.2/lib/restclient.rb:65:in `get'
     # ./spec/acceptance_spec.rb:14:in `block (2 levels) in <top (required)>'

Finished in 21.21 seconds (files took 0.38227 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/acceptance_spec.rb:6 # Acceptance test accepts and responds to a web request
```

So, when we made the response, it completed the test with an exception from
`RestClient`, saying that we did it wrong.

## Plan

* What we need to do at this point is parse the request into that request object.
  We'll do this at the unit test level.
* Then we need to make a response object. Also a unit test, but what do we need it to do?
* We figure that out by hooking it up in the acceptance test and seeing what
  failures we get from the acceptance test. the tests to see what we need for it,
  translating each acceptance test failure into a unit test.
* Then we need it to generate a valid http response, also as unit tests.
* And finally, get our acceptance test passing.
* If there's time, lets try and get a post request working.

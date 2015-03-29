Building a webserver Day 2
==========================

Lets start with a Recap of what we covered last time.

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

-----

Now, we'll begin implementing our server.

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
That's because it's stuck waiting waiting for a request,
like when you call `gets`.
So the method never returns, and thus we can never make the request!

## Execute code at the same time with threads

To get past this, we'll need threads,
which allow two pieces of code to execute at the same time.
Here, we have a thread inserting `1` into `array`,
and our main thread inserts 2. Normally, all the `1`s would
be inserted, then all the `2`s. But since we're doing
this in threads, they are interleaved -- the code is executing
in parallel.

```ruby
array  = []

thread = Thread.new do
  5.times do
    array << 1 # this thread inserts 1
    sleep rand(2)
  end
end

5.times do
  array << 2 # this thread inserts 2
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

Prying from our test to get context
-----------------------------------

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
`RestClient`, saying that what the server returned (`"zomg"`) was not a valid
HTTP response.

## Plan

* What we need to do at this point is parse the request that we saw with `client.gets`
  into that request object. We'll do this at the unit test level.
* Then we need to make a response object. Also a unit test, but what do we need it to do?
* We figure that out by hooking it up in the acceptance test and seeing what
  failures we get from the acceptance test. the tests to see what we need for it,
  translating each acceptance test failure into a unit test.
* Then we need it to generate a valid HTTP response, also as unit tests.
* And finally, get our acceptance test passing.
* If there's time, lets try and get a post request working.


## Implementing from the top.

So, what should our code do? Lets just think through it sequentially,
and add use nonexistent code according to what makes sense from the top here.
We can later make this code actually work, but for now,
it's super cheap to just build on top of nothing.

How about if that returns a `Request` object.
And it'll need to hand our code a response object.
Then

```ruby
  def start
    # Lets edit the server to use the passed in port
    server   = TCPServer.new(@port)
    client   = server.accept

    # It's going to need to parse the request, and hand the block a request object.
    # So... lets try a few things out. This line seems to make sense, according to that need.
    request  = Request.parse(client)

    # And the second param that the block receives is a response
    # So lets use a Response object. What does it need?
    # I don't know, I just know I need it to exist!
    response = Response.new

    # Call block, pass it the request and response
    # Hmm, we'll figure out what to do with this later.

    # After calling the block, the app has had a chance to tell us what it wants to do.
    # It told us by setting values on the Response object.
    # So now we need to turn that into an HTTP response,
    # lets use a nonexistent method, to_http, on our nonexistent class `Response`
    # And our response is just like a file, or $stdout, so we can call 'print' on it
    # (why print and not puts?)
    client.print(response.to_http)

    # And when we're done, we need to close the input that we read the request from,
    # and the output that we wrote the response to.
    client.close
  end
```

## Using this to drive our wiring

So, our code doesn't work right now, since it's foundation is hopes and dreams,
and not actual code! Running our test, we see the first failure is that we don't have
a `Request` class. Creating it, the second problem is that we can't call `Request.parse`.
So, lets make that, too. We don't need it to be real yet, nothing in our test depends on it,
and we don't know what it needs to look like or do yet.

I'm just going to put this all in the same file for simplicity.
We can pull them out into different files later, if we like.

```ruby
class Request
  def self.parse(stream)
    new
  end
end
```

The next thing we hit is that there is no `Response` class, so lets make that.
And then, there is no `to_http` method. We can make that too.
To verify that this is reasonable, lets hard-code the HTTP response that is
expected by our test, and make sure that the test passes.
Right now, we've implemented so little of the code, that seeing it go all the way
through like this will help us verify that our plan is good.

```ruby
class Response
  def to_http
    "HTTP/1.1 200 OK\r\n" +
    "Content-Type: text/html;charset=utf-8\r\n" +
    "X-XSS-Protection: 1; mode=block\r\n" +
    "X-Content-Type-Options: nosniff\r\n" +
    "X-Frame-Options: SAMEORIGIN\r\n" +
    "Content-Length: 16\r\n" +
    "omg: bbq\r\n" +
    "\r\n" +
    "hello, class ^_^"
  end
end
```

And what happens? Our test passes!

Recap
-----

So, we started with a little exploration to see how the pieces fit,
then we made a test that uses our server the way a client (eg browser)
would. Then used that to drive the outermost interface to the server.
Then we used that to drive the toplevel algorithm of the server.
For that algorithm, we just copied the code we tried out in pry,
right into the server.

That, in turn, used things that didn't exist, so we had to go make those things.
We didn't worry about correctness, we don't know what is correct, and we don't have
any tests to verify it is correct. We just worried about getting the wiring in place
so that we could see the tests pass.

Next Time
---------

That got our test passing, but now we need to go through and
replace our hard-coded and missing implementations with real implementations.
We'll do that with unit tests. The requirements are determined by how we're using
the code, what does it need to do? At the same time, we may discover things while writing
the unit tests that help us better understand the higher level code.
So the low and high level tests each get context and give context to each other.
this helps us figure out what we are doing, and where we are going,
and give us a sharp understanding of what needs to happen,
which reduces the number of incorrect paths we go down,
and dramatically reduces the amount of time required to complete our task.

### More on blocks

If you'd like to explore blocks a bit more,
I made a playground to show you how they work,
and asks interesting questions that you'll have to explore in order to answer!

1. Start here: [New Kids On The Block](http://104.131.24.233/blocks/new-kids-on-the-block)
2. This gets a bit more involved: [Block It Up And Do It Again](http://104.131.24.233/blocks/block-it-up-and-do-it-again)
3. Don't do this one if you're epistemological insecure. [How I Learned To Stop Worrying And Love The Block](http://104.131.24.233/blocks/how-i-learned-to-stop-worrying-and-love-the-block)

See you next time!

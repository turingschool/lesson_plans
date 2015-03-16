Building a webserver Day 1
==========================

## What is a web server

A program that listens to the internet and allows your program (app) to communicate over it.


## Where does your Rails app fit in?

Your Rails app talks to an intermediate layer called Rack.
Rack knows how to talk to your server.
You could have the app talk directly to the server,
but then you could only have that one server that Rails knows how to talk to.

So Rails and Sinatra and every other Ruby web framework know how to talk to Rack,
and Puma and Unicorn and Thin all know how to talk to Rack,
which means that Rails can use any server to be available on the web.

## What is HTTP

"HyperText Transfer Protocol", just a way of structuring text that the server
and the client both agree on. Then they send the text across the web,
and since they adhere to this structure, they can parse it.

## View HTTP Request

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


## Start server that prints what it sees.

```
$ nc -l 3000
```

In browser, go to [http://localhost:3000/users?filter=true](http://localhost:3000/users?filter=true)
* View HTTP Response
  ```
  $ curl -i http://google.com
  HTTP/1.1 301 Moved Permanently
  Location: http://www.google.com/
  Content-Type: text/html; charset=UTF-8
  Date: Mon, 02 Mar 2015 16:48:28 GMT
  Expires: Wed, 01 Apr 2015 16:48:28 GMT
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
* Show that we can work with this stuff

  ```
  server:
    $ nc -l 3000

  client: (from pry -r rest-client)
    response = RestClient.post "localhost:3001/users", user: { name: 'Josh', age: 31 }

  server: (see the request and type this response, ^D means "hold control and press d")
    HTTP/1.1 200 OK
    Content-Type: text/plain
    Greeting: Hello, class!

    this is the body
    I would put my html here
    ^D

  client:
    > response.body    # => "this is the body\nI would put my html here\n"
    > response.headers # => {:content_type=>"text/plain", :greeting=>"Hello, class!"}
  ```
* Handle request programatically

  ```ruby
  # The server
  $ pry -r socket
  > server = TCPServer.new 3000
  > client = server.accept
  > client
  > ls -v client
  > client.gets
  > client.print "hello, browser\r\n"
  > client.close

  # the client
  $ pry -r socket -r rest-client
  > socket = TCPSocket.new 'localhost', 3000
  > socket.puts "hello, client"
  > socket.gets
  > socket.close
  ```

## Lets make an acceptance test

We're going to do this top-down, which means we're building on
things that don't exist yet. By writing from the end, we can
think about what is necessary to make this code work.

Here is what I want to make work, it's making a get request
to our server and asserting that some particular thing comes back.

```ruby
require 'mah_webserver'
require 'rest-client'

RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    response = RestClient.get 'localhost:3000/users'

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end
end
```

So, what will it take to make that work?
We'll need to start our server before we can make that request,
and once we're done, we can stop our server.

```ruby
require 'mah_webserver'
require 'rest-client'

RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    server.start
    response = RestClient.get 'localhost:3000/users'
    server.stop

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end
end
```

And now we have to figure out what the server is.
Since this is occurring somewhere in the middle of a reqest,
we have to figure out how to inject the code that
chooses a response code of `200`, a header of `omg: 'bbq'`,
and a body of `"hello, class ^_^"` into the middle of it.
I think a block is a decent interface to accomplish this.
We'll go over how to use a block a bit more in the next lesson.

And what should our block receive and return?
I don't know, that's why I start with an acceptance test!
How about if it receives an object that tells it what information
came in the request, eg that the path is "/users".
And how will it tell the server what it wants the server to do?
How about a response object, as well, that it can set this info on.

And what info should it set?
The info that we said we expected in the request, of course!

```ruby
require 'mah_webserver'
require 'rest-client'

RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    server = MahWebserver.new(3000) do |request, response|
      response.code = 200
      response.headers[:omg] = 'bbq'
      response.body = "hello, class ^_^"
    end

    server.start
    response = RestClient.get 'localhost:3000/users'
    server.stop

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end
end
```

Great, now we have an acceptance test that we can use to drive
our code. This helps us figure out what code we need to implement,
and what our high-level goals actually are.

As we get down to unit tests, we'll get more feedback, and possibly
need to come back up to here and change the acceptance test.
Low-level tests and high-level tests both inform each other.
But the nice thing about these is that once we get it in place,
there should be very few reasons for it to change,
so it actually exercises all the pieces together.

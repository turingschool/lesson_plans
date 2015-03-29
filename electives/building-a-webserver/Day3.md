Building a webserver Day 3
==========================

Lets recap where we're at
-------------------------

* HTTP is a way of formatting text
* To make a web request, we open a "socket" (a file, really) across the web to an IP Address with a program listening on a Port
* The program is called a "server", it parses the request, hands it to an application,
  and then generates an HTTP response.
* An HTTP request
  * Has a first line that includes the method type (GET/POST/PUT/ETC), path, and version
  * Then it has headers, which is sort of like a hash
  * Then there is a blank line (`"\r\n")
  * Last, there is a body. The body is just any kind of text at all.
    Usually we figure out what kind of text it is by looking at the `Content-Type` header,
    and we figure out how long it is by looking at the `Content-Length` header.
* An HTTP response
  * Has a first line that includes the HTTP version, status code, and human readable status code
  * Has a list of headers, just like above
  * Has a blank line ("\r\n")
  * Has a body

We also discussed threads and blocks.
If you'd like to explore blocks a bit more,
I made a playground to show you how they work,
and asks interesting questions that you'll have to explore in order to answer!

1. Start here: [New Kids On The Block](http://104.131.24.233/blocks/new-kids-on-the-block)
2. This gets a bit more involved: [Block It Up And Do It Again](http://104.131.24.233/blocks/block-it-up-and-do-it-again)
3. Don't do this one if you're epistemological insecure. [How I Learned To Stop Worrying And Love The Block](http://104.131.24.233/blocks/how-i-learned-to-stop-worrying-and-love-the-block)


-----

Better understanding the expected interface
--------------------------------------------

Basically all Ruby web apps implement an interface called `Rack`.
Lets figure out what our server needs to provide to get this interface to work.

```sh
$ gem install puma
$ cat `gem which rack/handlers/puma`
```

Seems pretty small, start it,
then make a request in our browser to see what Rack gives us:

```ruby
$ ruby -r rack/handler/puma -r pp -e 'Rack::Handler::Puma.run(lambda { |env| pp env; [200, {"Content-Type" => "text/plain"}, ["Hello, World!"]] })'
  Puma 2.11.0 starting...
  * Min threads: 0, max threads: 16
  * Environment: development
  * Listening on tcp://0.0.0.0:8080
{"rack.version"=>[1, 3],
 "rack.errors"=>#<IO:<STDERR>>,
 "rack.multithread"=>true,
 "rack.multiprocess"=>false,
 "rack.run_once"=>false,
 "SCRIPT_NAME"=>"",
 "CONTENT_TYPE"=>"text/plain",
 "QUERY_STRING"=>"",
 "SERVER_PROTOCOL"=>"HTTP/1.1",
 "SERVER_SOFTWARE"=>"2.11.0",
 "GATEWAY_INTERFACE"=>"CGI/1.2",
 "REQUEST_METHOD"=>"GET",
 "REQUEST_PATH"=>"/",
 "REQUEST_URI"=>"/",
 "HTTP_VERSION"=>"HTTP/1.1",
 "HTTP_HOST"=>"localhost:8080",
 "HTTP_CONNECTION"=>"keep-alive",
 "HTTP_ACCEPT"=>
  "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
 "HTTP_USER_AGENT"=>
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36",
 "HTTP_ACCEPT_ENCODING"=>"gzip, deflate, sdch",
 "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8",
 "SERVER_NAME"=>"localhost",
 "SERVER_PORT"=>"8080",
 "PATH_INFO"=>"/",
 "REMOTE_ADDR"=>"127.0.0.1",
 "puma.socket"=>#<TCPSocket:fd 13>,
 "rack.hijack?"=>true,
 "rack.hijack"=>#<Puma::Client:0x3fe7cf202fa0 @ready=true>,
 "rack.input"=>#<Puma::NullIO:0x007fcf9f9a7f60>,
 "rack.url_scheme"=>"http",
 "rack.after_reply"=>[]}
```

We can now cancel the server. And compare this to the raw request:

```sh
$ nc -l 8080
GET / HTTP/1.1
Host: localhost:8080
Connection: keep-alive
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36
Accept-Encoding: gzip, deflate, sdch
Accept-Language: en-US,en;q=0.8
```

Comparing these, we see that

* The first line is parsed into `REQUEST_METHOD`, `PATH_INFO`, and `SERVER_PROTOCOL`
* The headers are upcased, their dashes are turned into underscores, and they are prepended with `HTTP_`
  So our last line, `Accept-Language: en-US,en;q=0.8` becomes `"HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8"`
* There are only 2 `IO` objects, `"rack.errors"=>#<IO:<STDERR>>`, and  `"rack.input"=>#<Puma::NullIO:0x007fcf9f9a7f60>`,
  this is presumably the body.

So, we need our server to parse the request into this.
Lets take that request and pass that as our test.
We'll change the method to `POST` so we can give it a body.
We'll make the body be `abc=123&def=456`, which means
we also need to give it a `Content-Length: 15` and
`Content-Type: application/x-www-form-urlencoded`
headers.

Turn our findings into tests
----------------------------

Our Request test, `spec/request_spec.rb`

```ruby
require 'mah_webserver'

RSpec.describe Request do
  let :env do
    Request.parse \
      "GET / HTTP/1.1\r\n" \
      "Host: localhost:8080\r\n" \
      "Connection: keep-alive\r\n" \
      "Cache-Control: max-age=0\r\n" \
      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n" \
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36\r\n" \
      "Accept-Encoding: gzip, deflate, sdch\r\n" \
      "Accept-Language: en-US,en;q=0.8\r\n" \
      "Content-Length: 15\r\n" \
      "Content-Type: application/x-www-form-urlencoded\r\n" \
      "\r\n"
      "abc=123&def=456"
  end

  context 'the first line' do
    it 'parses the method as REQUEST_METHOD'
    it 'parses the path as PATH_INFO'
    it 'parses the protocol as SERVER_PROTOCOL'
  end

  context 'the headers' do
    specify 'are upcased, prepended with "HTTP_", and have their dashes turned to underscores'
    # I had to do a little more work to figure this one out
    it 'doesn\'t prepend HTTP_ to the content length or content type'
  end

  context 'the body' do
    it 'is an io object at the key "rack.input"pointing at the first character of the body'
  end
end
```

Running that, we see they're all pending.
So, lets fill them out.

```ruby
require 'mah_webserver'

RSpec.describe Request do
  let :env do
    Request.parse(
      "POST / HTTP/1.1\r\n" \
      "Host: localhost:8080\r\n" \
      "Connection: keep-alive\r\n" \
      "Cache-Control: max-age=0\r\n" \
      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n" \
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36\r\n" \
      "Accept-Encoding: gzip, deflate, sdch\r\n" \
      "Accept-Language: en-US,en;q=0.8\r\n" \
      "Content-Length: 15\r\n" \
      "Content-Type: application/x-www-form-urlencoded\r\n" \
      "\r\n" \
      "abc=123&def=456"
    )
  end

  context 'the first line' do
    it 'parses the method as REQUEST_METHOD' do
      expect(env['REQUEST_METHOD']).to eq 'POST'
    end

    it 'parses the path as PATH_INFO' do
      expect(env['PATH_INFO']).to eq '/'
    end

    it 'parses the protocol as SERVER_PROTOCOL' do
      expect(env['SERVER_PROTOCOL']).to eq 'HTTP/1.1'
    end
  end

  context 'the headers' do
    specify 'are upcased, prepended with "HTTP_", and have their dashes turned to underscores' do
      expect(env['HTTP_ACCEPT_LANGUAGE']).to eq "en-US,en;q=0.8"
    end

    it 'doesn\'t prepend HTTP_ to the content length or content type' do
      expect(env['CONTENT_LENGTH']).to eq '15'
      expect(env['CONTENT_TYPE']).to eq 'application/x-www-form-urlencoded'
    end
  end

  context 'the body' do
    it 'is an io object at the key "rack.input"pointing at the first character of the body' do
      expect(env['rack.input'].read).to eq "abc=123&def=456"
    end
  end
end
```

Running that, we see lots of failures.
Lets take them one at a time, we can do this with the
`--fail-fast` flag:

```sh
$ rspec spec/request_spec.rb --fail-fast --color --format documentation

Request
  the first line
    parses the method as REQUEST_METHOD (FAILED - 1)

Failures:

  1) Request the first line parses the method as REQUEST_METHOD
     Failure/Error: expect(env['REQUEST_METHOD']).to eq 'GET'
     NoMethodError:
       undefined method `[]' for #<Request:0x007fb92382a440>
     # ./spec/request_spec.rb:22:in `block (3 levels) in <top (required)>'

Finished in 0.0006 seconds (files took 0.23042 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/request_spec.rb:21 # Request the first line parses the method as REQUEST_METHOD
```

Implementing Request
--------------------

At this point, we just need to build a hash out of a string.
We'll take it one at a time.

I initially implemented it like this:

```ruby
class Request
  def self.parse(stream)
    env = {}
    method, path, protocol = stream.gets.chomp.split
    env['REQUEST_METHOD']  = method
    env['PATH_INFO']       = path
    env['SERVER_PROTOCOL'] = protocol
    env
  end
end
```

But that blew up, because my test passes a `String`,
not a stream. How can we get them to look the same?
Well, there's a class in the standard library called
`StringIO`, it looks just like an `IO` object, but
it sits on top of a `String`.

```ruby
require 'stringio'                     # => true
s = StringIO.new("012\n345\nabcdefg")  # => #<StringIO:0x007fd50b04f618>
s.gets                                 # => "012\n"
s.gets                                 # => "345\n"
s.read(1)                              # => "a"
s.read(2)                              # => "bc"
s.read(3)                              # => "def"
```

Nice, so applying that to our test:

```ruby
let :env do
  Request.parse(
    StringIO.new \
      "GET / HTTP/1.1\r\n" \
      "Host: localhost:8080\r\n" \
      "Connection: keep-alive\r\n" \
      "Cache-Control: max-age=0\r\n" \
      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n" \
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36\r\n" \
      "Accept-Encoding: gzip, deflate, sdch\r\n" \
      "Accept-Language: en-US,en;q=0.8\r\n" \
      "Content-Length: 15\r\n" \
      "Content-Type: application/x-www-form-urlencoded\r\n" \
      "\r\n" \
      "abc=123&def=456"
  )
end
```

And now we're passing the first test.
The headers are all the next lines until the "\r\n",
which separates the headers from the body.
And then we need to parse them for the key and value,
and add them to the hash, giving us:

```ruby
def self.parse(stream)
  env = {}

  # first row
  method, path, protocol = stream.gets.chomp.split
  env['REQUEST_METHOD']  = method
  env['PATH_INFO']       = path
  env['SERVER_PROTOCOL'] = protocol

  # headers
  loop do
    line = stream.gets
    break if line == "\r\n"
    key, value = parse_header(line)
    env[key] = value
  end

  env
end
```

And now we have to figure out what that `parse_header` is.
We could put a pry in there to play around until we get it
figured out, it's basically split on the `": "` which separates
the key and the value. Then we have to apply the `HTTP_` prefix,
upcase it, and substitute all dashes for underscores.

```ruby
def self.parse_header(line)
  key, value = line.chomp.split(": ")
  key = key.upcase.gsub "-", "_"
  key = "HTTP_#{key}" unless key == 'CONTENT_TYPE' || key == 'CONTENT_LENGTH'
  [key, value]
end
```

And now we're passing the tests for the header parsing.
If we were a bit more serious about this, we'd also test
that this works correctly when there are more than one `": "`
on the line (currently, it doesn't).

So, we go onto the last test. Here, we need to return
an `IO` object. Well, our input is an `IO` object,
but I experimentally figured out that `Sinatra` will
just read as much input as available. And since the stream
doesn't have an end, that will cause `Sinatra` to block.
So we need to read the `CONTENT_LENGTH` from the stream,
and put that in a `StringIO` object, which will behave
as if it saw an "end of file" character when it runs out of input.

```ruby
class Request
  def self.parse(stream)
    env = {}

    # first row
    method, path, protocol = stream.gets.chomp.split
    env['REQUEST_METHOD']  = method
    env['PATH_INFO']       = path
    env['SERVER_PROTOCOL'] = protocol

    # headers
    loop do
      line = stream.gets
      break if line == "\r\n"
      key, value = parse_header(line)
      env[key] = value
    end

    # body
    length = env['CONTENT_LENGTH'].to_i
    stream = StringIO.new stream.read length
    env['rack.input'] = stream

    env
  end

  def self.parse_header(line)
    key, value = line.chomp.split(": ")
    ["HTTP_#{key.upcase.gsub "-", "_"}", value]
  end
end
```

We could refactor this some, if we wanted,
but I don't see anything particularly obvious to do with it,
and I like being able to see it all in one place like this,
so we'll leave it for now.

Updating the acceptance test
----------------------------

Lets go back and check out our acceptance test.
Okay. And we could reasonably make this work,
but our request is mimicking the rack interface,
so it makes sense that our response should, as well.
So lets change it to match, and add in a check within the app
to assert that it's actually giving us the env
that we expected based on the request down below.

```ruby
require 'mah_webserver'
require 'rest-client'

RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    server = MahWebserver.new(3000) do |env|
      expect(env['PATH_INFO']).to eq '/users'
      body = "hello, class ^_^"
      headers = {
        'Content-Type'   => 'text/plain',
        'Content-Length' => body.length,
        'omg'            => 'bbq'
      }
      [200, headers, [body]]
    end

    thread = Thread.new { server.start }
    thread.abort_on_exception = true

    puts "about to make request"

    response = RestClient.get 'localhost:3000/users'
    server.stop
    thread.join

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end
end
```

The Response
------------

Everything is still passing, but we're not generating a real response,
we've got it hard-coded in there.
Lets make a test for it.
Now that we've looked around a bit more, we have a better
idea of what it should look like, so we'll make the test
that we want, and then go amend the caller (our server)
to match it.

```ruby
require 'mah_webserver'

RSpec.describe 'Response test' do
  it 'creates an HTTP response from a rack response' do
    http = Response.to_http(
      404,
      {'this-is-a-header' => 'and-a-value'},
      ["This is a body"]
    )

    expect(http).to eq \
      "HTTP/1.1 404\r\n" \
      "this-is-a-header: and-a-value\r\n" \
      "\r\n" \
      "This is a body"
  end
end
```

Running this, it fails, because the `to_http` method
is an instance method, as we previously thought
that we were going to use objects. Lets get it passing,
and then we'll go amend the server.


```ruby
class Response
  def self.to_http(code, headers, body)
    response = "HTTP/1.1 #{code}\r\n"
    headers.each { |key, value| response << "#{key}: #{value}\r\n" }
    response << "\r\n"
    body.each { |line| response << line }
    response
  end
  # ...
```

Sweet, now we're passing again.
But, our acceptance test is failling!
We need to pass our environment to the block
and get the response back.

Using the block in the server
-----------------------------

Here is an example of how to call a block.
Notice that whatever we pass to `call` is given to the block's arguments,
and whatever it returns is returned to the callsite:

```ruby
block = lambda { |env|
  env                                  # => {:fake=>:env}
  [200, {'key' => 'value'}, ['body']]  # => [200, {"key"=>"value"}, ["body"]]
}

block.call(fake: :env)  # => [200, {"key"=>"value"}, ["body"]]
```

So, we can take this and use it in our server.

```ruby
class MahWebserver
  def initialize(port, &webapp)
    @port   = port
    @webapp = webapp
  end

  def start
    server   = TCPServer.new(@port)
    client   = server.accept
    env      = Request.parse(client)
    code, headers, body = @webapp.call(env)
    response = Response.to_http(code, headers, body)
    client.print(response)
    client.close
  end

  def stop
  end
end
```

Now our acceptance spec is passing again,
and we aren't using the hard-coded http method anymore,
so we can take it out, and now our response just looks like this:

```ruby
class Response
  def self.to_http(code, headers, body)
    response = "HTTP/1.1 #{code}\r\n"
    headers.each { |key, value| response << "#{key}: #{value}\r\n" }
    response << "\r\n"
    body.each { |line| response << line }
    response
  end
end
```

Handling multiple requests
--------------------------

Lets add one more test that shows we can handle multiple requests.
We'll copy/paste and edit the current one.

```ruby
it 'handles multiple requests' do
  server = MahWebserver.new(3000) do |env|
    [200, {'Content-Type' => 'text/plain'}, []]
  end

  thread = Thread.new { server.start }
  thread.abort_on_exception = true

  expect(RestClient.get('localhost:3000/').code).to eq 200
  expect(RestClient.get('localhost:3000/').code).to eq 200

  server.stop
  thread.join
end
```

We see that this one hangs. I played around with it for a bit and figured
out that it's because the server from the first test
never actually stopped. So we'll fill out the stop method.

But, the second will still hang, waiting for the response,
because our server can only take one request.
So we'll put that bit of the server in a loop.

```ruby
class MahWebserver
  def initialize(port, &webapp)
    @port   = port
    @webapp = webapp
  end

  def start
    @server = TCPServer.new(@port)
    loop do
      client = @server.accept
      env    = Request.parse(client)
      code, headers, body = @webapp.call(env)
      response = Response.to_http(code, headers, body)
      client.print(response)
      client.close
    end
  end

  def stop
    @server.close_read
    @server.close_write
  end
end
```

Still hanging, because we're joining the thread with the server in it,
but it's fallen asleep waiting for input (the `server.accept`).
So, we'll have to kill the thread instead of joining it
(joining with a sleeping thread puts our thread to sleep, too >.<).

So now our acceptance test looks like this:

```ruby
require 'mah_webserver'
require 'rest-client'

RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    server = MahWebserver.new(3000) do |env|
      expect(env['PATH_INFO']).to eq '/users'
      body = "hello, class ^_^"
      headers = {
        'Content-Type'   => 'text/plain',
        'Content-Length' => body.length,
        'omg'            => 'bbq'
      }
      [200, headers, [body]]
    end

    thread = Thread.new { server.start }
    thread.abort_on_exception = true

    response = RestClient.get 'localhost:3000/users'
    thread.kill
    server.stop

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end

  it 'handles multiple requests' do
    server = MahWebserver.new(3000) do |env|
      [200, {'Content-Type' => 'text/plain'}, []]
    end

    thread = Thread.new { server.start }
    thread.abort_on_exception = true

    expect(RestClient.get('localhost:3000/').code).to eq 200
    expect(RestClient.get('localhost:3000/').code).to eq 200

    thread.kill
    server.stop
  end
end
```

Making a Sinatra App
--------------------

Sweet, lets try serving a Sinatra app!
We'll make a file named `app.rb` in the root directory.

```ruby
require 'sinatra'

class MyApp < Sinatra::Base
  get '/' do
    '<h1>Welcome to my app!</h1>' \
    '<p>What\'s your name?</p>' \
    '<form action="/greet" method="post" accept-charset="utf-8">'\
    '  <p><label for="name">Name</label><input type="text" name="name" value="" id="name"></p>'\
    '  <p><input type="submit" value="Greet"></p>'\
    '</form>'
  end

  get '/greet' do
    redirect '/'
  end

  post '/greet' do
    "<h1>Hello, #{params[:name]}</h1>"
  end
end
```

Serving the Sinatra App
-----------------------

And we need to wire that up to our server,
so lets make a file called `serve.rb`, also in the root directory:

```ruby
require_relative 'lib/mah_webserver'
require_relative 'app'
require 'pp'

port = "3000"
puts "Go to localhost:#{port} in the browser!"

server = MahWebserver.new(port) do |env|
  puts "REQUEST CAME IN!"
  pp env
  code, headers, body = MyApp.call env
  puts "HERE IS THE RESPONSE:"
  puts "CODE:    #{code}"
  puts "HEADERS: #{headers.inspect}"
  puts "BODY:    #{body.inspect}"
  puts "-" * 80
  [code, headers, body]
end

server.start
```

And now we can try running it and making a request to the root.
We see it works, so lets fill the form in with our name and submit it.
And look! It's greeted us, so we've served a Sinatra app on our webserver!

```sh
$ ruby serve.rb
Go to localhost:3000 in the browser!
REQUEST CAME IN!
{"REQUEST_METHOD"=>"GET",
 "PATH_INFO"=>"/",
 "SERVER_PROTOCOL"=>"HTTP/1.1",
 "HTTP_HOST"=>"localhost:3000",
 "HTTP_CONNECTION"=>"keep-alive",
 "HTTP_CACHE_CONTROL"=>"max-age=0",
 "HTTP_ACCEPT"=>
  "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
 "HTTP_USER_AGENT"=>
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36 OPR/28.0.1750.40",
 "HTTP_ACCEPT_ENCODING"=>"gzip, deflate, lzma, sdch",
 "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8",
 "HTTP_COOKIE"=>
  "remember_user_token=BAhbB1sGaQZJIiIkMmEkMTAkZ2Z2WTR1Yk9jMVlWVEFFZWo5VldLZQY6BkVU--67ee79115eb333a69d7db7507c2a373f0e152d1d; __atuvc=2%7C8%2C2%7C9%2C6%7C10",
 "rack.input"=>#<StringIO:0x007f8b39906840>}
HERE IS THE RESPONSE:
CODE:    200
HEADERS: {"Content-Type"=>"text/html;charset=utf-8", "Content-Length"=>"250", "X-XSS-Protection"=>"1; mode=block", "X-Content-Type-Options"=>"nosniff", "X-Frame-Options"=>"SAMEORIGIN"}
BODY:    ["<h1>Welcome to my app!</h1><p>What's your name?</p><form action=\"/greet\" method=\"post\" accept-charset=\"utf-8\">  <p><label for=\"name\">Name</label><input type=\"text\" name=\"name\" value=\"\" id=\"name\"></p>  <p><input type=\"submit\" value=\"Greet\"></p></form>"]
--------------------------------------------------------------------------------
REQUEST CAME IN!
{"REQUEST_METHOD"=>"POST",
 "PATH_INFO"=>"/greet",
 "SERVER_PROTOCOL"=>"HTTP/1.1",
 "HTTP_HOST"=>"localhost:3000",
 "HTTP_CONNECTION"=>"keep-alive",
 "CONTENT_LENGTH"=>"9",
 "HTTP_CACHE_CONTROL"=>"max-age=0",
 "HTTP_ACCEPT"=>
  "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
 "HTTP_ORIGIN"=>"http://localhost:3000",
 "HTTP_USER_AGENT"=>
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36 OPR/28.0.1750.40",
 "CONTENT_TYPE"=>"application/x-www-form-urlencoded",
 "HTTP_REFERER"=>"http://localhost:3000/",
 "HTTP_ACCEPT_ENCODING"=>"gzip, deflate, lzma",
 "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8",
 "HTTP_COOKIE"=>
  "remember_user_token=BAhbB1sGaQZJIiIkMmEkMTAkZ2Z2WTR1Yk9jMVlWVEFFZWo5VldLZQY6BkVU--67ee79115eb333a69d7db7507c2a373f0e152d1d; __atuvc=2%7C8%2C2%7C9%2C6%7C10",
 "rack.input"=>#<StringIO:0x007f8b3b045510>}
HERE IS THE RESPONSE:
CODE:    200
HEADERS: {"Content-Type"=>"text/html;charset=utf-8", "Content-Length"=>"20", "X-XSS-Protection"=>"1; mode=block", "X-Content-Type-Options"=>"nosniff", "X-Frame-Options"=>"SAMEORIGIN"}
BODY:    ["<h1>Hello, Josh</h1>"]
--------------------------------------------------------------------------------
```

Recap
-----

So, we had most of our server in place already.
We just needed to parse the request, generate the response,
and put the thing in a loop.

And now, we've built our own webserver,
using just code available from the standard library,
and even served our own Sinatra App on it!

Hope y'all had fun! Don't forget to check out my
[block challenges](http://104.131.24.233/blocks/new-kids-on-the-block)!
I made them just for you ^_^

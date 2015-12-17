What you should learn
---------------------

* Use the rack-test gem to test rack applications (e.g. Sinatra, Rails)
* Rack-test hooks in at the level of Rack, so it calls your code the same as a real web request
* Declare an `app` method so it knows what Rack app to use
  * Turn off noisy dev html on errors: `set :show_exceptions, false`
* The rack-test methods
  * get the methods by including `include Rack::Test::Methods`
  * make a request: (`get/post/put/patch/delete/options/head`)
  * pass params by providing a params hash as the second argument
  * follow a redirect: `follow_redirect!``
  * get the request or response: `last_request/last_response`
* Go to the response for
  * status code: (200, 404, 302, 500, etc)
  * other relevant information: `url/body`
  * human-readable methods for these: (ok?, not_found?)
* Make assertions about the body
  * look for relevant strings using normal string methods
  * parse it with Nokogiri
* Basic Nokogiri methods
  * Parse an html document with Nokogiri: `doc = Nokogiri::HTML(html)`
  * Find one element using CSS selectors: `doc.at_css`
  * Find all elements that match a CSS selector: `doc.css`
  * Get the text out of an element
* SeeingIsBelieving snippets
  * To play with Sinatra in the same way Rack does `s_sinatra`<tab>
  * To play with Nokogiri `s_nokogiri`<tab>


Locations of useful information
-------------------------------

* [Relevant toplevel methods](https://github.com/brynary/rack-test/blob/d798a3dafd1ae3c5a7156b5c2a8c88a704b07a2d/lib/rack/test/methods.rb#L59-77)
* [Implementation of http verbs (get/post/put.etc)](https://github.com/brynary/rack-test/blob/d798a3dafd1ae3c5a7156b5c2a8c88a704b07a2d/lib/rack/test.rb#L49-113)
* [Human readable status codes](https://github.com/rack/rack/blob/575bbcba780d9ba71f173921aa1fcb024890b867/lib/rack/response.rb#L118-137)
* [Nokogiri documentation](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node)

Exercises (Codealong)
---------------------

#### See what a Rack app is

```ruby
# What is a rack app?
#   an object with a method "call", that receives a hash named "env"
#   the "env" hash has all the info about the web request
#
#   "call" returns an array with 3 things:
#     1: status code (e.g. 200)
#     2: a headers hash (e.g. {'Content-Type' => 'text/html'}
#     3: the body, an enumerator that yields a string (e.g. ["abc"])

run lambda { |env|
  [203, {'Content-Type' => 'text/plain'}, ['hi!']]
}
```

#### See that we can call Sinatra via Rack

* Make an app, assert that it returns OK: `s_sinatra`<tab>
* Play with this a bit

### Make our own simple rack-test

* Define an `app` method
* define a `get` method that returns a `Rack::MockResponse.new`

### See that the real rack-test looks like ours

* `require 'rack/test'`
* keep our `app` but extend `extend Rack::Test::Methods` onto main

### Look at some of the methods we now have

* `puts Rack::Test::Methods.instance_methods(false)`
* See that it gives us the HTTP verbs
* See the `last_request` and `last_response`
* See methods on the response `puts last_response.methods - Object.new.methods`
  * status, body, content_type
  * note the status helpers `puts (last_response.methods - Object.new.methods).grep(/\?$/)`

### Write a test for this example

We wrote:

```
require 'minitest/autorun'
class MyAppTest < Minitest::Test
  MyApp.set :show_exceptions, false
  include Rack::Test::Methods

  def app
    MyApp
  end

  def test_it_mocks_the_specified_user
    response = get '/users/123'
    assert_equal "User number 123 is an uppity know-it-all", response.body
  end
end
```


Exercises (alone or with a pair)
--------------------------------

### Test an endpoint that "creates" a user, and redirects

Create and test an endpoint `POST /users`
that saves a list of users on the app itself.
redirects to `/users/:id`, which returns "You made it!"

### Testing an endpoint that raises (500)

The `/users/:id` should blow up if we haven't given it a user

[Here](https://gist.github.com/JoshCheek/44fd654335d417772c73) is our final result.

### Make an endpoint `/is_day/:date/:dayname` that returns html specifying the date

We need to parse it using Nokogiri, but we dont' know how yet.

### Lets play with Nokogiri `s_nokogiri`<tab>

```
doc = Nokogiri::HTML(html)

doc.at_css('css selector')
   .text

doc.css('css selector')
```

### Questions?

Lets explore

### Do you have apps?

Lets add some testing!

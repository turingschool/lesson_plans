---
title: Testing Sinatra Applications
length: 120
tags: testing, tdd, sinatra, http, rack
---

# Testing Sinatra Applications

## Learning Goals

* Test HTTP responses using `Rack::Test`
* Set environment variables to differentiate code paths in development/test
* Use Nokogiri to parse HTML responses 

## Structure

* 5 - Warmup
* 40 - Testing Routes using `Rack::Test::Methods` and Minitest
* 5 - Break
* 40 - Testing Content using Nokogiri
* 5 - Wrapup

## Warmup 

With a partner, discuss the following questions: 

* Give what you know from SalesEngine, how would you go about testing a web application built using Sinatra?
* What testing tools do you already know how to use for testing a web app and what tools are you missing?

## Resources

* [Talker](https://github.com/turingschool-examples/testing-sinatra-applications)

## Full Group Instruction: Testing Routes

In SalesEngine, we tested Ruby objects using Minitest and Rspec. But how do we test a route in Sinatra like the one in `fake_app.rb`?

```rb
class FakeApp < Sinatra::Base
  get '/' do
    "Today is going to be a wonderful day."
  end
end
```

Rack gives us some tools to make HTTP requests to our Sinatra application and inspect the response and make assertions based on the response.

`app_test.rb` demonstrates how to send a GET request to a route and inspect the response.

```rb
ENV["RACK_ENV"] = "test"
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'

require_relative '../app/fake_app'

class FakeApp < Minitest::Test
  include Rack::Test::Methods

  def app
    FakeApp.new
  end

  def test_it_tells_you_that_today_will_be_wonderful
    get '/'
    assert_equal 200, last_response.status
    assert last_response.ok?
    assert_equal "Today is going to be a wonderful day.", last_response.body
  end
end
```

We can use any of the HTTP methods: `get`, `post`, `put`, `delete`, `patch`.

## Key Points

* Use the `rack-test` gem to test rack applications (e.g. Sinatra, Rails)
* Rack-test hooks in at the level of Rack, so it calls your code the same as a real web request, but with mock objects
* Declare an `app` method so it knows what Rack app to use

* What can you do with Rack::Test? 
  * get access to the methods by including `include Rack::Test::Methods`
  * make a request: (`get/post/put/patch/delete`)
  * pass params by providing a params hash as the second argument: `get '/', { title: "My Idea" }`
  * follow a redirect: `follow_redirect!`
  * get the request or response: `last_request` or `last_response`

* What to use `last_response` for:
  * status code: (200, 404, 302, 500, etc) -- see all status codes [here](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)
  * human-readable methods for these: (ok?, not_found?)
  * `body`

* What to use `last_request` for:
  * `url` if testing a redirect (`follow_redirect!`)

* Make assertions about the body
  * look for relevant strings using normal string methods like `.include?`, etc.
  * parse it with Nokogiri

* Basic Nokogiri methods
  * Parse an html document with Nokogiri: `doc = Nokogiri::HTML(html)`
  * Find all elements that match a CSS selector: `doc.css(selector)`
  * Find the first element that matches a CSS selector: `doc.at_css(selector)`
  * Get the text out of an element: `doc.css(selector).text`

## To the Code!

* Clone [Talker](https://github.com/turingschool-examples/testing-sinatra-applications)

* `git checkout 8db90a8` Initial Commit
* `git checkout 2daab4b` Set up minitest and rack-test in Gemfile
* `git checkout c27332f` Set up test class
* `git checkout d4bf3e5` Test for hello world
* `git checkout 015abc6` Example test for a post request
* `git checkout e533009` Sad path example for 404/not found
* `git checkout 5b903d8` Test using form parameters
* `git checkout e29b074` Test using URL parameters
* `git checkout 84199b9` Test a redirect
* `git checkout 05543d4` Test using Nokogiri
* `git checkout 5aa5901` Alternate way to set up requirements using Bundler


## Discussion

* What things should we test in IdeaBox?
* What might be some challenges to asserting numbers of ideas when we use one database?
* How can we use `ENV["RACK_TEST"]` to avoid this problem?

## Resources

* [Testing Sinatra with Rack::Test](http://www.sinatrarb.com/testing.html)
* [Nokogiri cheat sheet](https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet)

---
title: Testing in Sinatra
length: 180
tags: testing, tdd, sinatra, http
---

**Current Status**: Draft (Work in Progress)

## Learning Goals

* Test HTTP requests and responses using `Rack::Test`
* Set environment variables to differentiate code paths in development and testing
* Pull out components of an application to facilitate testing

## Structure

* 5 - Warmup
* 25 - Testing Routes using `Rack::Test::Methods` and Minitest
* 5 - Wrapup

## Resources

* [Feel Good Bot](https://github.com/turingschool-examples/feel-good-bot)

## Warm Up

Start a gist and answer the following questions:

* Give what you know from SalesEngine, how would you go about testing a web application built using Sinatra?
* What tools do you have at your disposal and what tools are you missing?

## Full Group Instruction: Testing Routes

In SalesEngine, we tested Ruby objects using Minitest and Rspec. But how do we test a route in Sinatra like the one in `01_app.rb`?

```rb
get '/' do
  "Today is going to be a wonderful day."
end
```

Rack gives us some tools to make HTTP requests to our Sinatra application and inspect the response and make assertions based on the response.

`01_test.rb` demonstrates how to send a GET request to a route and inspect the response.

```rb
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'

require_relative '../app/01_app'

describe FeelGoodBot do
  include Rack::Test::Methods

  def app
    FeelGoodBot.new
  end

  it "tells you how great today is going to be" do
    get '/'
    assert_equal 200, last_response.status
    assert last_response.ok?
  end
end
```

We can use any of the HTTP methods: `get`, `post`, `put`, `delete`, `patch`.

Each method takes a route and an optional set of parameters.

```rb
get '/', { name: "Alan Turing" }
get '/', name: "Alan Turing"
```

After we make a request, `Rack::Test::Methods` gives us two variables to work with: `last_request` and `last_response`. These are the most recent request and response we've sent or received. For the purposes of this tutorial, we care mostly about `last_response`.

`last_response` has a number of properties. We're going to concern ourselves with only a subset of those today.

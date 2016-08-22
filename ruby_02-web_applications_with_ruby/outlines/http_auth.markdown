---
title: HTTP Auth with Sinatra
length: 60
tags: sinatra, authentication, http
---

## Learning Goals

* Learn how HTTP Basic Auth works in Sinatra applications
* Experiment with implementing HTTP Basic Auth

## Structure

* 5 - Warmup Demo
* 20 - How HTTP Basic Auth Works
* Break
* 25 - Independent Work
* 5 - Wrapup / Questions

## Warmup Demo

First up, let's see what HTTP Basic Auth will do for us when it's fully implemented.

## Full-Group Instruction

* Starting with http://github.com/turingschool-examples/sinatra_cms
* Fire up a console with `rake console`
* See there are pages with `Page.all`
* Start the server with `rackup`
* Visit `http://localhost:9292/pages/sample_1` and it displays

### Protect All Pages

* `Rack::Auth::Basic` is a "middleware"
* Activate it with `use`
* If the block returns true, then the request is processed

```ruby
use Rack::Auth::Basic, "Secret Area" do |username, password|
  username == 'admin' && password == 'secret'
end
```

* See the results in the browser

### Protect a Single Page

* Define a `protected!` method that'll be used to specify that a certain
page should be password protected
* Use them to protect only the `sample_2` page

```ruby
def protected!
  return if authorized?
  headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
  halt 401, "Not authorized\n"
end

def authorized?
  @auth ||= Rack::Auth::Basic::Request.new(request.env)
  @auth.provided? && @auth.basic? &&
  @auth.credentials && @auth.credentials == ['admin', 'admin']
end
```

## Independent Challenge

Write some tests and reverse the above example:

* Write a test which verifies that the `sample_2` page is reachable without login
* Write a test which verifies that the `sample_1` page is not reachable with no
username/password
* Write a test which verifies that the `sample_1` page is not reachable with the
wrong username/password
* Write a test which verifies that the `sample_1` page is reachable with
the correct login

To get things working, reference the notes above as well as the
[Sinatra FAQ](http://www.sinatrarb.com/faq.html#test_http_auth).

## Wrap-Up

* Your questions

## Resources

* [Sinatra FAQ About Auth](http://www.sinatrarb.com/faq.html#auth)
* [Sinatra Recipes with Auth Basic](http://recipes.sinatrarb.com/p/middleware/rack_auth_basic_and_digest)

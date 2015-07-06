---
title: What is Rack?
length: 30
tags: rack, rails, sinatra
---

A minimal API for connecting web servers and web frameworks.

- All rack apps need to respond to #call
- Must return an array containing status (integer), headers (hash), body (array)
- The body needs to respond to #each and then successively return strings that represent the response body.
- Discuss Middleware - https://github.com/rack/rack-contrib/tree/master

Have the students experiment with Rack middleware by cloning this [Rack Lobster](https://github.com/turingschool-examples/rack-lobster) repo.

### Resources
[Introducing Rack](http://chneukirchen.org/blog/archive/2007/02/introducing-rack.html)

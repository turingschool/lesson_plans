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

### Worktime

Have the students experiment with Rack middleware by cloning this [Rack Lobster](https://github.com/turingschool-examples/rack-lobster) repo.

- Demonstrate how to start the server.
- Take a look at the `config.ru` file and have them work through the numbered comments in order.
- Make the end goal for them to get their names to appear on the page that is being served.
- Provide a link to [Introducing Rack](http://chneukirchen.org/blog/archive/2007/02/introducing-rack.html) for a better understanding.

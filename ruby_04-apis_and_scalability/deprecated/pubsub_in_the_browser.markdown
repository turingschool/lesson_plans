---
title: Pub/Sub in the Browser
length: 180
tags: json, javascript, websockets, jquery, sinatra, faye
status: deprecated
---

**Nota bene:** This lesson has been replaced by [Building Real-Time Applications][rt].

[rt]: https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/real_time_applications_with_node.markdown

## Learning Goals

* Understand how to use Rack middleware
* Understand how web sockets work
* Implement pub/sub in the browser using Faye
* Implement pub/sub in the browser using Socket.io

## Resources

* [slacker-web][repo] repository in [turingschool-examples][org]
* [right-now][rn] repository  in [turingschool-examples][org]

[repo]: https://github.com/turingschool-examples/slacker-web
[org]: https://github.com/turingschool-examples
[rn]: https://github.com/turingschool-examples/right-now

## Structure

* 5 - Warm up
* 20 - Lecture
* 5 - Break
* 25 - Experiment  #1: SlackerWeb
* 5 - Break
* 25 - Experiment #2: Pushing Events from the Server
* 5 - Break
* 75 - Pair Practice
* 15 - Wrap Up

## Warm Up

Last week we learned about pub/sub on the server. Reflect on the following questions before we begin:

* What are the limitations of using pub/sub to enable communication between the server and the client?
* How would you implement pub/sub in the browser?

## Lecture

* Explain WebSockets vs. the HTTP request/response cycle
  * A WebSocket is a persistent two-way connection between the server and the client
  * The server can push an event without having to receive a request from the client
  * The client can send messages to the server without having to wait for a response
* In what contexts would you want to consider WebSockets?
  * Chat/instant messaging
  * Real-time analytics
  * Document collaboration
  * Streaming
* WebSockets work best when there is an event-driven server on the backend
  * Ruby with [EventMachine][]
  * [Node.js][]
* [Socket.io][] and [Faye][] will fallback to other methods if it can't make a WebSocket connection
  * Some examples include: long-polling, Adobe Flash sockets
* Introducing [Faye][]
  * Works with Ruby/Rack or Node.js on the backend
  * The Ruby version provides Rack middleware and be used with any web application library or framework that sits on top of rack (e.g. Sinatra and Rails)
  * Provides a client-side library out of the box
  * Faye can *only* be used with `thin` and `RACK_ENV` must be set to `production`
  * Alternatives: [Node.js][] with [Socket.io][]

[Socket.io]: http://socket.io/
[Faye]: http://faye.jcoglan.com/
[Node.js]:http://nodejs.org
[EventMachine]: http://rubyeventmachine.com/

## Experiment #1: SlackerWeb

[Last week we created a set of small server-side modules that used pub/sub to communicate.][pss] The closest we got to a web interface was [`webber.rb`][webber], which sent a POST request to a Sinatra application that in turn broadcasted the message on our Redis channel. `webber.rb` had no way of receiving messages from other publishers.

[pss]: https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/pubsub_on_the_server.markdown
[webber]: https://github.com/turingschool-examples/slacker/blob/master/publishers/webber.rb

Clone the [turingschool-examples/slacker-web][repo] repository.

Let's take a look at [`f5ac2fc`][c1]. Here we have a basic web application.

* When the user clicks submit, jQuery sends JSON to the server, which responds the message.
* If we wanted to get fancy, we'd put this message in a database and maybe respond with all of the new messages.
* This approach relies on the normal HTTP request/response cycle. We would only be able to fetch new data when we make a request.
* We *could* have jQuery fetch data at a regular interval, but it's still not real-time and we would potentially be making needless requests when there was no new data.

Let's checkout [`262b299`][c2].

In this commit, we've swapped in Faye—a websocket library for Ruby and Node.

In our `config.ru` [we added the following][rackfaye]:

[rackfaye]: https://github.com/turingschool-examples/slacker-web/blob/master/config.ru#L10-L11

```rb
use Faye::RackAdapter, :mount => '/faye',
:timeout => 25
```

* Faye sits next to our Sinatra application as Rack middleware.
* It has created a `/faye` endpoint.
* It has also provided us with `/faye/client.js`, which will provide us with a client-side API for connecting with Faye on the server.
* We connect to Faye with [the following line][fc]: ` var client = new Faye.Client('/faye');`
* This matches up with the endpoint we added in `config.ru`

There are two important functions that make this work.

First, our Faye client [subscribes to a channel][fayesub]—much like we did with Redis on the server.

```js
var subscription = client.subscribe('/messages', function(message) {
  addMessage(message);
});
```

When the server pushes on the `/messages` channel, the client will pass it along to `addMessage`, which parses the JSON, formats some HTML, and then appends it to the DOM.

Secondly, when we submit a new message, the client *publishes* the `/messages` channel.

```js
client.publish('/messages', message);
```

This sends the message to the server, which in turn sends it out to all of the connected clients.

At the core of pub/sub on the browser, we need to do the following:

* Subscribe to a channel
* Have some functionality that reacts when something is published on the channel we subscribed to
* Optionally, we can add functionality that allows the client to publish from their browser

## Experiment #2: Slacker Meets SlackerWeb

So, now let's tie this all together.

If you don't have Slack cloned, go ahead and [clone it now][slacker].

[slacker]: https://github.com/turingschool-examples/slacker

We swapped out traditional HTTP request/response for WebSockets to allow us to listen for events. Sinatra and Rails also adhere to the traditional cycle, so we'll need to rethink our server implementation as well.

We need some kind of event-based server. Node is a popular choice for these kinds of problems. One solution is to implement the traditional portions of our web application in Rails or Sinatra and have a small Node server sit next to it to handle real-time/event-driven elements.

Another option is to use Ruby's [EventMachine][] library. EventMachine adds similar functionality to Ruby. We'll use it in an attempt to keep things simple.

Let's switch to the [`event-driven`][evtdb] branch.

`lib/listener.rb` is a small module that we can run alongside our server. It does two things:

* It subscribes to the Redis channel used by Slacker.
* When it receives a message on Redis, it formats it and sends it off to Faye, which in turn sends it to all of the connected browsers.

Now, anything that happens on Slacker will also be sent to the connected web browsers.

## Pair Practice

Choose one or more of the following challenges with your pair:

* When an idea is posted in one IdeaBox, all of the other connected clients update with the new idea.
  * When an idea is deleted, it is removed from all connected clients.
  * When an idea is edited. it is replaced on all connected clients.
* Add multiple rooms to SlackerWeb. As it stands, all messages are posted to the `/messages` channel.
  * Users should only be able to receive messages posted to the channel they're currently subscribed to.
  * Create a command syntax that allows them to switch rooms.
  * *Extension*: Create a command that allows users to post to another channel.

## Wrap Up

Let's spend a few moments sharing some of the results from pair practice.

After sharing, reflect on the following questions:

* Which—if any—of your previous projects would have benefited from using WebSockets?
* What kind of project would you like to build using WebSockets in the future?

[c1]: https://github.com/turingschool-examples/slacker-web/commit/f5ac2fc084c7e2d6f10813605ed65e1e33ff6e5a
[c2]: https://github.com/turingschool-examples/slacker-web/commit/262b299a467adb53a5fbe8d323a5fac4386829d3
[fc]: https://github.com/turingschool-examples/slacker-web/blob/master/lib/public/slacker.js#L1
[fayesub]: https://github.com/turingschool-examples/slacker-web/blob/master/lib/public/slacker.js#L8-L10
[evtdb]: https://github.com/turingschool-examples/slacker-web/tree/event-driven

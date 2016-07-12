---
title: Building Real-Time Applications
length: 90
tags: json, javascript, websockets, jquery, socket.io, node
---

**Nota bene:** This is the successor to [the Pub/Sub in the Browser lesson][psb].

[psb]: https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/pubsub_in_the_browser.markdown

## Learning Goals

* Understand what it means for an application to be "real time."
* Understand the pub/sub model
* Understand how WebSockets work
* Set up a basic Node.js server using Express
* Implement pub/sub in the browser using Socket.io

## Resources

* [right-now][rn] repository  in [turingschool-examples][org]

[org]: https://github.com/turingschool-examples
[rn]: https://github.com/turingschool-examples/right-now

## Structure

* 5 - Warm up
* 20 - Lecture
* 5 - Break
* 25 - Experiment  #1: Right Now
* 5 - Break
* 25 - Experiment #2: Twitter Stream
* 5 - Wrap Up

## Warm Up

In your notebook, record your answers to the following questions:

- What does it mean to be _real time_?
- Can we name any applications that are _real time_?
- What's stopping our applications from being real time?

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
* ActionCable

[Socket.io]: http://socket.io/
[Faye]: http://faye.jcoglan.com/
[Node.js]:http://nodejs.org
[EventMachine]: http://rubyeventmachine.com/

## Experiment: Right Now

### Getting Started

[This repository][rn] contains a simple little Express app that servers a static `index.html` page. It also has [Socket.io][] hooked up by default—despite the fact that we're not using it at this moment.

You can fire up the server with `npm start`.

Let's start with a simple "hello world" implementation.

In our server, add the following code:

```js
// index.js
io.on('connection', function (socket) {
  console.log('Someone has connected.');
});
```

When a connection is made to via WebSocket, you're server will log it to the console. The next step, of course is create a connection via WebSocket, right?

```js
// public/application.js
var socket = io();
```

You should see the following in your terminal after you refresh the page:

```shell
Your server is up and running on Port 3000. Good job!
Someone has connected.
```

We can also let the client celebrate our new connection.

```js
// public/application.js
socket.on('connect', function () {
  console.log('You have connected!');
});
```

One thing that you've probably picked up on is that we have an `io` object on the server—as well as the client-side of our application.

So, let's send a message over the wire when a user connects.

```js
// index.js
io.on('connection', function (socket) {
  console.log('Someone has connected.');
  socket.emit('message', {user: 'turingbot', text: 'Hello, world!'});
});
```

Like everything with WebSockets, this is a two-part affair. The server is now emitting an event on the `message` channel. (This is arbitrary—like `sandwich_time` was when we discussed the using Redis for PubSub on the server-side.) We now need to do something when the client receives that message.

```js
socket.on('message', function (message) {
  console.log('Something came along on the "message" channel:', message);
});
```

Super cool. You did the thing! Let's shoot some stuff over the wire on a regular interval.

```js
// index.js
io.on('connection', function (socket) {

  var interval = setInterval(function () {
    socket.emit('message', {user: 'turingbot', text: 'I am a banana.'});
  }, 1000);

  socket.on('disconnect', function () {
    clearInterval(interval);
  });
});
```

### Your Turn

So, right now, we're pushing data from the client out to the server. That's cool, but it would be nicer if we displayed them onto the page.

Can you write some jQuery to append these messages to the DOM?

### Talking Back to the Server

WebSockets are a two-way street. We can send something back to the server over `socket.send`.

```js
// public/application.js
socket.on('connect', function () {
  console.log('You have connected!');
  socket.send('message', {
    username: 'yournamehere',
    text: 'I did the thing.'
  });
});
```

Let's also write a listener on the server.

```js
// index.js
io.on('connection', function (socket) {

  var interval = setInterval(function () {
    socket.emit('message', {user: 'turingbot', text: 'I am a banana.'});
  }, 1000);

  socket.on('message', function (channel, message) {
    console.log(channel + ':', message);
  });

  socket.on('disconnect', function () {
    clearInterval(interval);
  });
});
```

**Important Note**: We're doing it like this to demonstrate how you would push information from the client to the server using WebSockets. But, keep in mind, that the client has always been able to send requests to the server. It's totally okay to use AJAX in this situation.

### Your Turn

* Write the functionality on the client that sends something over the `mission` channel.
* Write the functionality on the server that listens on the `mission` channel and logs it to the console.

Here is a little bit of code to point you in the right direction.

```js
io.on('connection', function(socket) {
  socket.on('message', function (channel, message) {
    console.log(message);
  });
});
```

### Adding Some Nuance

So far, we've had one server talking to one client. This has a lot of practical value, but what if we wanted to create add more functionality to our little application? Socket.io has a few other APIs for fine-tuning your application.

```js
// Send to current request socket client
socket.emit('message', {user: 'turingbot', text: 'You can do the thing.'});

// Sending to all clients, include sender
io.sockets.emit('message', {user: 'turingbot', text: 'You can do the thing.'});

// Sending to all clients except sender
socket.broadcast.emit('message', {user: 'turingbot', text: 'You can do the thing.'});
```

You can also start to break your messaging out in additional channels. Here's an example.

```js
socket.on('new message', addMessageToPage);
socket.on('new connection', function () { updateStatus('A new user has connected.'); });
socket.on('lost connection', function () { updateStatus('Someone has disconnected.'); });
```

There are also some helpful methods for seeing how many clients are currently connected.

- `io.engine.clientsCount`
- `io.sockets.sockets.length`
- `Object.keys(io.sockets.connected).length`

### Your Turn

* When a user connects. Broadcast a message to all of the other clients connected announcing that someone new has connected.
* When a user disconnects. Broadcast a message to all of the other clients connected announcing that someone new has disconnected.
* When a message comes in from a user. Broadcast it out to all users.

## Pair Project

We're going to build a small chat room (like [this one][ch]) using Socket.io and jQuery.
Users should be able to fill out a little form, which will send their message over the
WebSocket to the server, which will broadcast it out to all of the connected clients.

[ch]: https://fullstack-denver.herokuapp.com/websockets/

### Extension

* Can you take advantage of [node-tweet-stream][nts] to stream tweets to your chatroom?

[nts]: https://www.npmjs.com/package/node-tweet-stream

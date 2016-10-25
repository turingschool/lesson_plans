## Intro to Action Cable

* How messaging works
* Asynchronous Messaging
* WebSockets
* Differences between the Request-Response and PubSub Messaging patterns
* How to use the PubSub Messaging pattern in Rails

### How Messaging Works

A message pattern is a network-oriented architecture that describes how two different parts of a system connect and communicate with each other.

### Request-Response Pattern

When you are browsing the Internet, the most common messaging pattern is the request-response pattern.

When you visit a website, for example, your browser sends a request to a server, and the server responds with the data that your browser will render on your screen. Since this happens at the moment the user sends the request, this is a synchronous request.

### Asynchronous Messaging

This works well when the user is the one who starts the request, but what if something happened in the server, like receiving an email, and you don't know anything about it? Using the request-reply pattern synchronously will mean that unless the user sends a new request, like hitting a "refresh" button, she won't be able the get her email.

The asynchronous request-reply messaging pattern provides a potential solution. This type of pattern lets us to put the request in a queue allowing us to say how often we would like to send a request to the server. Therefore, we can check the server every once in a while to see whether there is new data, like a new email, and get it from the server.

### PubSub Messaging Pattern

But what if you have are in a chatroom and several users are talking to each other at the same time? If you use the asynchronous request-response pattern, your users will only get the new messages once in a while, derailing the entire conversation.

The PubSub messaging pattern solves this by having one publisher (i.e. the chat service) and many subscribers (i.e. the chatroom participants). This pattern allows the publisher to send one message to one or more clients that are subscribed to that publisher.

This means that every time something changes in the chat service, the server will send a message to all the participants at once allowing real-time conversations.

As you probably have guessed, this isn't easily supported by HTTP. Enter WebSockets. WebSockets are connections that have state, unlike HTTP which is stateless. It accomplishes this by maintaining a constant connection.

### PubSub in Rails

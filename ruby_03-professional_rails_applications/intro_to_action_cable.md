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

The asynchronous request-reply messaging pattern provides a potential solution. This type of pattern lets us put the request in a queue allowing us to say how often we would like to send a request to the server. Therefore, we can check the server every once in a while to see whether there is new data, like a new email, and get it from the server.

### PubSub Messaging Pattern

But what if you are in a chatroom and several users are talking to each other at the same time? If you use the asynchronous request-response pattern, your users will only get the new messages once in a while, derailing the entire conversation.

The PubSub messaging pattern solves this by having one publisher (i.e. the chat service) and many subscribers (i.e. the chatroom participants). This pattern allows the publisher to send one message to one or more clients that are subscribed to that publisher.

This means that every time something changes in the chat service, the server will send a message to all the participants at once allowing real-time conversations.

As you probably have guessed, this isn't easily supported by HTTP. Enter WebSockets. WebSockets are connections that have state, unlike HTTP which is stateless. It accomplishes this by maintaining a constant connection.

### PubSub in Rails

With Rails 5, PubSub is made easy with Action Cable. Rails 5 gives you the channel and connection configuration, in order to keep a constant connection and allow real-time data updates to all users who are subscribed to a channel.

Let's dive into it by creating a simple chat app.

#### Action Cable Tutorial

__Basic Chat App w/o Action Cable__

Let's start by cloning down this chat app repo. This chat currently does not have Action Cable set up. It is just a basic app that shows messages on a page, but other users can't see what you have updated until the page is refreshed.

```sh
$ git clone https://github.com/turingschool-examples/chat_app.git action_cable_tutorial
$ cd action_cable_tutorial
$ bundle
$ rake db:{create,migrate}
$ rails server
```

Now that your rails server is running, open up localhost:3000 in your browser. And also open up an incognito window and navigate out to localhost.
Let's type in `clancey` for our first user's name, and `delores` for our second user's name. Once you are in the chat window, start typing from both users.
Notice that the page has to refresh in order for us to see the updated messages that the other user is sending. This is annoying, and not practical when we want to read messages in real time. We want other users to laugh at Clancey's joke as soon as they are sent, and not 5 minutes later.

Cue Action Cable!

__Looking at what is given to us with Rails 5__

Before we setup our app to work in real time. Let's take a look at the Action Cable folders/files that now come with Rails 5. First, Rails 5 gives us a new folder called `channels`. Within this folder, is yet another folder called `application_cable` and within that we get two files `channel.rb` and `connection.rb`. The file structure looks like this.

|-- app
  |-- channels
    |-- application_cable
      |-- channel.rb
      |-- connection.rb

Both of these files inherit from the ActionCable::Channel::Base

Within the `Channel` class you could place shared logic between multiple channels your app has.

Within the `Connection` class you would authorize incoming connections if you were requiring authorization from users.

We won't be dealing with any of those files for now.

Within `app/assets/javascripts` we also get a new `channels` folder, along with a `cable.js` file. The file structure looks like this.

|-- app
  |-- assets
    |-- javascripts
      |-- channels
    |-- cable.js

If you look at `cable.js`, you will notice that this is where the client-side instance of our WebSocket connection has been defined for us.

Time to setup our app.

__Setting up Action Cable__

There are three main steps for setting up Action Cable.

1. Creating the channel
2. Updating our controller to "broadcast" the data to everyone who is subscribed to the channel
3. Create our javascript file for the client side (what are user is seeing)


We could have rails generate channel files for us by doing `rails generate channel [Channel_name]`; however, this will create .coffee files for us and we just want to use javascript files so we will add it manually. ```sh
$ touch app/channels/turing_channel.rb
```

Rails 5 also gives us an action that we need to use in order to subscribe to a channel and that is...you guessed it, `subscribed`.

```rb
# app/channels/turing_channel.rb

class TuringChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'turing'
  end
end
```

Now that we are able to subscribe to a channel, we want any new messages to be published to that channel in real time. We can do this by "broadcasting" the channel. Rails gives us a handy dandy method called `broadcast` in order for us to do this. When would we want to broadcast our messages? Anytime a message is saved. So let's go into our MessagesController #create method.

```rb
# app/controllers/messages_controller.rb

def create
  message = Message.create(message_params)
  if message.save
    message.update_attribute(:username, session[:username])
    ActionCable.server.broadcast 'turing',
      content: message.content,
      username: message.username
  end
end
```

Let's stop and restart our server to see where we are at right now. Refresh your two localhost windows. Let's send a message from one of the windows. What is happening? We send the message, but nothing happens on the page. If we look at our server log, we can see that the message is transmitted as a hash. You should see something like this:

```sh
[ActionCable] Broadcasting to turing: {:content=>"hidy ho", :username =>"yo dawg"}
```

Why isn't anything rendering on the page? Because we haven't set up our javascript file yet. Let's set it up.

We want our js file to live in `app/assets/javascripts/channels`.

```sh
$ touch app/assets/javascripts/channels/turing.js
```

Notice that I named my js file the same as my channel file. While this isn't necessary (you could name it asdf.js and it would still work), it's better to organize your files this way. Let's open up the file, and enter in this:

```js
App.room = App.cable.subscriptions.create("TuringChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function() {}
});
```

Note: The channel name in the js file needs to match the class name of the channel you created in `app/channels` thus, ...create("TuringChannel")...

We won't worry about the connected and disconnected methods for now. Let's focus on the received method. We want to add code into the `received` method to get our messages to actually show up on the page asynchronously. First let's just add an alert to see how this works.

```js
App.room = App.cable.subscriptions.create("TuringChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    alert(data.username + ":" + data.content);
  }
});
```

Refresh your browsers and start sending messages. You should see two alert windows. One for each window. Now that we know it's working, we can add the code we need. Since we aren't refreshing the page, we want to be able to append the message to the rest of the messages. Let's replace our alert with this code.

```js
App.room = App.cable.subscriptions.create("TuringChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    $("ul.media-list").append('<li class="media">' +
      '<div class="media-body">' + data.username + ' | ' +
      '<small class="text-muted">' + data.content +
      '</small>' + '<hr />' + '</div>' + '</li>')

    scroll_bottom();
  }
});
```

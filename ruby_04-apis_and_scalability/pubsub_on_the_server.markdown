---
title: Pub/Sub on the Server
length: 180
tags: redis, json, faraday, sinatra
status: draft
---

## Learning Goals

* Understand the pub/sub pattern and its advantages over synchronous request and response
* Implement pub/sub using Redis; create publishers and subscribers
* Implement pub/sub in a Ruby/Sinatra application with external APIs
* Understand the advantages of non-blocking and asynchronous code

## Structure

* 5 - Warm up
* 20 - Lecture
* 5 - Break
* 15 - Experiments
* 10 - Discussion
* 5 - Break
* 25 - Experiments
* 5 - Break
* 75 - Pair Practice
* 15 - Wrap Up

## Materials

* The [Slacker][slacker] repository
* A running [Redis To Go][redistogo] instance
* A Slack channel with a webhook integration set up

[slacker]: https://github.com/turingschool-examples/slacker
[redistogo]: http://redistogo.com

## Warm Up

In a gist—

1. How would you set up communication between two applications?
2. How about *n* different applications?
3. What if the communication had to be in real time?

## Lecture (Part One)

* How would you wire up multiple applications that had to talk to each other?
* One basic way would be to set up a series of requests and responses to facilitate communication between the applications.
* On a basic level, this will work, but we're hard coding these dependencies into our application.
* Thinking back to Module 1, this is a bit of a code smell. It means that each time we want to add or remove a dependency, we have to modify the code for all of the other applications.
* It also gets complex as the number of applications grows.
* Lastly, Ruby is blocking. If we're doing all of this in—let's say—our controllers, then Ruby halts execution after each request until it gets a response from the other application. This can potentially take a while as the number of intercommunicating applications grows. We're leaving the client waiting as we take care of our internal business.
* Background workers are potentially an option, but what if we need this all to happen in real-time? What if we're building a chat application?
* What is pub/sub? It stands for publish and subscribe. In it's simplest form, pub/sub allows us to build applications that broadcast messages and other applications who listen for those messages and act on them.
* Pub/sub is asynchronous and non-blocking. This means after publishing a single message, execution in our controller can continue without blocking and waiting for a response.
* This approach works as well with 2 clients as it does with *n* clients.
* We can also scale up to having multiple publishers and multiple subscribers.

## Break

* Make sure you have Redis installed (`brew install redis`)
* Make sure you have the Redis gem installed (`gem install redis`)

## A First Experiment

Open up three tabs in the terminal.

In the first tab, start up Redis (`redis-cli monitor`).

Open up a second tab and fire up `pry`. Enter the following:

```rb
require 'redis'

redis = Redis.new

redis.subscribe("my_channel") do |event|
  event.message do |channel, body|
    puts "I heard [#{body}] on channel [#{channel}]"
  end
end
```

Check out your Redis tab; you should see something similar to the following:

```
1415105055.243106 [0 127.0.0.1:49407] "subscribe" "my_channel"
```

This will block up `pry`. So, we'll use another tab and enter the following:

```rb
redis.publish("my_channel", "the message")
```

Flipping back to that first `pry` tab, you should see `I heard [the message] on channel [my_channel]` and checking in our Redis server, we should see something along the lines of `1415105317.658196 [0 127.0.0.1:49322] "publish" "my_channel" "the message"`.

Not satisfied? Let's pop open a third `pry` window and subscribe as to our channel as well.

```rb
redis.subscribe("my_channel") do |event|
  event.message do |channel, body|
    puts "I think [#{body}] sounds great!"
  end
end
```

Let's also publish another message to the channel:

```rb
redis.publish("my_channel", "Is this thing on?")
```

A few things should have happened:

* `redis-cli` logged something like `"publish" "my_channel" "Is this thing on?"`
* Our first `pry` window logged `I heard…`
* Our newest `pry` window logged `I think…`
* Our `redis.publish` method most likely returned `2` instead of `1`. Why is this?

## Discussion

In Redis, we have this concept of channels. We can use channels to namespace publishers and subscribers.

In a hypothetical blogging application, we could have a channel for `posts` and a different channel for `comments`. You'll typically see namespaced channels like `posts:add`, `posts:destroy`, `comments:add`, `comments:destroy`. Redis has pattern-subscribing (`psubscribe`), which would allow an application to easily subscribe to all of the comment-related channels with `PSUBSCRIBE comments*`.

Supported patterns:

* `h?llo` subscribes to `hello`, `hallo` and `hxllo`
* `h*llo` subscribes to `hllo` and `heeeello`
* `h[aaello` subscribes to `hello` and `hallo`, but not `hillo`

## Pair Practice

* Create a pair of scripts that publish and listen on another channel (e.g. `my_sandwich`).
* Modify a your listener to `PSUBSCRIBE` to multiple channels (e.g. `my_channel` and `my_sandwich`)

## Using Slacker

[Clone Slacker from its repository.][slacker]

By default, Slacker uses your local Redis database, so make sure you have that up and running.

Run `bundle`.

In two separate tabs, run the following:

1. `ruby publishers/talk  er.rb`
2. `ruby subscribers/listener.rb`

Type something into the tab running `talker.rb` and check `listener.rb`.

### All Together Now

If you set a `SLACKER_REDIS` environment variable, Slacker will use that remote database instead.

```shell
export SLACKER_REDIS=redis://…
```

Restart `publishers/talker.rb` and `subscribers/listener.rb` and start chatting.

### Further Exploration

There are a few other small applications in the repository. Let's explore each of them as a group.

* `subscribers/logger.rb`
* `subscribers/whisper.rb`
* `publishers/webber.rb`

## Pair Practice

In pairs, let's resurrect your old IdeaBox projects from Module 2.

* Can you create a logger that listens for new ideas and commits them to a log file?
* Can you create a publisher that posts your idea to the *#supersecret* channel on Slack?
* Can you create a service that sends your idea to a phone number via SMS using Twilio?
* Can you integrate your both of your projects so that adding an idea to one IdeaBox also adds it to the other?
* Can you implement updating and destroying ideas in the same fashion?
* Can you use pattern-subscribing to properly namespace your channels?

## Wrap-Up

What are some alternative uses for pub/sub that you can think of that we didn't discuss today?

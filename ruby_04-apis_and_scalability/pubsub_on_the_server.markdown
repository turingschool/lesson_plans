---
title: Pub/Sub on the Server
length: 90
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

redis.subscribe("sandwich_time") do |event|
  event.message do |channel, body|
    puts "I heard [#{body}] on channel [#{channel}]"
  end
end
```

Check out your Redis tab; you should see something similar to the following:

```
1415105055.243106 [0 127.0.0.1:49407] "subscribe" "sandwich_time"
```

This will block up `pry`. So, we'll use another tab and enter the following:

```rb
redis.publish("sandwich_time", "the message")
```

Flipping back to that first `pry` tab, you should see `I heard [the message] on channel [sandwich_time]` and checking in our Redis server, we should see something along the lines of `1415105317.658196 [0 127.0.0.1:49322] "publish" "sandwich_time" "the message"`.

Not satisfied? Let's pop open a third `pry` window and subscribe as to our channel as well.

```rb
require 'redis'

redis = Redis.new

redis.subscribe("sandwich_time") do |event|
  event.message do |channel, body|
    puts "I think [#{body}] sounds great!"
  end
end
```

Let's also publish another message to the channel:

```rb
redis.publish("sandwich_time", "Is this thing on?")
```

A few things should have happened:

* `redis-cli` logged something like `"publish" "sandwich_time" "Is this thing on?"`
* Our first `pry` window logged `I heard…`
* Our newest `pry` window logged `I think…`
* Our `redis.publish` method most likely returned `2` instead of `1`. Why is this?

## A Brief Discussion: Redis Pub/Sub Additional Features

We won't get into it much in this lesson, but Redis has a few more
useful pub/sub features, including:

* __Channel__ Subscriptions
* __Pattern__ Subscriptions

### Channels

Channels can be used as a way to "namespace" or separate different types of
messages. For example we could create one channel for `posts` and another for `clients`.

If we need more specificity than this, a common redis convention is to use `:` to subdivide
namespaces, for example: `posts:add` or `posts:destroy`

If we look back at the initial example where we used `redis.subscribe("sandwich_time")` to
watch for incoming messages, we can now see that "sandwich_time" is the specific _channel_
we were subscribing to.

__Exercise: Channel filtering__

Return to your original 3 tabs you fired up in the first example. If you shut them down,
re-launch them. You should still have one watching on the channel "sandwich_time".

In your other pry terminal, try publishing a message on a channel besides "sandwich_time".
Verify that it doesn't appear in the listening terminal.

### Patterns

Another neat feature supported by Redis is the ability to subscribe to "patterns" of
channels. This is done with the `psubscribe` function. Consider our previous example
of multiple namespaced channels around "posts" (`posts:create`, `posts:destroy`, `posts:update`).

If we wanted to subscribe to all updates relating to posts, we could use `psubscribe` to
subscribe to a pattern containing "posts"

__Exercise: psubscribe__

Fire up a new Redis client using `redis-cli`

Subscribe to a new "sandwiches" pattern, using: `psubscribe "sandwiches:*"`

Then, from another tab, try publishing some messages onto various channels
within the "sandwiches" namespace.

Finally, pattern subscriptions are worthwhile if only because they
give us the best-named programming API method: __[PUNSUBSCRIBE](http://redis.io/commands/punsubscribe)__.

[Redis psubscribe docs](http://redis.io/topics/pubsub)

## Using Slacker

Now, let's practice using Redis' pub/sub features more interactively.
For this section we'll use the example Slacker project.

__Setup__

[Clone Slacker from its repository.][slacker]

By default, Slacker uses your local Redis database, so make sure you have that up and running.

Run `bundle`.

In two separate tabs, run the following:

1. `ruby publishers/talker.rb`
2. `ruby subscribers/listener.rb`

Type something into the tab running `talker.rb` and check `listener.rb`.

### All Together Now

__Setup__

Your instructor should provide the group with a special Redis URL
for everyone to connect to. Once you have this, re-run the above
scripts, providing the new Redis URL as a `SLACKER_REDIS` environment
variable.

**Please, please note:** you will be provided with a URL for the shared Redis server. Replace the _entirety_ of `{{shared-redis-url}}` with this URL.

For example:

```
SLACKER_REDIS={{shared-redis-url}} ruby publishers/talker.rb
# (in other tab)
SLACKER_REDIS={{shared-redis-url}} ruby publishers/listener.rb
```

### Further Exploration

There are a few other small applications in the repository. Let's explore each of them as a group.

* `subscribers/logger.rb`
* `subscribers/whisper.rb`
* `publishers/webber.rb`

## Pair Practice

(Only do this if you're doing the 180 minute version of this lesson or if time allows.)

In pairs, let's resurrect your old IdeaBox projects from Module 2. Can you create a logger that listens for new ideas and commits them to a log file?

## Wrap-Up

What are some alternative uses for pub/sub that you can think of that we didn't discuss today?

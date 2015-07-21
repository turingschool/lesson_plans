---
title: Consuming Apis
length: 180
tags: apis, json, faraday, twitter
---

## Learning Goals

* Practice pulling data from public APIs using both faraday/curl and
  dedicated wrapper libraries
* Understand some common organizational patterns for public APIs
* Practice retrieving nested data from multi-level JSON structures
* Understand API tokens and application registration


Iterations

- Consuming API using `cURL` (raw HTTP) - Twitter
Practice: students practice with instagram, github
- Consuming API using Faraday (http in ruby)
Practice: students practice with instagram, github
- Consuming API using our own wrapper client around faraday
Practice: students practice with instagram, github
- Consuming API using open source wrapper gem
Practice: students practice with instagram, github

Supporting materials:

- gist containing sample API tokens to use for each service

Workshop: Building a rails app to fetch tweet data

## Structure

TODO

## Warmup

Discuss some intro questions to get those API brain juices
flowing:

```
```

## Discussion - What is an API?

* Have you encountered the term _API_ before? What does it stand for?
* What are the most common use-cases for a service to provide an API? Why bother?
* What APIs have you used or wanted to use in the past?

## Discussion - APIs: Variety is the Spice of Life

One of the problems with working with APIs is that there are very few consistent
generalizations or assumptions that can be made.

As an exercise, let's consider some of the things that make it (relatively)
easy for us, as Rubyists, to read code written by other Rubyists:

* Common idioms for expressing ourselves
* Common language features for structuring our code (classes, OOP, method practices)
* Common set of tools for designing projects
* Common style practices (capitalization, underscores, spelling, predicate methods, etc)
* Shared community best practices -- `SOLID`, Sandi Metz' rules, conference talks, ruby books, etc etc

In short, when working within the ruby community, we have a lot of shared practices
and ideas that help us write "unsurprising" code that will hopefully be easily intelligble
to a future reader, especially one versed in the same community idioms as we are.

Why bring this up? Because we are about to make our first forays into the realm of
public APIs, which is, comparatively the Wild Wild West.

Let's consider some of the reasons why we might find relative non-conformity within
this corner of the tech world:

* Huge cross-section of language and community backgrounds (power of HTTP is its accessibility
from any platform)
* Very little shared design principles. Even around the ideas of REST there are differing interpretations
and implementations
* Lack of standardization around request/response formats, status codes, etc. etc.
* Tremendous variation in quality of documentation (often very little...)

In short, there's a good chance that no 2 APIs you will encounter are alike.

A handful of community projects such as [Swagger](http://swagger.io/) and [json:api](http://jsonapi.org/)
have attempted to address this, but even these are fragmented and not well adopted.

([See Relevant XKCD](https://xkcd.com/927/))

So why should we venture into this cesspool of non-conforming inter-process communication?

Because APIs let us do cool stuff. And fortunately HTTP with JSON (or even XML) is a relatively
easy to understand format.

With a little careful experimentation and probing, we can generally figure out what we need to do.
But it's good to have a sense of what to expect so that when we run into issues we won't be surprised and
will know what to do.

## Discussion API Spectrum of Quality

You can never really know what to expect from an API, but here are a few general predictors

* The larger the platform, the better. The top names in the social media space (twitter, foursquare,
facebook, instagram, etc) will generally have better public APIs since more people use them.
* The newer the better. Unsurprisingly an API that was implemented in the early 2000's will
often feel dated or clunky
* The more "RESTful" the better. This is hard to predict until you start digging in,
but the more Resource-oriented an API is, the more natural it will feel to use. You can often
"guess" a resource or endpoint and be relatively close

## Workshop -- Consuming APIs

With these ringing endorsements out of the way, let's get down to actually
consuming some data.

Throughout this section, we'll work on answering a few key questions:

* What are some ways for sending input data _to_ an API?
* What tools are available to fetch data from an API?

__Material:__ Instructor should provide students with a private gist containing
API tokens for Twitter, Instagram, and Github.

### Step 1 -- APIs via Raw HTTP

These days, when we say "API", we're generally talking about a RESTful, HTTP API.
With any luck, it uses JSON as a serialization format.

So if it's just HTTP, what's the simplest way to interact with it?

Let's practice using everyone's favorite lightweight HTTP tool: `cURL`.
For each of the sections below, we'll be starting with Twitter and then
doing some independent exploration using Github and Instagram.

First, let's head over to the API docs to get a sense of what we're
working with. You can find them [here](https://dev.twitter.com/rest/public).

We're mostly interested in the REST API. Consider Twitter's summary of what
they are providing:

> The REST APIs provide programmatic access to read and write Twitter data.
> Author a new Tweet, read author profile and follower data, and more.
> The REST API identifies Twitter applications and users using OAuth; responses are available in JSON.

So: __JSON__ and __REST__. So far so good.

Now let's take a moment to peruse the API docs and see what's available.
This is one of the most important skills when consuming APIs, so it's important to practice.

__Demo:__ Instructor reads through API docs noting especially what parameters
are required for each request and what data is returned.

__Practice: Pulling Data__

Now that we've poked around a bit, let's practice pulling some data.

Unfortunately, Twitter's API requires OAuth in order to access it. This is a bit of
a pain to configure manually, so we'll use a gem called [twurl](https://github.com/twitter/twurl),
which gives us a curl-like interface to Twitter using OAuth.

Install it:

```
gem install twurl
```

And authorize our app with:

```
twurl authorize --consumer-key my-consumer-key --consumer-secret my-consumer-secret
```

This authentication process is a bit strange, but it will basically output a URL to your
terminal which you should copy, and open in your browser.

This will prompt you to OAuth with the app, and will provide you a numeric
PIN to finish the Auth process.

Paste this PIN into the console, and your authentication should be compelete.

Now we can finally make some requests. Let's practice by fetching these pieces of data

Try these 2 requests:

1. Recent tweets from user "worace" (twurl command: `twurl "/1.1/statuses/user_timeline.json?screen_name=worace"`)
2. Recent retweets for your user account (question: how does twitter identify "your user account"?) (twurl: `twurl "/1.1/statuses/retweets_of_me.json"`) 

__Your turn__

Based on the patterns above, see if you can generate the proper twurl requests to
fetch these pieces of data

1. Recent tweets from user "j3"
2. Recent user timeline for your account (i.e. tweets from users you follow)

__Extra Credit: Posting Data__

If you're feeling brave, let's see if we can send a tweet.

* Under REST, what sort of request would we expect to use to create a tweet?
* How can we send data when making a request like this?

Here's an example to post a tweet:

`twurl -d "status=Posting tweets from twitter API with @turingschool" "/1.1/statuses/update.json"`

### APIs for Experimentation

#### Foursquare

* Documentation: https://developer.foursquare.com/docs/
* Gem: https://github.com/mattmueller/foursquare2
* Apps: https://foursquare.com/developers/apps
* API Explorer: https://developer.foursquare.com/docs/explore#req=users/self

(Foursquare's interactive API explorer is one of the nicer ones out
there IMO)

See if you can retrieve a list of venues near Turing (lat/long: 39.7496354, -105.0001058)

What data is available with only an application token and secret?
What actions require an authenticated user token?
What is the "version" parameter that foursquare requires?

#### Flickr

Demo Api Key:
`1c5111342219c4fab62e164fce5e28f6`
Demo Api Secret: `36454725931308aa`
https://www.flickr.com/services/apps/by/127167934@N07

* Documentation: http://www.flickr.com/services/api/
* Flickraw gem: https://github.com/hanklords/flickraw
* Flickr-objects gem: https://github.com/janko-m/flickr-objects

Try pulling some images from the "latest" feed (similar to how we did
with 500px above).

#### Twitter

* Documentation: https://dev.twitter.com/docs/api/1.1
* Twitter gem: https://github.com/sferik/twitter
* Dev console (nice for in-browser experimentation): https://dev.twitter.com/rest/tools/console
* Test keys: https://apps.twitter.com/app/7110558/keys

- Can you load the last tweet from j3? How many
  followers does he have?
- Can you get the public twitter uri for a user loaded through the
  gem?

#### NPR

* Documentation: http://www.npr.org/api/index
* NPR Gem: https://github.com/bricker/npr

- Can you find the station closest to Turing (zip 80202)?

#### Any others? What APIs are you curious about?

## Final

Let's see if we can build a simple rails app which shows the latest
tweet for a given twitter user name. We'll use this to get some more
practice with APIs, and then we'll build on it with some tests in the
next lesson.

Start your sample app with:

```
rails new twitter-demo
```

We'll be using the twitter gem to access tweet data, so let's add it to
our Gemfile:

```
gem "twitter"
```

Don't forget to bundle! Since we're in kind of a hurry, we'll just
create a global twitter client object to use throughout our app. A good
place to do this is in an initializer, eg
`config/initializers/twitter.rb` (remember that all .rb files in the
`initializers` directory get run when our app boots).

We are going to cut corners and just throw some API keys in this file. Remember in real
life we should source these from an environment variable. But enough
excuses, here's what our `config/initializers/twitter.rb` will look
like:

```
TWITTER = Twitter::REST::Client.new do |config|
  config.consumer_key        = "W94h9TI21dRmkuDKewew2gy2t"
  config.consumer_secret     = "4QOGnSWrT8vfxoUHohZFEtPFeCGlo47uhJatjL90BD73JGe3g7"
end
```

Now let's add a controller for viewing tweet streams at:
`app/controllers/tweet_streams_controller.rb`

```
class TweetStreamsController < ApplicationController
  def new
  end

  def create
  end
end
```

We'll be adding a simple form to accept a username, and then on the
create action we'll use that username to fetch the tweets in real time.

Go ahead and add the corresponding routes to `config/routes.rb`:

```
  resources :tweet_streams, :only => [:new, :create]
```

The output from `rake routes` should look something like:

```
Prefix Verb URI Pattern                  Controller#Action
tweet_streams POST /tweet_streams(.:format)     tweet_streams#create
new_tweet_stream GET  /tweet_streams/new(.:format) tweet_streams#new
```

Let's start with the form, in `app/views/tweet_streams/new.html.erb`:

```
<%= form_tag(tweet_streams_path) do %>
  <%= label_tag "twitter handle" %>
  <%= text_field_tag("twitter_handle")  %>
  <%= submit_tag %>
<% end %>
```

Pretty straightforward so far. We're looking to accept a twitter
username as input, so let's look at what is required in our create
action to fetch tweets from that user.

Remember the global twitter client we created in our initializer? Now
we can use it to fetch tweets for the provided user. In
`app/controllers/tweet_streams_controller.rb`:

```
def create
  @tweets = TWITTER.user_timeline(params[:twitter_handle])
end
```

And we want to show these to the user somehow, so let's add a simple
layout in `create.html.erb` (we often don't use the create template, but
in this case we aren't trying to persist anything to the DB or redirect
a user, so it is a good fit):

```
<div>
  <ul>
    <% @tweets.each do |tweet| %>
      <li class="tweet">
        <p><em><%= tweet.user.screen_name %></em> says: <%= tweet.text %></p>
      </li>
    <% end %>
  </ul>
</div>

<p>
  <%= link_to("try another user", new_tweet_stream_path) %>
</p>
```

With any luck, you'll see a super low-fi version of the twitter feed for
the user you submitted. Try to get this working, because we'll build on
it with some tests in the next lesson.

## Corrections & Improvements for Next Time


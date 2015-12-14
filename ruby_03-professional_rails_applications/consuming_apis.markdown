---
title: Consuming Apis
length: 180
tags: apis, json, faraday, twitter
---

## Learning Goals

* Practice pulling data from public APIs using both curl and dedicated wrapper libraries
* Understand some common organizational patterns for public APIs
* Practice retrieving nested data from multi-level JSON structures
* Understand API tokens and application registration

Supporting materials:

- gist containing sample API tokens to use for each service

Workshop: Building a rails app to fetch tweet data

## Structure

* 25 mins - Warmup / Discussion: What is an API? What to expect from most APIs?
* 5 mins - Break
* 25 mins - Twurl discussion, setup and some examples
* 5 mins - Break
* 10 mins - Finishing Twurl examples
* 15 mins - Wrapper gem discussion and set up
* 5 mins - Break
* 25 mins - Wrapper gem usage and student experimentation
* 5 mins - Break
* 25 mins - Twitter API demo app walkthrough
* 5 mins - Break
* 15 mins - Twitter API demo app walkthrough wrapup
* 10 mins - Recap / Wrapup discussion

## Warmup

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

### Step 2 -- APIs Using a Wrapper Library

If you haven't caught on yet, this process is a bit of a pain.

For every we request we want to make, we have to look up what its url and format are. We
have to figure out the proper HTTP verb to use, and if there are any request parameters,
we have to make sure we get those just right as well.

And how about that authentication process? On the one hand, it's good that twitter is keeping
everything secure, but it can be a pain as a developer when the Auth procedure is so involved
(note - many APIs will simply accept your API tokens as auth credentials, which simplifies things).

As the [saying goes](http://c2.com/cgi/wiki?OneMoreLevelOfIndirection), there's no problem
that can't be solved with another layer of abstraction. One very common practice when working
with external APIs is to use a wrapper library. In our case, this will be a ruby gem, although most popular
APIs will have wrapper libraries available in many languages.

This has several advantages:

* Allow us to bundle up process of authenticating with API credentials
* Easier to pull returned values into our code (as opposed to fetching raw strings via `curl`)
* Easier data passing -- we can provide parameters as method arguments rather than building
a raw URL or post body string
* More idiomatic interface

Fortunately for us, the [twitter ruby gem](https://github.com/sferik/twitter) by [sferik](https://github.com/sferik)
is one of the nicest around. Let's get some practice using it to make requests
instead of the manual `twurl` approach.

__Setup: Twitter Gem__

For now, let's just install the gem globally:

```
gem install twitter
```

Then start a new Pry session and pull in the gem:

```
pry
[1] pry(main)> require "twitter"
=> true
[2] pry(main)> Twitter
=> Twitter
```

Next, we need to configure the gem to use our API credentials:

```
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
end
=> #<Twitter::REST::Client:0x007fb216732290
```

The gem also accepts user-specific OAuth access tokens, but for now we just
need our app-level credentials.

__Usage: Twitter Gem__

Notice the object we just instantiated: an instance of `Twitter::Rest::Client`.
This object will give us a nice, object-oriented interface into the Twitter
REST api.

Let's practice a simple example by retrieving the user information for
twitter user "j3":

```
client.user("j3")
```

Store the returned object as a variable in your console. Use the `#methods`
method to see some of the data it has available. Spend a few moments trying
some of these methods to see what they give you.

__Your Turn: Twitter Gem Experimentation (10 - 15 minutes)__

Now that we have our Twitter ruby client set up, experiment with making the
some API requests using the gem.

The Twitter gem is pretty large, so you may want to consult the
[API Docs](http://www.rubydoc.info/gems/twitter).

1. Fetch recent tweets from user "worace"
2. Find total number of tweets posted by user "j3"
3. The permalink of the most recent tweet from user "stevekinney"
4. The text of the last 3 tweets for the hastag "#turingschool"

## Final Workshop -- Consuming an API in a Rails App

Let's see if we can build a simple rails app which allows a user to
log in and see recent tweets from their Twitter feed.

We'll use this to get some more
practice with APIs, and then we'll build on it with some tests in the
next lesson.

Additionally, since we want users to be able to authenticate with Twitter,
we'll build on top of the OAuth sample app in [this tutorial](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/getting_started_with_oauth.markdown).

If you have your own application from that tutorial, continue working with
that. Otherwise, you can start with the [example implementation provided here]
(https://github.com/turingschool-examples/oauth-workshop). (Follow the setup
instructions included in the application's README to get started)

__Step 1 - Basic Setup / Verification__

Make sure your application is properly running and that you
can login using Twitter's OAuth process and see that it is
able to pull in your username.

__Step 2 - Adding Twitter Dependency__

We'd like to see a user's recent timeline info on our homepage.

To get this information, we'll need to pull it from Twitter's API.

And as we learned in the previous section, the most pleasant way to
do this will be to use the Twitter gem, so let's add
it as a dependency in our Gemfile:

```ruby
# in Gemfile
gem "twitter"
```

(don't forget to bundle)

__Step 3 - A User's Twitter Information__

Recall that in the previous step we were able to access Twitter
information by instantiating an instance of the `Twitter::REST::Client`
which the twitter gem provides us.

We were even able to pass in a user's screen name and see
some of their recent tweets. But what about the user's home timeline?
Were you able to access that data? If you had tried, you
probably would have gotten a security or permissions error,
since this information requires authentication on behalf of the
user.

Fortunately, this is exactly what OAuth provides us. When we
authenticate a user, we are saving (in our DB) their
`oauth_token` and `oauth_token_secret`. These credentials
will allow us to make authenticated API requests to twitter on
behalf of the user.

Let's experiment with this in rails console. First make sure
you have authenticated at least one user into the app, then
open a rails console session and try these commands:

```ruby
u = User.last

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token = u.oauth_token
  config.access_token_secret = u.oauth_token_secret
end

tweets = client.home_timeline
```

__Step 4 - Pulling this Information into our App__

So we can now see that it's possible, using the OAuth tokens
we've acquired, to make authenticated twitter requests for
our users.

So let's pull this into our app. It would be nice
if we had a method on our `User` model to fetch
their twitter timeline.

To do this we'll need to set up a user-specific Twitter client
just as we did in the previous console example, but fortunately
both of these are pretty straightforward.

Let's add the code to `app/models/user.rb`:

```ruby
# in app/models/user.rb

def twitter_client
  @client ||= Twitter::REST::Client.new do |config|
    config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
    config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
    config.access_token = u.oauth_token
    config.access_token_secret = u.oauth_token_secret
  end
end

def twitter_timeline
  twitter_client.home_timeline
end
```

__Step 5 - Your Turn: Pulling and Displaying Tweets on the Homepage__

Now that we have the basic infrastructure, see if you can finish the
job.

When a user logs in and visits the homepage of our simple app,

* Show them a message saying "Your Twitter Timeline:"
* Fetch their home timeline, and display the tweets in a simple list
* See if you can display the sender's username and time submitted for
each tweet as well

Remember that Twitter provides this data to us wrapped as methods on various
Ruby objects (for example `Twitter::Tweet`). Use experimentation in pry/console
or the API docs to figure out how to access the data you need.

## Addenda / Extras

### Additional APIs for Experimentation

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

#### NPR

* Documentation: http://www.npr.org/api/index
* NPR Gem: https://github.com/bricker/npr

- Can you find the station closest to Turing (zip 80202)?

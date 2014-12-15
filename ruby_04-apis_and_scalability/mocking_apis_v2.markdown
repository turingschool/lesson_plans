---
title: Mocking Apis
length: 90
tags: apis, json, clients, mocking, testing
status: draft
---

## Learning Goals

* Get exposure to a handful of different approaches to testing API
  integrations
* Understand the pros and cons of different approaches
* Learn how to structure our code so that it is easy to take advantage
  of these approaches
* Look at some open-source tools which can be helpful for this purpose

## Context

We live in an era of Web API saturation, which is pretty cool. Just
about every major web service out there has a public API of some sort,
and the things you can do by combining different ones are pretty cool.

But as we start to pull in more external data for our apps, we do
sacrifice some control. With ActiveRecord models backed by our own
database, we can control everything going in and out, and (thankfully)
we generally experience low latency and high availability.

With an external HTTP api, latencies are much higher and reliability
much lower. This takes an especially high toll on our test suite, which
we want to run quickly and repeatably.

The best solution to this problem is usually to Mock the API, so that we
regain some more control over our test environment. In this lesson, we'll
look at a few approaches to Mocking external APIs and cover the pros and
cons of each.


### Mocking APIs: Desirable Factors:

- Closeness to production / reality
- Speed
- Reliability / Consistency
- Customizability
- Ease of implementation (when writing the test)

Approaches:

1. Client stubbing - Stubbing methods on provided client
2. Client stubbing - Stubbing methods on our own wrapper client
3. Client stubbing - Wrapper client combined with Mock client
4. Transit-layer mocking - JSON fixtures
5. Whole-hog mock it at the source AKA VCR
6. Client integration -- building a dup service approach


### Setup:

Let's use the simple twitter display app we built in the last lesson.
We'd like to add some basic tests that validate our functionality. Start
with a new controller test:
`test/controllers/tweet_streams_controller_test.rb`, and flush it out
with some basic examples:

```
require "test_helper"

class TweetStreamsControllerTest < ActionController::TestCase
  test "fetches tweets on create" do
    post :create, :twitter_handle => "j3"
    assert_response :success
    assert_not_nil assigns(:tweets)
    assert_select "li.tweet"
  end
end
```

run the test with `rake`. Does it pass? (hopefully it should)

What about if you turn your wifi connection off? Without a network
connection our test is doomed to fail because we are connecting to the
live twitter api. In this case twitter is usually pretty fast, but we
can also imagine things getting pretty slow if we had a lot of these.

Onward to mocking!

#### 1: Stubbing methods on provided client

Perhaps the easiest way to stub out our service connection is by setting
individual expectations on our client object. This gives us good
granularity, is quick-and-dirty, and is usually not bad for small or
isolated cases.

Since we're just trying to look at stubs on our existing object for now,
let's pull in the `mocha` gem, which adds some basic expectation/stub functionality.

In `Gemfile` add:

```
group :test do
  gem 'mocha'
end
```

and add the following require to `test/test_helper.rb`:

```
require 'mocha/mini_test'
```

Mocha gives us a nice expectation and stubbing interface using the
methods `#expects` and `#stubs`. These methods return `Expectation`
objects which you can also send messages like `#with` to specify desired
arguments and `#returns` to specify return values. Play around with
stubbing interactions on our `TWITTER` object and see if you can get the
test to pass.

Check out the mocha docs if you want more info on what mock/stub methods
are available: http://gofreerange.com/mocha/docs/

- Hint 1: think closely about the interface for the `#user_timeline`
  method we're using
- Hint 2: Flexible objects like `OpenStruct` or `Hashie::Mash` often
  make versatile dummy objects for test responses

Notice the time difference between our un-stubbed and stubbed versions:

```
Finished in 1.132931s, 0.8827 runs/s, 2.6480 assertions/s.
```

VS

```
Finished in 0.088945s, 11.2429 runs/s, 44.9716 assertions/s.
```

#### 2: Using a Wrapper Client Object

In the previous example, we are stubbing methods directly on the
`TWITTER` object we created, which is an instance of the `Twitter::REST::Client`
from the twitter gem. Stubbing these methods is better than hitting the
API directly, but it still leaves us very reliant on the whims of the
twitter gem itself.

A common solution to this is to create a client class of our own which
wraps the 3rd-party twitter gem. That way we control the interface and
gain some flexibility against future changes in the upstream API.

For now we can just create a new class in our `models` directory (`lib`
might also be a common place). For now we only have one method that takes
one argument, so starting with a class method is probably ok. `app/models/twitter_client.rb`:

```
class TwitterClient
  def self.fetch_tweets(user)
    TWITTER.user_timeline(user)
  end
end
```

And now we can change the interface in our controller to use our new
client:

In `app/controllers/tweet_streams_controller.rb`:

```
def create
  @tweets = TwitterClient.fetch_tweets(params[:twitter_handle])
end
```

First load the app in the browser again to make sure it still works.
Then add another test and see if you can provide a stubbed implementation
for this new client which makes the test pass.

#### 3: Our Own Client Wrapper with a Mock Client

Discussion
- dependency injection
- ease of sharing test implementations

Example:

Dependency injection is the idea that all external dependencies for an
object should be able to be provided from the outside (and thus
interchanged at will). Ruby's flexible duck typing makes it a great
candidate for DI -- implement the right methods and you're done!

Let's look at changing our dummy twitter client to accept the external
client as an argument:

In `app/models/twitter_client.rb`:

```
class TwitterClient
  attr_reader :client

  def initialize(client=TWITTER)
    @client = client
  end

  def fetch_tweets(user)
    client.user_timeline(user)
  end

  def self.fetch_tweets(user)
    TWITTER.user_timeline(user)
  end
end
```

(Note we're leaving the class-method implementation in place for now;
this is redundant but it will be useful to see the options side by side)

Now in our controller, let's add a memoized reader method to use an
instance of our new and improved `TwitterClient`:

In `app/controllers/tweet_streams_controller.rb`:

```
class TweetStreamsController < ApplicationController
  attr_accessor :twitter_client

  def new
  end

  def create
    @tweets = twitter_client.fetch_tweets(params[:twitter_handle])
  end

  def twitter_client
    @twitter_client ||= TwitterClient.new
  end
end
```

For starters, let's add a stub implementation on this client just like
we did with the others. (HINT: you can access a controller's properties
in a controller test with `@controller`)

Once that's done, let's look at building out a true "Mock Client." The
reason we set up the global `TWITTER` client as an argument to our
instance of `TwitterClient` is that it allows us to provide any
alternative client at will. As long as the new client implements the
critical `#user_timeline` method which accepts 1 argument, they will
be completely interchangeable from the perspective of our
`TwitterClient`.

DISCUSSION: Fading ease of test implementation VS robustness /
flexibility

Let's look at a sample Mock Client implementation. For now we can just
add this at the bottom of our
`test/controllers/tweet_streams_controller_test.rb`:

```
class MockTwitterClient
  def user_timeline(user)
    [OpenStruct.new(:user => OpenStruct.new(:screen_name => "j3"), :text => "pizza")]
  end
end
```

now we can add another test, and this time we'll manually set the
`twitter_client` attribute of our controller to include a new
`TwitterClient` instance which uses our Mock:

In `test/controllers/tweet_streams_controller_test.rb`:

```
  test "fetches tweets on create with Mock client" do
    @controller.twitter_client = TwitterClient.new(MockTwitterClient.new)
    post :create, :twitter_handle => "j3"
    assert_response :success
    assert_not_nil assigns(:tweets)
    assert_select "li.tweet"
  end
```

The difference between these last 3 approaches may seem subtle, but it's
useful to recognize how we're moving along a gradient from
simple implementation to greater abstraction and control. These are toy
examples but the principles at work here can pay off big in a larger
application.

#### 4: Production Mocking with JSON Fixtures

The examples we've seen so far have been mostly ruby/application-layer
implementations. That is, we are creating stand-in ruby objects that are
"close enough" to the real thing for the purposes of our tests.

This approach has the benefit of being pretty easy to implement, but the
downside is it does add some more distance between our tests and the
real API. Additionally, if we were using a lot of methods on our client,
we can imagine how tedious it would become to manually build out stubs.

Generally the easiest way to get a big wad of realistic JSON is to pull
it from prod:


Here's an example gnarly curl command. Note these tokens are only authed
for a short period with the twitter api, so you will likely need to
re-validate with your own app: https://dev.twitter.com/rest/reference/get/statuses/user_timeline

```
curl --get 'https://api.twitter.com/1.1/statuses/user_timeline.json' --data 'count=2&screen_name=j3' --header 'Authorization: OAuth oauth_consumer_key="W94h9TI21dRmkuDKewew2gy2t", oauth_nonce="3ceaacc5f1559900b810269f6c96092e", oauth_signature="H%2FejncGPjgdn1lAggUjmoHuYBNc%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1418625983", oauth_version="1.0"' --verbose | pbcopy
```

Generally when working with these, I dump the text into a JSON fixture
file in the `test/fixtures` directory. e.g.:
`test/fixtures/tweets_response.json`.

The benefit of this approach is that it's real data. Granted it is
static and we'll have to update it ourselves if we want the data to
change in the future, but it's going to give us a much more realistict
representation of the production API than our previous manual stubs
will.

Let's read this data and use it in our controller test. For starters I'd
like to pull in the `hashie` gem because it will make dealing with this
big blob of JSON easier.

In `Gemfile`:

```
gem "hashie"
```

Now let's add some code in our controller test to pull sample tweet data
out of the fixture we just made:

In `test/controllers/tweet_streams_controller_test.rb`

```
def tweet_data
  JSON.parse(File.read(File.join(Rails.root, "test", "fixtures", "tweets_response.json"))).map do |hash|
    Hashie::Mash.new(hash)
  end
end
```

This looks a little gnarly, so let's walk through what it's doing:

1. Create a path to our fixture file using `File.join` and `Rails.root`
2. Read the contents of the file using `File.read` (remember `File.read`
   returns a string)
3. Parse that string as JSON, which will yield an Array of Hashes
4. Map over the array of Hashes and turn them into `Hashie::Mashes`,
   which will let us use dot-notation to access the various properties

Phew!

Now let's look at using this data in our test just as we did in previous
examples:

```
  test "fetches tweets with prod data" do
    TWITTER.expects(:user_timeline).with("j3").returns(tweet_data)
    post :create, :twitter_handle => "j3"
    assert_response :success
    assert_not_nil assigns(:tweets)
    assert_select "li.tweet"
  end
```

Notice we're back to stubbing on the global `TWITTER` client -- just an
example of how the different approaches we've seen can be combined
depending on your needs.

#### 5: Transit-Layer mocking with VCR or Webmock

Finally let's look at a more "whole-hog" solution for mocking 3rd party
API data. VCR and Webmock are tools designed to help us intercept
network traffic at a relatively low level -- when we are actually
sending requests and receiving data via HTTP.

Advantages:
- Exercises our entire application stack with near-produciton data
- Easy to set up, little internal (to our app) code required
- Easy to capture large or otherwise sophisticated API responses

Disadvantages:
- Easy to get stuck on stale / out-of-date data
- Hoover vacuum effect: will happily suck up any requests going in/out,
  not just the ones you are thinking of
- Can be more difficult to debug mysterious responses
- Less refined/controlled -- bit of a "shotgun" approach to API testing

Let's see how it looks in our app:

in `Gemfile`:

```
  gem "vcr"
```

Now let's add some basic configuration in `test/test_helper.rb`:

```
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :serialize_with => :json }
end
```


Some people are very strongly opinionated about these tools. They are
certainly powerful. Used well they can be incredibly usefull, but be
careful not to shoot your foot off.

### Additional Points

- blocking http traffic with webmock

## Key Points

* Inject the client so you can wire it up appropriately for the given context
* You can then inject a mock version of the gem
* Or mock it out with webmock
* Or create a fake service that you direct the client to instead of the real one.

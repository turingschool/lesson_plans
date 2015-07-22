---
title: Mocking Apis
length: 120
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

The best solution to this problem is usually to "Mock" the API, or replace it
with a stripped-down implementation which runs only on our machine. This
let's us regain better control over our test environment, and more easily
control the responses we see from the API.

In this lesson, we'll look at a few approaches to Mocking external APIs and cover the pros and
cons of each.

### Mocking APIs: Desirable Factors:

If we could imagine our ideal setup for testing against external
APIs, what would it look like?

Offhand, we might like it to have some of these traits:

- Closeness to production / reality
- Speed
- Reliability / Consistency
- Customizability
- Ease of implementation (when writing the test)

Approaches:

1. Client stubbing - Stubbing methods on provided (or our own wrapper) client
2. Transit-layer mocking - WebMock with manual JSON fixtures
3. Transit-layer mocking - VCR with automatic HTTP fixtures

### Setup:

For this lesson, we'll use this simple
[twitter display app](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/mocking_apis_v2.markdown)
as a starting point.

Visit the application's README and follow the included set up instructions to get started.
When you are done, you should have a simple rails app running which allows you to enter a user's
Twitter handle in a form and see a simple list of their recent tweets on the page.

### Step 1 - Basic Testing Experiments

Currently the application has no tests, but we'd like to fix that. 
Let's start with a new controller test to validate the functionality
of the `TweetStreamsController`.

Create a new file, `test/controllers/tweet_streams_controller_test.rb`, and flush it out
with some basic examples:

```ruby
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

What about if you turn your wifi connection off?

Without a network connection our test is doomed to fail.
Our application connects to the twitter API, and there's currently no infrastructure
in place to prevent this from happening in the test suite.

Fortunately for us, the Twitter API is relatively fast, but things will still
slow down pretty quickly if we have a lot of tests hitting it.

Additionally, we'd like the tests to work offline anyway (imagine a CI environment, or
simply a situation when you don't have network access). And to top it off, currently our
test suite runs will count against the quota of API requests Twitter allows us under
their [Rate Limits](can also imagine things getting pretty slow if we had a lot of these.
).

What we'd like is to find a way to "deactivate" the API usage in our test suite, but still
maintain enough of the essential functionality that the app can continue to work.

This practice is often referred to as "Mocking" or "Stubbing" the external API -- We will
be replacing the existing (real) implementation with various "fake" implementations that
get us close enough to the real thing without requiring network access.

Onward to mocking!

### Step 2: Stubbing methods on provided client

Perhaps the easiest way to stub out our service connection is by setting
individual expectations on our client object. This gives us good
granularity, is quick-and-dirty, and is usually not bad for small or
isolated cases.

"Stubbing" in this sense of the word will actually involve overwriting
the behavior of various Ruby objects in our system. Partly, we are taking
advantage of the looseness of Ruby's "Duck Typing" -- an object doesn't
have to care if a method came from a real object or a stub, as long
as it works.

A useful tool for doing mocking and stubbing in Ruby is the [Mocha Gem](https://github.com/freerange/mocha).
It gives us a flexible interface for mocking and stubbing methods
on arbitrary ruby objects.

(Alternatively, if you are using rspec, the included [RSpec Mocks](https://www.relishapp.com/rspec/rspec-mocks/docs)
Library is a good choice).

Let's add Mocha to our `Gemfile`:

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
arguments and `#returns` to specify return values.

__Demo: stubbing followers count__

Instructor shows use of stubs to replace the "followers count" functionality.

([Example Implementation](https://github.com/turingschool-examples/twitter-demo/commit/f307dc506b142d5414fe89180e0a29585f2621d3))

__Your Turn: stubbing user timeline__

Use the same techniques to replace the "user timeline" functionality within our
TweetStreamsController.

Remember:

* Stubbing is all about method and object interfaces. Think about what objects are
being returned by our twitter client, and what methods they need to implement in order to be "valid".
* Flexible objects like `OpenStruct` or `Hashie::Mash` often
make versatile dummy objects for test responses
* The [Mocha Docs](http://gofreerange.com/mocha/docs/) are a useful
resource for understanding the library

Notice the time difference between our un-stubbed and stubbed versions:

```
Finished in 1.132931s, 0.8827 runs/s, 2.6480 assertions/s.
```

VS

```
Finished in 0.088945s, 11.2429 runs/s, 44.9716 assertions/s.
```

DISCUSSION: Ease of use / Flexibility Criteria

* What are the advantages of this approach?
* How easy is it to use in the tests?
* How flexible (if we want to change the data, etc)

#### 2: Production Mocking with JSON Fixtures

The last example provided a ruby/application-layer solution.
That is, we are creating or modifying stand-in ruby objects (using mocking) that are
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

_Discussion_: Some people are very strongly opinionated about these tools. They are
certainly powerful. Used well, they can be very useful, but be
careful not to shoot your foot off.

Let's see how it looks in our app:

in `Gemfile`:

```ruby
group :test do
  gem "vcr"
  gem "webmock"
end
```

Now let's add some basic configuration in `test/test_helper.rb`:

```
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :serialize_with => :json }
end
```

These options tell VCR:

1. Where to store its cassettes
2. Which HTTP Mocking library to use -- webmock is a fine option
3. What format to use when serializing the cassettes; the default here
   is actually "marshal", but I like to override with json because it
makes the cassettes human-readable, which aids in debugging

Now that we have VCR set up, let's go to our test:

In `test/controllers/tweet_streams_controller_test.rb`

```
  test "fetches tweets avéc VCR" do
    VCR.use_cassette("j3_tweets") do
      post :create, :twitter_handle => "j3"
      assert_response :success
      assert_not_nil assigns(:tweets)
      assert_select "li.tweet"
    end
  end
```

The `VCR.use_cassette` method tells VCR to record any http requests that
occur during the provided block. More importantly, on subsequent test
runs, it will play back everything it records, so we get a facimile of
the original HTTP responses.

Run this test -- it should still pass. Run it again and see that on
subsequent runs, the tests are much faster. This is because we're no
longer hitting the real API, but rather slurping recorded data out of
our VCR cassette.

#### Additional Points
- blocking http traffic with webmock


#### Recap:

As we have seen there's quite a lot of approaches we can take to mocking
3rd party APIs in our test suite. Ultimately the options are limited
only by your creativity and willingness to experiment with ruby. The
general theme is that different approaches have different costs and
benefits, and generally tradeoff along several axes such as ease-of-use
vs. thoroughness, flexibility vs. realism, etc. It's up to you as the
developer to assess your needs in a given case and come up with the
right approach.



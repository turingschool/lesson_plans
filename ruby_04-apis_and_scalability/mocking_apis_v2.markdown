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
2. Production Data - Stubbing the client with manual JSON fixtures
3. Transit-layer mocking - VCR with automatic HTTP fixtures

### Setup:

For this lesson, we'll use this simple
[twitter display app](https://github.com/turingschool-examples/twitter-demo)
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

### Step 3: Production Mocking with JSON Fixtures

The last example provided a ruby/application-layer solution to our
external service dependency problem. That is, we modified our existing
ruby objects (in this case, an instance of `Twitter::REST::Client`)
to provide fake functionality which is "close enough" to the real thing for the purposes of our tests.

This approach has the benefit of being pretty easy to implement, but the
downside is it does add some more distance between our tests and the
real API. How can we know the data we are providing is a realistic representation
of the real data from the API?

Additionally, if we were using a lot of methods on our client,
we can imagine how tedious it would become to manually build out stubs.

Generally the easiest way to generate a realistic representation of a
large, complicated JSON response is...to pull it from production!
Fortunately, Twitter provides a pretty handy [API Console](https://dev.twitter.com/rest/tools/console)
tool which allows us to interact with it's API from the browser.

We can use this tool to fetch data from the API and store it in our tests
for future use.

__Demo: Working with Twitter API Console__

(Instructor shows basics of interacting with the console, and shows how to use it to
generate a sample request for the user timeline)

Generally when working with these, I dump the text into a JSON fixture
file in the `test/fixtures` directory. e.g.:
`test/fixtures/tweets_response.json`.

The benefit of this approach is that it's real data. Granted it is
static and we'll have to update it ourselves if we want the data to
change in the future, but it's going to give us a much more realistic
representation of the production API than our previous manual stubs
will.

In a moment, we'll read this data and use it in our controller test.
Additionaly, we'll use the `hashie` gem. [Hashie](https://github.com/intridea/hashie)
is a library for turning nested ruby hashes into Struct-like
objects. It's a handy way to turn a big blob of JSON into a more
"object-like" structure that we can use in our code.


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

This is a little gnarly, so let's walk through what it's doing:

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
    @controller.twitter_client.expects(:user_timeline).with("j3").returns(tweet_data)
    post :create, :twitter_handle => "j3"
    assert_response :success
    assert_not_nil assigns(:tweets)
    assert_select "li.tweet"
  end
```

([Example Implementation](https://github.com/turingschool-examples/twitter-demo/commit/4e15659afd9da4ab44d184887272cdeaf1df3f7e))

__Your Turn: Production User Data__

See if you can follow this pattern to:

1. Use the Twitter API console to fetch a sample User response
2. Pull the JSON from this response into a static fixture file
3. Read that JSON into a Hashie::Mash in your test, and use
this in place of the `#user` method on our twitter client

### Step 4: Transit-Layer mocking with VCR and Webmock

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
  c.before_record do |r|
    r.request.headers.delete("Authorization")
  end
end
```

These options tell VCR:

1. Where to store its cassettes
2. Which HTTP Mocking library to use -- webmock is a fine option
3. What format to use when serializing the cassettes; the default here
is actually "marshal", but I like to override with json because it
makes the cassettes human-readable, which aids in debugging
4. Finally, we tell VCR to delete the "Authorization" header when it
saves a cassette. This is important for keeping our API tokens
out of our codebase

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
runs, it will play back everything it records, so we get a facsimile of
the original HTTP responses.

Run this test -- it should still pass, but will probably be slightly slow.

Run it again and see that on
subsequent runs, the tests are much faster. This is because we're no
longer hitting the real API, but rather slurping recorded data out of
our VCR cassette.

([Example Implementation](https://github.com/turingschool-examples/twitter-demo/commit/41fc407ea7e14209dd1caba3371be7e094c1758f))

### Recap:

As we have seen are several approaches we can take to mocking
3rd party APIs in our test suite. Ultimately the options are limited
only by your creativity and willingness to experiment with ruby. The
general theme is that different approaches have different costs and
benefits, and generally tradeoff along several axes such as ease-of-use
vs. thoroughness, flexibility vs. realism, etc. It's up to you as the
developer to assess your needs in a given case and come up with the
right approach.

### Addendum: VCR with OAuth

VCR works great in the general case, especially if you're just consuming
an external resource anonymously. But sometimes we need to incorporate
a more robust authentication scheme, especially if we're working
with a resource that requires authentication with OAuth.

Let's consider some of the issues this imposes on our test fixtures:

* We need to keep our OAuth tokens out of VCR cassettes, since these
get committed to (presumably public) source control
* We need to use OmniAuth stubs to allow us to log in with fake user
accounts (as oppposed to using real accounts in tests)
* However, we still need a real OAuth token for this user, otherwise
the API won't allow our requests and we won't be able to record VCR
cassettes.

Fortunately, we have a few solutions available to us for these issues:

* We can use VCR's `before_record` hook to "sanitize"
our cassette data
* We can use OAuth credentials from a real user we
create in development as our credentials from test
* We can add these sample credentials to our `application.yml`
and source them from the app's `ENV` so that they stay out of
our source code

__Workshop__

Let's work through an example of testing in this way, using [https://github.com/turingschool-examples/oauth-workshop](https://github.com/turingschool-examples/oauth-workshop) as our
starting point.

Start by following the Setup instructions on that repository. You will need to
create a Twitter app account if you don't have one already.

__Step 1 - Test Dependencies__

We'll be using VCR again, so let's set it up just as we did in the previous
example:

in `Gemfile`:

```ruby
group :test do
  gem "vcr"
  gem "webmock"
end
```

in `test/test_helper.rb`:

```
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :serialize_with => :json }
  c.before_record do |r|
    r.request.headers.delete("Authorization")
  end
end
```

__Step 2 - A Real Oauth Token__

For starters, we need a real OAuth token and token secret.
The best way to generate one of these is to boot your app in development mode
and go through the login process.

Upon receiving the OAuth callback from twitter, our app will create
a new user record in the database that includes the credentials
we are looking for.

To capture this information,

1. Open a rails console
2. Find the last user (presumably the one we just created)
3. Grab that user's `oauth_token` and `oauth_token_secret`
4. Add these to your `config/application.yml` file under the `test`
environment. I call them `SAMPLE_OAUTH_TOKEN` and `SAMPLE_OAUTH_TOKEN_SECRET`, respectively.

__Step 3 - Using our Sample OAuth Tokens in Test__

Let's add a new test that verifies the basic functionality of our app.
Add the following code to the appropriate portions of the app:

__in `app/models/user.rb`:__

```ruby
  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = oauth_token
      config.access_token_secret = oauth_token_secret
    end
  end

  def twitter_timeline
    twitter_client.home_timeline
  end
end
```

__in `app/views/welcome/index.html.erb`:__

```ruby
<% if current_user %>
  <h3>Your Twitter Timeline!</h3>
  <ul>
  <% current_user.twitter_timeline.each do |tweet| %>
    <li class="tweet">
      <p><%= distance_of_time_in_words(Time.now, tweet.created_at) %> ago, <%= tweet.user.screen_name %> said:</p>
      <p><%= tweet.text %></p>
    </li>
  <% end %>
  </ul>
<% end %>
```

__in `test/integration/user_logs_in_with_twitter_test.rb`:__

```ruby
  test "logging in" do
    VCR.use_cassette("user-timeline") do
      visit "/"
      assert_equal 200, page.status_code
      click_link "login"
      assert_equal "/", current_path
      assert page.has_content?("Horace")
      assert page.has_link?("logout")
      assert page.has_css?(".tweet")
    end
  end

  def stub_omniauth
    # first, set OmniAuth to run in test mode
    OmniAuth.config.test_mode = true
    # then, provide a set of fake oauth data that
    # omniauth will use when a user tries to authenticate:
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      extra: {
        raw_info: {
          user_id: "1234",
          name: "Horace",
          screen_name: "worace",
        }
      },
      credentials: {
        token: ENV["SAMPLE_OAUTH_TOKEN"],
        secret: ENV["SAMPLE_OAUTH_TOKEN_SECRET"]
      }
    })
  end
```

Notice that in our `stub_omniauth` method, we're now sourcing our
OAuth tokens from the environment, rather than hardcoding them.

And since these tokens get sourced into our environment via
the `config/application.yml` file, which does not get committed to source
control, we can keep the tokens out of our codebase entirely.

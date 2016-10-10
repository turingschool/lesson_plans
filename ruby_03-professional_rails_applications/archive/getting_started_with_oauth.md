---
title: Getting Started with OAuth
length: 120
tags: rails, security, authentication, OAuth
---

## Notes to Instructor

- Make sure to cover and explain `Omniauth.mock_auth` for testing toward the end of the lesson. There has been a good amount of confusion and time lost with students related to a lack of understanding on the subject.
- This lesson can also be taught with a whole new rails app, in case you want more practice starting apps from scratch. Just check the history.

## Prework

Start by watching this [video](https://www.youtube.com/watch?v=tFYrq3d54Dc). Which explains the oauth process at a high level.

Then watch this [video](https://vimeo.com/173947281) which actually demonstrates the process live with Github.

Then draw a diagram of the OAuth handshaking process that takes place between your app and and an external API (Twitter, Facebook, Github etc)

## Tutorial: Getting Started With OAuth

Authentication is a ubiquitous problem in web applications. So
ubiquitous, in fact, that we might be inclined to think of ways
to "outsource" the problem of authentication to an external provider.

Solving these problems is one of the major focuses of OAuth. Using OAuth,
we can allow users to authenticate with our app via a 3rd-party service
provider (often a large online or social media service).

In this tutorial, we'll discuss the ideas behind OAuth, and walk
through an example of implementing it in a project.

### Benefits of OAuth

There are a lot of potential advantages to outsourcing our Authentication
via Oauth.

__Removing Security Complexities__

Authentication is a tricky problem with a high cost of failure. It can often be tedious
to re-implement on one application after another, but any small mistake
can still have dire consequences.

With OAuth, the user never has to provide sensitive credentials to our application.
Instead, they send these details to the OAuth provider (e.g. Google), who sends
us an authentication token and some basic details on the user's behalf.

Since the provider stores the user's actual credentials, we no longer have to worry about the
security considerations of storing and encrypting user passwords.

__Service Authorization / Authentication__

Another benefit of having users authenticate with OAuth is that it gives us
authenticated access (on their behalf) to any APIs available from the OAuth
provider. API Providers frequently limit your access to their platform, and
having a user authenticate with the provider can get you access to more
resources or to an additional volume of requests.

This can be a big help with API rate limiting, for example, since each authenticated user will usually
be allowed their own supply of requests.

### Disadvantages of OAuth

Like everything in technology, using OAuth isn't without tradeoffs. Often the benefits
outweigh the costs, but let's look at a few things to be aware of.

__Loss of Control__

With OAuth, we're no longer entirely in control of the user's login process. We
might like to collect additional information in the signup process that the
3rd party doesn't provide to us, or design our own onboarding flow, but with OAuth
we'll be locked into whatever our provider makes available.

__Account Requirement__

This one may seem obvious, but if we're using OAuth with twitter, then our users
will be required to have a twitter account in order to use the app. Many services
are so ubiquitous these days that this may not be a large disadvantage, but it is
something to be aware of.

Particularly, we may want to consider our target userbase when determining which
OAuth provider to rely on. If your app is a hip social network for tweens, requiring
users to log in with LinkedIn may not be the best choice.

__Data Duplication__

One challenge OAuth imposes on our application design is deciding how much data
to copy from the external service and where to store it. Do we duplicate the user's
basic profile info into a table in our own DB? Or just read it from the API whenever
we need it? These types of dilemmas are very common when dealing with remote data, and
OAuth data is no exception.

## Workshop -- Implementing OAuth with Twitter

Let's get some practice with OAuth by implementing it in a simple rails project.

### Step 1 - Registering with the Provider

For this exercise, we'll be authenticating with Twitter. As a first step,
we need to register an application with Twitter, which will allow us
to obtain the credentials we'll need in order for Twitter to authenticate
users on our behalf.

__Note:__ During the registration process, you may be required to verify your account
by adding a mobile phone number. Follow the steps outlined [here](https://support.twitter.com/articles/110250-adding-your-mobile-number-to-your-account-via-web) to do this.

To register a new application, follow these steps:

1. Make sure you're logged in to Twitter
2. Visit [https://apps.twitter.com/](https://apps.twitter.com/)
3. Click the button for "Register New App"
4. For description you can enter whatever you want, but for "Website", you'll want
to enter "http://127.0.0.1:3000", and for "Callback URL" "http://127.0.0.1:3000/auth/twitter/callback"
5. You should end up on a url like "https://apps.twitter.com/app/my-app-id". Save this link
as we'll want to use the credentials from it later in the tutorial.

### Step 2 - Setting up our Application

Let's add "Sign in with Twitter" to our favorite rails app, Storedom:

```
git clone https://github.com/turingschool-examples/storedom.git oauth-workshop
cd oauth-workshop
bundle
rake db:setup
```

### Step 3 - Adding Omniauth

OmniAuth is a popular ruby library for integrating OAuth into a rails application,
and we'll be using it in our app to connect with Twitter's OAuth service.

In fact we'll actually be using 2 pieces here: the `omniauth` core library which is implemented
as a Rack Middleware (an intermediate "layer" in our application stack), and the `omniauth-twitter`
library, which adds specific provider support for Twitter.

One great thing about OAuth is that it's open for extensibility -- anyone who wants to implement
the protocol on their own servers can become a provider. For this reason the OmniAuth gem is designed
to accept provider-specific "strategies", such as the "Twitter Strategy" which we'll be using.

`omniauth` is a dependency of the `omniauth-twitter` library, so we can get started by just adding this gem
to our `Gemfile`:

```ruby
# In Gemfile
gem "omniauth-twitter"
```

Then `bundle` your application.

### Step 4 - Configuring OmniAuth

Now that we have omniauth installed, we need to configure it to recognize our specific application.
We'll do this by telling OmniAuth to use the credentials we acquired from twitter when we registered
our application in Step 1.

1. Go back to your twitter application page and click on the tab labeled "Keys and Access Tokens".
2. Retrieve the 2 keys labeled "Consumer Key (API Key)" and "Consumer Secret (API Secret)", respectively.
3. Create a new `initializer` in your application at `config/initializers/omniauth.rb`
4. Configure OmniAuth in the initializer by adding the following lines:

```ruby
# in config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "YOUR_CONSUMER_API_KEY", "YOUR_CONSUMER_API_SECRET"
end
```

Make sure you restart your application after adding this, since initializers only get run
on application startup.

__Note__ that you should extract these values as environment-provided keys before deploying your
application or committing it to version control.

### Step 5 - Adding our "Sign in with Twitter" button

We have our basic omniauth configuration in place, but so far there's not much to do with it. Let's fix this by filling in routing and adding our button:

- Add a `get` route for `/auth/twitter` (this is a special route used by omniauth) and specify `:twitter_login` as the value for the `:as` key. You don't need to specify the `:to` key.
- Add a "Login" link to `app/views/layouts/_navbar.html.erb` which points to the `twitter_login_path` we just established.
  - Refer to the [bootstrap docs to add to the navbar](https://getbootstrap.com/components/#navbar)

Test your work by loading the root path. The login link should now be in the navbar.
Now click the login link. If your application is configured correctly, you should be taken off to a twitter-hosted
url and shown the standard "Sign in with Twitter" screen.

Accept the login and see what happens.

### Step 6 - Handling the OAuth Callback

OAuth uses a callback-redirect system to allow communication between the provider
and our application. When we want to authenticate a user with twitter, we will redirect them
to a special twitter URL used for this purpose (actually OmniAuth will do this for us, but this
is what's going on under the covers).

Once the user has approved our application, Twitter will redirect the user back to our application.
We're currently _not_ handling this "callback" request, which is why we got a routing error after
we logged in with twitter in the previous example.

Let's add a route to handle that now. But where do we put it? Conceptually, the purpose of this
request is to log the user in to our application. Twitter has said they are OK, so we'll need
to cookie them in some way so that we can identify them on future requests.

Where have we put that type of logic in the past? That's right -- `SessionsController#create`.
Set up a controller and route to handle this request:

1. Create a `SessionsController` with a `create` action
2. Add a route that maps a `get` request for `/auth/twitter/callback` to `sessions#create`

Return to the root page and click the "login" link again. You'll likely get an `ActionView::Template` error
since we haven't actually filled in any view or route handling for this endpoint yet.

### Step 7 - Capturing User Data from the OAuth Callback

We can now see that users are getting back to our application after authenticating
with twitter, but there's still a big question we haven't solved -- how do we know
who the user is when they arrive?

We mentioned earlier that one of the important points about OAuth is that providers
can send us some basic data about the user once they've authenticated. This is actually
done by embedding data in the request headers, and fortunately omniauth gives
us an easy way to access this data.

Let's update our `SessionsController#create` action with the following implementation:

```ruby
# in app/controllers/sessions_controller.rb
def create
  render text: request.env["omniauth.auth"].inspect
end
```

Calling `render :text` from a controller does just what it sounds like: renders raw text as the response
instead of the standard html template.

This can be a handy debugging technique when we just want to inspect some data -- in this case the auth data
that twitter sent back to us packaged up under the `omniauth.auth` header.

If we look closely we can see that this `omniauth.auth` object is a hash-like data structure, and embedded within it are
a handful of user details, including their screen_name, follower count, location, name, user id (on twitter),
as well as an oauth token, which can be used to make authenticated requests to twitter on the user's
behalf.

So what do we do with this information? Remember part of the purpose of using OAuth is that this
flow replaces our standard user "sign up" flow. To that end, we'd like to capture
these user details and store them somewhere. Typically this would be done in
a database, although we could also imagine saving the information in a cookie or some
other storage medium.

Now that we've identified the mechanism by which Twitter sends us information about the
authenticated user, in the next step we'll look at how we might save this into our own
database.

### Step 8 - Adding oAuth to the User model

Assuming we'd like to save our OAuth user details in the DB, let's consider the
new user information we'd like to save to our new `User` model:

* `screen_name`
* `user_id` (by convention, we often save this into a column called `uid`)
* `oauth_token`
* `oauth_token_secret`

We could grab more information out of the omniauth auth hash, but this is probably
enough to start.

Let's generate a user model with columns to store all this new information:

```
rails g migration AddOAuthFieldsToUser screen_name:string uid:string oauth_token:string oauth_token_secret:string
rake db:migrate
```

Notice that we're saving all this information as strings, even the `uid` which often takes
the form of an integer. Storing this field as a string is relatively conventional,
since it leaves us the flexibility to potentially handle more providers in the future
whose `uid` might not be formatted as an integer.

### Step 9 - Creating Users

So what does it mean when a user arrives at our OAuth callback url (i.e. `SessionsController#create`).

Well it actually could mean one of 2 things: either it is a new user on their
first visit to the site _or_ it is a returning user who had been logged out
somehow.

When managing our own user signup / auth flow, we typically have separate paths for new users
and returning ones. But with OAuth everyone goes through the same path, since everyone needs
to pass through the external OAuth provider.

Because of this, let's consider what we need to do in our `Sessions#create` action:

1. If the user does not exist, we should create a record for them, and cookie them so
they will remain logged in.
2. If the user does exist, we should recognize their existing record, and cookie them
with that record so they will remain logged in.

So how do we know if the user exists? The key lies in the `omniauth.auth` information
that twitter sent to us on the callback redirect. Fortunately they include an
identifying `user_id`, which will be unique among twitter's system. Thus if
there is an existing user in the DB with the provided twitter `user_id`, we
can assume it is the same user, and re-use that record.

Otherwise we'll want to create a new record with all the appropriate information.

Let's define a method to handle all of this logic in our `User` model:


```ruby
# in app/models/user.rb

def self.from_omniauth(auth_info)
  where(uid: auth_info[:uid]).first_or_create do |new_user|
    new_user.uid                = auth_info.uid
    new_user.name               = auth_info.extra.raw_info.name
    new_user.screen_name        = auth_info.extra.raw_info.screen_name
    new_user.oauth_token        = auth_info.credentials.token
    new_user.oauth_token_secret = auth_info.credentials.secret
  end
end
```

Let's walk through what we're doing here:

1. Take in the provided omniauth authentication info
2. Read the `user_id` from the `auth_info`. If a user already exists with the
`uid` value of that `user_id`, then we've found who we're looking for,
and can return her.
3. Otherwise, we need to create this user. The next section parses
out the various pieces of information needed to create a user from the
auth hash.

Now that we have this in place, let's look at using it from
our `SessionsController`:

```ruby
# in app/controllers/sessions_controller.rb
  def create
    if user = User.from_omniauth(request.env["omniauth.auth"])
      session[:user_id] = user.id
    end
    redirect_to root_path
  end
```

Here we generate a user from the provided omniauth information.
Assuming one is created, we cookie them so we can identify them on future requests.
Then we simply redirect them. All in one signup/login flow.

Return to the root of your app once more, and click the login button.
If all goes well, this time you will end up back on the root page!

We so far have no visible evidence that the process works, but we will
fix that shortly.

### Step 10 - Identifying Logged In Users

Now that we've created a user and (hopefully) cookied them appropriately,
let's look at displaying some feedback that this whole process actually
worked.

Let's start by adding a familial `current_user` helper method in our
`ApplicationController`:

```ruby
# in app/controllers/application_controller.rb
helper_method :current_user

def current_user
  @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
end
```

Now let's use this back in our welcome template:

```ruby
<%# in app/views/layouts/_navbar.html.erb %>

<% if current_user %>
  Hello, <%= current_user.name %>
<% else %>
  <%= link_to "Sign in with Twitter", twitter_login_path %>
<% end %>
```

Refresh the page. If all goes well, you should see a small message welcoming you
to our very simple (but thoroughly OAuth-ed) site.

### Step 11 - Logging Out

As a simple enhancement, let's also add a link that let's our users log out once logged in.

First, add a route which connects a `delete` request to `/logout` to `SessionsController#destroy`
and name it as `logout`.

Then, update your `app/views/layouts/_navbar.html.erb` template to include the logout link:

```ruby
<% if current_user %>
  hello, <%= current_user.name %>.
  <%= link_to "Logout", logout_path, method: :delete %>
<% else %>
  <%= link_to "Sign in with Twitter", twitter_login_path %>
<% end %>
```

Finally, add a `#destroy` method to your `SessionsController`, which clears
the user's session and redirects them back to the root path.

At this point, you should have a basic login/logout system working with OAuth!

### Step 12 - Testing

One thing we haven't addressed yet is testing. Now that we have a basic idea of what
the OAuth process entails, let's discuss some topics to incorporate it into our application's
test suite.

The basic challenge here is that OAuth does add some additional complexity into our
application. Specifically, it adds a network dependency on an external service.
When a user wants to log in, we have to bounce them to the external provider's auth
infrastructure and back.

This external network dependency is especially frustrating in our test suite. We'd
ideally like our test suite to run quickly and in total isolation, which using a real
OAuth connection would make relatively impossible.

In addition, we'd prefer not to need to create real Twitter (or whatever service provider
we are using) accounts that will be used in our test suite.

In short, for testing purposes, we'd like to "mock out" the OAuth process. Fortunately
OmniAuth includes some useful tools for doing this. In this section, we'll look at
using OmniAuth's built-in mocking facilities to fake out a Twitter user in our
test suite.

### Step 13 - Testing Setup

First, let's add some basic tools to our project. In your `Gemfile`, in the development
and test groups, add the `capybara` gem:

```ruby
# in Gemfile
group :development, :test do
  gem 'capybara'
end
```

and bundle.

Next, let's make a new integration test file called `user_logs_in_with_twitter_test.rb`.

Fill it with some basic test set up:

```ruby
# in test/integration/user_logs_in_with_twitter_test.rb
require "test_helper"
class UserLogsInWithTwitterTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  def setup
    Capybara.app = OauthWorkshop::Application
  end

  test "logging in" do
    visit "/"
    assert_equal 200, page.status_code
  end
end
```

__Note__ that the name of your application may be different if you used a different
name when you generated it. You can find the proper name to use here by looking
in `config/application.rb` for the name of the `module` which wraps your
Rails application definition.

Run your tests with `rake` and make sure you have a single passing test,
indicating that our test infrastructure is configured correctly.

### Step 14 - Filling in User Flow

Next let's start to fill in the details for this test. Consider the user's flow
through our app:

* User visits the homepage
* User clicks the login link
* User should be redirected via twitter Oauth flow (which we will be stubbing out)
* User should end up on the homepage again
* User should now see their name displayed, along with a logout link

Let's fill in some test code to make this happen:

```ruby
# in test/integration/user_logs_in_with_twitter_test.rb
require "test_helper"
class UserLogsInWithTwitterTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  def setup
    Capybara.app = OauthWorkshop::Application
  end

  test "logging in" do
    visit "/"
    assert_equal 200, page.status_code
    click_link "Sign in with Twitter"
    assert_equal "/", current_path
    assert page.has_content?("Horace")
    assert page.has_link?("Logout")
  end
end
```

Run this test and see what happens. You should get
a routing error similar to:

```
ActionController::RoutingError: No route matches [GET] "/oauth/authenticate"
```

This is because by default, our OAuth middleware is disabled in test mode.
As we said before, we need to provide a "mock" implementation for our test
suite, so that the tests don't need the real OAuth implementation in order to
pass.

### Step 15 - Using OmniAuth.mock_auth to stub OAuth details

We can do this using the `mock_auth` method on `OmniAuth.config`. Here's
an example of how to do this for twitter:

```ruby
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
          screen_name: "worace"
        }
      },
      credentials: {
        token: "pizza",
        secret: "secretpizza"
      }
    })
  end
```

The config we are providing looks a bit complicated at first, but it's just
a nested hash with the proper structure for containing the data we need.

So how do we know what data we need? If we look closely, we'll see that the
structure we're using here mirrors what we were consuming from the `auth_data`
OmniAuth provided us in our `User.from_omniauth` method.

This process can be a bit tedious, since the shape of the data will often vary
from provider to provider. But the easiest way to figure out what you need is to
capture a real auth_hash in development, investigate its structure, and determine
which keys and values you need to provide.

### Step 16 - Putting the Full Test Together

Now that we have a method for configuring OmniAuth with test data, let's invoke that
in our test's `setup` method. Here's the whole test file that we have up to now:

```ruby
require "test_helper"
class UserLogsInWithTwitterTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  def setup
    Capybara.app = Storedom::Application
    stub_omniauth
  end

  test "logging in" do
    visit "/"
    assert_equal 200, page.status_code
    click_link "login"
    assert_equal "/", current_path
    assert page.has_content?("Horace")
    assert page.has_link?("logout")
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
          uid: "1234",
          name: "Horace",
          screen_name: "worace",
        }
      },
      credentials: {
        token: "pizza",
        secret: "secretpizza"
      }
    })
  end
end
```

Run your tests with `rake`. It should pass! If you're still getting failures,
double check the following:

* Make sure you're calling your `stub_omniauth` method from your test's `setup` method
* Make sure the structure of the data you're providing in the `OmniAuth::AuthHash`
matches what your `User.from_omniauth` method is consuming from twitter.

You now have a model for basic integration testing using OmniAuth.

Finally, you can read more about integration testing with omniauth [here](https://github.com/intridea/omniauth/wiki/Integration-Testing).

## Wrapup

In this tutorial we've covered the basics of setting up a rails app that
authenticates with OAuth. The steps included:

* Setting up an application account with an external OAuth provider
* Using the OmniAuth gem to incorporate the OAuth protocol flow into your application
* Handling the OAuth callback and capturing identification details in our
own application's database
* Testing OAuth using OmniAuth's provided mocking system

Now that you understand the fundamentals of working with OAuth, you should be
able to extend this knowledge to your own applications or to working with different
OAuth providers.

## Resources for Further Study

* [OAuth](http://en.wikipedia.org/wiki/OAuth) on Wikipedia
* [Understanding OAuth](http://lifehacker.com/5918086/understanding-oauth-what-happens-when-you-log-into-a-site-with-google-twitter-or-facebook) on LifeHacker
* [OmniAuth](https://github.com/intridea/omniauth) for integration in Ruby web apps
* [Oauth 1.0 Diagram (from MashApe's oauth bible)](http://puu.sh/2pJ4y)
* [Oauth Bible](http://oauthbible.com/) - lots of in-depth info about different oauth versions and components
* [Edge Cases Podcast #36](http://edgecasesshow.com/036-zenos-paradox-of-authentication.html) - Good in-depth discussion of the evolution of Oauth and the pros and cons of using it.
* [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) -- Oauth provider gem
* OmniAuth core API documentation: https://github.com/intridea/omniauth
* OmniAuth wiki: https://github.com/intridea/omniauth/wiki
* A Devise and OmniAuth powered Single-Sign-On implementation: https://github.com/joshsoftware/sso-devise-omniauth-provider
* [RailsCast on combining Devise and OmniAuth](http://railscasts.com/episodes/235-devise-and-omniauth-revised)

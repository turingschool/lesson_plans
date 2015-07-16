---
title: Getting Started with OAuth
length: 90
tags: rails, security, authentication, OAuth
---

## Warmup

Begin by answering the following questions:

1. Why do we use passwords?
2. What does it mean to say we then *trust* the service provider?
3. Why does having more and more systems with logins make the average person
*less* secure?
4. How does OAuth help?
5. Why is OAuth advantageous for a startup business?

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

ANother benefit of having users authenticate with OAuth is that it gives us
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

Let's generate a new rails app into which we'll be integrating our OAuth functionality:

```
rails new oauth-workshop --database=postgresql --skip-turbolinks
cd oauth-workshop
bundle
rake db:create db:migrate
```

We don't currently have anything in our database, but we'll be adding a `User` model shortly.

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

```
# in config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "YOUR_CONSUMER_API_KEY", "YOUR_CONSUMER_API_SECRET"
end
```

Make sure you restart your application after adding this, since initializers only get run
on application startup.

__Note__ that you should extract these values as environment-provided keys before deploying your
application or commiting it to version control.

### Step 5 - Fleshing out the Application

We have our basic omniauth configuration in place, but so far there's not much to do with it.
In fact if we start our rails app now and view it we'll see it's still just rendering the default
rails page.

Let's fix this by filling in some very basic UI and routing:

1. Generate a new controller called `WelcomeController`.
2. Configure your `root` route to point to `welcome#index`.
3. Add a template at `app/views/welcome/index.html.erb` which includes a simple greeting (`<h1>Welcome!</h1>`).
4. Add a route labeled `login` which points to `/auth/twitter` (this is a special route used by omniauth).
5. Add a "Login" link to `app/views/welcome/index.html.erb` which points to the `login_path` we just established.

Test your work by loading the root path. You should see your "Welcome!" message as well as the login link.
Now click the login link. If your application is configured correctly, you should be taken off to a twitter-hosted
url and shown the standard "Login with Twitter" screen.

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
2. Add a route that maps a `get` request to `/auth/twitter/callback` to `sessions#create`

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

```
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

### Step 8 - Creating a User model

Assuming we'd like to save our OAuth user details in the DB, let's consider the
user information we'd like to save to our new `User` model:

* `name`
* `screen_name`
* `user_id` (by convention, we often save this into a column called `uid`)
* `oauth_token`
* `oauth_token_secret`

We could grab more information out of the omniauth auth hash, but this is probably
enough to start.

Let's generate a user model with columns to store all this new information:

```
rails g model user name:string screen_name:string uid:string oauth_token:string oauth_token_secret:string
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


```
# in app/models/user.rb

def self.from_omniauth(auth_info)
  if user = find_by(uid: auth_info.extra.raw_info.user_id)
    user
  else
    create({name: auth_info.extra.raw_info.name,
            screen_name: auth_info.extra.raw_info.screen_name,
            uid: auth_info.extra.raw_info.user_id,
            oauth_token: auth_info.credentials.token,
            oauth_token_secret: auth_info.credentials.secret
            })
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
auth hash and passes them into the `create` method.

Now that we have this in place, let's look at using it from
our `SessionsController`:

```
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

```
# in app/controllers/application_controller.rb
def current_user
  @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
end
helper_method :current_user
```

Now let's use this back in our welcome template:

```
<%# in app/views/welcome/index.html.erb %>

<% if current_user %>
<p>hello, <%= current_user.name %></p>
<% end %>
```

## Key Terms & Concepts

* Brokering trust
* (Encryption) Key & Secret

## Discussion Plan

1. Discuss OAuth at a high level including issues of trust, passwords, and
users' security considerations
2. Discuss why/how OAuth came about and how to recognize it
3. Walk through the OAuth flow
4. Outline the necessary steps to be an OAuth consumer
5. Discuss what it'd look like to be an OAuth provider
6. Take a quick look at OmniAuth

## Resources

* [OAuth](http://en.wikipedia.org/wiki/OAuth) on Wikipedia
* [Understanding OAuth](http://lifehacker.com/5918086/understanding-oauth-what-happens-when-you-log-into-a-site-with-google-twitter-or-facebook) on LifeHacker
* [OmniAuth](https://github.com/intridea/omniauth) for integration in Ruby web apps
* [Oauth 1.0 Diagram (from MashApe's oauth bible)](http://puu.sh/2pJ4y)
* [Oauth Bible](http://oauthbible.com/) - lots of in-depth info about different oauth versions and components
* [Edge Cases Podcast #36](http://edgecasesshow.com/036-zenos-paradox-of-authentication.html) - Good in-depth discussion of the evolution of Oauth and the pros and cons of using it.
* [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) -- Oauth provider gem



OLD TUT

{% include custom/sample_project_follow_along.html %}

* Intro to OAuth
* Advantages / Disadvantages of Oauth
* OAuth 2 vs OAuth 1
* Intro to Omniauth
* Tutorial outline

### Accessing the Remote Service

You need to restart your server so the initializer is run and the middleware loaded. The default URL pattern is:

In your browser go to http://127.0.0.1:8080/auth/twitter and, after a few seconds, you should see a Twitter login page. 

Login to Twitter using any account, then you should see a Routing Error from your application. If you’ve got that, then things are on the right track.

<div class='note'>
If you get to this point and encounter a 401 Unauthorized message there is more work to do. You’re probably using your own API key and secret. You need to go into the settings on Twitter for your application, and add http://127.0.0.1 as a registered callback domain. Also add http://0.0.0.0 and http://localhost while you're in there. 

Now give it a try and you should get the Routing Error.
</div>

### Handling the Callback

The authentication pattern starts with your app redirecting to the third party authenticator, the third party processes the authentication, then it sends the user back to your application at a *callback URL*. OmniAuth defaults to listening at `/auth/twitter/callback`. 

You'd handle that callback by adding a route in `/config/routes.rb`:

```ruby
get '/auth/:provider/callback', to: 'sessions#create'
``` 

Your router will attempt to call the `create` action of the `SessionsController` when the callback is triggered.

### Creating a Sessions Controller

You can generate a controller at the command line and add a create method like this:

```ruby
class SessionsController < ApplicationController
  def create
    render text: debug request.env["omniauth.auth"]
  end
end
```

Calling `render :text` is a good debugging technique to display plain text as the response. Here you'd see the response body data stored under the `omniauth.auth` key.

### Creating a User Model

Even though we're using an external service for authentication, we'll still need to keep track of user objects within our system. Let's create a model that will be responsible for that data. 

As you saw, Twitter gives us a ton of data about the user. What should we store in our database?  The minimum expectations for an OmniAuth provider are three things:

* `provider` - A string name uniquely identifying the provider service
* `uid` - An identifying string uniquely identifying the user within that provider
* `name` - Some kind of human-meaningful name for the user

Let's start with just those three in our model. From your terminal:

{% terminal %}
$ rails generate model User provider:string uid:string name:string
{% endterminal %}

Then update the database with `rake db:migrate`.

### Creating Actual Users

How you create users might vary depending on the application. For our demonstration, we'll allow anyone to create an account automatically just by logging in with the third party service.

Hop back to the `SessionsController`. The controller should have as little domain logic as possible, so we'll proxy the User lookup/creation from the controller down to the model like this:

```ruby
  def create
    @user = User.find_or_create_by_auth(request.env["omniauth.auth"])
  end
```
 
Now the `User` model is responsible for figuring out what to do with that big hash of data from Twitter. Open the model file and add this method:

```ruby
  def self.find_or_create_by_auth(auth_data)
    user = self.find_or_create_by_provider_and_uid(auth_data["provider"], auth_data["uid"])
    if user.name != auth_data["user_info"]["name"]
      user.name = auth_data["user_info"]["name"]
      user.save
    end    
    return user
  end
```

To walk through that step by step...

* Look in the users table for a record with this `provider` and `uid` combination. If it's found, you'll get it back. If it's not found, a new record will be created and returned
* Compare the user's `name` and the `name` in the auth data. If they're different, either this is a new user and we want to store the name or they've changed their name on the external service and it should be updated here. Then save it.
* Either way, return the `user`

Now, back to `SessionsController`, we need to save the logged in user's id in the session. And let's add a redirect action to send them to the `articles_path` after login:

```ruby
  def create
    @user = User.find_or_create_by_auth(request.env["omniauth.auth"])
    session[:user_id] = @user.id
    redirect_to articles_path, notice: "Logged in as #{@user.name}"
  end
```

Now visit `/auth/twitter` and you should eventually be redirected to the Articles listing.

### UI for Login/Logout

That's exciting, but now we need links for login/logout that don't require manually manipulating URLs. Anything like login/logout that you want visible on every page goes in the layout.

Open `/app/views/layouts/application.html.erb` and you'll see the framing for all our view templates. Let's add in the following:

```erb
  <div id="account">
    <% if current_user %>
      <span>Welcome, <%= current_user.name %></span>
      <%= link_to "logout", logout_path, id: "logout" %>
    <% else %>
      <%= link_to "login", login_path, id: "login" %>
    <% end %>
  </div>
```

If you refresh your browser that will crash for several reasons.

### Accessing the Current User

It's a convention that Rails authentication systems provide a `current_user` method to access the user. 

Let's create that in our `ApplicationController` with these steps:

* Underneath the `protect_from_forgery` line, add this: 

    ```ruby
    helper_method :current_user
    ```

* Just before the closing `end` of the class, add this:

    ```ruby
      private
        def current_user
          @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end  
    ```

By defining the `current_user` method as private in `ApplicationController`, that method will be available to all our controllers because they inherit from `ApplicationController`. 

In addition, the `helper_method` line makes the method available to all our views. Now we can access `current_user` from any controller and any view!

#### Progress Check

Refresh the page in your browser and you'll move on to the next error:

```
undefined local variable or method `login_path'.
```

### Convenience Routes

Just because we're following the REST convention doesn't mean we can't also create our own named routes. The view snippet we wrote is attempting to link to `login_path` and `logout_path`, but our application doesn't yet know about those routes.

Open `/config/routes.rb` and add two custom routes:

```ruby
  get "/login" => redirect("/auth/twitter"), as: :login
  get "/logout" => "sessions#destroy", as: :logout  
```

The first line creates a path named `login` which redirects to the static address `/auth/twitter` which will be intercepted by the OmniAuth middleware. The second line creates a `logout` path which will call the `destroy` action of our `SessionsController`.

With those in place, refresh your browser and it should load without error.

### Implementing Logout

Our login works great, but we can't logout!  When you click the logout link it's attempting to call the `destroy` action of `SessionsController`. Let's implement that.

* Open `SessionsController`
* Add a `destroy` method
* In the method, erase the session with:

    ```ruby
    session[:user_id] = nil
    ```
    
* Redirect to the `root_path` with the notice `"Goodbye!"`
* Define a `root_path` in your router like this: 

    ```ruby
    root to: "article#index"
    ```

### Wrapup

At that point, your login/logout system should be working!

That's just the beginning with OmniAuth. Now, you could choose to add other providers by adding API keys to the initializer and properly handling the different routes.

You might try out some of these:

* A Devise and OmniAuth powered Single-Sign-On implementation: https://github.com/joshsoftware/sso-devise-omniauth-provider
* RailsCast on combining Devise and OmniAuth: http://asciicasts.com/episodes/236-omniauth-part-2

## References

* OmniAuth core API documentation: https://github.com/intridea/omniauth
* OmniAuth wiki: https://github.com/intridea/omniauth/wiki

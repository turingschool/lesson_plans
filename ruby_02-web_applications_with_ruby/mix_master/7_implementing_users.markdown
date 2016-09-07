# Mix Master Part 7: Implementing Users

Here's our situation: want this app to be a multi-user platform where each user has their own collection of playlists. There are three parts to making this happen:

* Authentication - Establish identity
* Ownership - Attach data records to user records
* Authorization - Control who is allowed to do what

We'll start by adding in functionality for multiple users to be able to login using a Spotify account. If you've ever logged in to a site using your Google/Facebook/Twitter login, we'll be creating a similar experience.

In terms of authentication, it's possible to hand-roll your own authentication where you provide your own account sign-up interface. We'll learn about this in class.

One of the most popular libraries for authentication right now is Devise because it makes it very easy to get up and running quickly. The downside is that the implementation uses very aggressive Ruby and metaprogramming techniques which make it very challenging to customize.

#### Why OmniAuth?

As we learn more about constructing web applications there is a greater emphasis on decoupling components. It makes a lot of sense to depend on an external service for our authentication, then that service can serve this application along with many others.

The best application of this concept is the OmniAuth. It’s popular because it allows you to use multiple third-party services to authenticate, but it is really a pattern for component-based authentication. You could let your users login with their Twitter or Facebook account, but we can also build our own OmniAuth provider that authenticates all your companies’ apps.

OmniAuth can handle multiple concurrent strategies, so you can offer users multiple ways to authenticate. Your app is just built against the OmniAuth interface, those external components can come and go.

Let's go:

```
$ git checkout -b 7_implement-users
```

Instead of writing the test first, let's spike so that we can understand how the OmniAuth gem works and what information the third-party service will provide to us.

I tried using the [omniauth-spotify](https://github.com/icoretech/omniauth-spotify/) gem but ran into some issues with an invalid redirect URI. As it turns out, there's an issue with the callback_url when using Spotify and omniauth. If you want to go down the rabbit hole (as I did), you can check out [this issue](https://github.com/icoretech/omniauth-spotify/issues/7) and then follow all of the links :)

So instead of using the gem, we'll just create our own OmniAuth Strategy.

First, add the `omniauth-oauth2` gem to your Gemfile:

```ruby
gem 'omniauth-oauth2'
```

Then `bundle`.

Next, create an initializer:

```
$ touch config/initializers/omniauth.rb
```

The name of this file is arbitrary. Any file inside of the initializers directory will be run once upon initialization of the app. For our purposes, this would be `rails s` or `rails c` or when we push to Heroku. You can read more about initialization [here](http://guides.rubyonrails.org/initialization.html).

Inside of this `omniauth.rb` file, we'll define our strategy `Spotify` and set the site url, authorize_url, and token_url. You can read more about how to make your own strategy on the [omniauth-oauth2 README](https://github.com/intridea/omniauth-oauth2).

```ruby
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Spotify < OmniAuth::Strategies::OAuth2
      option :name, 'spotify'

      option :client_options, {
        site:          'https://api.spotify.com/v1/',
        authorize_url: 'https://accounts.spotify.com/authorize',
        token_url:     'https://accounts.spotify.com/api/token'
      }

      def info
        @raw_info ||= access_token.get('me').parsed
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET']
end
```

NOTE: Generally if you're using OAuth, you'll use a predefined strategy that comes packaged as a gem. For example, check out [omniauth-twitter](https://github.com/arunagw/omniauth-twitter) or [omniauth-shopify-oauth2](https://github.com/Shopify/omniauth-shopify-oauth2). In both of those cases, you would not need to define your own class as we have done. The only lines you'd need are the last three (`Rails.application.config.middleware.use OmniAuth::Builder do...`). We're only making our own because of the `callback_url` problem I described above. Our method definition overriding `callback_url` fixes this problem for Spotify.

Notice that we're using `ENV['SPOTIFY_KEY']` and `ENV['SPOTIFY_SECRET']`. These are environment variables that contain our Spotify keys. We haven't registered our app yet, so let's do that and get these keys.

Navigate to [https://developer.spotify.com/](https://developer.spotify.com/) and click "My Apps". At this point you may have to sign in (or create an account) and accept Spotify's terms of use. Once you've completed that, you should be redirected to [My Applications](https://developer.spotify.com/my-applications/#!/applications). Click the green "Create an App" button, then provide a name ("MixMaster") and a description (your choice). Once you click "Create", you'll see a page where you can enter more information. The only piece you need to set right now is the "Redirect URIs". In that box, enter this:

```
http://localhost:3000/auth/spotify/callback
```

This is the pattern used by omniauth to redirect after authenticating. Click "Add", then scroll to the bottom of the page and click "Save".

This page also gives us access to the Client ID and the Client Secret. Although we could hardcode these into our codebase, that's a bad idea if you're pushing to a public repository or sharing your code in any way. Instead, let's use [Figaro](https://github.com/laserlemon/figaro), a gem that manages sensitive information and provides an easy way to push these variables to Heroku.

First, add Figaro to your Gemfile:

```ruby
gem "figaro"
```

Then `bundle` and run `figaro install`. This command will do two things: 1) create `config/application.yml` which is where you'll store sensitive information, and 2) add that file to your .gitignore so that git doesn't see it (and therefore doesn't add and push to Github). At this point, open your `.gitignore` file to make sure that it includes the following line:

```
/config/application.yml
```

Your `.gitignore` file should be in the root folder of your app, but may not show up in your Atom file browser depending on your preferences. If that happens to you, you should still be able to open it form the command line with `atom .gitignore`.

Next, open `config/application.yml` and delete any comments. Add your key (Client ID) and secret (Client Secret) like this:

```yaml
SPOTIFY_KEY: PASTEYOURCLIENTIDERE
SPOTIFY_SECRET: PASTEYOURCLIENTSECRETHERE
```

The key and secret do not need to be in quotation marks.

Let's talk about that redirect URI we gave Spotify: `http://localhost:3000/auth/spotify/callback`. This is where Spotify will return a response once it's done authenticating. We need to provide this route in our `routes.rb`:

```ruby
get '/auth/spotify/callback', to: 'sessions#create'
```

Notice that we're routing it to a controller that doesn't exist. Before we create this controller, let's make sure we have everything wired up correctly. In order to trigger the authentication process with Spotify, we'll need a link to sign in. For now, let's add this to our `application.html.erb` layout:

```erb
<!DOCTYPE html>
<html>
<head>
  <title>MixMaster</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
</head>
<body>
<%= link_to "Sign in with Spotify", "/auth/spotify" %>

<%= yield %>

</body>
</html>
```

Again, the pattern "/auth/provider" is used by omniauth to trigger the third-party authentication process. Let's check to see if we get the error we're expecting when we click on our new link. If you're still logged in to Spotify, log out now. Start up your application with `rails s` and navigate to any page (for example: `http://localhost:3000/playlists`). Click your "Sign in with Spotify" link. You should be redirected to a Spotify page where you can click a green "okay" button to allow your app to authenticate you. Do that now.

*If you get an `uninitialized constant SessionsController` error, you're on the right track!*

This means that it was able to authenticate using Spotify and redirect to our callback url: `/auth/spotify/callback`. Great! Let's make a sessions controller and the create action.

We will use the sessions controller to create a "session" for the user -- an instance of the user being logged in. A session is a special type of tamper-proof cookie that we'll use to keep track of the state of our user (whether or not they are logged in). This won't be stored in our database, so we won't need a Session model or sessions table. You can read more about sessions in [Rails Guides Security: Sessions](http://guides.rubyonrails.org/security.html#sessions).

Ok, make the controller:

```
$ touch app/controllers/sessions_controller.rb
```

Then inside of that controller, define the `create` action and put a `byebug` inside of it. We're going to do some experimenting here so that we know what the OmniAuth response looks like:

```ruby
class SessionsController < ApplicationController
  def create
    byebug
  end
end
```

Now, start up your server again and repeat that process. This time, after you click "okay", go back to your server log and you should see this:

```
[1, 5] in /Users/rwarbelow/mix_master/app/controllers/sessions_controller.rb
   1: class SessionsController < ApplicationController
   2:   def create
   3:     byebug
=> 4:   end
   5: end
```

If you type `request` and hit enter, you'll see a large `ActionDispatch::Request` object. This is what is coming back from Spotify's authentication. `request` has an instance variable `env` that returns a hash which we can access like this: `request.env`.

Note: If you don't want to look at that giant blob of text, you can require pretty print inside of byebug `require 'pp'` and then `pp request`. It's a little easier to look at this way.

This is still a lot of information. We only need to get the omniauth information which is contained in the key `"omniauth.auth"` (do you see it?). We'll do that like this: `request.env["omniauth.auth"]`. You should see an `OmniAuth::AuthHash` object.

Now, because we defined an `info` method when we defined our Spotify strategy (see `config/initializers/omniauth.rb` if you don't remember this), we also have access to `request.env["omniauth.auth"].info`. So I can do something like this within my byebug session:

``` ruby
auth = request.env["omniauth.auth"]
pp auth #=> If you've required pp this will give you a nicely formatted version of `auth`
auth.provider #=> "spotify"
auth.info
auth.info.display_name #=> "Rachel Warbelow"
auth.info.id #=> "myuniqueuserid"
```

Great! Now that we have this information, let's create or find an existing user in our `SessionsController`:

```ruby
class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    if @user
      session[:user_id] = @user.id
      redirect_to playlists_path
    end
  end
end
```

Neither the `User` model nor `User.find_or_create_from_auth` exist. Let's make the user model:

```
$ rails g model User name provider uid
```

Remember, if we don't put data types in from the command line, they will default to string. This will be ok for us. Remember to `rake db:migrate`. You should have this table in your schema:

```ruby
  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
```

Now, we'll implement the `User.find_or_create_from_auth` method in the `User` model:

```ruby
class User < ActiveRecord::Base
  def self.find_or_create_from_auth(auth)
    User.find_or_create_by(
      provider: auth["provider"],
      uid: auth["info"]["id"],
      name: auth["info"]["display_name"]
    )
  end
end
```

You can read more about the `find_or_create_by` ActiveRecord method [here](http://apidock.com/rails/v4.0.2/ActiveRecord/Relation/find_or_create_by).

Now start up your server `rails s` and try logging in. Nothing should break, but we also don't see any confirmation that we're signed in. The "Sign in with Spotify" link still appears, and we don't see our name anywhere. Let's fix this.

Remember how we set `session[:user_id] = @user.id` in `SessionsController#create`? Well, we can use this value to be able to access a current user. The `session` object is available in all controllers and views. Let's create a current_user method in the ApplicationController using the `session[:user_id]` value:

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
```

Then in the `application.html.erb` layout, let's display the `current_user`'s name and create some logic to determine whether to show a sign in or sign out link:

```erb
<!DOCTYPE html>
<html>
<head>
  <title>MixMaster</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
</head>
<body>

<% if current_user %>
  <h3>Welcome, <%= current_user.name %></h3>
  <%= link_to "Sign out", logout_path, method: :delete %>
<% else %>
  <%= link_to "Sign in with Spotify", "/auth/spotify" %>
<% end %>
<%= yield %>

</body>
</html>
```

This won't work yet, since we don't have a `logout_path`. Let's add that in `routes.rb`:

```ruby
  delete '/logout', to: 'sessions#destroy'
```

Now refresh the page. You should see your name and a link to sign out. If you click the link, it tells you that the action `destroy` doesn't exist.

When we logged in, we set the `session[:user_id]` equal to the primary key ID of the user. Now, we'll want to clear that so that the user is no longer logged in:

```ruby
class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    if @user
      session[:user_id] = @user.id
      redirect_to playlists_path
    end
  end

  def destroy
    session.clear
    redirect_to playlists_path
  end
end
```

Everything should be wired up correctly now. Try signing in and out to see if it works.

So, how do we test this? First, let's write a user story:

```
As a user
When I visit the playlists index
And I click "Sign in with Spotify"
Then I should see a "Sign Out" link
And I should see my display name
And I should not see "Sign in with Spotify"
```

```
$ touch spec/features/user_signs_in_spec.rb
```

Inside of that file:

```ruby
require 'rails_helper'

RSpec.feature "User signs in with Spotify" do
  scenario "they see a link to sign out" do
    auth_data = {
        'provider'  => 'spotify',
        'info' => {
          'display_name' => 'Fake User',
          'id'           => '12345'
        }
      }

    OmniAuth.config.mock_auth[:spotify] = auth_data

    visit playlists_path
    click_link "Sign in with Spotify"
    expect(page).to have_content("Sign out")
    expect(page).to have_content(auth_data['info']['display_name'])
    expect(page).to_not have_content("Sign in with Spotify")
  end
end
```

We'll also need to configure our `rails_helper.rb` to be able to work with OmniAuth in test mode:

```ruby
OmniAuth.config.test_mode = true
```

What we're doing here is telling OmniAuth that we're using test_mode, then using the strategy `:spotify` to mock out the data hash that we've defined as `auth_data` in the test.

For a challenge, erase all of your work for this section (`git reset --HARD`) and use the spec we wrote above to TDD this whole process. Have fun!

Wondering how to write a controller spec for this functionality? Check out [this blog post](http://www.natashatherobot.com/rails-test-omniauth-sessions-controller/) or the [omniauth documentation](https://github.com/intridea/omniauth/wiki/Integration-Testing).

### Adding Playlist Ownership

**COMING SOON. WIP.**

Apps will evolve over time, and you may reach a point where you need to go back and modify a spec to reflect this new functionality. We now need playlists to belong to a user.

Make sure to commit your work! Use proper commit message manners. All tests should be passing.

### Life Raft

If you've messed things up, you can clone down the [7_implement-users](https://github.com/rwarbelow/mix_master/tree/7_implement-users) branch of `mix_master` which is complete up to this point in the tutorial.

```
$ git add .
$ git commit
$ git checkout master
$ git merge 7_implement-users
```

Before pushing to Heroku, you'll want to create a new set of Spotify keys and follow the instructions for the [Figaro](https://github.com/laserlemon/figaro) gem in order to set those keys on Heroku. In general, you want to have a set of keys, or registered application, for production and one for development. Since we specify the callback url when we register the app, one set of keys won't work locally and in production.  

### Maybe Coming Soon!

* Polymorphism with images
* Paperclip with images
* SASS
* Switch over your views to use HAML instead of ERB

### Other Resources

* [BetterSpecs: rspec guidelines with ruby](http://betterspecs.org/)
* [Understanding Polymorphic Associations in Rails](http://www.gotealeaf.com/blog/understanding-polymorphic-associations-in-rails)
* [Testing wtih RSpec - Codeschool](http://rspec.codeschool.com/levels/1)
* [An Introduction to RSpec - Team Treehouse](http://blog.teamtreehouse.com/an-introduction-to-rspec)

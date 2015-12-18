## Mix Master: Implementing Artists

Like all good developers, we'll start by writing a feature test (obviously). First, we'll need to set up Capybara in order to mimic an end-user. In the Gemfile:

```ruby
group :development, :test do
  gem 'capybara'
end
```

You may also want to add `gem 'launchy'` so that you can `save_and_open_page` for debugging purposes.

Then `bundle`.

Next, add the dependency to the `rails_helper.rb` file:

```ruby
require 'capybara/rails'
```

Time to write the test! We'll use a red-green-refactor approach:

*RED*: Write a test for some piece of functionality that your app should have. Obviously, since we haven't implemented any code, the test should fail. That's what we want!

*GREEN*: Use the error messages and failures to drive your development. Implement the smallest possible piece of code to fix the error. Keep repeating this cycle until you get a passing test.

*REFACTOR*: Now is the time to go back and refactor your code. This means cleaning up variable names, method names, duplication, and implementation.  

We'll start with a feature test, which is a type of acceptance test. An acceptance test tests functionality that the end user will need. We'll use this feature test to drive out the creation and functionality of certain routes, controllers, models, and views. As we touch those pieces, we may drop down to a lower level (for example, a model test) in order to test edge cases.

Let's start with a user story for creating a artist:

```
As a user
When I visit the artists index
And I click "New artist"
And I fill in the name
And I fill in an image path
And I click "Create Artist"
Then I should see the artist name and image on the page
```

Check out a new branch: `git checkout -b implement-artists`

Make a folder for features: `mkdir spec/features` and then create a test: `touch spec/features/user_creates_an_artist_spec.rb`

Inside of that file, we'll use our user story to flesh out a feature test:

```ruby
require 'rails_helper'

RSpec.feature "User submits a new artist" do
  scenario "they see the page for the individual artist" do
    artist_name       = "Bob Marley"
    artist_image_path = "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"

    visit artists_path
    click_on "New artist"
    fill_in "artist_name", with: artist_name
    fill_in "artist_image_path", with: artist_image_path
    click_on "Create Artist"

    expect(page).to have_content artist_name
    expect(page).to have_css("img[src=\"#{artist_image_path}\"]")
  end
end
```

Let's run the spec and see what happens. From your command line, type `rspec`.

You should see this error:

```
/usr/local/rvm/gems/ruby-2.2.2/gems/activerecord-4.2.5/lib/active_record/connection_adapters/postgresql_adapter.rb:661:in `rescue in connect': FATAL:  database "mix_master_test" does not exist (ActiveRecord::NoDatabaseError)
```

This means that we haven't created our database yet. We need to run `rake db:create`. Now run the test again.

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: visit artists_path

     NameError:
       undefined local variable or method `artists_path' for #<RSpec::ExampleGroups::UserSubmitsANewArtist:0x007f9dccce0330>
     # ./spec/features/user_creates_a_song_spec.rb:8:in `block (2 levels) in <top (required)>'

Finished in 0.00376 seconds (files took 5.88 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/features/user_creates_a_song_spec.rb:4 # User submits a new artist they see the page for the individual artist
```

The first bit tells us that we don't have a `schema.rb`. That's ok; we don't have any migrations yet. Let's use the errors and failures to guide our development. We'll focus in on this line:

```
NameError:
       undefined local variable or method `artists_path' for #<RSpec::ExampleGroups::UserSubmitsANewArtist:0x007f9dccce0330>
```

This tells us that we don't have an artists_path (which will be the index of all artists), so we'll define that in our `config/routes.rb` file:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index]
end
```

When we run rake routes, we'll see this output:

```
Prefix Verb URI Pattern        Controller#Action
artists GET  /artists(.:format) artists#index
```

Since the prefix is `artists`, we can append `_path` which will create the link to `'/artists'`. Run the spec again:

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: visit artists_path

     ActionController::RoutingError:
       uninitialized constant ArtistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/conditionalget.rb:25:in `call'
     ...
```

We'll need to create an ArtistsController. We can do this using the [rails generate controller](http://guides.rubyonrails.org/getting_started.html#say-hello-rails) command, but this will give us a whole bunch of files that we a) probably won't use, and b) are untested. Let's create the controller by hand:

`$ touch app/controllers/artists_controller.rb`

And inside of that file, we'll define the controller:

```ruby
class ArtistsController < ApplicationController
end
```

Run the spec again:

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: visit artists_path

     AbstractController::ActionNotFound:
       The action 'index' could not be found for ArtistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

If we look at the output of `rake routes`, we'll see that `artists_path` should be going to the index action:

```
Prefix Verb URI Pattern        Controller#Action
artists GET  /artists(.:format) artists#index
```

We haven't defined the index action, so let's do that inside of the controller:

```
class ArtistsController < ApplicationController
  def index
  end
end
```

Run the spec again:

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: visit artists_path

     ActionView::MissingTemplate:
       Missing template artists/index, application/index with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in:
         * "/Users/rwarbelow/Desktop/Coding/Turing/mix_master/app/views"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Rails is attempting to find `artists/index` inside of our views folder, but it doesn't see it (because we haven't created it. Good job, Rails!). Let's make that:

```
$ mkdir app/views/artists
$ touch app/views/artists/index.html.erb
```

Run the spec again:

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "New artist"

     Capybara::ElementNotFound:
       Unable to find link or button "New artist"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

It's not seeing a link or button to click for new artist. We'll need to add that in the view:

```erb
<h1>All Artists</h1>

<%= link_to "New artist", new_artist_path %>
```

Run the spec:

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: <%= link_to "New artist", new_artist_path %>

     ActionView::Template::Error:
       undefined local variable or method `new_artist_path' for #<#<Class:0x007fee98ab17e0>:0x007fee98aa1188>
     # ./app/views/artists/index.html.erb:3:in `_app_views_artists_index_html_erb__160270083333517601_70331334416800'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

We've used the `new_artist_path` helper, but that doesn't exist yet. It should return a path of `'/artists/new'`, so we'll need to add this to our `routes.rb`:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new]
end
```

Run `rake routes` to see the new route:

```
Prefix Verb URI Pattern            Controller#Action
artists GET  /artists(.:format)     artists#index
new_artist GET  /artists/new(.:format) artists#new
```

Now that we have the `new_artist_path`, we'll run the spec again. Can you predict what the error will be?

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "New artist"

     AbstractController::ActionNotFound:
       The action 'new' could not be found for ArtistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Our route specifies that `'/artists/new'` should go to the `new` action in the controller, but we haven't defined that:

```ruby
class ArtistsController < ApplicationController
  def index
  end

  def new
  end
end
```

Let's run the spec again:

```
.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "New artist"

     ActionView::MissingTemplate:
       Missing template artists/new, application/new with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in:
         * "/Users/rwarbelow/Desktop/Coding/Turing/mix_master/app/views"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Again, the test is looking for a view that we dont have: `artists/new`. We'll make that view:

```
$ touch app/views/artists/new.html.erb
```

Run the spec again:

```
.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: fill_in "artist_name", with: artist_name

     Capybara::ElementNotFound:
       Unable to find field "artist_name"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

`Capybara::ElementNotFound: Unable to find field "artist_name"` means that it's looking for a field to fill in, but there's nothing on this page. We'll need to make a form for this new artist. In the `new.html.erb` view:

```erb
<%= form_for(Artist.new) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>
<% end %>
```

Notice that we only added one field, even though we know the artist will also have an `image_path`. That's because we don't know if this bit of code will work, or if there is something else we need to do before continuing on the form. Let's run the spec:

```
.
F

Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: <%= form_for(Artist.new) do |f| %>

     ActionView::Template::Error:
       uninitialized constant ActionView::CompiledTemplates::Artist
     # ./app/views/artists/new.html.erb:1:in `_app_views_artists_new_html_erb___2323050576229746218_70261753554780'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
    ...
```

Ah! So we have an uninitialized constant `Artist`. In the form, we said `form_for(Artist.new)`, but Rails does not know what `Artist` is. This means we'll need to create the model since we're planning to store this in the database:

```
$ rails g model Artist name image_path
```

If we don't specify the data type from the command line, then the default will be a string. That sounds ok to me. This command will give us a migration, a model, and two files for testing: a model test and a fixtures file.

Go ahead and run the spec again:

```
/Users/rwarbelow/Desktop/Coding/Turing/mix_master/db/schema.rb doesn't exist yet. Run `rake db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/rwarbelow/Desktop/Coding/Turing/mix_master/config/application.rb to limit the frameworks that will be loaded.
/usr/local/rvm/gems/ruby-2.2.2/gems/activerecord-4.2.5/lib/active_record/migration.rb:392:in `check_pending!':  (ActiveRecord::PendingMigrationError)

Migrations are pending. To resolve this issue, run:

  bin/rake db:migrate RAILS_ENV=test

  from /usr/local/rvm/gems/ruby-2.2.2/gems/activerecord-4.2.5/lib/active_record/migration.rb:405:in `load_schema_if_pending!'
  ...
```

Now we care about that first message: `/schema.rb doesn't exist yet. Run rake db:migrate to create it, then try again.` 

Let's follow this error message and run `rake db:migrate`. This will generate our schema that will then be loaded into our test database when we run our specs. Run them, and you'll see this message:

```
F*

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) Artist add some examples to (or delete) /Users/rwarbelow/Desktop/Coding/Turing/mix_master/spec/models/artist_spec.rb
     # Not yet implemented
     # ./spec/models/artist_spec.rb:4


Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: fill_in "artist_image_path", with: artist_image_path

     Capybara::ElementNotFound:
       Unable to find field "artist_image_path"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

Here we have a `Pending` spec: inside of our `artist_spec.rb` file (which was generated when we typed `rails g model Artist`), it stubs out the beginning of a spec to be implemented later. That's ok. We'll leave it for now.

We're failing for a different reason now: `Capybara::ElementNotFound: Unable to find field "artist_image_path"`. What does this mean? Well, we're no longer failing on the `fill_in "artist_name"` line. So we'll need to add another field to our form:

```erb
<%= form_for(Artist.new) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :image_path %>
  <%= f.text_field :image_path %>
<% end %>
```

Run the spec again (I'll leave out the pending example):

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "Create Artist"

     Capybara::ElementNotFound:
       Unable to find link or button "Create Artist"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

Cool. The `image_path` field is working. Now it can't find a link or button to create the artist. Let's add a submit button to our form:

```erb
<%= form_for(Artist.new) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :image_path %>
  <%= f.text_field :image_path %>

  <%= f.submit %>
<% end %>
```

By default, the Rails `form_for` will put text on the submit button that says "Create Artist" since the form is for an `Artist.new`. If this form were for an existing artist, then the default text would be "Update Artist". You can override the default value of the button by doing something like `<%= f.submit "Save this artist!" %>`. We won't worry about overriding the default today.

Run the spec:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "Create Artist"

     ActionController::RoutingError:
       No route matches [POST] "/artists"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/railties-4.2.5/lib/rails/rack/logger.rb:38:in `call_app'
     ...
```

Great! Our submit button was found, and now it's trying to find the route for `[POST] "/artists"`. When we look at our routes, we see this:

```
    Prefix Verb URI Pattern            Controller#Action
   artists GET  /artists(.:format)     artists#index
new_artist GET  /artists/new(.:format) artists#new
```

Do you see a `POST` for `'/artists'`? Because I don't. This means we'll need to modify our `routes.rb`:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create]
end
```

Now the output of `rake routes` looks like this:

```
    Prefix Verb URI Pattern            Controller#Action
   artists GET  /artists(.:format)     artists#index
           POST /artists(.:format)     artists#create
new_artist GET  /artists/new(.:format) artists#new
```

Ok, now our `POST` to `'/artists'` exists. Run the spec and predict what the error will be before you look below!

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "Create Artist"

     AbstractController::ActionNotFound:
       The action 'create' could not be found for ArtistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

That route is trying to go to the `create` action in our controller. Let's make that:

```ruby
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "Create Artist"

     ActionView::MissingTemplate:
       Missing template artists/create, application/create with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in:
         * "/Users/rwarbelow/Desktop/Coding/Turing/mix_master/app/views"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

This tells us that we're missing the template `artists/create`, but we don't really want a template. What we want is to create the artist, then redirect to it's `show` page probably. So in our controller, let's go ahead and implement the creation of this artist:

```ruby
class ArtistsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @artist = Artist.create(artist_params)
    redirect_to @artist
  end

private

  def artist_params
    params.require(:artist).permit(:name, :image_path)  
  end
end
```

The private `artist_params` method is an example of [strong parameters](http://edgeguides.rubyonrails.org/action_controller_overview.html#strong-parameters). We'll pass these permitted params into `Artist.create` in the `def create` method, then redirect to `artist`. This gives us the same behavior as saying `redirect_to artist_path(artist)`.

Run the spec and predict the output:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: redirect_to artist

     NoMethodError:
       undefined method `artist_url' for #<ArtistsController:0x007fabd7e2fb28>
     # ./app/controllers/artists_controller.rb:10:in `create'
    ...
```

The error, `NoMethodError: undefined method 'artist_url'` indicates that we don't have that route helper yet. Since this is the `show` route, we'll add it to our `routes.rb`:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show]
end
```

This produces the following routes:

```
    Prefix Verb URI Pattern            Controller#Action
   artists GET  /artists(.:format)     artists#index
           POST /artists(.:format)     artists#create
new_artist GET  /artists/new(.:format) artists#new
    artist GET  /artists/:id(.:format) artists#show
```

Run the spec:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "Create Artist"

     AbstractController::ActionNotFound:
       The action 'show' could not be found for ArtistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Again, we've specified a route but we haven't defined the `show` action in the `ArtistsController`. Go do that:

```ruby
class ArtistsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @artist = Artist.create(artist_params)
    redirect_to @artist
  end

  def show
  end

private

  def artist_params
    params.require(:artist).permit(:name, :image_path)  
  end
end
```

Run the spec:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: click_on "Create Artist"

     ActionView::MissingTemplate:
       Missing template artists/show, application/show with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in:
         * "/Users/rwarbelow/Desktop/Coding/Turing/mix_master/app/views"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Missing template `artists/show` of course. Make it:

```
$ touch app/views/artists/show.html.erb
```

Run the spec:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: expect(page).to have_content artist_name
       expected to find text "Bob Marley" in ""
     # ./spec/features/user_creates_an_artist_spec.rb:14:in `block (2 levels) in <top (required)>'

Finished in 0.29334 seconds (files took 2.87 seconds to load)
2 examples, 1 failure, 1 pending

Failed examples:

rspec ./spec/features/user_creates_an_artist_spec.rb:4 # User submits a new artist they see the page for the individual artist
```

YAY! A true failure. RSpec cannot find the text "Bob Marley" on that page. That's good, because we don't have anything on the page yet.

We could hardcode "Bob Marley" right onto the view, but we know this is not the implementation that we'll ultimately want, so let's think of other things we could do.

What we want to happen is that we have some artist object that we can call `#name` on. I suppose we could do `Artist.first.name`, but that will only ever allow us to see the first artist on the page. Instead, let's prepare an instance variable in the controller, then access it in the view. How will we grab the correct artist? Well, let's put a `byebug` in the `show` method:

```ruby
  def show
    byebug
  end
```

Now when you run your tests, you should see it stop on the `byebug`:

```
[10, 19] in /Users/rwarbelow/mix_master/app/controllers/artists_controller.rb
   10:     redirect_to artist
   11:   end
   12:
   13:   def show
   14:     byebug
=> 15:   end
   16:
   17: private
   18:
   19:   def artist_params
```

Type `request.path` and you'll see that it returns something like `"/artists/5"` (your id number may be different). We can grab this id out of the URL using our params. `params` returns `{"controller"=>"artists", "action"=>"show", "id"=>"5"}`, so `params[:id]` should return `5`. We can then use this to access the correct artist: `Artist.find(params[:id])`. Try it!

Let's add that code to our controller:

```ruby
  def show
    @artist = Artist.find(params[:id])
  end
```

Nice. But the spec failure is going to say the same thing since we haven't done anything to use that variable. Go back to your view, and add:

```erb
<h1><%= @artist.name %></h1>
```

Run the spec:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: expect(page).to have_css("img[src=\"#{artist_image_path}\"]")
       expected to find css "img[src=\"http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg\"]" but there were no matches
     # ./spec/features/user_creates_an_artist_spec.rb:15:in `block (2 levels) in <top (required)>'

Finished in 0.26541 seconds (files took 3.01 seconds to load)
2 examples, 1 failure, 1 pending

Failed examples:

rspec ./spec/features/user_creates_an_artist_spec.rb:4 # User submits a new artist they see the page for the individual artist
```

Now the test sees "Bob Marley", but we don't see the image source in the html. Let's add an image tag in the `show` view:

```erb
<h1><%= @artist.name %></h1>
<%= image_tag @artist.image_path %>
```

Run the spec, and you'll see that our first feature is passing! (Ignore the pending example)

```
Finished in 0.23294 seconds (files took 2.66 seconds to load)
2 examples, 0 failures, 1 pending
```

Now that we're *green*, let's do a bit of refactoring. First, in our `new.html.erb` view, let's not make an object directly in the view. Instead, let's use an instance variable:

```
<%= form_for(@artist) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :image_path %>
  <%= f.text_field :image_path %>

  <%= f.submit %>
<% end %>
```

And then we can define that instance variable in our controller:

```
  def new
    @artist = Artist.new
  end
```

This will allow us to use this `form_for` code snippet in a partial for the edit view later on in addition to allowing us to do some neat things with error messages on the `@artist` object.

#### Sad Path

What should happen if a user forgets to put in a name? Should an artist be created still? In this case, probably not. Sometimes you'll choose to test your sad path cases at the feature level, and sometimes you will test those validations at the model level. How do you decide? Well, if you care about the error that the user should see, then we probably want to make a feature test. Feature tests are expensive and slow, so if we're going to test a sad path, we only need one. The rest of our validations will be tested at the model level. Let's go.

Here's our sad path user story:

```
As a user
When I visit the artists index
And I click "New artist"
And I fill in an image path
And I click "Create Artist"
Then I should see "Name cannot be blank" on the page
```

Let's add a new context to our existing spec file:

```ruby
require 'rails_helper'

RSpec.feature "User submits a new artist" do
  scenario "they see the page for the individual artist" do
    artist_name       = "Bob Marley"
    artist_image_path = "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"

    visit artists_path
    click_on "New artist"
    fill_in "artist_name", with: artist_name
    fill_in "artist_image_path", with: artist_image_path
    click_on "Create Artist"

    expect(page).to have_content artist_name
    expect(page).to have_css("img[src=\"#{artist_image_path}\"]")
  end

  context "the submitted data is invalid" do
    scenario "they see an error message" do
      artist_image_path = "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"

      visit artists_path
      click_on "New artist"
      fill_in "artist_image_path", with: artist_image_path
      click_on "Create Artist"

      expect(page).to have_content "Name can't be blank"
    end
  end
end
```

Notice that we wrap this `scenario` in a `context` block. Context blocks can be used to add additional information that makes it easier to read what the test should be doing.

Let's run the spec:

```
Failures:

  1) User submits a new artist the submitted data is invalid they see an error message
     Failure/Error: expect(page).to have_content "Name can't be blank"
       expected to find text "Name can't be blank" in ""
     # ./spec/features/user_creates_an_artist_spec.rb:27:in `block (3 levels) in <top (required)>'

Finished in 0.48679 seconds (files took 4.44 seconds to load)
3 examples, 1 failure, 1 pending

Failed examples:

rspec ./spec/features/user_creates_an_artist_spec.rb:19 # User submits a new artist the submitted data is invalid they see an error message
```

So what's happening here? Well, Capybara is looking for the text "Name can't be blank", but it's not seeing *anything* on the page. That's because the only thing that's printing out to the page right now is `@artist.name`. And if we didn't enter a name, then of course nothing is on the page.

If you don't understand that, I'd suggest using a `save_and_open_page` in your test to see what Capybara is seeing. Perhaps you can also put a `byebug` in the controller after the instance variable `@artist` is assigned.

This means that the artist is being created regardless of the fact that a name was not submitted. Let's pause on the feature test for a moment and drop down to the model level in order to validate the presence of a name. Add the word `pending` right below `scenario "they see an error message" do`.

#### Validations at the Model Level

We can use the [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) gem in order to test validations easily with one line. First, add the gem to your Gemfile:

```ruby
group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'shoulda-matchers'
end
```

And `bundle`. Next, we'll configure shoulda matchers to work with RSpec in `rails_helper.rb`:

```ruby
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

...etc...
```


Now let's add some model-level validation tests in `artist_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe Artist, type: :model do
  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:image_path) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
```

Even though we don't have a feature test to drive out these validations, we know that the `create artist` feature should act the same way (ie - show an error message) if any of these things are wrong. Run `rpsec` and let's see what happens.

```
Failures:

  1) Artist should require name to be set
     Failure/Error: it { is_expected.to validate_presence_of(:name) }

       Expected errors to include "can't be blank" when name is set to nil,
       got no errors
     # ./spec/models/artist_spec.rb:5:in `block (2 levels) in <top (required)>'

  2) Artist should require image_path to be set
     Failure/Error: it { is_expected.to validate_presence_of(:image_path) }

       Expected errors to include "can't be blank" when image_path is set to nil,
       got no errors
     # ./spec/models/artist_spec.rb:6:in `block (2 levels) in <top (required)>'

  3) Artist should require case sensitive unique value for name
     Failure/Error: it { is_expected.to validate_uniqueness_of(:name) }

       Expected errors to include "has already been taken" when name is set to "a",
       got no errors
     # ./spec/models/artist_spec.rb:7:in `block (2 levels) in <top (required)>'

Finished in 0.94621 seconds (files took 4.57 seconds to load)
5 examples, 3 failures, 1 pending

Failed examples:

rspec ./spec/models/artist_spec.rb:5 # Artist should require name to be set
rspec ./spec/models/artist_spec.rb:6 # Artist should require image_path to be set
rspec ./spec/models/artist_spec.rb:7 # Artist should require case sensitive unique value for name
```

Lot's of failures. Let's focus on that first one. RSpec is looking for errors when a name is nil. We don't have a validation for this in our model, so let's go add that in `artist.rb`:

```ruby
class Artist < ActiveRecord::Base
  validates :name, presence: true
end
```

When we run the specs again, we see that spec passes now. To make the other two pass, we add similar validations:

```ruby
class Artist < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :image_path, presence: true
end
```

All of our model specs are now passing, so let's go back up to the feature test level and remove `pending`. This spec will still fail since we're not handling what happens if a artist is not successfully saved into the database. So let's modify our controller `create` action:

```ruby
  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      redirect_to @artist
    else
      render :new
    end
  end
```

Now whenever the artist cannot successfully be saved due to failing validations, it will render the `new` view. We'll need to add a bit of code in `new.html.erb` in order to check whether or not errors exist on the `@artist` object:

```erb
<%= form_for(@artist) do |f| %>
  <% if @artist.errors.any? %>
    <h2><%= pluralize(@artist.errors.count, "error") %> prohibited this record from being saved:</h2>
    <ul>
      <% @artist.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  <% end %>

  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :image_path %>
  <%= f.text_field :image_path %>

  <%= f.submit %>
<% end %>
```

**OPTIONAL**: Create feature tests for editing and deleting an artist.

All tests should be passing. Go ahead and add and commit your work to this branch. Make sure to check out [this post](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) to learn about proper commit messages and conventional format. Check out master, and merge the branch back into master. Push to Heroku, and migrate.

```
$ git add .
$ git commit
$ git checkout master
$ git merge implement-artists
$ git push heroku master
$ heroku run rake db:migrate
```

Now you can visit `https://your-herokuapp-number.herokuapp.com/artists` and test out this functionality!

#### Implementing Songs

Artists are all set. Now let's implement `songs`. First, check out a new branch:

```
$ git checkout -b implement-artists
```

And like before, we'll base our implementation off of a feature test. Here's our user story:

```
As a user
Given that artists exist in the database
When I visit the artist songs index
And I click "New song"
And I fill in the title
And I select the artist
And I click "Create Song"
Then I should see the song name
And I should see a link to the song artist's individual page
```

So let's make a spec file: `$ touch spec/features/user_creates_a_song_spec.rb`. Try writing your own version of the spec before looking at mine below.

```ruby
require 'rails_helper'

RSpec.feature "User submits a new song" do
  scenario "they see the page for the individual song" do
    artist = create(:artist)

    song_title = "One Love" 

    visit artist_path(artist)
    click_on "New song"
    fill_in "song_title", with: song_title 
    select artist.name, from: "song_artist_id"
    click_on "Create Song"

    expect(page).to have_content song_title
    expect(page).to have_link artist.name, href: artist_path(artist)
  end
end
```

What's that line `artist = create(:artist)`? This is syntax for using a test factory in order to have one place where we specify generic objects we use in our tests. If now decide that a Song or Artist had some other required attribute, we’d have to update several spec files to create the objects properly.

This duplication makes our tests more fragile than they should be. We need to introduce a factory.

The most common libraries for test factories are FactoryGirl(https://github.com/thoughtbot/factory_girl) and [Fabrication](https://github.com/paulelliott/fabrication). Each of them has hit a rough patch of maintenance, though, which guided me towards a third option.

Let’s use FactoryGirl. Open up your Gemfile and add a dependency on "factory_girl_rails" and "database_cleaner" in the test/development environment. Run bundle to install the gem.

Now for some configuration. Create a file `spec/support/factory_girl.rb` and add this configuration to get RSpec and FactoryGirl to play nicely:

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do 
    begin
      DatabaseCleaner.start
      FactoryGirl.lint ensure
      DatabaseCleaner.clean 
    end
  end 
end
```

The following line should currently be commented out in `rails_helper.rb`. Find it and uncomment it. This line will allow us to require all ruby files that we put inside of the `spec/support` directory. 

```ruby
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
```

Finally, we'll need to make our factories. Make a file `spec/support/factories.rb` and inside of it, we'll define the Artist factory:

```ruby
FactoryGirl.define do 
  factory :artist do
    name       "Bob Marley"
    image_path "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"
  end
end
```

Take a look back at your spec. Where do you think the first problem will arise? Here's the error I got:

```
Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: click_on "New song"
     
     Capybara::ElementNotFound:
       Unable to find link or button "New song"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

We have the view (this is the individual artist show view), but we don't have this link. Let's add it:

```erb
<h1><%= @artist.name %></h1>
<%= image_tag @artist.image_path %>

<%= link_to "New song", new_artist_song_path(@artist) %>
```

Run `rspec`:

```
Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: <%= link_to "New song", new_artist_song_path(@artist) %>
     
     ActionView::Template::Error:
       undefined method `new_artist_song_path' for #<#<Class:0x007ff0b91eaaf8>:0x007ff0b91f3810>
     # ./app/views/artists/show.html.erb:4:in `_app_views_artists_show_html_erb__838814999508935524_70335907719360'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

We haven't defined `artist_songs_path`. This may seem like a strange name for a path. This is an example of nesting resources. Read the [RailsGuide Nested Resource Documentation](http://guides.rubyonrails.org/routing.html#nested-resources) before continuing.  

Nested resources will allow us to have urls like `/artists/1/songs/new` which will allow us to create a song for that specific artist (artist with `id: 1` from the path). 

To get this path, we'll need to add a route:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show] do 
    resources :songs, only: [:new]
  end
end
```

Running `rake routes` will output this new path:

```
         Prefix Verb URI Pattern                             Controller#Action
new_artist_song GET  /artists/:artist_id/songs/new(.:format) songs#new
        artists GET  /artists(.:format)                      artists#index
                POST /artists(.:format)                      artists#create
     new_artist GET  /artists/new(.:format)                  artists#new
         artist GET  /artists/:id(.:format)                  artists#show
```

Take a look at that first line. `'/artists/:artist_id/songs/new'` is the path we want. The prefix is `new_artist_song` which is what we specified in our test. 

Run `rspec` again:

```
F.....

Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: visit new_artist_song_path(artist)
     
     ActionController::RoutingError:
       uninitialized constant SongsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

`ActionController::RoutingError: uninitialized constant SongsController` tells us that we need another controller -- this time for Songs. Let's make that: `$ touch app/controllers/songs_controller.rb`. Inside of it, define the controller:

```ruby
class SongsController < ApplicationController
end
```

Run `rspec`:

```
F.....

Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: visit new_artist_song_path(artist)
     
     AbstractController::ActionNotFound:
       The action 'new' could not be found for SongsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Our new action should find the artist referred to in the path (`/artists/1/songs/new`), then instantiate a new song of that artist. 

```ruby
class SongsController < ApplicationController
  def new
    @artist = Artist.find(params[:artist_id])
    @song = @artist.songs.new
  end
end
```

The problem is that we don't have a the relationship set up to be able to call `@artist.songs`, so RSpec will complain about this:

```
F.....*

Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: @song = @artist.songs.new
     
     NoMethodError:
       undefined method `songs' for #<Artist:0x007fb2fea26eb8>
     # ./app/controllers/songs_controller.rb:4:in `new'
     ...
```

How do we solve this? Well, we know we'll need a model, but let's fix the actual error first. It wants a method `songs` to be defined for artist. We know this will be a `has_many` relationship. In the Artist model:

```ruby
class Artist < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :image_path, presence: true

  has_many :songs
end
```

Now run `rspec`:

```
Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: @song = @artist.songs.new
     
     NameError:
       uninitialized constant Artist::Song
     # ./app/controllers/songs_controller.rb:4:in `new'
     ...
```

We don't have a `Song` constant. Let's make a model: `$ rails g model Song title artist:references`. This command will use a string value for title and create an `artist_id` integer field, along with an index and a foreign key constraint to maintain referential integrity. (Google this if it doesn't make sense).

Next, we'll want to migrate: `$ rake db:migrate`

Now we can run `rspec` again (skipping the pending song model specs output):

```
F.....

Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: visit new_artist_song_path(artist)
     
     ActionView::MissingTemplate:
       Missing template songs/new, application/new with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in:
         * "/Users/rwarbelow/Desktop/Coding/Turing/mix_master/app/views"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Try to create the view on your own. Then check out my view below (`/app/views/songs/new.html.erb`):

```erb
<%= form_for([@artist, @song]) do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>

  <%= f.label :artist %>
  <%= f.collection_select(:artist_id, Artist.all, :id, :name) %>

  <%= f.submit %>
<% end %>
```

In the form's argument, we're passing in an array of the `@artist` and the `@song`. The `@song` variable is acting how we would normally expect, while the `@artist` variable is there to create the route. Remember, we're nesting all of this under artists in the path, so when we post, it should submit a post request to `'/artists/1/songs'`, and the `@artists` variable will allow the route to be constructed using the correct id. 

Run the spec again:

```
F.....

Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: <%= form_for([@artist, @song]) do |f| %>
     
     ActionView::Template::Error:
       undefined method 'artist_songs_path' for #<#<Class:0x007fdcfde29de8>:0x007fdcfde335a0>
     # ./app/views/songs/new.html.erb:1:in `_app_views_songs_new_html_erb__3381179736744756855_70293564557660'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
    ...
```

This is kind of weird. We're getting `undefined method 'artist_songs_path'`, but we haven't used `artist_songs_path` in the file and line that it's referring to: `/app/views/songs/new.html.erb:1`. 

What's happening here? We'll, because we've passed in a new object (`@song`) to the form (`form_for([@artist, @song])`), Rails automatically assumes that we'll want to post to the `artist_songs_path` when we submit the form. That's where it's blowing up. We don't have a `post` route for the `songs` path. Let's define that by adding `create` for our songs resources:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show] do 
    resources :songs, only: [:new, :create]
  end
end
```

Now run your specs:

```
Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: click_on "Create Song"
     
     AbstractController::ActionNotFound:
       The action 'create' could not be found for SongsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Can you implement the `create` action in the `SongsController`? Try it, then check mine:

```ruby
class SongsController < ApplicationController
  def new
    @artist = Artist.find(params[:artist_id])
    @song = @artist.songs.new
  end

  def create
    @artist = Artist.find(params[:artist_id])
    @song = @artist.songs.create(song_params)

    redirect_to song_path(@song)
  end

private

  def song_params
    params.require(:song).permit(:title)  
  end
end
```

First we need to find the artist using the `artist_id` from the url, then we will build a new song off of that artist. 

Predict what will happen in the last line of the create action. What will the spec complain about?

```
Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: redirect_to song_path(@song)
     
     NoMethodError:
       undefined method `song_path' for #<SongsController:0x007f92800a2958>
     # ./app/controllers/songs_controller.rb:11:in `create'
     ...
```

Ok, we have an `undefined method 'song_path'`. We're trying to `redirect_to song_path(@song)`, but we haven't defined a path for the song show. Let's do that:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show] do 
    resources :songs, only: [:new, :create]
  end

  resources :songs, only: [:show]
end

```

Notice that we're creating the route *outside* of the nested resources. This is so we don't end up having a super long route for the show, since the show doesn't rely on who the artist is. Read more about [potential problems with nesting and how to avoid them](http://guides.rubyonrails.org/routing.html#limits-to-nesting). 

What's going to happen when you run the specs? 

```
Failures:

  1) User submits a new song they see the page for the individual song
     Failure/Error: click_on "Create Song"
     
     AbstractController::ActionNotFound:
       The action 'show' could not be found for SongsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

**Your turn**: Make this spec pass. Take a look at the view below if you're stuck.

```erb
<h1><%= @song.title %></h1>
<%= link_to @song.artist.name, artist_path(@song.artist) %>
```

At this point, your repo probably looks like [the song-functionality branch of MixMaster](https://github.com/rwarbelow/mix_master/tree/song-functionality). Make sure to commit your work. 

Push to Heroku (`git push heroku master`). Then open your site and check out the functionality!

*Before you move on to the "Your Turn" section, check out a new branch to work on in case you end up messing up everything and needing to go back to a functional state. Trust me. I speak from experience.*

#### Your Turn (Optional)

Implement the spec and functionality for one or all of these three user stories:

##### Easy

```
As a user
Given that an artist exists in the database
When I visit the individual artist page
And I click "New song"
And I select an artist
And I click "Create Song"
Then I should see "Title cannot be blank" on the page
```

This first user story will also force (encourage?) you to drop down to the model level to test your validations. 

##### Hard(er)

```
As a user
Given that an artist and that artist's associated songs exist in the database
When I visit the individual artist page
And I click "View songs"
Then I should see the song titles for that specific artist sorted alphabetically
And each title should link to the individual song page
```

You'll want to check out the [FactoryGirl Documentation](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md) in order to figure out how to set up factories that have associations. 

```
As a user
Given that songs exist in the database
When I visit the songs index ('/songs')
Then I should see the titles of all songs in the database sorted alphabetically
And the titles should each link the individual song page
```

If you're stuck, check out the [song-functionality branch of the MixMaster repo](https://github.com/rwarbelow/mix_master/tree/song-functionality) at this point of completion. Keep in mind: this code is not *the answer*; it's just one way of doing it. If you find a way that you can justify as being better, do it! 

#### Creating Playlists

If you messed up everything (or things get messed up going into the next section), remember that you can always go back to master (your last working state) and check out a branch from there. 

We're tracking songs and artists. How do we create playlists? Not sure. Let's write a user story and have the test drive out this behavior. 

```
As a user
Given that songs and artists exist in the database
When I visit the playlists path
And I click "New playlist"
And I fill in a name
And I select the songs for the playlist
And I click "Create Playlist"
Then I see the playlist title
And I see the titles of all songs in that playlist
And the titles should link to the individual song pages
```

Create a spec file: `$ touch spec/features/user_creates_a_playlist_spec.rb`. Inside of that file, let's write the test:

```ruby
require 'rails_helper'

RSpec.feature "User creates a playlist" do
  scenario "they see the page for the individual playlist" do
    song_one, song_two, song_three = create_list(:song, 3)

    playlist_name = "My Jams"

    visit playlists_path
    click_on "New playlist"
    fill_in "playlist_name", with: playlist_name 
    check(song_one.title)
    check(song_three.title)
    click_on "Create Playlist"

    expect(page).to have_content playlist_name

    within("li:first") do
      expect(page).to have_link song_one.title, href: song_path(song_one)
    end

    within("li:last") do
      expect(page).to have_link song_two.title, href: song_path(song_two)
    end
  end
end
```

Depending on whether or not you built a song factory in the optional "Your Turn" section, you may not see the error below. I see it, so I'll walk through how I'll fix it. 

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: song_one, song_two, song_three = build_list(:song, 3)
     
     ArgumentError:
       Factory not registered: song
     # /usr/local/rvm/gems/ruby-2.2.2/gems/factory_girl-4.5.0/lib/factory_girl/registry.rb:24:in `find'
     ...
```

`Factory not registered: song` means that we haven't yet created a song factory. We'll define this in our `/spec/support/factories.rb`:

```ruby
FactoryGirl.define do 
  sequence :title, ["A", "C", "B"].cycle do |n|
    "#{n} Title"
  end 

  factory :song do
    title
    artist
  end
end
```

Here, I defined a song factory, and I also defined a sequence for title. Learn more about [FactoryGirl Sequences](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#sequences) and [custom sequences](http://www.pmamediagroup.com/2009/05/smarter-sequencing-in-factory-girl/). 

Run the spec again:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: song_one, song_two, song_three = build_list(:song, 3)
     
     ActiveRecord::RecordInvalid:
       Validation failed: Name has already been taken
     # /usr/local/rvm/gems/ruby-2.2.2/gems/factory_girl-4.5.0/lib/factory_girl/configuration.rb:14:in `block in initialize'
     ...
```

Hmm. Oopsies. It seems that we've caused a problem for ourselves since we've hardcoded "Bob Marley" as the name in the artist factory, but now it's trying to generate an artist with each song, and we can't have duplicated names (per our uniqueness validation). Gah. Let's change up our factories:

```ruby
FactoryGirl.define do 
  factory :artist do
    name
    image_path "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"
  end

  sequence :name do |n|
      "#{n} Artist"
    end 

  sequence :title, ["A", "C", "B"].cycle do |n|
    "#{n} Title"
  end 

  factory :song do
    title
    artist
  end
end
```

Here, we've created a new sequence for an artist name. This will make a dynamic new name for each artist. That sounds pretty good. Run the spec again:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: visit playlists_path
     
     NameError:
       undefined local variable or method `playlists_path' for #<RSpec::ExampleGroups::UserCreatesAPlaylist:0x007ff280950ef0>
     # ./spec/features/user_creates_a_playlist_spec.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.6029 seconds (files took 3.77 seconds to load)
8 examples, 1 failure, 1 pending
```

Cool. Now we can start implementing some other stuff. Like a route for `playlists_path`. This doesn't need to be nested under anything. 

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show] do 
    resources :songs, only: [:new, :create]
  end

  resources :songs, only: [:show]
  resources :playlists, only: [:index]
end
```

Run `rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: visit playlists_path
     
     ActionController::RoutingError:
       uninitialized constant PlaylistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

We know how to fix this. Let's make a controller: `$ touch app/controllers/playlists_controller.rb`. We know that we'll also need an index action and a view, so let's make those too. (If you're bored of following each tiny error, go ahead and skip ahead to the form creation section.)

```ruby
class PlaylistsController < ApplicationController
  def index
  end
end
```

```
$ mkdir app/views/playlists
$ touch app/views/playlists/index.html.erb
```

Run the spec:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "New playlist"
     
     Capybara::ElementNotFound:
       Unable to find link or button "New playlist"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

Capybara can't find the "New playlist" link. Go ahead and add that.

```erb
<h1>All Playlists</h1>

<%= link_to "New playlist", new_playlist_path %>
```

`rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: <%= link_to "New playlist", new_playlist_path %>
     
     ActionView::Template::Error:
       undefined local variable or method `new_playlist_path' for #<#<Class:0x007fba3880f698>:0x007fba38d1cb68>
     # ./app/views/playlists/index.html.erb:3:in `_app_views_playlists_index_html_erb__546494196404700757_70218897014620'
     ...
```

Add a route for the `new_playlist_path`:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show] do 
    resources :songs, only: [:new, :create]
  end

  resources :songs, only: [:show]
  resources :playlists, only: [:index, :new]
end
```

`rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "New playlist"
     
     AbstractController::ActionNotFound:
       The action 'new' could not be found for PlaylistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

We need the `new` action in the `PlaylistsController`. 

```ruby
class PlaylistsController < ApplicationController
  def index
  end

  def new
    @playlist = Playlist.new
  end
end
```

`rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "New playlist"
     
     ActionView::MissingTemplate:
       Missing template playlists/new, application/new with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in:
         * "/Users/rwarbelow/Desktop/Coding/Turing/mix_master/app/views"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

It can't find the template `playlists/new`, so let's make that: `$ touch app/views/playlists/new.html.erb`.

`rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: fill_in "playlist_name", with: playlist_name
     
     Capybara::ElementNotFound:
       Unable to find field "playlist_name"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

So now Capybara is trying to find a field to fill in. This indicates that we'll need a form:

```erb
<h1>New Playlist</h1>

<%= form_for(@playlist) do |f| %>
  <%= f.text_field :name %>
<% end %>
```

Can you predict what the error will be? (Hint: what are we making a `form_for`?) 

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: <%= form_for(@playlist) do |f| %>
     
     ActionView::Template::Error:
       uninitialized constant ActionView::CompiledTemplates::Playlist
     # ./app/views/playlists/new.html.erb:3:in `_app_views_playlists_new_html_erb___2408870859850317183_70310555634900'
     ...
```

We have an uninitialized constant `Playlist`. We know that playlist is something that will be stored in our database, so we'll need to generate a model: `$ rails g model Playlist name:string`. Make sure to migrate. 

Now that we have the model, let's run the test again. What will the error be? 

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: check(song_one.title)
     
     Capybara::ElementNotFound:
       Unable to find checkbox "A Title"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

Capybara is trying to find a checkbox with the text "A Title" next to it. We don't have checkboxes rendered in our form. Here's how we'll do that:

```erb
<h1>New Playlist</h1>

<%= form_for(@playlist) do |f| %>
  <%= f.text_field :name %>

  <% Song.all.each do |song| -%>
    <div>
      <%= check_box_tag(:song_ids, song.id, false, :name => 'playlist[song_ids][]', id: "song-#{song.id}") %>
      <%= song.title %>
    </div>
  <% end %>
<% end %>
```

Here we've iterated over all songs in the database (`Song.all`) and made a [check_box_tag](http://apidock.com/rails/ActionView/Helpers/FormTagHelper/check_box_tag) for each of them. 

*Go look at those docs and figure out what each argument in the `check_box_tag` method is before continuing.*

Let's run the test and see if Capybara can find those checkboxes now:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "Create Playlist"
     
     Capybara::ElementNotFound:
       Unable to find link or button "Create Playlist"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
     ...
```

Excellent. It found the checkboxes, and now it is looking for the "Create Playlist" button. Let's add that:

```erb
<h1>New Playlist</h1>

<%= form_for(@playlist) do |f| %>
  <%= f.text_field :name %>

  <% Song.all.each do |song| -%>
    <div>
      <%= check_box_tag :song_ids, song.id, false, :name => 'playlist[song_ids][]', id: "song-#{song.id}" %>
      <%= song.title %>
    </div>
  <% end %>

  <%= f.submit %>
<% end %>
```

What will RSpec complain about next time? Think of where `form_for(@playlist)` will try to route to when you hit the submit button. 

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "Create Playlist"
     
     ActionController::RoutingError:
       No route matches [POST] "/playlists"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/railties-4.2.5/lib/rails/rack/logger.rb:38:in `call_app'
     ...
```

We need a post for `'/playlists'`. Let's add that to our routes:

```ruby
Rails.application.routes.draw do
  resources :artists, only: [:index, :new, :create, :show] do 
    resources :songs, only: [:new, :create]
  end

  resources :songs, only: [:show]
  resources :playlists, only: [:index, :new, :create]
end
```

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "Create Playlist"
     
     AbstractController::ActionNotFound:
       The action 'create' could not be found for PlaylistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

Now add the create action. We know the next error is going to be that it can't find the template. That's not what we want anyway. Let's think about this. Go ahead and put a `byebug` in the `create` method so that you can see your params coming in:

```ruby
class PlaylistsController < ApplicationController
  def index
  end

  def new
    @playlist = Playlist.new
  end

  def create
    byebug
  end
end
``` 

Can you figure out what you need to do, and which params you need to permit in your strong params? Try it, then take a look below:

```ruby
class PlaylistsController < ApplicationController
  def index
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.create(playlist_params)
    redirect_to @playlist
  end

private

  def playlist_params
    params.require(:playlist).permit(:name, song_ids: [])
  end
end
```

What is that weird thing `song_ids: []` inside the strong params? [Read about it before moving on](http://patshaughnessy.net/2014/6/16/a-rule-of-thumb-for-strong-parameters). 

Run `rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: @playlist = Playlist.create(playlist_params)
     
     ActiveRecord::UnknownAttributeError:
       unknown attribute 'song_ids' for Playlist.
     # ./app/controllers/playlists_controller.rb:10:in `create'
     ...
```

Hmm. `unknown attribute 'song_ids' for Playlist`. That makes sense, since we don't have that attribute on our `Playlist` model. Let's think about the relationship here. A playlist can have many songs, and a song can have many playlists (ie - a song can be used on multiple playlists). This means we're gonna need a many-to-many relationship, and a many-to-many relationship indicates that we'll need a join table.

Let's start by writing a model test to ensure that a Playlist has many `playlist_songs` and `songs` through that join table. Inside of `spec/models/playlist_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe Playlist, "associations", type: :model do
  it { should have_many(:playlist_songs) } 
  it { should have_many(:songs).through(:playlist_songs) } 
end
```

How did I figure out this thing? I looked at [the docs](http://matchers.shoulda.io/). **You should do that, too.** 

Now if you run `rspec`, three things are going to be failing. AHH! Too much failing. Let's just run that one model spec using the pattern `rspec path/to/spec/file.rb`. 

```
$ rspec spec/models/playlist_spec.rb
```

Whew. Much less overwhelming. Let's look at the error: 

```
Failures:

  1) Playlist associations should have many playlist_songs
     Failure/Error: it { should have_many(:playlist_songs) }
       Expected Playlist to have a has_many association called playlist_songs (no association called playlist_songs)
     # ./spec/models/playlist_spec.rb:4:in `block (2 levels) in <top (required)>'

  2) Playlist associations should have many songs through playlist_songs
     Failure/Error: it { should have_many(:songs).through(:playlist_songs) }
       Expected Playlist to have a has_many association called songs (no association called songs)
     # ./spec/models/playlist_spec.rb:5:in `block (2 levels) in <top (required)>'

Finished in 0.03436 seconds (files took 3.09 seconds to load)
2 examples, 2 failures

Failed examples:

rspec ./spec/models/playlist_spec.rb:4 # Playlist associations should have many playlist_songs
rspec ./spec/models/playlist_spec.rb:5 # Playlist associations should have many songs through playlist_songs
```

The important bits are `no association called playlist_songs` and `no association called songs`. Let's go into our Playlist model and implement those:

```ruby
class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs
end
```

Want to know more about `has_many, through` and why you should not be using `has_and_belongs_to_many`? Check out [this blog post](http://blog.flatironschool.com/why-you-dont-need-has-and-belongs-to-many/). 

Run just that spec file again:

```
Failures:

  1) Playlist associations should have many playlist_songs
     Failure/Error: it { should have_many(:playlist_songs) }
       Expected Playlist to have a has_many association called playlist_songs (PlaylistSong does not exist)
     # ./spec/models/playlist_spec.rb:4:in `block (2 levels) in <top (required)>'

  2) Playlist associations should have many songs through playlist_songs
     Failure/Error: it { should have_many(:songs).through(:playlist_songs) }
     
     NameError:
       uninitialized constant Playlist::PlaylistSong
     # /usr/local/rvm/gems/ruby-2.2.2/gems/shoulda-matchers-3.0.1/lib/shoulda/matchers/active_record/association_matcher.rb:1116:in `rescue in class_exists?'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/shoulda-matchers-3.0.1/lib/shoulda/matchers/active_record/association_matcher.rb:1113:in `class_exists?'
     # /usr/local/rvm/gems/ruby-2.2.2/gems/shoulda-matchers-3.0.1/lib/shoulda/matchers/active_record/association_matcher.rb:973:in `matches?'
     # ./spec/models/playlist_spec.rb:5:in `block (2 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # NameError:
     #   uninitialized constant Playlist::PlaylistSong
     #   /usr/local/rvm/gems/ruby-2.2.2/gems/shoulda-matchers-3.0.1/lib/shoulda/matchers/active_record/association_matchers/model_reflection.rb:16:in `associated_class'

Finished in 0.03994 seconds (files took 3.17 seconds to load)
2 examples, 2 failures

Failed examples:

rspec ./spec/models/playlist_spec.rb:4 # Playlist associations should have many playlist_songs
rspec ./spec/models/playlist_spec.rb:5 # Playlist associations should have many songs through playlist_songs
```

These two things are the important parts: `PlaylistSong does not exist` and `uninitialized constant Playlist::PlaylistSong`. What should we do? 

Well, it's an uninitialized constant (indicating a class), and we know it is something we'll store in the database, so we should probably make a model: `rails g model PlaylistSong song:references playlist:references` and then `rake db:migrate`. 

### Extensions

* Integrate the [SoundCloud API](https://developers.soundcloud.com/docs/api/reference)
* Implement Oauth with Twitter
* 


### Other Resources

* [Understanding Polymorphic Associations in Rails](http://www.gotealeaf.com/blog/understanding-polymorphic-associations-in-rails)
* [Testing wtih RSpec - Codeschool](http://rspec.codeschool.com/levels/1)
* [An Introduction to RSpec - Team Treehouse](http://blog.teamtreehouse.com/an-introduction-to-rspec)

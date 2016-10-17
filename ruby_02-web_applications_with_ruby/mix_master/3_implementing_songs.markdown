# Mix Master Part 3: Implementing Songs

Artists are all set. Now let's implement `songs`. First, check out a new branch:

```
$ git checkout -b 3_implement-songs
```

And like before, we'll base our implementation off of a feature test. Here's our user story:

```
As a user
Given that artists exist in the database
When I visit the artist songs index
And I click "New song"
And I fill in the title
And I click "Create Song"
Then I should see the song name
And I should see a link to the song artist's individual page
```

So let's make a spec file: `$ touch spec/features/user_creates_a_song_spec.rb`. Try writing your own version of the spec before looking at mine below.

**If you want more of a challenge, stop right here and create this test on your own.**

```ruby
require 'rails_helper'

RSpec.feature "User submits a new song" do
  scenario "they see the page for the individual song" do
    artist = create(:artist)

    song_title = "One Love"

    visit artist_path(artist)
    click_on "New song"
    fill_in "song_title", with: song_title
    click_on "Create Song"

    expect(page).to have_content song_title
    expect(page).to have_link artist.name, href: artist_path(artist)
  end
end
```

What's that line `artist = create(:artist)`? This is syntax for using a test factory in order to have one place where we specify generic objects we use in our tests. If we now decide that a Song or Artist had some other required attribute, we’d have to update several spec files to create the objects properly.

This duplication makes our tests more fragile than they should be. We need to introduce a factory.

The most common libraries for test factories are [FactoryGirl](https://github.com/thoughtbot/factory_girl) and [Fabrication](https://github.com/paulelliott/fabrication).

For this exercise, let’s use FactoryGirl. Open up your Gemfile and add a dependency `gem "factory_girl_rails"` and `gem "database_cleaner"` in the test/development environment. Run bundle to install the gem.

Now for some configuration. Make a `spec/support` directory, and inside of that create a file `spec/support/factory_girl.rb`. Add this configuration to get RSpec and FactoryGirl to play nicely:

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
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
<%= link_to "Edit", edit_artist_path(@artist) %>
<%= link_to "Delete", artist_path(@artist), method: :delete %>
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
  resources :artists do
    resources :songs, only: [:new]
  end
end
```

Running `rake routes` will output this new path:

```
         Prefix Verb    URI Pattern                             Controller#Action
new_artist_song GET     /artists/:artist_id/songs/new(.:format) songs#new
        artists GET     /artists(.:format)                      artists#index
                POST    /artists(.:format)                      artists#create
     new_artist GET     /artists/new(.:format)                  artists#new
    edit_artist GET     /artists/:id/edit(.:format)             artists#edit
         artist GET     /artists/:id(.:format)                  artists#show
                PATCH   /artists/:id(.:format)                  artists#update
                PUT     /artists/:id(.:format)                  artists#update
                DELETE  /artists/:id(.:format)                  artists#destroy
```

Take a look at that first line. `'/artists/:artist_id/songs/new'` is the path we want. The prefix is `new_artist_song` which is what we specified in our view.

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

The problem is that we don't have the relationship set up to be able to call `@artist.songs`, so RSpec will complain about this:

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
<h1>New Song</h1>
<p>Add a new song for <%= @artist.name %></p>
<%= form_for([@artist, @song]) do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>

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

What's happening here? We'll, because we've passed in a new object (`@song`) to the form (`form_for([@artist, @song])`), Rails understands that we'll want to post to the `artist_songs_path` when we submit the form. That's where it's blowing up. We don't have a `post` route for the `songs` path. Let's define that by adding `create` for our songs resources:

```ruby
Rails.application.routes.draw do
  resources :artists do
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
  resources :artists do
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

At this point, your repo probably looks like [the 3_song-functionality branch of MixMaster](https://github.com/rwarbelow/mix_master/tree/3_implement-songs). Make sure to commit your work! Use proper commit message manners.

```
$ git add .
$ git commit
$ git checkout master
$ git merge 3_implement-songs
$ git push heroku master
$ heroku run rake db:migrate
```

Then open your Heroku site and check out the functionality! Whoa so cool.

*If you choose to move on to the "Optional Additional Song Features" section, check out a new branch to work on in case you end up messing up everything and needing to go back to a functional state. Trust me. I speak from experience.*

### Life Raft

If you've messed things up, you can clone down the [3_song-functionality branch](https://github.com/rwarbelow/mix_master/tree/3_implement-songs) of `mix_master` which is complete up to this point in the tutorial.

### Choose Your Own Adventure!

#### Click here for [Mix Master Optional Song Features](/ruby_02-web_applications_with_ruby/mix_master/3_optional_additional_song_features.markdown) (recommended, but not necessary)

#### Click here for [Mix Master Part 4: Implementing Playlists](/ruby_02-web_applications_with_ruby/mix_master/4_implementing_playlists.markdown)

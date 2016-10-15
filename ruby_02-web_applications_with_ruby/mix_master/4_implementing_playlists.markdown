# Mix Master Part 4: Implementing Playlists

If you messed up everything doing the optional additional features (or things get messed up going into the next section), remember that you can always go back to master (your last working state) and check out a branch from there.

The instructions for this part will build onto the end of `3_implementing-songs` and assume that you did not implement additional song features. If you built the additional functionality and merged it into master, you will be fine. Just keep your eye out for the few places that might be different.

Artists, check. Songs, check. Now let's implement `playlists`. First, check out a new branch:

```
$ git checkout -b 4_implement-playlists
```

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

**If you want more of a challenge, stop right here and create this test on your own.**

```ruby
require 'rails_helper'

RSpec.feature "User creates a playlist" do
  scenario "they see the page for the individual playlist" do
    song_one, song_two, song_three = create_list(:song, 3)

    playlist_name = "My Jams"

    visit playlists_path
    click_on "New playlist"
    fill_in "playlist_name", with: playlist_name
    check("song-#{song_one.id}")
    check("song-#{song_three.id}")
    click_on "Create Playlist"

    expect(page).to have_content playlist_name

    within("li:first") do
      expect(page).to have_link song_one.title, href: song_path(song_one)
    end

    within("li:last") do
      expect(page).to have_link song_three.title, href: song_path(song_three)
    end
  end
end
```

Notice that we're using `create_list(:song, 3)` which is a FactoryGirl method. When we generated the `Song` model, it also created a factory in `spec/factories/songs.rb`. It's good practice to have all of your factories separated if you have a lot of them, but we don't right now. Let's delete this file and define a song factory in `spec/support/factories.rb`. Notice that the first factory for `artist` is one we previously defined.

```ruby
FactoryGirl.define do
  factory :artist do
    name       "Bob Marley"
    image_path "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"
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

Here, I defined a song factory, and I also defined a sequence for title. Learn more about [FactoryGirl Sequences](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#sequences) and [custom sequences](http://www.pmamediagroup.com/2009/05/smarter-sequencing-in-factory-girl/).

Run the spec again:

```
Finished in 0.05686 seconds (files took 3.5 seconds to load)
0 examples, 0 failures

/usr/local/rvm/gems/ruby-2.2.2/gems/factory_girl-4.5.0/lib/factory_girl/linter.rb:14:in `lint!': The following factories are invalid: (FactoryGirl::InvalidFactoryError)

* song - Validation failed: Name has already been taken (ActiveRecord::RecordInvalid)
  from /usr/local/rvm/gems/ruby-2.2.2/gems/factory_girl-4.5.0/lib/factory_girl/linter.rb:4:in `lint!'
     ...
```

Hmm. Oopsies. The [FactoryGirl Linter]() caught an issue with one of our factories. We've hardcoded "Bob Marley" as the name in the artist factory, but now it's trying to generate an artist with each song, and we can't have duplicated names (per our uniqueness validation). That's ok. We're agile. We can roll with changes.

Let's change up our factories:

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
  resources :artists do
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
  resources :artists do
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

We need the `new` action in the `PlaylistsController`. We'll need to pass a new Playlist instance to our form. Let's go ahead and create that now.

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

Capybara is trying to find a checkbox with the text "A Title" next to it. We don't have checkboxes rendered in our form. We're trying to create a new checkbox for each song that we have. Here's how we'll do that:

```erb
<h1>New Playlist</h1>

<%= form_for(@playlist) do |f| %>
  <%= f.text_field :name %>

  <% @songs.each do |song| -%>
    <div>
      <%= check_box_tag(:song_ids, song.id, false, :name => 'playlist[song_ids][]', id: "song-#{song.id}") %>
      <%= song.title %>
    </div>
  <% end %>
<% end %>
```

Since we're using `@songs` in our `new.html.erb`, we'll also need to define that in our controller. In the `playlists_controller.rb` update your `new` method to the following:

```ruby
  def new
    @playlist = Playlist.new
    @songs    = Song.all
  end
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

  <% @songs.each do |song| %>
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
  resources :artists do
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
    @songs    = Song.all
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
    @songs    = Song.all
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

What is that weird thing `song_ids: []` inside the strong params? [Read about it before moving on](http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters).

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

Ok, let's run the spec again:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: redirect_to @playlist

     NoMethodError:
       undefined method `playlist_url' for #<PlaylistsController:0x007f860d9b32d8>
     # ./app/controllers/playlists_controller.rb:11:in `create'
    ...
```

How does `redirect_to @playlist` even work? Read [this Stackoverflow answer](http://stackoverflow.com/questions/23082683/how-does-redirect-to-method-work-in-ruby) before continuing.

We know that `NoMethodError: undefined method `playlist_url'` means we'll need a show route. Let's add that:

```ruby
Rails.application.routes.draw do
  resources :artists do
    resources :songs, only: [:new, :create]
  end

  resources :songs, only: [:show]
  resources :playlists, only: [:index, :new, :create, :show]
end
```

Run `rspec`:

```
Failures:

  1) User creates a playlist they see the page for the individual playlist
     Failure/Error: click_on "Create Playlist"

     AbstractController::ActionNotFound:
       The action 'show' could not be found for PlaylistsController
     # /usr/local/rvm/gems/ruby-2.2.2/gems/rack-1.6.4/lib/rack/etag.rb:24:in `call'
     ...
```

We know how to fix this along with adding the view. Go ahead and do that on your own, then check the code below if you're stuck. Follow the errors to drive out what your view needs to have/look like.

* `playlists_controller.rb`:

```ruby
class PlaylistsController < ApplicationController
  def index
  end

  def new
    @playlist = Playlist.new
    @songs    = Song.all
  end

  def create
    @playlist = Playlist.create(playlist_params)
    redirect_to @playlist
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

private

  def playlist_params
    params.require(:playlist).permit(:name, song_ids: [])
  end
end
```

* `app/views/playlists/show.html.erb`

```erb
<h1><%= @playlist.name %></h1>

<ul>
  <% @playlist.songs.each do |song| %>
    <li><%= link_to song.title, song %></li>
  <% end %>
</ul>
```

#### Your turn

Write and implement a feature test for viewing all playlists (`spec/features/user_views_all_playlists_spec.rb`):

```
As a user
Given that playlists exist in the database
When I visit the playlists index
Then I should see each playlist's name
And each name should link to that playlist's individual page
```

Write and implement a feature test for editing an playlist (`spec/features/user_edits_a_playlist_spec.rb`):

```
As a user
Given that a playlist and songs exist in the database
When I visit that playlist's show page
And I click on "Edit"
And I enter a new playlist name
And I select an additional song
And I uncheck an existing song
And I click on "Update Playlist"
Then I should see the playlist's updated name
And I should see the name of the newly added song
And I should not see the name of the removed song
```

Make sure to commit your work! Use proper commit message manners.

### Life Raft

If you've messed things up, you can clone down the [4_playlist-functionality branch](https://github.com/rwarbelow/mix_master/tree/4_implement-playlists) of `mix_master` which is complete up to this point in the tutorial.

```
$ git add .
$ git commit
$ git checkout master
$ git merge 4_implement-playlists
$ git push heroku master
$ heroku run rake db:migrate
```

### On to [Mix Master Part 5: Refactoring](/ruby_02-web_applications_with_ruby/mix_master/5_refactoring.markdown)

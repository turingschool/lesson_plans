---
title: Forms and Route Helpers in Rails
length: 180
tags: forms, routes, helpers, rails
---

## Learning Goals

* construct forms using built-in Rails form helpers
* construct links using built-in Rails helpers
* create user interfaces for CRUD functionality in a Rails app

## Setup

```
$ rails new my-jams
$ cd my-jams
$ bundle
$ rails g model Song title:text artist:text
$ rake db:migrate
```

## Routes

Add RESTful routes for Song:

```ruby
Rails.application.routes.draw do
  resources :songs
end
```

Run `$ rake routes` and look at the output:

```
    Prefix Verb   URI Pattern                    Controller#Action
     songs GET    /songs(.:format)               songs#index
           POST   /songs(.:format)               songs#create
  new_song GET    /songs/new(.:format)           songs#new
 edit_song GET    /songs/:id/edit(.:format)      songs#edit
      song GET    /songs/:id(.:format)           songs#show
           PATCH  /songs/:id(.:format)           songs#update
           PUT    /songs/:id(.:format)           songs#update
           DELETE /songs/:id(.:format)           songs#destroy
```

Let's add a few songs from the console:

```
$ rails c
> Song.create(title: "Baby", artist: "Justin Bieber")
> Song.create(title: "Drunk in Love", artist: "Beyonce")
> Song.create(title: "Fancy", artist: "Iggy Azalea")
> Song.create(title: "Problem", artist: "Ariana Grande")
```

Create a controller for Songs:

```
$ touch app/controllers/songs_controller.rb
```

### Index

Inside of that file:

```ruby
class SongsController < ApplicationController

  def index
    @songs = Song.all
  end
end
```

Create a view:

```
$ mkdir app/views/songs
$ touch app/views/songs/index.html.erb
```

Inside of that file:

```erb
<% @songs.each do |song| %>
  <%= song.title %>
<% end %>
```

Start up your server (`rails s`) and navigate to `localhost:3000/songs`.

## Route Helpers

We can use the prefixes from our `rake routes` output to generate routes:

```
    Prefix Verb   URI Pattern                    Controller#Action
     songs GET    /songs(.:format)               songs#index
           POST   /songs(.:format)               songs#create
  new_song GET    /songs/new(.:format)           songs#new
 edit_song GET    /songs/:id/edit(.:format)      songs#edit
      song GET    /songs/:id(.:format)           songs#show
           PATCH  /songs/:id(.:format)           songs#update
           PUT    /songs/:id(.:format)           songs#update
           DELETE /songs/:id(.:format)           songs#destroy
```

If we want to go to `/songs`, we can create a link to `songs_path`. If we want to go to `/songs/new`, we can create a link to `new_song_path`. Notice that we just add on `_path` to the prefix. 

Rails also has a link helper that looks like this:

```erb
<%= link_to "Song Index", songs_path %>
```

Which will generate the equivalent of:

```erb
<a href="/songs">Song Index</a>
```

We can add a link to view individual songs with this:

Inside of that file:

```erb
<% @songs.each do |song| %>
  <%= link_to song.title, song_path(song) %>
<% end %>
```

1) What is `song_path(song)`?

### Show

Add a route for show:

```ruby
class SongsController < ApplicationController

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end
end
```

Let's create a view to show the individual song: `$ touch app/views/songs/show.html.erb`.

Inside of that file:

```erb
<h1><%= @song.title %></h1>
<h1><%= @song.artist %></h1>
```

### New

1) Ok, back to the index (`/songs`). How can we create a link to go to a form where we can enter a new song? Let's put that link on our `index.html.erb` page.

This link relies on a new action in our controller, so let's add that:

```ruby
class SongsController < ApplicationController

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end
end
```

Add a `new.html.erb` file in your songs views folder.

Inside of that file:

```erb
<%= form_for(@song) do |f| %>
  <%= f.text_field :title %>
  <%= f.text_field :artist %>
  <%= f.submit %>
<% end %>
```

Let's start up our server and check out this form. If we inspect the elements, where will this form go when we click submit? 

### Create

Add a `create` action in the controller:

```ruby
class SongsController < ApplicationController

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to song_path(@song)   # Rails is smart enough to also do redirect_to @song
    else
      render :new
    end
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist)
  end
end
```

### Edit

Let's go to the show view and add a link to edit. What will this link look like? 

Add a route in the controller for edit.

Add a view for edit which contains a `form_for(@song)`. This form looks EXACTLY THE SAME as our `new.html.erb`. What can we do to get rid of duplicated code? 

Better question: If we use a partial, how does Rails know which route to use depending on if it's a `new` or an `edit`? 

### Update

Add an update method in the controller:

```ruby
  def update
    @song = Song.find(params[:id])
    if @song.update(song_params)
      redirect_to song_path(@song)
    else
      render :edit
    end
  end
```

### Destroy

Add a link on the song show view to destroy the song:

```erb
<%= link_to "Delete", song_path(@song), method: :delete %>
```

Add a `destroy` action in your controller:

```ruby
  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    redirect_to tasks_path
  end
```

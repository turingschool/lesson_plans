---
title: Sinatra Partial Arts
length: 60
tags: views, sinatra, partials
---

### Goals

By the end of this lesson, you will know/be able to:

* define partial and helper method
* extract repetitive view code into a partial
* create helper methods to dynamically generate HTML

### Structure

### Video

* None Yet

### Repository

* [PartialArts](https://github.com/turingschool-examples/partial-arts)

### Lecture

#### Warmup:

* How do we normally deal with repeated code?
* Where do you see repeated code in the views?
* Ideas for how to solve this?

#### Together:

##### Extract the Artist Div into a Partial

The way that you extract repetitive code in ERB views is to use a *partial*. In your views folder `touch` a new file called `_artist.erb`.

```
$ touch app/views/_artist.erb
```

Find one instance of the `<div class="artist">...</div>` (e.g. in `/app/views/artists/index.erb`), copy the `div` with the class of `artist` and paste it into your newly created partial file. So, in `/app/views/_artist.erb` you should now have the following:

```erb
<div class="artist">
  <img src="<%= artist.image_url %>" alt=""> <br>
  <h3><a href="/artists/<%= artist.id %>"><%= artist.first_name %> <%= artist.last_name %></a></h3>
</div>
```

Now we have access to the `artist` partial, but we're not making use of it. Let's go back to the `/app/views/artists/index.erb` file and replace the code we have with a call to this partial.

In that file, replace the artist div with the following:

```erb
<=% erb :_artist, locals: {artist: artist}%>
```

A couple of things to notice:

1. You're calling `erb` the same way you would normally in your controller. This is just more ruby code that is going to get evaluated because it's in your ERB template.
2. You're also passing a local variable `artist` into this partial. If you look back at the partial, you'll see that you need to have access to an artist. The only way that you'll get it into your partial is by passing it from here in the `index.erb` file where you're calling it.

Check in your browser to see if the `artist` div is still rendering properly when you visit `/artists`. If so, go back to the other places you saw that repeated code (the `index.erb` files for `belts` and `categories`) and use your partial there as well. Check to make sure that `/belts` and `/categories` are both still rendering correctly.

##### Implement a URL Helper for '/artists/:id'

Let's take another look at our partial. It's not the biggest deal, but it seems like that link to the specific artist's page is a little long. Wouldn't it be nice if in our view we could have a simpler representation of that code? Let's create a URL helper to do just that.

Helper methods are going to be methods that we're able to call from our ERB. While we could do this in any of our controllers (each of them is basically extending the functionality of our `PartialArts` class) let's do this in `/app/controllers/partial_arts_controller.rb`. This code is going to be available in each of our views, and that feels like the best place to hold something that applies to all of the views rather than one in particular.

In that controller, let's create an `artists_url` method that we can call in our artist partial. Copy the full HTML code for the link into that method. One thing to notice: in our ERB template we're using ERB tags to basically do some string interpolation. Now that we're moving this into our controller let's do that string interpolation here so that we're just dropping a string into our ERB file. In order to do that, we'll have to switch the ERB tags to Ruby style string interpolation (see the #{} in the code below?)

```ruby
helpers do
  def artist_url(artist)
    "<a href='/artists/#{artist.id}'>#{artist.first_name} #{artist.last_name}</a>"
  end
end
```

Now, anywhere in our views we should be able to use `artist_url(artist)` to create a link to a specific artist.

Go back to your `/app/views/_artist.erb` partial and replace the link to the artist with the following:

```erb
<%= artist_url(artist) %>
```

Visit `/artists` to see if everything is still working. Yes? Good!

#### In Pairs:

With the time you have left complete the following tasks with a pair:

* Implement a url helper for '/' (root) and use it as a link at the top of artists_index, belts_index, and categories_index
* Extract the Category Statistics div into a partial
* Extract the Belt Statistics div into a partial
* Extract the Location Statistics div into a partial
* Implement a helper to correctly pluralize 'artist' in 'welcome.erb'

### Resources

  * [Sinatra Partials Documentation](http://www.sinatrarb.com/faq.html#partials)
  * [Sinatra Helpers Documentation](http://www.sinatrarb.com/faq.html#helpview)


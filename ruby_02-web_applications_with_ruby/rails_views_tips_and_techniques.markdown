---
title: Rails Views: Tips, Techniques, and Tricks
length: 90
tags: views, rails, helpers, partials
---

## Goals
* refactor views to remove database queries
* use partials to tidy up repeated code
* use built-in Rails Helper methods
* use custom helper methods

### Hook
* Do you want to be the Taylor Swift of Rails Programming? Or would you rather
be the Rebecca Black of Rails Programming?
* Today we are going to talk about views techniques that will make sure that
you look totally pro.

## Repository

* [Repo for lesson](https://github.com/mikedao/i-really-like-you)

### Opening
* Today we are going to talk about three big ideas.
* One: Refactor your views to remove database queries from your views.
* Two: You can use partials to handle repeated code.
* Three: Helper methods are there to help you.

### Removing Database Queries from your Views
* Views should not contain database queries.
* Data should be prepared in the controller and model.
* Logic should be absolutely minimal in views.
* Let's look at our repo. Checkout the idea_one branch.
* Look at the albums#index view.
* How do we refactor that?
* Now, on your own, refactor the album#show view.

### Partials Can Be Used to Tidy Up and Reuse Pieces of Code
* When we are writing ruby and we have some repeated code, what do we do?
* We refactor by pulling it out to another method.
* We can do sort of the same things in our views.

### What is a partial?
* It's a file that contains code that will be reused.
* `_filename.html.erb`
* A good example is think about a basic CRUD app. Isn't the same code
in both the new and show views?
* Let's pull that out into a form.

### Other things to know about partials.
* Normally, you would just do something like, <%= 'albums' %>
* What that does is that it looks for `_albums.html.erb` and renders that file
* Instance variables are automatically shared by both views and partials.
* Local variables you need to pass explicitly.
* `<%= render partial: ‘filename’, locals: { person: @child } %>`
* There's no underscore for filename when calling render <=% render 'filename' %>
* Must specify partial if you're going to use locals.
* You might want by default use partial.
* Partials can be shared if you put it in the app/views/shared
* You would use it like so: `<%= render partial: 'shared/filename' %>
* Let's pull out the @albums together.
* Now, you make an edit, and pull out that form.

### Helper methods are available within views and sometimes controllers!
* There are some built in ones, but, you can also make your own!
* Helpers are useful when they hide complexity that isn't relevant to the template.
* You've been using them already! `link_to` `text_field`
* Together, we're going to give album names SPARKLES.
* On your own, find some helper to implement.


* [Rails Form Helpers](http://guides.rubyonrails.org/form_helpers.html)
* [Rails Helper Method Catalog](http://www.oreillynet.com/pub/a/ruby/excerpts/ruby-learning-rails/ruby-catalog-helper-methods.html)
* [Custom View Helpers in Rails](http://www.rails-dev.com/custom-view-helpers-in-rails-4)
* [The Beginner's Guide to Rails Helpers](http://mixandgo.com/blog/the-beginner-s-guide-to-rails-helpers)

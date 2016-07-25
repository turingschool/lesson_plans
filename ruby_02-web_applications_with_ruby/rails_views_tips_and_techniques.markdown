---
title: Rails Views: Tips, Techniques, and Tricks
length: 60
tags: views, rails, helpers, partials
---

## Learning Goals
* Refactor views to remove database queries
* Use partials to tidy up repeated code
* Use built-in Rails Helper methods
* Use custom helper methods

### Hook
* Today we are going to talk about views techniques that will make sure you are writing clean code.

## Repository
* [Repo for lesson](https://github.com/mikedao/i-really-like-you)

### Opening
* Today we are going to talk about three big ideas.
* One: Refactor your views to remove database queries from your views.
* Two: You can use partials to handle repeated code - always keep things DRY.
* Three: Helper methods are there to help you.

### One - Removing Database Queries from your Views
* Views should **not** contain database queries.
* Data should be prepared in the controller and model.
* Logic should be _absolutely_ minimal in views.
* Let's look at our repo. Checkout the idea_one branch.
* Look at the albums#index view.
* How do we refactor that?
* Now, on your own, refactor the album#show view.

### Two - Partials Can Be Used to Tidy Up and Reuse Pieces of Code
* When we are writing ruby and we have some repeated code, what do we do?
* We refactor by pulling it out to another method.
* We can do sort of the same things in our views.

### What is a partial?
* It's a file that contains code that will be reused.
* `_filename.html.erb` - the covention for naming partials is to begin the name with an underscore.
* A good example is think about a basic CRUD app. Isn't the same code in both the new and edit views?
* Let's pull that out into a form.

### Other things to know about partials.
* You could render a partial like so <%= 'albums' %>
* That line looks for `_albums.html.erb` and renders that file.
* Instance variables are automatically shared by both views and partials.
* You need to pass local variables explicitly.
* `<%= render partial: ‘filename’, locals: { person: @child } %>`
* **Notice**- there's no underscore for filename when calling render `<=% render 'filename' %>`
* You must specify the partial you are rendering if you're going to use locals.
* You might want by default use partial - it's more readable.
* Partials can be shared if you put it in the `app/views/shared` folder
* You render a shared partial like so: `<%= render partial: 'shared/filename' %>`
* Let's pull out the @albums together.
* Now, you make an edit, and pull out that form.

### Three: Helper methods are available within views and sometimes controllers.
* There are some built in ones, but, you can also make your own!
* Example: `current_user` defined in `ApplicationController` and `helper_method :current_user`
* Helpers are useful when they hide complexity that isn't relevant to the template (this is the majority of the time).
* You've been using them already! `link_to` `text_field` `form_for` are all built in helpers

### Built In Rails View Helpers
* `number_to_currency(1234567890.50) # => $1,234,567,890.50`
* `number_to_percentage(100, precision: 0)        # => 100%`
* `time_ago_in_words(3.minutes.from_now)  # => 3 minutes`
* `distance_of_time_in_words(Time.now, Time.now + 15.seconds)        # => less than a minute`

Together, we're going to give album names SPARKLES. Then, let's look at some other examples of when you need to create custom view helpers. On your own, find some helper to implement.

### Resources
* [Rails Form Helpers](http://guides.rubyonrails.org/form_helpers.html)
* [Rails Helper Method Catalog](http://www.oreillynet.com/pub/a/ruby/excerpts/ruby-learning-rails/ruby-catalog-helper-methods.html)
* [Custom View Helpers in Rails](http://www.rails-dev.com/custom-view-helpers-in-rails-4)
* [The Beginner's Guide to Rails Helpers](http://mixandgo.com/blog/the-beginner-s-guide-to-rails-helpers)

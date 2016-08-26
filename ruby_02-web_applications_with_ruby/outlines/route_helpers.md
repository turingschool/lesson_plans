---
title: Rails Route Helpers

tags: routes, helpers
---


### Goals

By the end of this lesson, you will know/be able to:

  * Run `rake routes` to find information about your routes.
  * Understand the 5 pieces of information this `rake routes` gives us.
  * Use a route helper to easily refer to a relative and absolute path.
  * Understand the difference between what `_url` and `_path` return when combined with a routes prefix.
  * Use a link helper to make writing html links easier.
  * Find a routes prefix and use that prefix to build a helper.

### Review

What is CRUD again?

  * Create
  * Read
  * Update
  * Delete

### Warmup

In pairs, one of you write the CRUD routes for `song`, one for `phone`. If you're in a group of three, have the third person write the routes for `sticker`.

With your partner, do you notice any repetition or patterns in the routes that you wrote?

Large group share.

### Practice

#### Routes

Clone down [this repo](https://github.com/Carmer/helpers_playground).

  `git clone https://github.com/Carmer/helpers_playground`

Now go to the `routes.rb` file.

Let's create a `resources` line for each of the entities below and then run `rake routes` from the terminal:

  * Song
  * Phone
  * Sticker

`rake routes` gives you output in tabular format.

* What are the headers of the table that it gives you?
* With your partner, take a look at the entries in the table that `rake routes` gives you and fill out the table below in your notebook or on your computer.

|`rake routes` Table Heading|Exampe Entry|Potential Definition|
|---------------------------|------------|--------------------|
|                           |            |                    |

Fill in "Potential Definition" with your understanding of what what the column represents/how it can be used. If you're unsure of a definition, enter your best guess.

Large group share.

#### Route Helpers

* Start your server with `rails s`.
* Navigate to localhost:3000/artists. You should see each of the artist name as a link
* In your text editor, open up `app/views/artists/index.html.erb`. Right now, the code to make each individual article link looks like this:

```html
  <a href="/artists/<%= artist.id %>"><%= artist.name %></a>
```

Let's replace the code above with the following:

```erb
  <%= link_to artist.name, artist_path(artist.id) %>
```

Now open the artists show page, `app/views/artists/show.html.erb`. It should still render. Take a look at the `link_to` documentation available [here](http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to) especially the Examples section. **Note:** some of the code examples provided are examples of older ways of doing things. Make sure to read the language around the examples so that you know what the current preference is for how to use `link_to`.

With your partner, answer the following questions:

* What are the two arguments that are needed to create a link using `link_to`? Additional arguments can be included, but what's the bare minimum?
* Can you provide an alternative ("pithier") way to write the `link_to` method above for an individual artist based on the documentation? Try it and see if it still works. Either of these are valid. Do you have a preference between the two? Why?
* Look back at the table you created about `rake routes` output. What is the relationship between the output from `rake routes` and the arguments that you pass `link_to`?
* Can you use the `link_to` method to insert a link on this page that will send us back to the artists index view?

Large group share.


### For CodeAlong time this afternoon:

We will be building BookShelf. It is an app that we will use for some homework assignments and other lessons. You can find the directions and [tutorial here](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/outlines/forms_and_route_helpers_in_rails.markdown)

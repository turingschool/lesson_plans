---
title: Rails Route Helpers

tags: routes, helpers
---


### Goals

By the end of this lesson, you will know/be able to:

  * Run a command that can find all the information about your routes - know what 5 pieces of information this tool gives us.
  * Use a link helper to make writing html links easier.
  * Use a route helper to easily refer to a relative and absolute path.
  * Find a routes prefix and use that prefix to build a helper.

### What is CRUD again?

  * Create
  * Read
  * Update
  * Delete

### What are the specific CRUD routes I get:

  * If I am modeling the entity `:song`?
  * If I am modeling the entity `:phone`?
  * If I am modeling the entity `:product`?
  * If I am modeling the entity `:sticker`?

##### Do you notice any repetition or patterns here?

### Let's go practice hands on

#### Routes

  Clone down [this repo](https://github.com/Carmer/helpers_playground).

  `git clone https://github.com/Carmer/helpers_playground`

  Now go to the `routes.rb` file.

  Let's create a `resources` for each of the entities above and look at the `rake routes`:
    * Song
    * Phone
    * Product
    * Sticker

What is a prefix?
What is a URI pattern?
What 5 things to we get from rake routes?

#### Route Helpers

  * Start your server with `rails s`.
  * Navigate to localhost:3000/artists. You should see each of the artist name as a link
  * In your text editor, open up `app/views/artists/index.html.erb`. Right now, the code to make each individual article link looks like this:

  ```html
    <a href="/artists/<%= artist.id %>"><%= artist.name %></a>
  ```


  Can we replace this link with some code that may make this process of building this link easier?


  * Now open the artists show page, `app/views/artists/show.html.erb`.
  * Can you use the `link_to` method to insert a link on this page that will send us back to the artists index view?


### For CodeAlong time this afternoon:

  We will be building ToolChest. It is an app that we will use for some homework assignments and other lessons. You can find the directions and [tutorial here](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/forms_and_route_helpers_in_rails.markdown)

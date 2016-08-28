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

Write the CRUD routes for a project with a `mouse` model. How would you create these routes in a rails project?

Compare your solutions with a neighbor.

Large group share.

### Practice

#### Routes

Clone down [this repo](https://github.com/Carmer/helpers_playground).

`git clone https://github.com/Carmer/helpers_playground`

Now go to the `routes.rb` file.

Let's create a `resources` line for `song` and then run `rake routes` from the terminal:

`rake routes` gives you output in tabular format.

* What are the headers of the table that it gives you?
* With your partner, take a look at the entries in the table that `rake routes` gives you and fill out the table below in your notebook or on your computer.

|Table Heading       |Prefix|Verb|URI Pattern|Controller#Action|
|--------------------|------|----|-----------|-----------------|
|Example Entry       |      |    |           |                 |
|Potential Definition|      |    |           |                 |

Fill in "Potential Definition" with your understanding of what what the column represents/how it can be used. If you're unsure of a definition, enter your best guess.

Large group share.

#### Route Helpers

* `bundle`
* `rake db:create`
* `rake db:migrate`
* `rake db:seed`
* Start your server with `rails s`.
* Navigate to localhost:3000/artists. You should see each of the artist name as a link
* In your text editor, open up `app/views/artists/index.html.erb`. Right now, the code to make each individual article link looks like this:

```html
  <a href="/artists/<%= artist.id %>"><%= artist.name %></a>
```

See if you can research how to use route helpers to create this link. Be sure to open the artists show page when you think you have a solution to see if it still renders properly.

With your partner, answer the following questions:

* Can you provide an alternative way to write the method above for an individual artist based on rails documentation? Try it and see if it still works. Either of these are valid. Do you have a preference between the two? Why?
* Look back at the table you created about `rake routes` output. What is the relationship between the output from `rake routes` and the arguments that you pass to this method?
* Can you use this method to insert a link on this page that will send us back to the artists index view?

Large group share.

### Independent Work

Create the model, views, controller, routes, and migrations necessary for `index` and `show` pages for `songs`

Run `rails c` to create some new songs, and see if they display appropriately on your pages.

Create link helpers to create links between the two views.

### For CodeAlong time this afternoon:

We will be building BookShelf. It is an app that we will use for some homework assignments and other lessons. You can find the directions and [tutorial here](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/outlines/forms_and_route_helpers_in_rails.markdown)

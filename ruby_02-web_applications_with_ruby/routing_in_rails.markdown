---
title: Routing in Rails
length: 90
tags: routing, routes
---

## Learning Goals

* define routes and helpers `resources` provides
* understand when to use a singular resource
* understand static vs dynamic segments
* The advantages and drawbacks of using a namespace
* understand How a namespace compares to a scope

### Hook

* What exactly are routes?
* What does rails give us to help us build things quickly?
* Routes in rails lets us control the URLs that our users see.

### Background
This lesson is intended to build upon the concepts from
[Rest, Routing, and Controllers in Rails](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/rest_routing_and_controllers_in_rails.markdown).

### The Rails Router

* The Rails Router recognizes URLs and connects them to code, specifically
in our controllers.
* It can generate paths and URLs, so we don't ever have to hard code strings
in our views.

### Resources

* Resource routing allows you to quickly declare all of the common routes for
a given resourceful controller. Instead of declaring separate routes for your
index, show, new, edit, create, update and destroy actions, a resourceful route
declares them in a single line of code.
* Together, in our worksheet, let's fill out what we get when we have
`resources :photos` in our routes.rb.
* These are all of the resources. Of course, we can limit it to individual
items using only.
* We can "stack" resources like so, `resources :photos, :things, :more_things`

### Singular Resources

* We can use singular resources when we want to have a URL that doesn't quite
match.

`get 'dashboard', to:'users#show'`

* This can be something used in a website where you don't necessarily need
the user id in the URL.

### Check for Understanding

* Write out the singular resource equivalents in our photos chart.

### Dynamic versus Static Segments

* What is a static segment?
* How does that compare to a dynamic segment?
* What is an example of a dynamic segment?

`get 'books/:id', to: 'books#show'`

`@book = Book.find(params[:id])`

* Here, :id is the dynamic segment.
* We are saying that we want to find whatever book it is that has the id
number given after books/
* However, that isn't very pretty. Sometimes we don't want to deal with id
numbers because they are weird.

`get 'books/:name', to: 'books#show'`

`@book = Book.find_by(name: params[:name])`

* We can define how this information is stored in params, and we can define
just how we can search for it in our controller.
* If we wanted to we can mix and match how we define it in our params and how
we search for it. But don't. Be consistent. Remember the principle of
least surprise.

`get 'books/:thing', to: 'books#show'`

`@book = Book.find_by(name: params[:thing])`

* So, resources lets us take what would be potentially seven lines of code
and compresses it down to a single line.
* Can we override the default dynamic segments that resources gives us?

`resources :books, param: :title`

`@book = Book.find_by(title: params[:title])`


### Scope and Module

* We also have scope to contend with.

```
scope '/admin' do
  resources :photos
end
```

* With scope, we don't put the controllers into an admin folder and the
controllers do NOT inherit from Admin.
* So what's the difference here?
* It's all in where it routes.

```
scope "/admin" do
  resources :photos
end
```

* This routes to app/controllers/photos_controller.rb
* What URL helpers do you think this generates?
* They look like photos_path.
* What we can do is we can use a scope and make it inherit from admin,
and we can sort them into an admin folder.
* We use module to do this.

```
scope "/admin", module: "admin" do
  resources :photos
end
```

* This hits app/controllers/admin/photos_controller.rb
* The URL helper is still similar to photos_path.
* Namespace automatically adds module, and also gives us a more descriptive
URL helper, like we were using as:.

```
namespace "admin" do
  resources :photos
end
```

* This routes to app/controllers/admin/photos_controller
* The URL helpers are similar to admin_photos_path

```
scope “/admin”, as: “admin”, module: “admin” do
  resources :photos
end
```

```
namespace “admin” do
  resources :photos
end
```

### Namespace

* Namespaces lets us organize controllers better.
* The most common example of this is putting things into an Admin:: namespace.
* Let's take our photos example.
* You would put your photos controllers in app/controllers/admin

```
namespace :admin do
  resources :photos
end
```

### Check for Understanding

* Why do we namespace things?
* What is the difference between Namespacing and Scoping?
* When would we use one over the other?

### Nested Resources

* Consider magazines and ads.
* Magazines have many ads. Ads belong to a magazine.

```
class Magazine < ActiveRecord::Base
  has_many :ads
end

class Ad < ActiveRecord::Base
  belongs_to :magazine
end


# Routes file

resources :magazines do
  resources :ads
end
```

* Let's fill out our chart.

### Resources (As in additional materials)

[Slides](https://www.dropbox.com/s/is9rijwt7tel25f/routing_in_rails.key?dl=0)

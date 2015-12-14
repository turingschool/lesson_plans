---
title: REST, Routing, and Controllers in Rails
length: 90
tags: rest, routing, controllers, routes
---

## Prework

Read [this article](http://www.theodinproject.com/ruby-on-rails/routing). 

## Warmup 

With a partner, discuss the following questions: 

1) What is the purpose of the "controller" in a Sinatra application?

2) Rails separates routes from controllers (unlike Sinatra). What might this division look like?

## Learning Goals

* explain the purpose of the `routes.rb` file
* interpret the output of `rake routes`
* explain the connection between `routes.rb` and controller files
* create routes by hand 
* create routes using `resources :things`


## Intro to REST

* Representational State Transfer is a web architecture style
* Coined by Roy Fielding in doctoral dissertation (2000)
* Aims to give a URI (uniform resource identifier) to everything that can be manipulated and let the software determine what to do from there
* [Representational State Transfer](https://en.wikipedia.org/wiki/Representational_state_transfer) on Wikipedia
* [What is Rest?](http://www.restapitutorial.com/lessons/whatisrest.html) from REST API Tutorial

### So... what is REST in English? 

* a pattern for creating combinations of HTTP verbs and URIs to access resources

```
get /users
put /users/:id
get /users/new 
...etc...
```

### What is a "resource"?

“A resource is a conceptual object that has identity, state, and behavior," such as:

* a document 
* home page
* search result
* a session

## HTTP Verb Overview

* The HTTP verb (get, post, delete, put, patch) changes the action a request is routed to.
* HTTP verb + path = controller + action

**get**: retrieve a resource from a url

**post**: create a new resource

**delete**: remove/destroy a resource

**put**: update an entire resource

**patch** (new in Rails 4): update part of a resource

## Routes + Controllers in Rails

"Convention over configuration"

```
$ rails new routes-controllers-example
$ cd routes-controllers-example
```

Let's take a few minutes to explore what `rails new` generates. 

In `config/routes.rb`:

```ruby 
Rails.application.routes.draw do
  get '/tasks', to: 'tasks#index'
end
```

From the command line, see which routes you have available: `$ rake routes`. You should see this output:

```
Prefix Verb URI Pattern      Controller#Action
 tasks GET  /tasks(.:format) tasks#index
```

This means whenever a `get` request to `/tasks` is received, have the `tasks`_controller handle it with the `index` action (method). The `(.:format)` thing on the end of the URI pattern refers to things like `http://example.com/tasks.csv` or `http://example.com/tasks.pdf`, etc.

Based on our rake routes - what controller to we need? do we have it?

Make a tasks controller:

```
$ touch app/controllers/tasks_controller.rb
```

Naming is important. The name of the file should be the plural of what it is handling (in this case, tasks). 

Inside of that file:

```ruby
class TasksController < ApplicationController
  def index
    render :text => "hello world"
  end
end
```

What is ApplicationController? Look at the controllers folder and you should see an `application_controller.rb` file. This file defines the `ApplicationController` class, which (generally) all of your other controllers will inherit from. 

Notice that the name of the class matches the name of the file (tasks_controller.rb => class TasksController), one snake-cased and one camel-cased. 

Normally we would not put in the line `render :text => "hello world"`. Without the render line, Rails will automatically look for a view inside of a folder with the same name as the controller (`tasks` folder), then look for a view with the same name as the method (`index.erb`). However, we are not going to deal with views today, so rendering text is the easiest way to see if a route is working.

Start up your rails server: `rails server` or `rails s` from the command line. 

Navigate to `localhost:3000/tasks` and you should see your text.

### Workshop

1) Can you create a route that would bring the user to a form where they can enter a new task? 

2) Can you create a route that would allow a user to see one task? Just like in Sinatra, the route will need a changeable `/:id`. 

3) Can you create a route that would allow a user to get to the edit page for a task? Again, the route will need a changeable `/:id`. 

4) For the previous two routes (show and edit), can you get the `params[:id]` to display in the text that you render? 

In Sinatra, you could access the `:id` from the URL like this:

```ruby
get '/tasks/:id' do |id|
  puts id
end
```

In Rails, you'll need to use `params[:id]`. 

### Using Resources in the Routes File

Change your `routes.rb` file to this:

```ruby 
Rails.application.routes.draw do
  resources :tasks
end
```

Now let's look at the routes we have available: `$ rake routes`.

Using `resources :things` gives us eight RESTful routes that correspond to CRUD functionality. 

```
   Prefix Verb   URI Pattern               Controller#Action
    tasks GET    /tasks(.:format)          tasks#index
          POST   /tasks(.:format)          tasks#create
 new_task GET    /tasks/new(.:format)      tasks#new
edit_task GET    /tasks/:id/edit(.:format) tasks#edit
     task GET    /tasks/:id(.:format)      tasks#show
          PATCH  /tasks/:id(.:format)      tasks#update
          PUT    /tasks/:id(.:format)      tasks#update
          DELETE /tasks/:id(.:format)      tasks#destroy
``` 

Any methods with `/:id/` require an id to be passed into the URL. Remember this when we talk about route helpers tomorrow :)

(Why PATCH and PUT? Read more about it on the Rails Weblog [here](http://weblog.rubyonrails.org/2012/2/26/edge-rails-patch-is-the-new-primary-http-method-for-updates/).)

Questions: 

* What actions (methods) would we need in our `tasks`_controller in order to handle all of these routes?
* Which actions would render a form and which actions would redirect? (Think of TaskManager in Sinatra)

Don't worry about putting `render :text` in these actions. You won't be able to test out post, patch, put, or delete by navigating in your browser. 

If you add a whole bunch of `resources :things` to your routes file, it will generate these eight routes for all of the things you've specified:

```ruby 
Rails.application.routes.draw do
  resources :tasks
  resources :buildings
  resources :hosts
end
```

Now try `$ rake routes`.

### Other things

* We can add a route for our root with:

```ruby 
Rails.application.routes.draw do
  root 'tasks#index'
end
```

This will direct any get request to `localhost:3000` to the `tasks_controller.rb` `index` action. 

### Homework

* [Routes and Controllers Assignment](https://github.com/turingschool/challenges/blob/master/routes_controllers_rails.markdown)

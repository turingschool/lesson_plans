---
title: REST, Routing, and Controllers in Rails
length: 90
tags: rest, routing, controllers, routes
---

## Learning Goals

* explain the purpose of the `routes.rb` file
* interpret the output of `rake routes`
* explain the connection between `routes.rb` and controller files

## Warmup 

With a partner, discuss the following questions: 

1) What is the purpose of the "controller" in a Sinatra application?

2) Rails separates routes from controllers (unlike Sinatra). What might this division look like?

## Intro to REST

* Representational State Transfer is a web architecture style
* Coined by Roy Fielding in doctoral dissertation (2000)
* Aims to give a URI (uniform resource identifier) to everything that can be manipulated and let the software determine what to do from there

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

## Intro to Routing in Rails

"Convention over configuration"

* The HTTP verb (get, post, delete, put, patch) changes the action a request is routed to.
* HTTP verb + path = controller + action

**get
retrieve a resource from a url

**post
create a new resource

**delete
remove/destroy a resource

**put
update an entire resource

**patch (new in Rails 4)
update part of a resource

## Routes + Controllers in Rails

```
$ rails new routes-controllers-example
```

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

This means whenever a `get` request to `/tasks` is received, have the `tasks`_controller handle it with the `index` action (method).

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

Notice that the name of the class matches the name of the file (tasks_controller.rb => class TasksController), one snake-cased and one camel-cased. 

Normally we would not put in the line `render :text => "hello world"`. However, we are not going to deal with views today, so rendering text is the easiest way to see if a route is working.

Start up your rails server: `rails server` or `rails s` from the command line. 

Navigate to `localhost:3000/tasks` and you should see your text.

Can you create a route that would bring the user to a form where they can enter a new task? 
Can you create a route that would allow a user to see one task? Just like in Sinatra, the route will need a changeable `/:id`. 
Can you create a route that would allow a user to get to the edit page for a task? Again, the route will need a changeable `/:id`. 
In Sinatra, you could access the `:id` from the URL like this:

```ruby
get '/tasks/:id' do |id|
  puts id
end
```

In Rails, you'll need to us `params[:id]`. For the previous two routes (show and edit), can you get the `params[:id]` to display in the text that you render? 

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

(Why PATCH and PUT? Read more about it on the Rails Weblog [here](http://weblog.rubyonrails.org/2012/2/26/edge-rails-patch-is-the-new-primary-http-method-for-updates/).)

What actions (methods) would we need in our `tasks`_controller in order to handle all of these routes?

Which actions would render a form and which actions would redirect? (Think of TaskManager in Sinatra)

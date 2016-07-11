## REST, Routing, and Controllers in Rails

### Prework

Read this [article](http://www.theodinproject.com/ruby-on-rails/routing).

### Homework Wrap-Up

### Warmup

1) What is the purpose of the "controller" in a Sinatra application?

2) Rails separates routes from controllers (unlike Sinatra). What might this division look like?


### Learning Goals

* understand the concept of REST
* explain the purpose of the `routes.rb` file
* interpret the output of rake routes
* explain the connection between `routes.rb` and controller files
* create routes by hand
* create routes using `resources :things`

### Intro to **REST**

* Representational State Transfer is a web architecture style

* Coined by Roy Fielding in doctoral dissertation (2000)

### What's the purpose of **REST**?

Aims to give a URI (uniform resource identifier) to everything that can be manipulated and let the software determine what to do from there

### What is **REST** in English?

A pattern for creating combinations of HTTP verbs and URIs to access resources

```
get /users
put /users/:id
get /users/new 
...etc...
```

### What is a **resource**?

A resource is a conceptual object that has identity, state, and behavior," such as:

- a document
- home page
- search result
- a payload request


### Sinatra & REST

Remember two weeks ago when we looked at the seven routes we were going to be creating with `TaskManager`? We were already following REST conventions!

```
get '/tasks'
# showed all tasks

get '/tasks/new'
# shows form to create new task

post '/tasks'
# creates a new task
```

### Rails & **REST**

In Rails, our HTTP verb and path (`get '/tasks'`) corresponds with a specific controller and action that we will define in a `routes.rb` file.

Let's review real quick - what's the purpose or action associated with these HTTP verbs?

* GET
* POST
* PUT/PATCH
* DELETE


### Routes + Controllers in Rails

"Convention over configuration"

Let's create a new rails project by running the following command:

```
rails new name-of-project-here
```

Rails generates a LOT of files for us; thus, the saying "convention over configuration". By default, Rails configures the application for us. We simply (sometimes not so simply) need to follow the conventions Rails has set up.
 
Let's take a few minutes to explore what rails new generates.

### Routes

Check out `config/routes.rb`. Thankfully, Rails does a pretty good job of documention the conventions it wants us to follow. If you read through this file, Rails documents how you should implement your routes. 

Let's say we added our own route to the `config/routes.rb` file so:

```
get '/tasks', to: 'tasks#index'
```

Awesome. How do we know if this even did anything? 

From the command line, we can see which routes we have available by running a handy rake command: `rake routes`, which gives us this output: 

```
Prefix Verb URI Pattern      Controller#Action
 tasks GET  /tasks(.:format) tasks#index
```

This output gives us a great deal of information. It tells us that whenever a `GET` request to the endpoint `/tasks` is received, have the `tasks`_controller handle it by executing the `index` action (method). 

_Note_: The `(.:format)` on the end of the URI pattern refers to handling routes like `http://example.com/tasks.csv` or `http://example.com/tasks.pdf`, etc.

**Based on our rake routes - what controller to we need? do we have it?**

Let's make a tasks controller. Be careful - naming is important. The name of the file should be the plural of what it is handling (in this case, tasks). We need to create the following file: `app/controllers/tasks_controller.rb`.

Now, we can create the action that corresponds with the route we've already created.

```
class TasksController < ApplicationController
  def index
    render :text => "hello world"
  end
end
```

### What is ApplicationController? 

If we look at the controllers folder, we'll see an application_controller.rb file (Rails generated this for us). This file defines the `ApplicationController` class, which (generally) all of your other controllers will inherit from.

Notice that the name of the class matches the name of the file (`tasks_controller.rb => class TasksController`), one snake-cased and one camel-cased.

Normally we would not put in the line render :text => "hello world". Without the render line, Rails will automatically look for a view inside of a folder with the same name as the controller (`tasks` folder), then look for a view with the same name as the method (index.erb). However, we are not going to deal with views today, so rendering text is the easiest way to see if a route is working.

If we start up our rails server by running `rails server` or `rails s` from the command line, and navigate to `localhost:3000/tasks`, we should see our text.

### Workshop

1) Can you create a route (following RESTful conventions) that would bring the user to a form where they can enter a new task?

2) Can you create a route (following RESTful conventions) that would allow a user to see one task? Just like in Sinatra, the route will need a changeable /:id.

3) Can you create a route (following RESTful conventions) that would allow a user to get to the edit page for a task? Again, the route will need a changeable /:id.

4) For the previous two routes (show and edit), can you get the params[:id] to display in the text that you render?

### Accessing params

In Sinatra, we accessed params using the following syntax:

```
get '/tasks/:id' do |id|
  puts id
end
```

In a Rails controller method, we can access them via the local variable `params` like so:

```
class TasksController < ApplicationController
  def show
    puts params[:id]
  end
end
```

### Using Resources in the Routes File

What are the common CRUD actions? They match up to eight routes. Can you name all of them?

Since Rails is all about "convention over configuration", it has a nice way of allowing us to easily create all eight RESTful routes at one time via a shortcut. 

We can use the shortcut `resources`. As an example, we can change our `config/routes.rb` file to to look like this:

```
Rails.application.routes.draw do
  resources :tasks
end
```

Now, if we look at the routes we have available by running the rake command (`rake routes`) from our command line we'll see all eight routes!

Using `resources :tasks` gives us eight RESTful routes that correspond to CRUD functionality.

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

Any methods with `:id` require an id to be passed into the URL. These values are dynamically added (like viewing the seventh task via `/tasks/7`). Remember this when we talk about route helpers tomorrow. 

What actions (methods) would we need in our `tasks_controller` in order to handle all of these routes?

Which actions would render a form and which actions would redirect? (Think of `TaskManager` in Sinatra)


### Adding a root

What happens when we hit our root of our application - or `localhost:3000` or `www.cutecats.com`? 

We can use the `root` helper to define how our application will handle that `GET` request to `/`.


```
Rails.application.routes.draw do
  root 'tasks#index'
end
```

### Homework

[Routes and Controllers](https://github.com/turingschool/challenges/blob/master/routes_controllers_rails.markdown)
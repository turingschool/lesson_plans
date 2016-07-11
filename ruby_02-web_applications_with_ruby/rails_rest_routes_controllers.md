## REST, Routes, and Controllers in **Rails**

---

## Homework Review

---

## What is the purpose of the **router** in a Rails project?

---

## What **routes** would be provided to you with the line `resources :items`?

---

### What does `root :to => "items#index"` represent? 
<br>
### How would you access that route in a web app?

---
## What **rake** task is useful when looking at routes, and what information does it give you?

---

## How would you **interpret** this output?

```
items GET /items(.:format) items#index
```

---

## Warmup

1) What is the purpose of the "controller" in a Sinatra application?

2) Rails separates routes from controllers (unlike Sinatra). What might this division look like?

---

## Learning Goals

* understand the concept of REST
* explain the purpose of the `routes.rb` file
* interpret the output of rake routes
* explain the connection between `routes.rb` and controller files
* create routes by hand
* create routes using `resources :things`

---

## Intro to **REST**

**Representational State Transfer** is a web architecture style

Coined by Roy Fielding in doctoral dissertation (2000)


---

## What's the purpose of **REST**?

Aims to give a URI (uniform resource identifier) to everything that can be manipulated and let the software determine what to do from there


---
## What is **REST** in English?

A pattern for creating combinations of HTTP verbs and URIs to access resources

```
get /users
put /users/:id
get /users/new 
...etc...
```

---
## What is a **resource**?

A resource is a conceptual object that has identity, state, and behavior," such as:

- a document
- home page
- search result
- a payload request

---

## Sinatra & REST

```ruby
get '/tasks'
# showed all tasks

get '/tasks/new'
# shows form to create new task

post '/tasks'
# creates a new task
```

---

### Rails & **REST**

### HTTP verb + path => controller + action

---

## What's the purpose or action  associated with these HTTP verbs?
* GET
* POST
* PUT/PATCH
* DELETE

---

# **GET**

Retrieves a resource from a url

---

# **POST**
Creates a new resource

---

# **DELETE** 

Removes/destroys a resource

---

# **PUT**
Updates an entire resource

# **PATCH** 
Updates part of a resource

---

### Rails & **REST**

### HTTP verb + path => controller + action

---
## Routes & Controllers in Rails

"Convention over configuration"

---

## Code Along

---

1) Can you create a route (following RESTful conventions) that would bring the user to a form where they can enter a new task?

---

2) Can you create a route (following RESTful conventions) that would allow a user to see one task? Just like in Sinatra, the route will need a changeable /:id.

---

3) Can you create a route that would allow a user to get to the edit page for a task? Again, the route will need a changeable /:id.

---

4) For the previous two routes (show and edit), can you get the params[:id] to display in the text that you render?

---

## Accessing `params`

In Sinatra:

```
get '/tasks/:id' do |id|
  puts id
end
```

---

## Accessing `params`

In Rails:

```
def show
	puts params[:id]
end
```

---

## Rake Routes

```
Prefix Verb URI Pattern      Controller#Action
 tasks GET  /tasks(.:format) tasks#index
```
---

## Using Resources

`resources :tasks`

---

* What actions (methods) would we need in our `tasks_controller` in order to handle all of these routes?

* Which actions would render a form and which actions would redirect? (Think of `TaskManager` in Sinatra)

---

## Adding a root

```
Rails.application.routes.draw do
  root 'tasks#index'
end
```

`localhost:3000`
---

---

---
---
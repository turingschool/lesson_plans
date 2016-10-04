---
title: CRUD in Sinatra Redux
length: 120
tags: crud, sinatra
---

### Goals

By the end of this lesson, you will know/be able to:

* define CRUD in the programming sense of the word
* add functionality to complete the *U*pdate and *D*elete functionality of CRUD for a Sinatra app
* divide responsibilities between the controller, views, and models

### Structure

* Lecture
* Workshop
* Recap

### Repository

* If you have been following the [TaskManager](https://github.com/s-espinosa/task_manager_redux) tutorials up to this point, you should be able to use the version you already have.
* If not, clone the [TaskManager Repo](https://github.com/s-espinosa/task_manager_redux), and switch to the crud-lesson branch.

### Warm Up

* What does CRUD stand for and why is it important?
* What CRUD functionality are we missing in TaskManager?
* How would you write a raw SQL statement to update a task's title and description for task with id 6?
* What does MVC stand for? Create a diagram of the MVC pattern.
* What part of the MVC does `task_manager_app.rb` represent in our current TaskManager app? What about `task.rb`?

### CRUD Introduction

Assuming we want to create full CRUD functionality in our Sinatra app for users accessing our site through a browser, there are seven routes that we will need to define. Let's make a chart together.

(Here's a [completed chart](https://www.dropbox.com/s/vx3ocfsusjdrgfw/crud_in_sinatra.pdf?dl=0), but don't open it until you're finished!)

### Workshop

We're going to follow the MVC design pattern (Rails uses this by default, but in Sinatra we will need to create this structure ourselves) to implement the CRUD actions we're missing.

So far, we are able to create a task and read a task. How do we add functionality to update and delete tasks?

#### Editing a task

Our **edit** route should bring the user to a form where they can change the title and description of the task. In order to create this functionality, we'll need to create a button to get to the edit page, a route in our controller for that link, and a view that will be rendered when we hit the new route.

In our `index.erb` view:

```erb
<h1>All Tasks</h1>

<% @tasks.each do |task| %>
  <h3><a href="/tasks/<%= task.id %>"><%= task.title %></a></h3>
  <p><%= task.description  %></p>
  <a href="/tasks/<%= task.id %>/edit">Edit</a>
<% end %>
```

In our controller:

```ruby
  get '/tasks/:id/edit' do
    @task = Task.find(params[:id])
    erb :edit
  end
```
In our view, `edit.erb`:

```erb
<form action="/tasks/<%= @task.id %>" method="post">
  <p>Edit</p>
  <input type="hidden" name="_method" value="PUT" />
  <input type='text' name='task[title]' value="<%= @task.title %>"/><br/>
  <textarea name='task[description]'><%= @task.description %></textarea><br/>
  <input type='submit'/>
</form>
```

One quick note about the form: you'll notice that there's a hidden field with a value of `PUT`. Normally, HTML forms only allow `GET` or `POST` requests (see more information [here](http://www.w3schools.com/tags/att_form_method.asp)). 

We're going to want this form to access a route in our controller (that we'll create momentarily) using `PUT` to be consistent with conventions about the HTTP verb that is used when updating a resource (take a quick look at [this table](http://www.restapitutorial.com/lessons/httpmethods.html) if this is new information). 

HTML won't allow us to use `method='put'` in our `form` tag, but passing it as a hidden value gives our controller the information it needs to route the request correctly.

#### Updating a task

Our new form needs somewhere to go when a user clicks submit. We'll use the **update** route to do the work of changing the task in the database.

In our controller:

```ruby
  set :method_override, true  # this allows us to use _method in the form
  ...
  put '/tasks/:id' do |id|
    Task.update(id.to_i, params[:task])
    redirect "/tasks/#{id}"
  end
```

In our TaskManager model:

```ruby
  def self.update(id, task_params)
    database.execute("UPDATE tasks
                      SET title = ?,
                          description = ?
                      WHERE id = ?;",
                      task_params[:title],
                      task_params[:description],
                      id)

    Task.find(id)
  end
```

#### Deleting a task

We don't need a form to delete a task, we just need to know which task we want to delete. We'll use a form to send a `DELETE` request to a route with our task id.

In our `index.erb` view:

```erb
<% @tasks.each do |task| %>
  <h3><a href="/tasks/<%= task.id %>"><%= task.title %></a></h3>
  <p><%= task.description %></p>
  <a href="/tasks/<%= task.id  %>/edit">Edit</a>
  <form action="/tasks/<%= task.id %>" method="POST">
    <input type="hidden" name="_method" value="DELETE">
    <input type="submit" value="delete"/>
  </form>
<% end %>
```

In our controller:

```ruby
  delete '/tasks/:id' do |id|
    Task.destroy(id.to_i)
    redirect '/tasks'
  end
```

In our TaskManager model:

```ruby
  def self.destroy(id)
    database.execute("DELETE FROM tasks
                      WHERE id = ?;", id)
  end
```

### Homework & Work Time

#### Robot World

Fork [this repository](https://github.com/turingschool-examples/robot-world) and CRUD out a robot. This app should be a directory of robots. A robot has a name, city, state, and department. Users should be able to enter a robot (create), see a list of all of the robots, see each robot individually (read), edit a robot (update), and delete a robot (delete).

### Optional (possibly helpful) Setup

Want a better error page? What about a layout to connect your stylesheet? Check out the [Sinatra View Boilerplate](https://github.com/turingschool/challenges/blob/master/sinatra_view_boilerplate.markdown).

### Extensions:

* Add an avatar for each robot. Use [http://robohash.org/](http://robohash.org/) for pictures. 
* Add a dashboard that shows statistical data: a breakdown of how many robots and number of robots in each department/city/state.
* Can you use [HAML](http://haml.info/) for your html templates instead of ERB?
* Can you use a [partial](http://www.sinatrarb.com/faq.html#partials) in your views?
* Can you use the Pony gem to [send an email](http://www.sinatrarb.com/faq.html#email) from your Sinatra app?
* Can you protect your app using [HTTP Basic Auth](http://www.sinatrarb.com/faq.html#auth)?
* Use [Faker gem](https://github.com/stympy/faker) to get dynimac content in your app

### Other Resources:

* [Jumpstartlab IdeaBox Tutorial](http://tutorials.jumpstartlab.com/projects/idea_box.html)

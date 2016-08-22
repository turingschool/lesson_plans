---
title: CRUD in Sinatra
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
* Code-along
* Work Time

### Check for Understanding

Fork the [cfu_crud_in_sinatra.markdown](https://gist.github.com/Carmer/2c616bc4d840f02b5ca7879082facdbf) gist and click the edit button. 

### Repository

* [TaskManager: crud-lesson branch](https://github.com/turingschool-examples/task-manager/tree/crud-lesson): this repository is the result of completing the [TaskManager tutorial](https://github.com/JumpstartLab/curriculum/blob/master/source/projects/task_manager.markdown). If following the sequence of lessons, students should already have their own TaskManager app and should not have to clone this down.

### Review

What does CRUD stand for and why is it important?

### Lecture

We're going to follow the MVC design pattern (this is what Rails does by default - we need to be a little more intentional about it). Does anyone know what MVC stands for? Let's diagram MVC on the board.

How are `TaskManager` and `Task` related? So far, we are able to create a task and read a task. How do we add functionality to update and delete tasks?

Let's make a chart together.

(Here's a [completed chart](https://www.dropbox.com/s/vx3ocfsusjdrgfw/crud_in_sinatra.pdf?dl=0), but don't open it until you're finished!)

**Answer questions 1 & 2 from the CFU**

## Code-Along

### Editing a task

Our **edit** route should bring the user to a form where they can change the title and description of the task. The **update** route should be hit when the user submits the form and should do the work of changing the task in the database.

In our `index.erb` view:

```erb
<% @tasks.each do |task| %>
  <h3>(<%= task.id %>) <a href="/tasks/<%= task.id %>"><%= task.title %></a></h3>
  <a href="/tasks/<%= task.id %>/edit">Edit</a>
<% end %>
```

In our controller:

```ruby
  get '/tasks/:id/edit' do |id|
    @task = task_manager.find(id.to_i)
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

### Updating a task

In our controller:

```ruby
  set :method_override, true  # this allows us to use _method in the form
  ...
  put '/tasks/:id' do |id|
    task_manager.update(id.to_i, params[:task])
    redirect "/tasks/#{id}"
  end
```

In our TaskManager model:

```ruby
  def update(id, task)
    database.transaction do
      target = database['tasks'].find { |data| data["id"] == id }
      target["title"] = task[:title]
      target["description"] = task[:description]
    end
  end
```

**Answer questions 3 & 4 from the CFU**

### Deleting a task

In our `index.erb` view:

```erb
<% @tasks.each do |task| %>
  <h3>(<%= task.id %>) <a href="/tasks/<%= task.id %>"><%= task.title %></a></h3>
  <a href="/tasks/<%= task.id %>/edit">Edit</a>
  <form action="/tasks/<%= task.id %>" method="POST">
    <input type="hidden" name="_method" value="DELETE">
    <input type="submit" value="delete"/>
  </form>
<% end %>
```

In our controller:

```ruby
  delete '/tasks/:id' do |id|
    task_manager.destroy(id.to_i)
    redirect '/tasks'
  end
```

In our TaskManager model:

```ruby
  def destroy(id)
    database.transaction do
      database['tasks'].delete_if { |task| task["id"] == id }
    end
  end
```

**Answer question 5 (and any other unfinished questions) from the CFU**

### Work Time

##### Mild: Skill Inventory

Fork [this repository](https://github.com/turingschool-examples/skill-inventory-crud) and CRUD out a skill inventory. Users should be able to enter a skill (create), see a list of all of the skills, see each skill individually (read), edit a skill (update), and delete a skill (delete).

##### Spicy: Robot World

Create your own Sinatra app from scratch. This app should be a directory of robots. A robot has a name, city, state, avatar, birthdate, date hired, and department. Program the CRUD functionality for robots so that we can see all robots, see one specific robot, edit/update a robot, create a robot, and delete a robot. Use [http://robohash.org/](http://robohash.org/) for pictures. Add a dashboard that shows statistical data: average robot age, a breakdown of how many robots were hired each year, and number of robots in each department/city/state.  

### Optional (possibly helpful) Setup

Want a better error page? What about a layout to connect your stylesheet? Check out the [Sinatra View Boilerplate](https://github.com/turingschool/challenges/blob/master/sinatra_view_boilerplate.markdown).

##### Extensions for either project:

* Can you use [HAML](http://haml.info/) for your html templates instead of ERB?
* Can you use a [partial](http://www.sinatrarb.com/faq.html#partials) in your views?
* Can you use the Pony gem to [send an email](http://www.sinatrarb.com/faq.html#email) from your Sinatra app?
* Can you protect your app using [HTTP Basic Auth](http://www.sinatrarb.com/faq.html#auth)?
* Use [Faker gem](https://github.com/stympy/faker) to get dynimac content in your app

### Other Resources:

* [Jumpstartlab IdeaBox Tutorial](http://tutorials.jumpstartlab.com/projects/idea_box.html)

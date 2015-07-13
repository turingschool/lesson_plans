---
title: CRUD in Sinatra
length: 120
tags: crud, sinatra
---

First, let's add a custom error page:

In our controller:

```ruby
  not_found do
    erb :error
  end
```

Add an `error.erb` file inside of your views folder:

```erb
<h1>An Error Occured</h1>

<h3>Params</h3>
<table>
  <tr>
    <th>Request Verb</th>
    <td><%= request.request_method %></td>
  </tr>
  <tr>
    <th>Request Path</th>
    <td><%= request.path %></td>
  </tr>
  <tr>
    <th colspan=2>Parameters</th>
  </tr>
  <% request.params.each do |key, value| %>
    <tr>
      <td><%= key %></td>
      <td><%= value %></td>
    </tr>
  <% end %>
</table>
```

## Review

* How are `TaskManager` and `Task` related? 

* What is CRUD (in the programming sense of the word)? What CRUD functionality do we have in TaskManager already and what are we missing? What routes/views/methods would we need to add in order to have full CRUD functionality?

## Lecture

* C: create
* R: read
* U: update
* D: delete

So far, we are able to create a task and read a task. How do we add functionality to update and delete tasks? 

Let's make a chart.

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
    @task = TaskManager.find(id.to_i)
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
    TaskManager.update(id.to_i, params[:task])
    redirect "/tasks/#{id}"
  end
```

In our TaskManager model:

```ruby
  def self.update(id, task)
    database.transaction do
      target = database['tasks'].find { |data| data["id"] == id }
      target["title"] = task[:title]
      target["description"] = task[:description]
    end
  end
```

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
    TaskManager.delete(id.to_i)
    redirect '/tasks'
  end
```

In our TaskManager model:

```ruby
  def self.delete(id)
    database.transaction do
      database['tasks'].delete_if { |task| task["id"] == id }
    end
  end
```

### Worktime

##### Mild: Skill Inventory

Fork [this repository](https://github.com/turingschool-examples/skill-inventory-crud) and CRUD out a skill inventory. Users should be able to enter a skill (create), see a list of all of the skills, see each skill individually (read), edit a skill (update), and delete a skill (delete). 

##### Spicy: Robot World

Create your own Sinatra app from scratch. This app should be a directory of robots. A robot has a name, city, state, avatar, birthdate, date hired, and department. Program the CRUD functionality for robots so that we can see all robots, see one specific robot, edit/update a robot, create a robot, and delete a robot. Use [http://robohash.org/](http://robohash.org/) for pictures. Add a dashboard that shows statistical data: average robot age, a breakdown of how many robots were hired each year, and number of robots in each department/city/state.  

##### Extensions for either project:

* Can you use [HAML](http://haml.info/) for your html templates instead of ERB?
* Can you use a [partial](http://www.sinatrarb.com/faq.html#partials) in your views?
* Can you use the Pony gem to [send an email](http://www.sinatrarb.com/faq.html#email) from your Sinatra app? 
* Can you protect your app using [HTTP Basic Auth](http://www.sinatrarb.com/faq.html#auth)? 

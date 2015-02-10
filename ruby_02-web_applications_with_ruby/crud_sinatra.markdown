---
title: CRUD in Sinatra
length: 120
tags: crud, sinatra
---

## Learning Goals

## Lecture

* C: create
* R: read
* U: update
* D: delete

So far, we are able to create a task and read a task. How do we add functionality to update and delete tasks? 

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
    database.transaction do |db|
      target = db['tasks'].find { |data| data["id"] == id }
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
    database.transaction do |db|
      db['tasks'].delete_if { |task| task["id"] == id }
    end
  end
```

### Worktime

Clone [this repository](https://github.com/turingschool-examples/skill-inventory-crud) and CRUD out a skill inventory. Users should be able to enter a skill (create), see a list of all of the skills, see each skill individually (read), edit a skill (update), and delete a skill (delete). 

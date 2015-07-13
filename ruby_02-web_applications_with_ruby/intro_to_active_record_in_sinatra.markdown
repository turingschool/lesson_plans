---
title: Intro to ActiveRecord in Sinatra
length: 90
tags: activerecord, migrations, sinatra
---

## Goals

* generate a migration in order to create or modify a table
* interpret `schema.rb`
* set up relationships between tables at the database level using foreign keys in migrations
* set up relationships between tables at the model level using `has_many` and `belongs_to`
* use rake commands to create a database, drop a database, generate migration files, and migrate the database


## Lecture

We'll use this [ActiveRecord Skeleton Repo](https://github.com/turingschool-examples/active-record-sinatra) for today's lesson. Fork it to your Github account, clone it down, and run `bundle install`.

[What is ActiveRecord?](http://guides.rubyonrails.org/active_record_basics.html#what-is-active-record-questionmark) 
[ORM Diagram](http://wiki.expertiza.ncsu.edu/images/2/2c/ORM_Flowchart.jpg)

### Inspecting the Setup

* `Gemfile`
* `Rakefile` (find the included rake tasks [here](https://github.com/janko-m/sinatra-activerecord))
* `config/environment.rb`
* `config/database.rb`
* `config/database.yml`

### Creating the Task Table

First, we need to generate a migration file:

```
$ rake db:create_migration NAME=create_tasks
```

Inside of that file:

```ruby
class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
```

Now, run `rake db:create` to create the database. You should see an empty sqlite file now inside of your db folder. Run `rake db:migrate` to run your migrations against the database.

Inspecting the schema.rb file:

```ruby
ActiveRecord::Schema.define(version: 20150217022804) do

  create_table "tasks", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
```

### Creating the Task Model

Add a `task` model:

```
$ touch app/models/task.rb
```

Inside of that file:

```ruby
class Task < ActiveRecord::Base
end
```

By inheriting from ActiveRecord::Base, we're given a bunch of class and instance methods we can use to manipulate the tasks in our database. We no longer need a TaskManager class. These pieces of functionality will become class methods on Task (`Task.create(...)`, `Task.all`, etc.)

We'll add some tasks to our database using Tux, an interactive console for your app:

```
$ tux
>> Task.create(title: "Learn ActiveRecord", description: "so amazing")
>> Task.create(title: "Some creative task title", description: "some funny description")
>> Task.create(title: "blah", description: "blah blah")
```

In the controller: 

```ruby
class TaskManager < Sinatra::Base
  get '/tasks' do
    @tasks = Task.all
    erb :index
  end
end

```

Run `shotgun` from the command line. Visit `localhost:9393/tasks` and see your tasks! Amazing. Magical.

### Creating the User Table

A user can have many tasks, and a task belongs to a user. This means that the foreign key will live on the task. 

We'll need to create two migrations: one will create the user table, and one will add a `user_id` column to the task table.

```
$ rake db:create_migration NAME=create_users

```

Inside of that file:

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
    end
  end
end

```

Now the migration to add a user_id to the task table.

```
$ rake db:create_migration NAME=add_user_id_to_tasks

```

Inside of that file:

```ruby
class AddUserIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user_id, :integer
  end
end

```

Ok, we have two unmigrated migrations. Let's migrate: `rake db:migrate`.

Take a look at your schema.rb:

```ruby
ActiveRecord::Schema.define(version: 20150217022905) do

  create_table "tasks", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

end
```

### Associating the User and Task Models

First, create the user model: `$ touch app/models/user.rb`

Inside of that file:

```ruby
class User < ActiveRecord::Base
  has_many :tasks
end
```

This will allow us to call `user.tasks`. Behind the scenes, it will go through the task table and find all tasks where the `user_id` attribute is the same as the user it's being called on.

We'll add the opposite relationship inside of the task model:

```ruby
class Task < ActiveRecord::Base
  belongs_to :user
end
```

This will allow us to call `task.user` and get back the user object associated with that task. Behind the scenes, this is finding the user that has the id of the `user_id` column on the `task`.

### Adding Data through Tux

Let's add some users to our database:

```
$ tux
>> steve = User.create(name: "Steve")
>> raissa = User.create(name: "Raissa")
>> raissa.tasks << Task.find(1)
>> steve.tasks << Task.find(2)
>> steve.tasks << Task.find(3)
```

Another way to do this would be: `Task.find(1).update_attributes(user_id: 2)`

### Adding a users index

Let's add a `/users` route: 

```ruby
class TaskManager < Sinatra::Base
  get '/users' do
    @users = User.all
    erb :users_index
  end
end
```

Then let's create this `users_index` view:

```
$ touch app/views/users_index.erb
```

In the view:

```erb
<h1>All Users</h1>

<div id="tasks">
  <% @users.each do |user| %>
    <h1><%= user.name %></h1>
    <% user.tasks.each do |task| %>
      <h3><%= task.title %></h3>
      <p><%= task.description %></p>
    <% end %>
  <% end %>
</div>
```

Ideally, we would not be iterating through a collection inside of another iteration through a collection. We would want to pull this out to a partial and render that partial within the loop. For now though, let's leave it. 

Run `shotgun` from the command line, then navigate to `localhost:9393/tasks`. You should see the tasks sorted by user. 

### Things to Discuss

* What happens if you try to create an object when you have a model but not a table?
* What happens if you try to create an object when you have a table but not a model?
* What does `has_many` allow? What does `belongs_to` allow? Are both necessary?


### Homework

[Click here](https://github.com/turingschool/challenges/blob/master/active_record_and_database_design.markdown)


### Additional Resources

Below are a few tutorials that walk through creating a Postgres-Sinatra application that uses ActiveRecord.

* [Designing With Class: Sinatra + PostgreSQL + Heroku](http://mherman.org/blog/2013/06/08/designing-with-class-sinatra-plus-postgresql-plus-heroku/#.VOIsu1PF9h6)
* [Sinatra: Building an ActiveRecord and Postgres application](http://www.millwoodonline.co.uk/blog/sinatra-activerecord-postgres-application)
* [making-a-simple-database-driven-website-with-sinatra-and-heroku](https://samuelstern.wordpress.com/2012/11/28/making-a-simple-database-driven-website-with-sinatra-and-heroku/)


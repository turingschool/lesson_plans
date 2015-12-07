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

### Creating the Films Table

First, we need to generate a migration file:

```
$ rake db:create_migration NAME=create_films
```

Inside of that file:

```ruby
class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.text    :title
      t.date    :year
      t.integer :box_office_sales

      t.timestamps null: false
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
    t.date     "year"
    t.integer  "box_office_sales"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
```

### Creating the Film Model

Add a `film` model:

```
$ touch app/models/film.rb
```

Inside of that file:

```ruby
class Film < ActiveRecord::Base
end
```

By inheriting from ActiveRecord::Base, we're given a bunch of class and instance methods we can use to manipulate the tasks in our database. We don't need a `FilmManager` class. These pieces of functionality will become class methods on Film (`Film.create(...)`, `Film.all`, etc.)

We'll add some films to our database using Tux, an interactive console for your app:

```
$ tux
Film.create(title: "Avatar", date: 2009, box_office_sales: 760505847)
Film.create(title: "Titanic", date: 1997, box_office_sales: 658672302)
Film.create(title: "Jurassic World", date: 2015, box_office_sales: 652177271)
Film.create(title: "The Avengers", date: 2012, box_office_sales: 623279547)
Film.create(title: "The Dark Knight Rises", date: 2008, box_office_sales: 533316061)
Film.create(title: "Star Wars: Episode I - The Phantom Menace", date: 1999, box_office_sales: 474544677)
Film.create(title: "Shrek 2", date: 2004, box_office_sales: 436471036)
Film.create(title: "The Lion King", date: 1994, box_office_sales: 422783777)
```

In the controller: 

```ruby
class FilmFile < Sinatra::Base
  get '/films' do
    @films = Film.all
    erb :films_index
  end
end
```

Run `shotgun` from the command line. Visit `localhost:9393/films` and see your tasks! Amazing. Magical.

### Creating the Genre Table

Let's assume that a film belongs to a genre, and a genre has many films. This means that the foreign key will live on the film. 

We'll need to create two migrations: one will create the genres table, and one will add a `genre_id` column to the film table.

```
$ rake db:create_migration NAME=create_genres

```

Inside of that file:

```ruby
class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name
    end
  end
end

```

Now the migration to add a genre_id to the film table.

```
$ rake db:create_migration NAME=add_genre_id_to_films

```

Inside of that file:

```ruby
class AddGenreIdToFilms < ActiveRecord::Migration
  def change
    add_column :films, :genre_id, :integer
  end
end

```

Ok, we have two unmigrated migrations. Let's migrate: `rake db:migrate`.

Take a look at your schema.rb:

```ruby
ActiveRecord::Schema.define(version: 20150217022905) do

  create_table "tasks", force: :cascade do |t|
    t.text     "title"
    t.date     "year"
    t.integer  "box_office_sales"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

end
```

### Associating the Genre and Film Models

First, create the genre model: `$ touch app/models/genre.rb`

Inside of that file:

```ruby
class Genre < ActiveRecord::Base
  has_many :films
end
```

This will allow us to call `genre.films`. Behind the scenes, it will go through the films table and find all films where the `genre_id` attribute is the same as the primary key `id` of the genre it's being called on.

We'll add the opposite relationship inside of the task model:

```ruby
class Film < ActiveRecord::Base
  belongs_to :genre
end
```

This will allow us to call `film.genre` and get back the genre object associated with that film. Behind the scenes, this is finding the genre that has the primary key `id` of the `genre_id` column on the `film`.

### Adding Data through Tux

Let's add some genres to our database:

```
$ tux
animation = Genre.create(name: "Animation")
scifi = Genre.create(name: "Sci Fi")
drama = Genre.create(name: "Drama")
romance = Genre.create(name: "Romance")
```

And now we'll associate the films with their genres. 

```
animation.films << Film.find_by(name: "The Lion King")
animation.films << Film.find_by(name: "Shrek 2")
...and so on
```

Another way to do this would be: `Film.find_by(name: "Shrek 2").update_attributes(genre_id: 1)`

### Adding a users index

Let's add a `/genres` route: 

```ruby
class FilmFile < Sinatra::Base
  get '/genres' do
    @genres = Genre.all
    erb :genres_index
  end
end
```

Then let's create this `genres_index` view:

```
$ touch app/views/genres_index.erb
```

In the view:

```erb
<h1>All Genres</h1>

<div id="tasks">
  <% @genres.each do |genre| %>
    <h1><%= genre.name %></h1>
    <% genre.films.each do |film| %>
      <h3><%= film.name %></h3>
      <p><%= film.year %></p>
      <p><%= film.box_office_sales %></p>
    <% end %>
  <% end %>
</div>
```

Ideally, we would not be iterating through a collection inside of another iteration through a collection. We would want to pull this out to a partial and render that partial within the loop. For now though, let's leave it. 

Run `shotgun` from the command line, then navigate to `localhost:9393/genres`. You should see the films sorted by genre. 

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


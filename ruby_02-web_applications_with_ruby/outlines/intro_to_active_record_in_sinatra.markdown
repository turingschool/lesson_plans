---
title: Intro to ActiveRecord in Sinatra
length: 90
tags: activerecord, migrations, sinatra
---


## Goals

* generate a migration in order to create or modify a table
* use rake commands to create a database, drop a database, generate migration files, and migrate the database
* interpret `schema.rb`
* set up relationships between tables at the database level using foreign keys in migrations
* set up relationships between tables at the model level using `has_many` and `belongs_to`

## Lecture

We'll use this [ActiveRecord Skeleton Repo](https://github.com/turingschool-examples/active-record-sinatra) for today's lesson. We're going to create an application that displays films and each film's related genre (you'll also build on this application with your homework). Fork it to your Github account, clone it down, and run `bundle install`.

### Warm Up 

Answer these questions with a partner:

* What do you know about ActiveRecord?
* Take a look at your Task model in TaskManager and your Robot model in RobotWorld. What's similar? What's different?
* Name two ActiveRecord methods you explored this morning.

### Introduction to ActiveRecord

* What is ActiveRecord?
* What's an ORM?
* What does using an ORM give us?

### Inspecting the Setup

Let's examine each of these new files: 

* `Gemfile`
* `Rakefile` (find the included rake tasks [here](https://github.com/janko-m/sinatra-activerecord))
* `config/environment.rb`
* `config/database.rb`
* `config/database.yml`

### Creating the database
If you look in the `db` folder, you'll notice that we don't have any database files. In order to create our database, we need to run `rake db:create`. After running this command, you'll see an empty sqlite file now inside the `db` folder. 

### Creating the Genres Table

Before we can actually create a table, we need to generate a migration file. 

Review: What's a migration?

Rake gives us some handy commands to help us generate migration files. Let's run the following:

```
$ rake db:create_migration NAME=create_genres

```

Inside of that file you should see an empty migration file:

```ruby
class CreateGenres < ActiveRecord::Migration
  def change
  end
end

``` 

We'll want to use `ActiveRecord`'s `create_table` method to specify what we want to name this table and what fields it will include.


```ruby
class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
```


Run `rake db:migrate` to run your migrations against the database.

Inspecting the `schema.rb` file:

```ruby
ActiveRecord::Schema.define(version: 20160217022804) do

  create_table "genres", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
end
```

### Creating the Genre Model

Add a `genre` model:

```
$ touch app/models/genre.rb
```

Inside of that file:

```ruby
class Genre < ActiveRecord::Base
end
```

By inheriting from `ActiveRecord::Base`, we're given a bunch of class and instance methods we can use to manipulate the genres in our database. We don't need a `GenreManager` class. These pieces of functionality will become class methods on Genre (`Genre.create(...)`, `Genre.all`, etc.)

We'll add some genres to our database using Tux, an interactive console for your app:

```ruby
$ tux
animation = Genre.create(name: "Animation")
scifi = Genre.create(name: "Sci Fi")
drama = Genre.create(name: "Drama")
romance = Genre.create(name: "Romance")
```

In the controller: 

```ruby
class FilmFile < Sinatra::Base
  get '/genres' do
    @genres = Genre.all
    erb :"genres/index"
  end
end
```

We'll also need to create this view. Let's create a view template to display each genre.

Run `shotgun` from the command line. Visit `localhost:9393/genres` and see your genres! Amazing. Magical.


### Check for Understanding
Spend 1 minute reflecting on the following questions:

* What rake command helps generate migrations? What method do we use inside of a migration?
* How does a model relate to our database? What should our models inherit from?

Spend 2 minutes discussing your answers with a partner.

Shuffle/Shuffle/Pop as a big group.


### Creating the Films Table

You now have two options - you can try the following on your own or you can work with whomever is sitting next to you. 

Let's create a `films` table and a corresponding `Film` model!

A `Film` will have a title (text), year (integer), and box_office_sales (integer).

- Create a migration file. 
- Write code in that file to create the correct table (films) with the necessary fields (see above).
- Run your migrations.
- Inspect `schema.rb` to ensure your table was created as intended.
- Create the `Film` model (be sure it's inheriting form the correct class).
- Add the following data using `tux`:

```ruby
$ tux
Film.create(title: "Avatar", year: 2009, box_office_sales: 760505847)
Film.create(title: "Titanic", year: 1997, box_office_sales: 658672302)
Film.create(title: "Jurassic World", year: 2015, box_office_sales: 652177271)
Film.create(title: "The Avengers", year: 2012, box_office_sales: 623279547)
Film.create(title: "The Dark Knight Rises", year: 2008, box_office_sales: 533316061)
Film.create(title: "Star Wars: Episode I - The Phantom Menace", year: 1999, box_office_sales: 474544677)
Film.create(title: "The Lion King", year: 1994, box_office_sales: 422783777)
```
- Create a route in your controller and a view template to view all films.
- Launch your server to see your films!

### Recap: Creating Films


First, we need to generate a migration file:

```ruby
$ rake db:create_migration NAME=create_films
```

Inside of that file:

```ruby
class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.text    :title
      t.integer    :year
      t.integer :box_office_sales

      t.timestamps null: false
    end
  end
end
```

Run `rake db:migrate` to run your migrations against the database.

Inspect the schema.rb file:

```ruby
ActiveRecord::Schema.define(version: 20160217022804) do

  create_table "films", force: :cascade do |t|
    t.text     "title"
    t.integer     "year"
    t.integer  "box_office_sales"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
```

Add a `film` model:

```
$ touch app/models/film.rb
```

Inside of that file:

```ruby
class Film < ActiveRecord::Base
end
```

We'll add some films to our database using Tux, an interactive console for your app:

```ruby
$ tux
Film.create(title: "Avatar", year: 2009, box_office_sales: 760505847)
Film.create(title: "Titanic", year: 1997, box_office_sales: 658672302)
Film.create(title: "Jurassic World", year: 2015, box_office_sales: 652177271)
Film.create(title: "The Avengers", year: 2012, box_office_sales: 623279547)
Film.create(title: "The Dark Knight Rises", year: 2008, box_office_sales: 533316061)
Film.create(title: "Star Wars: Episode I - The Phantom Menace", year: 1999, box_office_sales: 474544677)
Film.create(title: "The Lion King", year: 1994, box_office_sales: 422783777)
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

Run `shotgun` from the command line. Visit `localhost:9393/films` and see your films.

### Genres and Films - How do they relate?

Let's assume that a film belongs to a genre, and a genre has many films. How will we connect these two tables?

If a genre has many films, then we'll add a foreign key on the film. 

We'll need to add a `genre_id` column to the `films` table. An individual `Film` will always have a reference to one `Genre` via the `genre_id` field.

Let's add the migration to add a `genre_id` to the `films` table.

```ruby
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

Let's migrate: `rake db:migrate` and take a look at `schema.rb`:

```ruby
ActiveRecord::Schema.define(version: 20160217022905) do

  create_table "films", force: :cascade do |t|
    t.text     "title"
    t.integer     "year"
    t.integer  "box_office_sales"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

end
```

### Associating the Genre and Film Models

Let's add an `ActiveRecord` association to our `Genre` to describe the relationship between a genre and a film. This will make it easy to find all of a specific Genre's films.

```ruby
class Genre < ActiveRecord::Base
  has_many :films
end
```

This will allow us to call the method `films` on an instance of `Genre`. Behind the scenes, it will go through the `films` table and find all films where the `genre_id` attribute is the same as the primary key `id` of the genre it's being called on.

Curious about how this is implemented? Check out [this blog post](http://callahanchris.github.io/blog/2014/10/08/behind-the-scenes-of-the-has-many-active-record-association/). 

Let's test it out:

```ruby
$ tux
animation = Genre.find_by(name: "Animation")
animation.films
# returns a collection of associated Film objects

```

Why is our result empty?

We've added a `genre_id` field to each `Film`, but we haven't given that field a value on any of our existing films.

There are a few different ways to associate your data. If both objects are already created, but we want to associate them, we could do the following:

```ruby
animation.films << Film.find_by(title: "The Lion King")
...and so on
```

Another way to do this would be: 

```ruby
Film.find_by(title: "The Lion King").update_attributes(genre_id: 1)
```

The better way to associate data is to do it upon creation:
```ruby
animation = Genre.find_by(name: "Animation")
animation.films.create(title: "The Lion King", year: 1994, box_office_sales: 422783777)
```
This will create a new `Film` record and place whatever animation's `id` is in the `genre_id` field in the film.

### Updating our View

Let's update our `genres/index.erb` view to show all the films in each genre:

```erb
<h1>All Genres</h1>

<div id="genres">
  <% @genres.each do |genre| %>
    <h1><%= genre.name %></h1>
    <% genre.films.each do |film| %>
      <h3><%= film.title %></h3>
    <% end %>
  <% end %>
</div>
```

Ideally, we would not be iterating through a collection inside of another iteration through a collection. We would want to pull this out to a partial and render that partial within the loop. For now though, let's leave it. 

Run `shotgun` from the command line, then navigate to `localhost:9393/genres`. You should see the films sorted by genre. 

### A Film's Relationship with Genre

A film has the opposite relationship with a genre. `ActiveRecord` gives us another association method:

```ruby
class Film < ActiveRecord::Base
  belongs_to :genre
end
```

This will allow us to call `film.genre` and get back the genre object associated with that film. Behind the scenes, this is finding the genre that has the primary key `id` of the `genre_id` column on the `film`.

If you have a `has_many` relationship on a model, it is **not** necessary to have a `belongs_to` on another model.

### Food for thought

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
* [What is ActiveRecord?](http://guides.rubyonrails.org/active_record_basics.html#what-is-active-record-questionmark)
* [ORM Diagram](http://wiki.expertiza.ncsu.edu/images/2/2c/ORM_Flowchart.jpg)


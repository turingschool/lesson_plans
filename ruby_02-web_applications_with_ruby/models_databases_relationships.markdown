---
title: Models, Databases, and Relationships

tags: models, databases, relationships, rails, migrations, activerecord
---

# Models, Databases, and Relationships

## Goals

(Some of these are review from last week)

* describe one-to-one, one-to-many, and many-to-many database relationships
* explain the difference between dev, test, and production environments in Rails
* create a Rails migration that creates a table or modifies a table
* set up relationships in a Rails migration with foreign key fields
* migrate the database and rollback migrations
* explain purpose of ORM (like ActiveRecord)
* use and explain common ActiveRecord class and instance methods
* set up relationships between models using ActiveRecord

## Lesson

### Primary and Foreign Keys

Let's discuss: 

* What is the difference between a primary key and a foreign key? Where would we find a primary key? What would it be called by default? Where would we find a foreign key? What is the naming convention for a foreign key? 

### Types of Relationships

Let's discuss: 

* **One-to-one relationships**: one object has one of another object. The relationship works in the inverse as well. An example might be one person has one social security number, and one social security number belongs to one person. How is this modeled at the database level? Let's draw this. 

* With a partner, brainstorm three examples of a `one-to-one relationship`. 

* **One-to-many relationships**: one object A has many of object B. One object B belongs to one object A. An example would be one child has many toys. Each toy belongs to one child. How is this modeled at the database level? Let's draw this. 

* With a partner, brainstorm three examples of a `one-to-one relationship`. 

* **Many-to-many relationships**: One object A has many of object B. One object B has many of object A. An example of this would be that a blog post has many tags, and a tag can have may blog posts. How is this modeled at the database level? Let's draw this. (Hint: You'll need a join table)

### Databases in Rails Apps

Let's make a new Rails app with the PG database already set up: `rails new appname --database=postgresql` (or `rails new appname -d postgresql`). The two places where you'll see the effects of this will be in the Gemfile (`gem 'pg'` instead of `gem 'sqlite3'`) and in `config/database.yml`. 

Let's look at that file. Getting rid of the comments, it looks like this: 

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *default
  database: appname_development

test:
  <<: *default
  database: appname_test

production:
  <<: *default
  database: appname_production
  username: appname
  password: <%= ENV['APPNAME_DATABASE_PASSWORD'] %>

```

* What's the difference between test, development, and production databases? What do we use each of these databases for? 

### One-to-Many Relationships

#### At the Database Level: Articles and Authors

Let's discuss:

* What is a migration?
* What does `t.timestamps` in the migration file give us? 

Let's do:

1. First, we'll create a model: `rails generate model Author first_name:text last_name:text`. The model generator creates a model, a migration, and two files related to testing. 

Let's look at the migration inside of `db/migrate`:

```ruby
class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.text :first_name
      t.text :last_name

      t.timestamps
    end
  end
end
```

Let's look at the model `author.rb`:

```
class Author < ActiveRecord::Base
end
```

It also creates a model test and a fixtures file to use for testing. More on this in a future lesson.

*Notes:*

* `rails g model ...` is shorthand for `rails generate model ...`
* You can also create a model without the attributes from the command line (`rails generate model Author`) but you'll then need to add the attributes into the migration file by hand. 
* You can create the migration and the model separately like this: `rails g migration CreateAuthors first_name:text last_name:text` then `touch app/models/author.rb` and adding the two lines of code to define the author class. 

* `rails generate model Something` will generate a model and a migration
* `rails generate model Something name:string age:integer` will generate model and migration with those attributes
* Change vs. Up/Down
* Common methods: `add_column`, `create_table` (automatically will generate a primary key), `remove_column`, `drop_table` (these methods take arguments)
* common column types: boolean, string, text, integer, date, datetime
* setting up relationships in a migration using id columns
* column modifier examples: `:null => false` `:default => 0` (more [here](http://guides.rubyonrails.org/migrations.html))
* everything in the migration is executable code (but use a seed file to generate seed data)
* `rake db:migrate` migrates development
* schema.rb contains snapshot of current database structure
* you (generally) don't need to do rake db:test:prepare or RACK_ENV=test rake db:migrate with Rails testing; running `rake test` will load the schema to the test database
* `rake db:rollback` or `rake db:rollback STEP=2` to reverse migrations
* `rake db:drop` and `rake db:create` to wipe out database and recreate it
* click [here](http://guides.rubyonrails.org/migrations.html) for more on migrations

#### What is ActiveRecord?
 
* Object Relational Mapping (ORM) framework
* connects objects in an application to relational database
* represent models and their data
* represent associations between models
* validate models before they are saved in database

### Models

#### Demonstration with Article model

* inheriting from ActiveRecord::Base -- additional class methods and instance methods
* naming of database tables (snake_case) vs. models (CamelCase)
* example ActiveRecord class methods: `all`, `count`, `find`, `find_by`
* example ActiveRecord instance methods: `update`, `destroy`, `save`, `attribute?`, `new_record?`
* you don't need to use `initialize` method
* in general, you don't need `attr_reader`
* click [here](http://guides.rubyonrails.org/active_record_basics.html) for more on ActiveRecord basics

### Associations

#### Demonstration of One-to-Many Relationships at the Model Level: Article/Author

* ActiveRecord Associations:
* has_many - this is a method
* belongs_to - this is a method

### Many-to-Many

#### Many-to-Many at the Database Level: articles, tags, and article_tags tables

* need three tables
* join table holds foreign keys for each of the other two tables

#### Many-to-Many at the Model Level: Article/Tag/ArticleTag models

* join tables: `has_many :thing` and `has_many :thing, through: :other_thing` - this is a method with an argument
* order matters
* click [here](http://guides.rubyonrails.org/association_basics.html) for more associations

### Work Time

[Rails Basics Challenge](https://github.com/turingschool/challenges/blob/master/models_databases_relationships_routes_controllers_oh_my.markdown)

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

### Databases

* primary key vs. foreign key
* one-to-one relationships (customer, home_address)
* one-to-many relationships (child, toys)
* many-to-many relationships with join tables (article, tag)

#### Practice with Databases

1) Brainstorm three situations: 

* a one-to-one relationship ('has one' / 'belongs to')
* a one-to-many relationship ('has many' / 'belongs to')
* a many-to-many relationship ('has many' / 'has many' with a join table)

### Databases in Rails Apps

* `rails new appname --database=postgresql` to generate a Rails app with a PostgreSQL database configured
* what's the difference between test, dev, and production databases?

### One-to-Many

#### One-to-Many Relationships at the Database Level: Articles and Authors

* What is a migration?
* timestamps on migration files
* Creating a migration: `rails generate migration CreateThings` (or AddSomething, ChangeSomething) or `rails generate migration CreateThings attribute1:type attribute2:type ...`
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

### Homework

[Rails Basics Challenge](https://github.com/turingschool/challenges/blob/master/models_databases_relationships_routes_controllers_oh_my.markdown)

---
title: Models, Databases, and Relationships

tags: models, databases, relationships, rails, migrations, activerecord
---

# Models, Databases, and Relationships

## Standards

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
* one-to-one relationships
* one-to-many relationships
* many-to-many relationships with join tables

#### Practice with Databases

1) Brainstorm three situations: 

* a one-to-one relationship ('has one' / 'belongs to')
* a one-to-many relationship ('has many' / 'belongs to')
* a many-to-many relationship ('has many' / 'has many' with a join table)

### Databases in Rails Apps

* `rails new appname --database=postgresql` to generate a Rails app with a PostgreSQL database configured
* what's the difference between test, dev, and production databases?

### [Migrations](http://guides.rubyonrails.org/migrations.html)

* What is a migration?
* timestamps on migration files
* Creating a migration: `rails generate migration CreateSomething ...` (or AddSomething, ChangeSomething)
* `rails generate model Something` will generate a model and a migration
* Change vs. Up/Down
* Common methods: `add_column`, `create_table` (automatically will generate a primary key), `remove_column`, `drop_table` (these methods take arguments)
* common column types: boolean, string, text, integer, date, datetime
* setting up relationships in a migration using id columns
* column modifier examples: `:null => false` `:default => 0` (more [here](guides.rubyonrails.org/migrations.html))
* everything in the migration is executable code (but don't use a migration for that)
* `rake db:migrate` migrates development
* schema.rb contains snapshot of current database structure
* `rake test` resets test database from schema.rb file
* `rake db:rollback` or `rake db:rollback STEP=2`
* `rake db:drop` `rake db:create`
* seed file
* click [here](guides.rubyonrails.org/migrations.html) for more on migrations

#### Practice with Migrations

1) Imagine that you have Users and Addresses. A user can have many addresses, and an address belongs to one user. Create a model and a migration (`rails g migration ...`) for both users and addresses.

2) Create a migration to add a boolean column `is_admin` to the users table. Give this a default value of false. Migrate this and watch how `schema.rb` changed.

3) Rollback the previous migration.

### What is ActiveRecord?
 
* Object Relational Mapping (ORM) framework
* connects objects in an application to relational database
* represent models and their data
* represent associations between models
* validate models before they are saved in database

### Models

* naming of database tables (snake_case) vs. models (CamelCase)
* inheriting from ActiveRecord::Base -- additional class methods and instance methods
* example ActiveRecord class methods: `all`, `count`, `find`, `find_by`
* example ActiveRecord instance methods: `update`, `destroy`, `save`, `attribute?`, `new_record?`
* you don't need to use `initialize` method
* in general, you don't need `attr_reader`
* click [here](http://guides.rubyonrails.org/active_record_basics.html) for more on ActiveRecord basics

#### Practice with Models

1) Create a User model that inherits from ActiveRecord::Base (don't use a generator for this)

2) Start `rails console` from the command line. Check how many class methods are available on the User class with `User.methods.count`

3) Create a new instance of a User (`user = User.new`). Check how many methods are available using `user.methods.count`.

4) Create a plain Ruby class and check how many methods are availble both for the class and an instance of the class.

5) Use the class methods `all` to see all Users and `find` / `find_by` to locate a user by an id or other attribute.

6) Use the instance methods `new_record?`, `update`, and `save` on `user`.

### Associations

* ActiveRecord Associations:
* has_many - this is a method
* belongs_to - this is a method
* join tables: has_many, through: :table - this is a method with an argument
* click [here](http://guides.rubyonrails.org/association_basics.html) for more associations

#### Practice with Associations

1) Set up a one-to-many relationship between the Address and User models.

2) In the `rails console`, create a new User (`user = User.new`), save that user (`user.save`), and create a new address for that user (`user.addresses.create`).

3) Look at the ActiveRecord relationship with `user.addresses`. 

## Wrapup

## Corrections & Improvements for Next Time

### Taught by Rachel

---
title: Models, Databases, and Relationships

tags: models, databases, relationships, rails, migrations, activerecord
---

# Understanding REST

## Standards

## Structure

## Lesson

#### Databases

* primary key vs. foreign key
* has one
* has many
* belongs to
* join tables
* `rails new appname --database=postgresql`
* test vs. dev vs. production databases

#### [Migrations](http://guides.rubyonrails.org/migrations.html)

* What is a migration?
* Creating a migration: `rails generate migration CreateSomething ...` (or AddSomething, ChangeSomething)
* `rails generate model Something` will generate a model and a migration
* Change vs. Up/Down
* Common methods: `add_column`, `create_table` (automatically will generate a primary key), `remove_column`, `drop_table` (these methods take arguments)
* common column types: boolean, string, text, integer
* setting up relationships in a migration
* column modifiers: `:null => false` `:default => 0`
* everything in the migration is executable code (but don't use a migration for that)
* `rake db:migrate` migrates development
* schema.rb contains snapshot of current database structure
* `rake test` resets test database from schema.rb file
* `rake db:rollback` or `rake db:rollback STEP=2`
* `rake db:drop` `rake db:create`
* click [here](guides.rubyonrails.org/migrations.html) for more on migrations

#### Practice with Migrations

1) Imagine that you have Users and Addresses. A user can have many addresses, and an address belongs to one user. Create a model and a migration (`rails g model ...`) for both users and addresses.

2) Create a migration that you can use to add a boolean column `is_admin` to the user table. Give this a default value of false. Migrate this and watch how `schema.rb` changed.

3) Rollback the previous migration.

#### Models

* Inheriting from ActiveRecord::Base -- additional class methods and instance methods
* example class methods: `all`, `count`, `find`
* example instance methods: `update`, `destroy`, `save`, `attribute?`, `new_record?`
* you don't need to use `initialize` method
* in general, you don't need `attr_reader`
* click [here](http://guides.rubyonrails.org/active_record_basics.html) for more on ActiveRecord basics


#### Associations
* ActiveRecord Associations:
* has_many - this is a method
* belongs_to - this is a method
* join tables: has_many, through: :table - this is a method with an argument
* click [here](http://guides.rubyonrails.org/association_basics.html) for more associations

## Wrapup

Return to standards and check progress.

## Corrections & Improvements for Next Time

### Taught by Rachel

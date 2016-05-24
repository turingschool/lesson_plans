---
title: Models, Databases, and Relationships

tags: models, databases, relationships, rails, migrations, activerecord
---

# Models, Databases, and Relationships

## Checks for Understanding

During and after the lesson you want to be able to answer the questions below. Start a Gist for yourself to write answers and notes along the way.

* What is a primary key?
* What is a foreign key?
* Why would one row of data have both primary and foreign keys?
* What is Rails' convention for the column name of the primary key?
* What is Rails' convention for the column name of a foreign key?
* What are dev, test, and prod databases all about?
* What is the database.yml and how is it used?

## Goals

* describe one-to-one, one-to-many, and many-to-many database relationships
* explain the difference between dev, test, and production environments in Rails
* create a Rails migration that creates a table or modifies a table
* set up relationships in a Rails migration with foreign key fields
* migrate the database and rollback migrations
* explain purpose of ORM (like ActiveRecord)
* use and explain common ActiveRecord class and instance methods
* set up relationships between models using ActiveRecord

## Lesson

### Starter Exercise

Imagine we're going to build a replacement for iTunes. It's well overdue!

What might the database schema look like? Let's emphasize figuring out the entities (aka tables), but also figure out some of the key data columns.

When you're done you'll likely have at least eight tables.

### Types of Relationships

Just storing data in a database isn't very interesting. Where the database shines is in the ability to connect or express relationships between elements of data.

* **One-to-one relationships**: a row of table A relates to one and only one row of table B

* **One-to-many relationships**: a row of table A relates to zero, one, or multiple rows of table B. However a row of table B relates to only one row of table A.

* **Many-to-many relationships**: a row of table A relates to zero, one, or multiple rows of table B. A row of table B relates to zero, one, or multiple rows of table A.

### Keys to Relationships

We use keys to "link" data across tables. Let's discuss:

* Primary key & "Auto-increment"
* Foreign keys
* Naming conventions

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

### Generating Models & Migrations

Rails has many built-in generators to create boiler-plate code for you. Let's look at the model generator:

* How do you list generators from the command line?
* How does the generate command create models?
* What files does it create for you and why?
* What are the *two ways* you can specify the attributes for a model?
* Where can you learn more about what's possible in a migration?

### Build

Let's *build*. Take that design that you put together at the beginning and let's build migrations and models to make it real.

### Homework

Then this afternoon/evening complete the [Rails Basics Challenge](https://github.com/turingschool/challenges/blob/master/models_databases_relationships_routes_controllers_oh_my.markdown)

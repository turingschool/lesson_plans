---
title: Database Schema Design
length: 180
tags: database, schema, relationships
---

## Goals

* use a schema designer to outline attributes of tables and relationships between tables
* use TDD to set up models and migrations for one-to-many and many-to-many relationships
* diagram complex relationships between multiple tables

## Review (15 minutes)

### One-to-Many

People

|id |first_name|last_name|
|---|---|---|
|  1| rachel| warbelow  |
|  2|  josh |  mejia |
|  3|  jorge| tellez  |

* the primary key id is stored on the other table as a foreign key:

Pets

|id |name|type|owner_id|
|---|---|---|-----|
|  1| bobby| turtle  | 3|
|  2| goldie |  fish | 3| 
|  3| dino | tiger  | 1| 

### Many-to-Many

* need to have a join table to keep track of the unique associations between one table and the other

Let's use a [Schema Designer](http://ondras.zarovi.cz/sql/demo/) to create a schema for this situation: 

Articles

|id |title|body|
|---|---|---|
|  1| oatmeal is delicious| insert text here  |
|  2|  removing crumbs from your keyboard |  insert text here |
|  3|  how to create a fantasy football app | insert text here  |

Tags

|id |tag_name|
|---|---|
|  1| food|
|  2|  computers |
|  3|  sports |

ArticleTags

|id |article_id|tag_id
|---|---|---|
|  1| 1| 1 |
|  2| 2 | 1| 
|  3| 2| 2 |
|  4| 3| 2 |
|  5| 3| 3 |

### Models

When setting up related tables...

* the table with the foreign key gets the `:belongs_to`
* the table(s) without a foreign key gets the `:has_many`
* this rule applies with a one-to-many or a many-to-many relationship
* remember, when going through a join table, you'll use `:has_many, through: :join_table` replacing `:join_table` with the name of your actual join table. 

## Warmup (50 minutes)

Use TDD to set up the migrations and models for two very basic Rails apps. 

1) A photo sharing app with two tables: users and photos (one-to-many)

2) A favorite places app with three tables: users, places, and user_places (many-to-many)

If you need a refresher on unit testing, see the [Unit Testing in Rails](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/unit_testing_in_rails.markdown) lesson plan. 

## Diagramming Complex Schemas (50 minutes)

### Key Points

* non-normalized: repeated data is stored in every record
* can lead to inconsitencies; errors
* avoid data duplication by normalizing the database
* each table should describe one thing
* if a table contains information about a sub-topic, break it out to a separate table

Let's use the schema designer to create an app to track students, courses, assignments, and submissions.

### Practice in Small Groups

1) City Library System
  * a user can check out books
  * books have one or more authors
  * books belong to a library branch
  * a book can be reserved by a user

2) Movie Showtimes
  * a movie has many showtimes at various theaters
  * a theater has many showtimes for various movies
  * a user can purchase a ticket for a specific showtime

3) Flash Cards
  * a deck has many cards
  * a user can play a round
  * a user has a response to each card
  * a user can see his/her score for each round played

4) Social Media App
  * a user can post statuses
  * a user can post pictures
  * a user can comment on statuses
  * a user can comment on pictures
  * a user can have many friends (need help with [self-referential association](http://railscasts.com/episodes/163-self-referential-association?view=asciicast)?[or this blog post](http://andrewcarmer.com/active-record-self_joins/))

5) Survey App
  * a user can create one or more surveys
  * a survey has many questions
  * each question has many choices
  * a user can take a survey
  * a user can choose a response to a question

### Migrations

* You don't necessarily need to get your schema exactly right before you start coding. That's what migrations are for.
* add tables, add columns, remove columns, drop tables, etc.

## Resources

* [Introduction to Database Design in Rails](http://quickleft.com/blog/introduction-to-database-design-on-rails)
* [Building a Data Model](http://dan.chak.org/enterprise-rails/chapter-5-building-a-solid-data-model/)

---
title: Database Schema Design
length: 180
tags: database, schema, relationships
---

## Goals

## Lecture

### Key Points

* non-normalized: repeated data is stored in every record
* can lead to inconsitencies; errors
* avoid data duplication by normalizing the database
* each table should describe one thing
* if a table contains information about a sub-topic, break it out to a separate table

### One-to-Many

* every table has a primary key

|id |first_name|last_name|
|---|---|---|
|  1| rachel| warbelow  |
|  2|  josh |  mejia |
|  3|  jorge| tellez  |

* the primary key id is stored on the other table as a foreign key:

|id |name|type|owner_id|
|---|---|---|-----|
|  1| bobby| turtle  | 3
|  2| goldie |  fish | 3
|  3| dino | tiger  | 1

### Many-to-Many

* [FINISH THIS]

* need to have a join table to keep track of the unique associations between one table and the other

### Models

When setting up related tables...

* the table with the foreign key gets the `:belongs_to`
* the table(s) without a foreign key gets the `:has_many`
* this rule applies with a one-to-many or a many-to-many relationship

### Practice

Set up the migrations and models for two very simple Rails apps:

1) A photo sharing app with two tables: users and photos (one-to-many)
2) A favorite places app with three tables: users, places, and user_places (many-to-many)

### Diagramming Complex Relationships

* [Schema Designer](http://ondras.zarovi.cz/sql/demo/)

Let's use the schema designer to create an app to track students, courses, assignments, and submissions.

### Practice

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
  * a user can have many friends (need help with [self-referential association](http://railscasts.com/episodes/163-self-referential-association?view=asciicast)?)

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

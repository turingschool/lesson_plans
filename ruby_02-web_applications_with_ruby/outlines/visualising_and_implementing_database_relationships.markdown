---
title: Visualising and Implementing Database Relationships
length: 120
tags: database, schema, relationships
---

## Goals

* Define foreign key, primary key, schema
* Define one to many and many to many relationships
* Describe the relationship between a foreign key on one table and a primary key on another table.
* Use a schema designer to outline attributes of tables
* Diagram a one-to-many relationship
* Diagram a many-to-many relationship

### Warm-Up

In our recent client meeting, our client decided their users should be able to organize their tasks by marking them with categories (we'll call these categories tags). Based on our conversation, we've decided:

     Users should have tasks. Tasks should have tags.

Right now, our database only supports tasks. Take a minute to consider what changes we would need to make to our database in order to support the features requested by our client.

### Opening

* This class is about identifying situations that require one to many and many to many relationships, and how to diagram them using a schema designer.

### Defining Key Terms

* Primary Key - a key in a relational database that is unique for each record. It is a unique identifier, such as a drivers license, or the VIN on a car. You must have one and only one primary key.
* Foreign Key - a foreign key is a field in one table that uniquely identifies a row of another table. A foreign key is defined in a second table, but it refers to the primary key in the first table.

### Schema / Schema Designer

* [Schema Designer](http://ondras.zarovi.cz/sql/demo/)

### One-to-many relationships

* The relationship between Users and Tasks is a one-to-many relationship.
* Task has a column called `user_id` which is refers to the primary key of the users table.
* Let's diagram the relationship using a schema designer.
* A car dealership has many cars - diagram this relationship using a schema designer.
* For independent practice, now implement (on your own computer) the relationship between menus and items.

### CFU

* Let's diagram the relationship between menus and items together. Shuffle/shuffle/pop.

### Many-to-many relationships

* Many-to-many is a little harder than one-to-many
* Imagine if we wanted to also tag all of our tasks that we've created.
* Tags can belong to many tasks, while at the same time, a task has many tags.
* They way we are able to implement this relationship through a join table.
* Diagram the tags and tasks relationship using the schema designer.
* For independent practice, now implement students and classes.

### CFU

* Let's diagram the relationship between students and classes together. Shuffle/shuffle/pop.

### Closing

Let's revist our learning goals. Take a few minutes to define/describe/diagram the following:

* Define foreign key, primary key, schema
* Define one to many and many to many relationships
* Describe the relationship between a foreign key on one table and a primary key on another table.
* Diagram the relationship between museums and original_paintings.


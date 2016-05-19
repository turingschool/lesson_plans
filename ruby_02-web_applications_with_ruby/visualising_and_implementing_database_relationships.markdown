---
title: Visualising and Implementing Database Relationships
length: 60
tags: database, schema, relationships
---

## Goals

* define foreign key, primary key, schema
* define one to many and many to many relationships (one to many is most important)
* describe the relationship between a foreign key on one table and a primary key on another table.
* use a schema designer to outline attributes of tables
* diagram a one to many relationship
* diagram a many to many relationship

### Hook

* Client comes and wants you to support users.
* Users should have tasks.
* Tasks should have tags.
* Right now, your database only supports tasks.
* Take a minute to consider what kind of changes we would need to make to our
database in order to support the features requested by our client.

### Opening

* This class is about identifying situations that require one to many and many to many
relationships, and how to diagram them using a schema designer.


### Defining Key Terms

* Primary Key - a key in a relational database that is unique for each
record. It is a unique identifier, such as a drivers license, or the VIN on a
car. You must have one and only one primary key.
* Foreign Key - a foreign key is a field in one table that uniquely identifies
a row of another table. A foreign key is defined in a second table,
but it refers to the primary key in the first table.


### Schema / Schema Designer

* [Schema Designer](http://ondras.zarovi.cz/sql/demo/)

### One to many relationships

* Talk about Users and tasks and how they are connected.
* Task has a column called users_id which is refers to the primary key
of the users table.
* Diagram relationship using a schema designer
* Practice with a different scenario with students. Car dealership has many
cars.
* For independent practice, now implement on your own computer with a menu
has many items. (2 mins)

### CFU

* Do on screen with students navigating

### Many to many relationships

* Also known as has and belongs to many.
* Many to Many is a little harder.
* Imagine a if we wanted to also tag all of our tasks that we've created.
* Tags can belong to many posts, while at the same time, a post has many tags.
* This is made possible through a join table.
* Diagram a tags and tasks relatiobship using the schema designer.
* Practice with students using the example of orders and products.
* For independent practice, now implment students and classes.

### CFU

* Go over onscreen with students navigating.

### Closing

* Give students two situations, not telling them which is 1tm, or mtm,
and in five minutes, have them explain.
* Patients and doctors.
* Museum and paintings.
* Have students navigate on big screen.
* Next steps, start thinking about diagramming this for Rush Hour.

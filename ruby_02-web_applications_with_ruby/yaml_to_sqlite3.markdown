---
title: Intro to ORM's & TaskManager Transformation
length: 180
tags: sqlite, yaml

---

### Learning Goals
* Understand the role of an Object Relational Mapper (ORM)
* Have a general idea of the process of replacing YAML::Store with SQLite
* Learn how to rely on a test suite while refactoring
* Use errors and stacktraces to guide development
* Introduce the concept behind migrations & the importance of separating table alterations
* The vulnerabilities to a test suite when expecting specific IDs


---

## Structure

* Overview of topic
* Code along or Tutorial 
* Recap

---

[Slides](https://www.dropbox.com/s/39s8xi31hbq3ics/yaml_to_sql.pdf?dl=0)

---

## Warmup

With a partner, discuss the following questions: 

1. How do you create a table in SQL?
2. What are some advantages/disadvantages of storing our data in YAML or simply a hash or array?

---

## Relational Databases
Database systems are helpful when handling massive datasets by helping to optimize complicated queries. Relational databases make it easy to relate tables to one another. 

For example, if we have a table of songs and artists, and a song belongs to one artist, we'll need to keep track of how these pieces of data relate to one another. There's no easy way to query a YAML file for this info.

---

## Object Relational Mappers
“An ORM framework is written in an object oriented language (like Ruby, Python, PHP etc.) and wrapped around a relational database. The object classes are mapped to the data tables in the database and the object instances are mapped to rows in those tables.”

(from sitepoint.com)


---

![400% ORM Diagram](http://wiki.expertiza.ncsu.edu/images/2/2c/ORM_Flowchart.jpg)

---

## Ruby ORM's
* ActiveRecord (lots)
* DataMapper (a few)
* Sequel (pretty much none)
 
---

## Why do we need an ORM?

We want to wrap our data in Ruby objects so we can easily manipuate them. If we didn't wrap them in Ruby objects, we'd simply have strings in arrays and other simple data types. This wouldn't be very easy to work with or manage.

---

## How does a database map to a Ruby class?

* the table represents the collection of instances
* a row represents one specific instance
* the columns represent the attributes of an instance

---

## From YAML to SQLite3
We're going to take TaskManager and convert our database storage from YAML::Store into SQLite3. We could use ActiveRecord, DataMapper, or Sequel, but that would be too easy. Before we use these tools that exist, we are going to build an ORM ourselves. 

---

## YAML -> SQLite

How do we know as we make changes if we've broken things?

Let's pause to take a look at our tests. Are they relying on data being in a specific order or id's being specific?

---

### It's **YOUR** turn! 

Follow the this [tutorial](https://github.com/s-espinosa/yaml_to_sql/blob/master/tutorial.md) to transform our `TaskManager` to store our data in a SQLite database rather than YAML::Store. Reminders - ask questions, read carefully, we'll recap at the end!

---

## Homework/Worktime
Transform Skill Inventory or Robot World to store your data in a SQLite3 database instead of YAML.

---


## Resources
- [ORM Ruby Introduction](https://www.sitepoint.com/orm-ruby-introduction/)
- [ActiveRecord Documentation](http://guides.rubyonrails.org/active_record_basics.html)
- [DataMapper Documentation](http://datamapper.org/)
- [Sequel Documentation](http://sequel.jeremyevans.net/)


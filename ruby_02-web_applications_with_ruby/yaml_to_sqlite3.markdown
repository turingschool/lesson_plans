---
title: Intro to ORM's & TaskManager Transformation
length: 120
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
* Code along
* Perform the transformation on our TaskManager

---

## Warmup

With a partner, discuss the following questions: 

1. How do you create a table in SQL?
2. What are some advantages/disadvantages of storing our data in YAML or simply a hash or array?

---

## Key Points

* SQL's syntax may be less than ideal
* Relational Database vs YAML
* Declarative programming vs. Object-oriented programming
* Object-Relational Mappers (ORMs)
* ActiveRecord (lots), DataMapper (few), Sequel (practically none)

---

## Relational Databases
Database systems are helpful when handling massive datasets by helping to optimize complicated queries. Relational databases make it easy to relate tables to one another. 

For example, if we have a table of songs and artists, and a song belongs to one artist, we'll need to keep track of how these pieces of data relate to one another. There's no easy way to query a YAML file for this info.

---

## Declarative programming vs. Object-oriented programming

Declarative programming is where you say what you want without having to say how to do it. With procedural programming, you have to specify exact steps to get the result.

For example, SQL is more declarative than procedural, because the queries don't specify steps to produce the result.

We are going to combine a declarative programming language (SQL) with an object-oriented programming language (Ruby).


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

- Code [before](https://github.com/turingschool-examples/task-manager/tree/feature-testing-implemented-1605) transformation (storing data w/ YAML)
- Code [after](https://github.com/turingschool-examples/task-manager/tree/yaml-to-sqlite3-1605) transformation (storing data w/ SQLite3)

---

## YAML -> SQLite

How do we know as we make changes if we've broken things?

---

## What do we need to do to accomplish this transformation?

1. Remove YAML::Store file
2. Create our SQLite database
3. Modify how we connect to the database
4. Modify our methods in TaskManager 

---

### Gemfile:

`gem 'sqlite3'`

---

### Migrations

- Migrations are a concept that allow you to evolve your database structure over time.
- Each migration is like a new 'version' of the database. 
- Once we start using a existing ORM (instead of creating our own), we'll need to be particular about where our migrations go and be mindful of how we name them and the content

---

```
# db/migrations/001_create_tasks.rb

require 'sqlite3'

environments = ["test", "development"]

environments.each do |environment|
  database = SQLite3::Database.new("db/task_manager_#{environment}.db")
  database.execute("CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(64),
          description VARCHAR(64)
        );"
  )
  puts "creating tasks table for #{environment}"
end

```

---

## How do we know if our database was created?
We can open our database using the sqlite3 gem with the following command:

```
sqlite3 task_manager_development.db
```


---

## Seed Data
For development purposes, sometimes you'll see what's called a seeds file. This file adds data to your database so that you have existing data you can view/manipulate.

---

```
# db/seeds.rb

require 'sqlite3'

database = SQLite3::Database.new("db/task_manager_development.db")

#Delete existing records from the tasks table before inserting these new records; we'll start from scratch.
database.execute("DELETE FROM tasks")

# Insert records.
database.execute(
				"INSERT INTO tasks
          (title, description)
        VALUES
          ('Go to the Gym', 'exercise is good for you'),
          ('Make dinner', 'obviously'),
          ('Pay the electric bill', 'it is due in 10 days'),
          ('Book a flight home for vacation', 'End of August');"

)

# verifying that our SQL INSERT statement worked
puts "It worked and:"
p database.execute("SELECT * FROM tasks;")
```


---

## Updating our database connection in our controller:

```
# app/task_manager_app.rb

def task_manager
  if ENV['RACK_ENV'] == "test"
    database = SQLite3::Database.new('db/task_manager_test.db')
  else
  	database = SQLite3::Database.new('db/task_manager_development.db')
  end
  database.results_as_hash = true
  TaskManager.new(database)
end
```

---

## Updating our database connection in tests:

```
# test/test_helper.rb

def task_manager
  database = SQLite3::Database.new('db/task_manager_test.db')
  database.results_as_hash = true
  @task_manager ||= TaskManager.new(database)
end

```


---

## Accessing our database in our TaskManager model

Previously, we accessed our data in our YAML::STore file like so:

```
database.transaction do
	# modify yaml
end
```

Now, we'll access our data in our SQLite3 database with code similar to the following:

```
database.execute("STRING OF SQL HERE;")
```

---

## TaskManager Transformation
Now that we have our database set up, we need to transform the following broken methods:

- find
- all
- create
- delete
- delete_all

---

## Homework/Worktime
Transform Skill Inventory or Robot World to store your data in a SQLite3 database instead of YAML.

---


## Resources
- [ORM Ruby Introduction](https://www.sitepoint.com/orm-ruby-introduction/)
- [ActiveRecord Documentation](http://guides.rubyonrails.org/active_record_basics.html)
- [DataMapper Documentation](http://datamapper.org/)
- [Sequel Documentation](http://sequel.jeremyevans.net/)


---
title: Database Design and Modeling
length: 60
tags: database, schema, relationships
---

## Goals

* use a schema designer to outline attributes of tables and one-to-many relationships between tables

## Lecture

### One-to-Many

Let's use a [Schema Designer](http://ondras.zarovi.cz/sql/demo/) to create a schema for this situation: 

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

### Questions

* What is the SQL statement that would be executed in order to get all of the pets belonging to Jorge? 
* What is the SQL statement that would be executed 

### Practice

Use the schema designer to model the following situations:

1) Users have tasks. 

2) Schools have students, and they also have teachers. Students have individual lockers. 

3) In Robot World, we stored duplicated data (location, department, etc.) as columns on the same table ('robots'). Design a schema where this duplicated data lives in separate tables. 

### ActiveRecord Implementation

Let's look back at the People/Pets example from the beginning of this lesson. If we were to use Ruby classes to model this data, it would look like this:

```ruby
class Person
  has_many :pets
end

class Pet
  belongs_to :person
end
```

Can you create Ruby classes for the three practice scenarios from above? 

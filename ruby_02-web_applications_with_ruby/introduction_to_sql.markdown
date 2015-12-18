---
title: Introduction to SQL
length: 90
tags: sql, databases, modeling
---

## Learning Goals

* Be able to explain how a database is made up of tables, columns, and rows
* Be able to select an appropriate datatype for a piece of data
* Be able to write an SQL statement using `SELECT` and `WHERE`
* Be able to explain what a foreign key is and why it's used
* Have some understanding of SQL joins

## Structure

* 5 - Warmup
* 20 - Lecture
* 5 - Break
* 15 - Lecture
* 10 - Fundamental SQL Tutorial
* 5 - Break
* 20 - Fundamental SQL Tutorial
* 5 - Wrapup

## Warmup

Discuss the following questions with another student. Which answers do you know? Which are you unsure about?

1. What are database tables, column, and rows? What's the purpose of each?
2. What's the meaning and purpose of `SELECT`? What about `WHERE?`
3. What's a foreign key? What's it used for?

## Lecture

[Slides](https://www.dropbox.com/s/8ofg6iu0iakdqw9/intro_to_SQL.key?dl=0)

Let's discuss the big picture of SQL:

* Databases
* Tables, Columns, and Rows
* Data types -- int, datetime, varchar, text, boolean, etc. See more [here](http://www.tutorialspoint.com/sql/sql-data-types.htm).
* Primary keys
* SELECT, INSERT, DELETE
* WHERE
* Foreign keys
* Joins -- see [Jeff Atwood's blog post](http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/) for a visual explanation of joins

### Key Points

* must end SQL statements with a semicolon
* capital vs. lowercase conventions

### Snippets

```sql
SELECT * FROM table WHERE column=value;
INSERT INTO table (column1,column2,column3) VALUES (value1,value2,value3);
DELETE FROM table WHERE column=value;
SELECT column FROM table1 INNER JOIN table2 ON table1.column_name=table2.column_name;
```


## Independent Work

Get together with your pair to complete the
[Fundamental SQL tutorial](http://tutorials.jumpstartlab.com/topics/sql/fundamental_sql.html)
tutorial.

### Extra Challenge

Create a table of Customers and a table of Orders. Can you execute a `JOIN` that
connects the two into one set of results?

Want more? Check out the [Bastard's Book of Ruby SQL Chapter](http://ruby.bastardsbook.com/chapters/sql/).

## Wrapup

Return to the warmup questions and improve your answers.

### Check For Understanding Questions

* What is a relational database, and how does it differ from any old database?
* Name something you can do with SQL.
* What does AUTOINCREMENT do? Why is this important, or how does it make our life easier?

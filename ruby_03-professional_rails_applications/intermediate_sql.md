---
title: Intermediate SQL
length: 90 minutes
tags: SQL
---

### Goals

By the end of this lesson, you will know/be able to:

* Understand INNER JOINS and OUTER JOINS
* Understand Aggregate Functions
* Introduce Subqueries

### Structure

### Lecture (tutorial)

#### Setup

From your terminal, run `psql`.

If you get an error that says something like `Database username "YOUR_NAME" does not exist.` you will need to create a database that shares the username. Run `createdb "YOUR_NAME"` and re-run `psql`.

Create a database to use as a playground:
`CREATE DATABASE intermediate_sql;`

Close the current connection and connect to the DB we just created.
`\c intermediate_sql;`

Create an items table:
`CREATE TABLE items(id SERIAL, name TEXT, revenue INT, course TEXT);`

From above: What does `SERIAL` do?

Run `SELECT * FROM items;` to make sure it was successful.

Let's insert some data:

```sql
INSERT INTO items (name, revenue, course)
VALUES ('lobster mac n cheese', 1200, 'side'),
       ('veggie lasagna', 1000, 'main'),
       ('striped bass', 500, 'main'),
       ('arugula salad', 1100, 'salad');
```

#### Aggregate Functions

* `SELECT sum(column_name) FROM table_name; `
* `SELECT avg(column_name) FROM table_name; `
* `SELECT max(column_name) FROM table_name; `
* `SELECT min(column_name) FROM table_name;`
* `SELECT count(column_name) FROM table_name; `

##### Write queries for the following:

1. What's the total revenue for all items?
1. What's the average revenue for all items?
1. What's the minimum revenue for all items?
1. What's the maximum revenue for all items?
1. What the count for items with a name?

Let's create an item that has all NULL values:
`INSERT into items (name, revenue, course) VALUES (NULL, NULL, NULL);`

Typically you `count` records in a table by counting on the `id` column, like `SELECT COUNT(id) FROM items;`. However, it's not necessary for a table to have an `id` column. What else can you pass to `count` and still get `5` as your result?

#### Building on Aggregate Functions

Now, combine multiple functions by returning both the minimum and maximum value from the revenue column:
`SELECT max(revenue), min(revenue) from items;`

How can we get the revenue based on the course?

`SELECT course, sum(revenue) FROM items GROUP BY course;`

##### Write queries for the following:

1. Return all `main` courses. Hint: What ActiveRecord method would you use to get this?
1. Return only the names of the `main` courses.
1. Return the min and max value for the `main` courses.
1. What's the total revenue for all `main` courses?

#### INNER JOINS

Now to the fun stuff. If you're a visual learner, you'll probably want to keep [this article](https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/) as you explore the concepts below. We're going to need multiple tables and to ensure we are on the same page, let's drop our table and populate our database with new data to experiment with.

`DROP TABLE items;`

Create some tables...

```sql
CREATE TABLE seasons(id SERIAL, name TEXT);
CREATE TABLE items(id SERIAL, name TEXT, revenue INT, season_id INT);
CREATE TABLE categories(id SERIAL, name TEXT);
CREATE TABLE item_categories(item_id INT, category_id INT);
```

Insert some data...

```sql
INSERT INTO seasons (name)
VALUES ('summer'),
       ('autumn'),
       ('winter'),
       ('spring');
```

```sql
INSERT INTO items (name, revenue, season_id)
VALUES ('lobster mac n cheese', 1200, 3),
       ('veggie lasagna', 1000, 1),
       ('striped bass', 500, 1),
       ('burger', 2000, 1),
       ('grilled cheese', 800, 4),
       ('hot dog', 1000, 1),
       ('arugula salad', 1100, 2);
```

```sql
INSERT INTO categories (name)
VALUES ('side'),
       ('dinner'),
       ('lunch'),
       ('vegetarian');
```

```sql
INSERT INTO item_categories (item_id, category_id)
VALUES (1, 1),
       (2, 2),
       (2, 4),
       (3, 2),
       (4, 3),
       (5, 3),
       (5, 4),
       (7, 1),
       (7, 2),
       (7, 3),
       (7, 4);
```

For our first query, we are going to grab each item and its season using an `INNER JOIN`.

```sql
SELECT * FROM items
INNER JOIN seasons
ON items.season_id = seasons.id;
```

```sql
id |         name         | revenue | season_id | id |  name
---+----------------------+---------+-----------+----+--------
 1 | lobster mac n cheese |    1200 |         3 |  3 | winter
 2 | veggie lasagna       |    1000 |         1 |  1 | summer
 3 | striped bass         |     500 |         1 |  1 | summer
 4 | burger               |    2000 |         1 |  1 | summer
 5 | grilled cheese       |     800 |         4 |  4 | spring
 6 | hot dog              |    1000 |         1 |  1 | summer
 7 | arugula salad        |    1100 |         2 |  2 | autumn
(7 rows)
```

This is useful, but we probably don't need all of the information from both tables.

* Can you get it to display only the name for the item and the name for the season?
* Having two columns with the same name is confusing. Can you customize each heading using `AS`?

It should look like this:

```sql
item_name            | season_name
---------------------+-------------
burger               | summer
veggie lasagna       | summer
striped bass         | summer
hot dog              | summer
arugula salad        | autumn
lobster mac n cheese | winter
grilled cheese       | spring
(7 rows)
```

Now let's combine multiple `INNER JOIN`s to pull data from three tables `items`, `categories` and `item_categories`.

* Write a query that pulls all the category names for `arugula salad`.
  Hint: Use multiple `INNER JOIN`s and a `WHERE` clause.

Can you get your return value to look like this?

```sql
name          |    name
--------------+------------
arugula salad | side
arugula salad | dinner
arugula salad | lunch
arugula salad | vegetarian
(4 rows)
```

Can you change the column headings?

```sql
item_name     | category_name
--------------+---------------
arugula salad | side
arugula salad | dinner
arugula salad | lunch
arugula salad | vegetarian
(4 rows)
```

#### OUTER JOINS

To illustrate a LEFT OUTER JOIN we'll add a few records without a `season_id`.

```sql
INSERT INTO items (name, revenue, season_id)
VALUES ('italian beef', 600, NULL),
       ('cole slaw', 150, NULL),
       ('ice cream sandwich', 700, NULL);
```

Notice the result when we run an INNER JOIN on items and seasons.

```sql
SELECT i.name items, s.name seasons
FROM items i
INNER JOIN seasons s
ON i.season_id = s.id;
```

_Bonus: This query uses aliases for items (`i`) and seasons (`s`) to make it cleaner. Notice that it's not necessary to use `AS` to name the column headings._

```sql
items                | seasons
---------------------+---------
hot dog              | summer
veggie lasagna       | summer
striped bass         | summer
burger               | summer
arugula salad        | autumn
lobster mac n cheese | winter
grilled cheese       | spring
(7 rows)
```

We don't see any of the new items that have `NULL` values for `season_id`.

A `LEFT OUTER JOIN` will return _all_ records from the left table (items) and return matching records from the right table (seasons). Update the previous query and the return value and you should see something like this:

```sql
SELECT *
FROM items i
LEFT OUTER JOIN seasons s
ON i.season_id = s.id;
```

```sql
id  |         name        | revenue | season_id | id |  name
----+---------------------+---------+-----------+----+--------
 6 | hot dog              |    1000 |         1 |  1 | summer
 2 | veggie lasagna       |    1000 |         1 |  1 | summer
 3 | striped bass         |     500 |         1 |  1 | summer
 4 | burger               |    2000 |         1 |  1 | summer
 7 | arugula salad        |    1100 |         2 |  2 | autumn
 1 | lobster mac n cheese |    1200 |         3 |  3 | winter
 5 | grilled cheese       |     800 |         4 |  4 | spring
 8 | italian beef         |     600 |           |    |
 9 | cole slaw            |     150 |           |    |
10 | ice cream sandwich   |     700 |           |    |
(10 rows)
```

What do you think a `RIGHT OUTER JOIN` will do?

* Write a query to test your guess.
* Insert data into the right table that will not get returned on an `INNER JOIN`.

### Subqueries

Sometimes you want to run a query based on the result of another query. Enter subqueries. Let's say I want to return all items with above average revenue. Two things need to happen:

1. Calculate the average revenue.
1. Write a `WHERE` clause that returns the items that have a revenue
greater than that average.

Maybe something like this:
`SELECT * FROM items WHERE revenue > AVG(revenue);`

Good try, but that didn't work.

Subqueries need to be wrapped in parentheses. We can build more complex queries by using the result of another query. Try using the following structure:

```sql
SELECT * FROM items
WHERE revenue > (Insert your query that calculates the avg inside these parentheses);
```

The result should look like so...

```sql
id |         name         | revenue | season_id
----+----------------------+---------+-----------
 1 | lobster mac n cheese |    1200 |         3
 2 | veggie lasagna       |    1000 |         1
 4 | burger               |    2000 |         1
 6 | hot dog              |    1000 |         1
 7 | arugula salad        |    1100 |         2
(5 rows)
```


1. Without looking at the previous solution, write a `WHERE` clause that returns the items that have a revenue less than the average revenue.

### Additional Challenges

* Write a query that returns the sum of all items that have a category of dinner.
* Write a query that returns the sum of all items for each category. The end result should look like this:
```sql
name       | sum
-----------+------
dinner     | 2600
vegetarian | 2900
lunch      | 3900
side       | 2300
(4 rows)
```

### Possible Solutions

Some of these apply directly to challenges above. Most of them will need to be modified to acheive the challenge.


```sql
SELECT count(*) FROM items;
```

```sql
SELECT * FROM items WHERE course = 'main';
SELECT name FROM items WHERE course = 'main';
SELECT max(revenue), min(revenue) from items WHERE course = 'main';
SELECT sum(revenue) from items WHERE course = 'main';
```

```sql
SELECT * FROM items
WHERE revenue >
(SELECT AVG(revenue) FROM items);
```

```sql
SELECT SUM(i.revenue)
FROM items i
INNER JOIN item_categories ic
ON i.id = ic.item_id
INNER JOIN categories c
ON c.id = ic.category_id
WHERE c.name = 'dinner';
```

```sql
SELECT c.name, SUM(i.revenue)
FROM categories c
INNER JOIN item_categories ic
ON c.id = ic.category_id
INNER JOIN items i
ON i.id = ic.item_id
GROUP BY c.name;
```

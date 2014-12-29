---
title: Introduction to Sequel
length: 90
tags: sql, databases, modeling, sequel, ORMs
---

## Learning Goals

* Be able to explain why we'd want to generate SQL
* Understand the role of an Object Relational Mapper (ORM)
* Be able to generate `SELECT` and `INSERT` statements with `WHERE` using Sequel

## Structure

* 5 - Warmup
* 15 - Lecture
* 20 - Sequel Tutorial
* 5 - Break
* 20 - Sequel Tutorial
* 15 - Sequel Playground

## Warmup

With a partner, discuss the following questions: 

1. What's hard about SQL? Why is that a big deal?
2. Why would SQL be a difficult match for Object-Oriented programming like Ruby?

## Key Points

[slides](https://www.dropbox.com/s/75t98l4lnmr1ub4/intro_to_sequel.key?dl=0)

* SQL is no fun
* Declarative programming vs. Object-oriented programming
* Object-Relational Mappers (ORMs)
* ActiveRecord (lots), DataMapper (few), Sequel (practically none)
* Why should we use Sequel? 

## Independent Work

Get together with your pair to complete the
[Sequel tutorial](http://tutorials.jumpstartlab.com/topics/sql/sequel.html).

## Sequel Playground

Ok, so how do you use Sequel with Sinatra? Let's check out a simple app that uses Sequel.

* [Sequel Playground](https://github.com/rwarbelow/sequel-playground) 

### Extra Challenge

Return to the SQL tutorial and try to re-implement each of those steps using
Sequel instead of raw SQL.

## Resources

* [Sequel Cheat Sheet](http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html)

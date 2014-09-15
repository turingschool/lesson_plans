---
title: Understanding Multi-Tenancy
length: 150
tags: rails, http, sessions, cart, dinner dash
---

## Learning Goals

* Understand why apps implement multi-tenancy at a high level
* Understand how multi-tenancy is implemented at a database level
* Understand how multi-tenancy is handled at the controller level

## Structure

* 5 - Warmup
* 20 - Lecture: Database Level
* 5 - Break
* 25 - Lecture: Using Scopes
* 5 - Break
* 25 - Lecture: In the Controller
* 5 - Break
* 75 - Paired Work
* 10 - Questions & Recap

## Warmup

* Start a Gist
* Set the title to "Storing State in Sessions" and the file type to Markdown
* Paste in the following questions:

```
1. What does it mean for an application to be multi-tenant?
2. Why would you want to build an application to be multi-tenant?
3. How do you implement multi-tenancy at the data / database level?
4. How do Active Record scopes help keep tenant data segregated?
5. Why is multi-tenancy dangerous from a security/privacy perspective?
```

* Save it as a public Gist
* Edit the Gist (thus creating a second version)
* Answer the questions to the best of your knowledge
* Save it

## Full-Group Instruction

We'll start with a full-group lecture/discussion in three parts:

### Big Picture

* Why multi-tenancy?
* Some examples of multi-tenancy

### Part 1: Database Level

* Adding a foreign key to a table
* Using `WHERE`
* Choosing a database-wide primary key
* Tying all records / tying some records

### Part 2: Using Scopes with Active Record

* ActiveRecord makes your life easier
* Chaining `.where` onto your class method queries
* Default Scope (don't do it)
* An implicit `.where`

### Part 3: Creating Records

* Putting the foreign key in the form
* It works!
* Why you shouldn't do that
* Building off a relationship
* Query off a relationship

## Independent Work

Get together with your pair and follow the very terse instructions here:

http://tutorials.jumpstartlab.com/topics/blogger/multitenancy.html

## Questions & Wrapup

First we'll discuss any questions from the independent work.

Then spend the last five minutes returning to your Gist from the Warmup, edit
to create a third version, and update your answers.

## Corrections & Improvements for Next Time

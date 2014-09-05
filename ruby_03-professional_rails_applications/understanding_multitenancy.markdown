---
title: Understanding Multi-Tenancy
length: 180
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
* 60 - Paired Work
* 25 - Questions & Recap

## Warmup

* Start a Gist
* Set the title to "Storing State in Sessions" and the file type to Markdown
* Paste in the following questions:

```
1. What does it mean for an application to be multi-tenant?
2. What would you want to build an application to be multi-tenant?
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

### Part 1: Database Level

### Part 2: Using Scopes with Active Record

### Part 3: In the Controller

## Independent Work

Get together with your pair and follow the very terse instructions here:

http://tutorials.jumpstartlab.com/topics/blogger/multitenancy.html

### Basic

* Get through scoping the article index by username

### Intermediate

* Automatically set the user for newly created articles
* Scope the edit/delete operations to the current user

### Challenging

* Add functionality such that a user can edit their own comment, but not comments
left by another user.

## Wrapup

Spend the last five minutes returning to your Gist from the Warmup, edit
to create a third version, and update your answers.

## Corrections & Improvements for Next Time

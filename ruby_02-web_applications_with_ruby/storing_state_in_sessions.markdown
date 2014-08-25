---
title: Storing State in Sessions
length: 90
tags: rails, http, sessions, cart, dinner dash
---

## Learning Goals

* Understand how cookies are a part of the request/response cycle
* Understand how cookies and sessions tie together
* Understand that cookies involve serialization via JSON
* Practice the syntax for setting and fetching session data
* Discuss creating a PORO to wrap a hash
* Understand how to tie a session reference to a database object

## Structure

* 5 - Warmup
* 20 - Full-Group Instruction
* 5 - Break
* 25 - Multi-Request Experiments
* 5 - Break
* 15 - Independent Work
* 5 - Wrapup

## Warmup

* Start a Gist
* Set the title to "Storing State in Sessions" and the file type to Markdown
* Paste in the following questions:

```
1. What's the difference between a cookie and a session?
2. What's serialization and how does it come into play with cookies?
3. Can a cookie be shared by more than one user? How/why?
4. What would it mean to store a shopping cart in a cookie?
5. What advantages/disadvantages are there between cookie-stored carts and
database-stored carts?
```

* Save it as a public Gist
* Edit the Gist (thus creating a second version)
* Answer the questions to the best of your knowledge
* Save it

## Full-Group Instruction

* Recapping Request/Response and Cookies
* How a cookie ties to a session
* Cookies are strings, JSON serialization
* Setting and fetching a value

## Multi-Request Experiments

* Storing a cart in the cookie
* Creating a PORO model for a cookie-based cart
* Creating a database cart model, storing a reference in the cookie

## Independent Work

You can really use any Rails application for experimenting with sessions,
but a good choice would be to clone and try our
[Storedom Sample App](git@github.com:turingschool-examples/storedom.git).

### Basic

If you'd like to review the core concepts discussed during the Full-Group
instruction, read through and experiment with the
[Sessions & Conversations Tutorial](http://tutorials.jumpstartlab.com/topics/controllers/sessions_and_conversations.html)
up to the heading "Storage Options".

### Intermediate

Experiment with implementing the ActiveRecord Session Store by referencing:

* [The project's README](https://github.com/turingschool-examples/storedom)
* Our [Sessions & Conversations Tutorial](http://tutorials.jumpstartlab.com/topics/controllers/sessions_and_conversations.html)
starting at "Database Storage with ActiveRecordStore"

### Challenging

Read [this blog post about "Session Store & Security"](http://dev.housetrip.com/2014/01/14/session-store-and-security/)
and experiment with cookie tampering and decoding.

## Wrapup

Spend the last five minutes returning to your Gist from the Warmup, edit
to create a third version, and update your answers.

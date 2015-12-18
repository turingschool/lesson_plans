---
title: Storing State with Cookies & Sessions
length: 120
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
* 10 - Full-Group Instruction (continued)
* 15 - Multi-Request Experiments
* 5 - Break
* 15 - Multi-Request Experiments (continued)
* 10 - Independent Work
* 5 - Break
* 20 - Independent Work (continued)
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

Our full-group session will be a mix of whiteboard discussion and live code
experiments. We'll use the
[Storedom Sample App](https://github.com/turingschool-examples/storedom)
as a basis for experimenting.

* Recapping Request/Response and Cookies
* How a cookie ties to a session
* Cookies are strings
* Serialization via JSON
* Setting and fetching a value

## Multi-Request Experiments

The second full-group session will involve more input from the class and use
Storedom as the base to:

* Create a simple hash-based cart
* Store the cart in the cookie
* Interact with the cart across requests
* Create a PORO model to wrap the cookie-based cart
* Discuss the plusses and minuses of this approach

Then, as a second approach:

* Create a database-backed cart model
* Store a reference in the cookie
* Use a `before_filter` to lookup the cart as a request comes in
* Discuss the plusses and minuses of this approach

## Independent Work

You can really use any Rails application for experimenting with sessions,
but a good choice would be to clone and try our
[Storedom Sample App](https://github.com/turingschool-examples/storedom).

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

## Corrections & Improvements for Next Time

* I ended up using the example of a "hit counter" to demonstrate how data is
persisted across requests, including how data dies when the cookie is deleted
* I drew a diagram here: http://cl.ly/image/2V2c3o1H0d1w
* The "Basic" tutorial could explain things a little more step-by-step about how to add something meaningful to the cart

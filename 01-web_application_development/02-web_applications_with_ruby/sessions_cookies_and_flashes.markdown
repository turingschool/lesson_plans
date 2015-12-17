---
title: Sessions, Cookies, and Flashes
length: 120
tags: rails, http, sessions, cart, dinner dash
---

## Learning Goals

* Understand how cookies are a part of the request/response cycle
* Understand how cookies and sessions tie together
* Understand how to store state in both cookies and sessions
* Practice the syntax for setting and fetching session data
* Practice setting flash messages based on conditionals

## Structure

* 15 - Whiteboard discussion: Request/Response and Cookies
* 45 - Code Along Video
* 30 - Q&A
* 30 - Begin Homework

## Warmup

1. What is a cookie?
1. What's the difference between a cookie and a session?
1. What's serialization and how does it come into play with cookies?
1. Can a cookie be shared by more than one user? How/why?
1. What would it mean to store a user id in a cookie?

## Full-Group Instruction

* Recapping Request/Response and Cookies
    - HTTP is stateless
    - Use cookies to maintain state

## Code at Your Own Pace

Clone [Storedom](https://github.com/turingschool-examples/storedom)

Code along with this [video](https://vimeo.com/130058574)

If you finish early...

* experiment with [`flash.now`](http://guides.rubyonrails.org/action_controller_overview.html#flash-now)
* read this blog post about [hacking Rails](http://robertheaton.com/2013/07/22/how-to-hack-a-rails-app-using-its-secret-token/) from 2013. Some of the content in this article is out of date but the concepts still apply.

## Question & Answer

* What makes sense?
* What's confusing?

1. What is a cookie?
1. What's the difference between a cookie and a session?
1. What's serialization and how does it come into play with cookies?
1. Can a cookie be shared by more than one user? How/why?
1. What would it mean to store a user id in a cookie?

## Begin Homework

## Notes

* Cookies are strings
    - But we can interact with them like a hash
    - Show how to use a cookie as a hit counter
    - Show how to edit a non-serialized cookie in the browser (why using a session is a good idea)
* How a cookie ties to a session
    - Convert our hit-counter to a session
* Setting and fetching a value
* Serialization via JSON
    - Values are hashed using `secret_key_base` in `secrets.yml`
    - Much more secure than non-serialized cookie
    - Database backed sessions are even more secure


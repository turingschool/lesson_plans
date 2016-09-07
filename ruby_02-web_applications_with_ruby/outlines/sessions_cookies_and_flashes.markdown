---
title: Sessions, Cookies, and Flashes
length: 90
tags: rails, http, sessions, cart, dinner dash
---

## Learning Goals

* Understand how cookies are a part of the request/response cycle
* Understand how cookies and sessions tie together
* Understand how to store state in both cookies and sessions
* Practice the syntax for setting and fetching session data
* Practice setting flash messages based on conditionals

## Structure

* 25 - Whiteboard discussion: Request/Response and Cookies
* 45 - Code Along
* 10 - Q&A + Begin Homework

## Request/Response and Cookies

### When You're Finished

When this session is over you should be able to answer the following:

1. What is a cookie?
1. What's the difference between a cookie and a session?
1. What's serialization and how does it come into play with cookies?
1. Can a cookie be shared by more than one user? How/why?
1. What would it mean to store a user id in a cookie?

### Discussion Points

* Recapping Request/Response 
* Stateless protocol
* Cookies and flow
* What goes in a cookie?
* Limitations & security concerns

## Code Along at Your Own Pace

Clone [Storedom](https://github.com/turingschool-examples/storedom)

Code along with this [video](https://vimeo.com/130058574)

If you finish early...

* experiment with [`flash.now`](http://guides.rubyonrails.org/action_controller_overview.html#flash-now)
* read this blog post about [hacking Rails](http://robertheaton.com/2013/07/22/how-to-hack-a-rails-app-using-its-secret-token/) from 2013. Some of the content in this article is out of date but the concepts still apply.

## Q&A

Return to the questions above. Which can you answer? Any areas of confusion?

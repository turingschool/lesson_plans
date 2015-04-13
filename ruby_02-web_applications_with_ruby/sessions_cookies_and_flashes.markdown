---
title: Sessions, Cookies, and Flashes
length: 120
tags: rails, http, sessions, cart, dinner dash
---
## WIP

** NOTE: Lesson was formerly based on [Storing State with Cookies & Sessions](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/storing_state_with_cookies_and_sessions.markdown).
It was broken apart to demonstrate storing the cart in session in a separate lesson.**

## Learning Goals

* Understand how cookies are a part of the request/response cycle
* Understand how cookies and sessions tie together
* Understand that cookies involve serialization via JSON
* Practice the syntax for setting and fetching session data

## Warmup

```
1. What's the difference between a cookie and a session?
2. What's serialization and how does it come into play with cookies?
3. Can a cookie be shared by more than one user? How/why?
4. What would it mean to store a user id in a cookie?
```

## Full-Group Instruction

Our full-group session will be a mix of whiteboard discussion and live code
experiments. We'll use the
[Storedom Sample App](https://github.com/turingschool-examples/storedom)
as a basis for experimenting.

* Recapping Request/Response and Cookies
    - HTTP is stateless
    - Use cookies to maintain state
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


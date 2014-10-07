---
title: SRP Controllers
length: 180
tags: rails, controllers, refactoring, apis
---

## Learning Goals

* Practice ripping apart complex controllers into smaller components
* Apply the Single Responsibility Principle to controllers
* Practice implementing namespaced controllers
* Practice using inheritance in Rails controllers

## Structure

* 5 - Warmup
* 20 - Discussion: Controllers, SRP, and `respond_with`
* 5 - Break
* 25 - Code: Implementing an API controller
* 5 - Break
* 25 - Group Work 1: Build an API controller
* 5 - Break
* 25 - Code: Admin Controllers
* 5 - Break
* 25 - Group Work 2: Implement an Admin controller
* 5 - Break
* 60 - Apply It

## Plan

### Discussion: Controllers, SRP, and `respond_`

* Controllers touch everything
* [SRP on Wikipedia](http://en.wikipedia.org/wiki/Single_responsibility_principle)
* `respond_to` and `respond_with` are cool and terrible
* REST is a concept, not a law
* APIs, especially, change and grow over time -- they need versions
* Controllers are where security goes wrong
* The more context you need, the harder it is to reason about code
* `if` statements are not OOP and they're sometimes a code smell
* Build lots of small things, not a few big things

### Code: Implementing an API controller

* Start with the example code base
* Create the routes using `namespace` [(docs)](http://guides.rubyonrails.org/routing.html#controller-namespaces-and-routing)
* Generate a controller with `api/v1/orders`
* Implement the controller using `respond_to` and `respond_with`
* Test it in the browser

### Group Work 1: Build an API Controller

Now get together with your first pair and implement an API controller for
`items` using the same steps as above.

### Code: Admin Controllers

* Continue with the example code base
* Create routes using `namespace`
* Generate a controller with `admin/orders`
* Move admin-only actions to the new controller
* Duplicate shared actions

### Group Work 2: Build an Admin Controller

Follow the same steps above to create an admin controller for `items`.

### Apply It

Get together with your pair and implement these techniques in one of your
*real* projects.

* If one of your independent projects has admin or API (as in serving an API)
functionality, then use that
* If not, then grab one of your The Pivot projects and add it there

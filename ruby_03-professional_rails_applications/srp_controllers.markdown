---
title: SRP Controllers
length: 180
tags: rails, controllers, refactoring, apis
---

## Instructor Setup

* Two sets of pairings for activities
* Base Storedom project cloned and bundled

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

### Warmup

Three quick questions to get you thinking:

1. What's the job of a controller in Rails?
2. Why do controllers tend to get complicated?
3. What is the Single Reponsibility Principle about?

### Discussion: Controllers, SRP, and `respond_`

* Controllers touch everything
* [SRP on Wikipedia](http://en.wikipedia.org/wiki/Single_responsibility_principle)
* `respond_to` and `respond_with` are cool and terrible
* [REST](http://en.wikipedia.org/wiki/Representational_state_transfer) is a concept, not a law
* APIs, especially, change and grow over time -- they need versions
* Controllers are where security goes wrong
* The more context you need, the harder it is to reason about code
* `if` statements are not OOP and they're sometimes a code smell
* Build lots of small things, not a few big things

### Code: Implementing an API controller

Let's build an example API controller/action for **Orders**:

* Start with the [Storedom example code base](https://github.com/turingschool-examples/storedom)
* Create the routes using `namespace` [(docs)](http://guides.rubyonrails.org/routing.html#controller-namespaces-and-routing)
* Generate a controller with `api/v1/orders`
* Implement the controller using `respond_to` and `respond_with` [(docs)](http://apidock.com/rails/ActionController/MimeResponds/respond_with)
* Test it in the browser

### Group Work 1: Build an API Controller

Now get together with your first pair and implement an API controller for
`items` using the same steps as above.

* Basic:  Index  => GET  /api/v1/items.json
* Medium: Show   => GET  /api/v1/items/1.json
* Fancy:  Create => POST /api/v1/items.json

### Code: Admin Controllers

Our sample application currently has a list of all orders exposed at OrdersController#index. Probably this isn't info we want visible to everyone who visits the site, so let's look at moving it into an admin namespace.

* Continue with the example code base
* Create routes using `namespace`
* Generate an Admin::OrdersController under `admin/orders`
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

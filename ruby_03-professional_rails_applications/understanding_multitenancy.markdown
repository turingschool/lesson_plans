---
title: Understanding Multitenancy
length: 180
tags: rails, pivot, controllers, models, routes, multitenancy
---

## Learning Goals

* Understand why apps implement multi-tenancy at a high level
* Understand how multi-tenancy is implemented at the routes level
* Understand how multi-tenancy is implemented at a database level
* Understand how multi-tenancy is handled at the controller level

## Structure

* 10 - Lecture: High Level Multitenancy
* 15 - Project Setup
* 5 - Break
* 25 - Lecture: Router & Controller Multitenancy
* 5 - Break
* 25 - Lecture: Database Multitenancy
* 5 - Break
* 20 - Workshop 1
* 5 - Questions & Recap

## Discussion -- What is Multitenancy?

* Intro -- view some examples (etsy, ebay, shopify, squarespace)
* What distinguishes a software "platform"?
* What differentiates a store that sells its own goods from a store that lets other people sell goods?
* What other ways might a software company support multiple tenants -- multi-instance (self-hosted)
vs single-instance (SaaS)
* Marketplace / Platform / Whitelabel -- very common software product patterns
* Economics of a multitenant product -- what is the additional value that the platform owner
is providing?

__Multitenancy Scoping, Security, and Authorization Concerns__

* Recall - what's the difference between authorization and authentication?
* What additional burdens does a multi-tenant system add with regard to these concepts?
* How can we keep one store from interacting with data from another?
* _Multitenancy_ -- kind of a big scary word for just another type of DB relationship

## Multitenancy in Rails -- DB and Routing Concerns

What about actually adding multitenancy to an application? Let's consider
the changes we would need to make.

Let's start with the Storedom schema -- what changes would we need to make in order to
make this application support multiple stores?

1. Need a way to represent our stores / tenants
2. Need a way to associate other "nested" data with stores

Similarly, at the routing and controller level, we need to identify
which specific store we're talking about at certain points (for example when
browsing a list of items)

1. How can we include and capture store/tenant information from our URLs?
2. What extra work will we need to do in our controllers to account for this?

## Workshop -- Adding Multitenant Stores to Storedom

For this workshop, you will work through the process of adding a concept
of separate stores to the storedom project, and scoping items and orders so
that they are attached to specific stores.

### Setup

```
git clone https://github.com/turingschool-examples/storedom.git multitenancy
cd multitenancy
bundle && bundle exec rake db:drop db:setup
```

### Process

Here's a breakdown of the big goals we need to achieve. Let's
see if we as a group can devise a way to tackle these in terms
of the routing and relationship constructs Rails gives us.

__Objectives:__

1. Need a record to model our "stores"
2. Need a way to view our stores in the app (at least an index / show)
3. Need a way to associate an item with a store (Q: what shape does this relationship take)
4. Need a way to view an item within the app _with contextual info about what store it's associated with_.
5. Need a way to prevent accessing the items in the wrong store (redirect? 404?)

__Open Questions__

* What should we show when viewing a store? A list of stores?
* What other records need to be associated with a single store?

### Your Turn

Go through the same procedure for the "orders" model:

* Modify your DB schema and AR relationships to associate an order with a given store

* Create a namespaced route for the orders within a store
* Add a stores/order controller and a view that lists the orders that belong to that store
* Add an orders url in the navbar to access these orders only when a store is present
* Add an order to the store via the console and verify that it works

## Supporting Materials

* [Notes](https://www.dropbox.com/s/kpm2ddj6k08hzrk/Turing%20-%20Understanding%20Multitenancy%20%28Notes%29.pages?dl=0)
* [Slides](https://www.dropbox.com/s/7so7sacihvoelfs/Turing%20-%20Understanding%20Multitenancy.key?dl=0)
* [Video 1502](https://vimeo.com/128198524)

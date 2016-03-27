---
title: Understanding Multi-tenant Applications
length: 120
Tags: multi-tenancy, rails, pivot, controllers, models, routes, namespacing
---

### Goals

By the end of this lesson, you will know/be able to:

* Explain what a multi-tenant application is, and why we need one.
* Implement multi-tenancy at a routes level
* Implement multi-tenancy at the controller level.
* Design a database scheme for a multi-tenant application.

### Structure

* 10 - Conversation: High Level Multi-tenancy
* 15 - App Setup
* 5  - Break
* 25 - Setting up routes and controllers for Multi-tenancy
* 5  - Break
* 25 - Database level Multi-tenancy
* 5  - Break
* 20 - Workshop 1
* 5  - Questions

## Multi-tenancy. What is it? and why do we need it?

* First there was a store.
* Then there was a marketplace.
* Examples of Multi-tenant applications - ebay, shopify, squarespace, etsy.
* Basically a single instance of the software is deployed vs. many instances.
* Single maintained large dataset that breaks down into smaller datasets for each customer/owner.

## Issues/Concerns of a Multi-tanant site.

* Authentication.
* Authorization - Scoping by role.
  * keeping one store from accessing and changing data from a different store.
* Database design and relationships.

## Multi-tenant Routing

* A single store software platform. What we've seen so far:
  * `/items`
  * '/items/:id' --> `/items/12`
* We need nested data for stores. We need a way to represent data for specific stores / tenants. What will our routes look like?
* What we need for multi-tenancy:
  * `/:store_name/items`
  * `/:store_name/items/:id` --> `/:store_name/items/12`

#### How?

* Namespacing in the router.

## Multi-tenancy Controllers. Whos is whos?

* Implementing multi-tenancy means we need to scope controllers to account for different user roles.
* ItemsController vs Store::ItemsController

#### How?

* Namespacing in the router.


## So now what? Let's do it.

Let's work through making the storedom repo, currently a single store platform, a multi-tenant platform.

```
git clone https://github.com/turingschool-examples/storedom.git multitenancy
cd multitenancy
bundle && bundle exec rake db:drop db:setup
```

### What do we want to accomplish?

1. We need to model our store.
2. We need to view our stores in the app (at least an index / show)
3. We need a way to associate an item with a store.
5. We need to establish the correct relationship between stores and their items.
6. We need a way to view an item within the app _and know which store it actually belongs to_.
7. We need to prevent access to items in the wrong store.



### Video

* [Understanding Multi-Tenancy - Oct. 2015](https://vimeo.com/142297870)
* [Understanding Multi-Tenancy - May. 2015](https://vimeo.com/128198524)

### Repository

* [Repo for the lesson](https://github.com/turingschool-examples/storedom)

### Resources

* [QuickLeft blog post/ discussion on Multi-tenancy](https://quickleft.com/blog/what-is-a-multi-tenant-application/)
*

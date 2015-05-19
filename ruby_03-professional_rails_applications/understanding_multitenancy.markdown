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

## Repository

git clone https://github.com/turingschool-examples/storedom.git multitenancy

## Procedure

1. Clone Storedom and prepare the database
2. Launch server and explore the app
3. Modify the router
  1. Add namespace in routes
  2. Change the root to stores#index
4. Add the controllers
  1. Create stores controller
  2. Create stores/stores controller
  3. Create stores/items controller
5. Add Store model
  1. Create Store model
  2. Create migration to add store_id to items
  3. Add validations to store
  4. Add before_validation callback
  5. Add generate_url method
  6. Add store-items relationship
    1. Add store relationship to Item
    2. Add item relationship to Store
6. Add helpers to stores/stores
  1. Add current_store method and helper
  2. Add store_not_found and before_action
  3. Modify stores/items to inherit from stores/stores
7. Add some items to the store
8. Fix the layout
  1. Show items when @current_store is present
9. Workshop 1 - Adding Orders

## Workshops

### Workshop 1

* Create a namespaced route for the orders within a store
* Add a stores/order controller and a view that lists the orders that belong to that store
* Add an orders url in the navbar to access these orders only when a store is present
* Add an order to the store via the console and verify that it works

## Supporting Materials

* [Notes](https://www.dropbox.com/s/kpm2ddj6k08hzrk/Turing%20-%20Understanding%20Multitenancy%20%28Notes%29.pages?dl=0)
* [Slides](https://www.dropbox.com/s/7so7sacihvoelfs/Turing%20-%20Understanding%20Multitenancy.key?dl=0)
* [Video 1502](https://vimeo.com/128198524)

## Corrections & Improvements for Next Time

* Have the application cloned beforehand in case the internet is not working.
* Bundle the gems and setup the database too.

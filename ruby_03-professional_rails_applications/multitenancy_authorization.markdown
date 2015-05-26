---
title: Multitenancy Authorization
length: 180
tags: rails, pivot, controllers, models, routes, multitenancy, security
---

## Learning Goals

* Understanding how to implement an authorization strategy from scratch
* Using a service object to isolate the authorization logic

## Structure

* 15 - Lecture: High Level Multitenancy Authorization
* 5 - Explore the App
* 5 - Break
* 25 - Lecture: Creating the models to support the authorization strategy
* 5 - Break
* 25 - Lecture: Implementing a permissions service
* 5 - Break
* 25 - Lecture: Modifying the application controller
* 5 - Break
* 25 - Lecture: Refactor and Extend our model
* 5 - Break
* 25 - Workshop
* 5 - Questions & Recap

## Repository

git clone -b multitenancy_authorization https://github.com/turingschool-examples/storedom.git multitenancy_authorization

## Procedure

1. rails g model Role name:string
2. rails g model UserRole user:references role:references
3. Add UserRole relationship in Role
4. Add UserRole relationship in User
5. rake db:migrate
6. Create three roles
  1. platform_admin
  2. store_admin
  3. registered_user
7. Add Permission methods in user model
  1. platform_admin?
  2. store_admin?
  3. registered_user?
8. Create services folder
9. Create Permission service
  1. initialize the object with a user
  2. implement #allow? method
  3. Only allow users to visit the stores controller
  4. Add additional permissions
  5. Add guest_user and add conditional
  6. Abstract permissions into private methods
10. Add Permission methods in ApplicationController
  1. current_permission
  2. authorize!
  3. before_action :authorize!
  4. private method :authorize?
11. Add helpers in ApplicationHelpers
  1. platform_admin?
  2. store_admin?
  3. registered_user?
12. Workshop

## Workshops

### Workshop 1

1. Can you build the permissions for a store admin?
2. The store admin will have access to the stores, sessions, items, and orders controllers.
3. However, he won’t have access to the users controller.
4. Can you create a helper that will hide that functionality from the navbar?

## Supporting Materials

* [Notes](#)

## Corrections & Improvements for Next Time

* None Yet

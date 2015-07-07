---
title: Multitenancy Authorization
length: 180
tags: rails, pivot, controllers, models, routes, multitenancy, security
---

## Learning Goals

* Recognize the limitations of single role / column-based authorization strategies
* Discuss patterns for implementing more sophisticated authorization strategies
* Practice using ActiveRecord models to implement an authorization strategy from scratch

## Structure

* 15 - Discussion: previously encountered authorization models
* 10 - Discussion: a more flexible approach to modeling application roles
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

## Discussion - previous authorization models

* What resources have you needed to authorize in previous projects?
* What levels of authorization existed? (admin? super admin? super duper admin?)
* What resources could each level of authorization access?
* How did we **model** these relationships at the data layer?

## Discussion - Limitations of Column-Based role modeling

There's a good chance your previous attempts used some sort of column on the users table
to track whether a given user was an "admin" and maybe also a "platform admin".

This strategy has few moving parts, making it simple. But what are the limitations?

What did you have to do when a new role was needed?

Alternatively, we could have had a second table -- "admins" -- and inserted
simple records for each user that we want to mark as an admin (with "id" and "user_id" as the only columns).

But we still run into the same fundamental problems -- adding more roles requires modifications
to our schema since we need to add more tables or columns to represent the new information.

## Discussion - a more flexible approach to modeling application roles

This is actually a very common problem in larger applications. Just about any
sophisticated business will need to track various "roles" within their organization.
Additionally, you'll frequently need to create these on the fly, perhaps even
letting non-technical users do this through a web interface of some sort.

So let's talk about what it would look like. What are the concepts we're dealing with?

* "Roles" or "Permissions" - Some notion of multiple levels of access within the app
and the need to store these independently
* "Users" - Existing idea of user accounts. Remember that an account largely
handles the problem of authentication rather than authorization.
* "User-Roles" - Once we've come up with a separate way of modeling the roles
themselves, we need a way to flexibly associate multiple users to multiple roles.

Hopefully this shape is starting to make sense as a normal many-to-many relationship
using a join table to connect betwen the 2 record types. Modeling roles in this way
will allow us to re-use a handful of roles for a large number of user accounts.

## Workshop 1 - Implementing Role-based Authorization

Let's walk through the process of implementing role-based authorization.

Here's a short list of goals we'd like to enable

1. Add a route to edit and update stores that can only be accessed by admins
2. Add a separate Roles table to track the existing roles
3. Add a capability to grant a user a role
4. Add a route to edit and update items that can be accessed by either "admins" or "inventory managers"

__Setup__

For this workshop, let's use a branch of storedom that already has basic store-based
multitenancy set up:

```
git clone -b multitenancy_authorization https://github.com/turingschool-examples/storedom.git multitenancy_authorization
```

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

* [Notes](https://www.dropbox.com/s/2b1zpyj8qm8acdu/Turing%20-%20Multitenancy%20Authorization%20%28Notes%29.pages?dl=0)
* [Video 1502](https://vimeo.com/128915494)

## Corrections & Improvements for Next Time

* Include a store admin example in the notes that implements a store admin that only has admin access to his/her store.

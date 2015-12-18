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
* 5  - Explore the App
* 5  - Break
* 25 - Lecture: Creating the models to support the authorization strategy
* 5  - Break
* 25 - Lecture: Implementing a permissions service
* 5  - Break
* 25 - Lecture: Modifying the application controller
* 5  - Break
* 25 - Lecture: Refactor and Extend our model
* 5  - Break
* 25 - Workshop
* 5  - Questions & Recap

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

## Hotseat Workshop 1 - Implementing Role-based Authorization

Let's walk through the process of implementing role-based authorization.

Here's a short list of goals we'd like to enable

1. Add a route to edit and update stores that can only be accessed by admins
2. Add a separate Roles table to track the existing roles
3. Add a capability to grant a user a role
4. Add methods to users to let us inquire about their permissions
5. Add a route to edit and update items that can be accessed by either "admins" or "inventory managers"

__Setup__

For this workshop, let's use a branch of storedom that already has basic store-based
multitenancy set up:

```
git clone -b multitenancy_authorization https://github.com/turingschool-examples/storedom.git multitenancy_authorization
cd multitenancy_authorization
bundle
bundle exec rake db:drop db:setup
```

## Discussion - Better abstraction around handling permissions

This current setup is much improved -- we have the ability to store
arbitrary roles and connect them with arbitrary numbers of users.

Are there any things we still don't like about our current implementation?

What functionality did we have to add to our users? How do we feel about this?
In particular, how will we feel about it as our number of roles increases?

Let's look at some ways to improve this situation by using a secondary object.
We need an object that encapsulates the responsibility of querying authorization
roles and determining permissions for a given resource.

Sometimes we'll refer to a utility / helper object like this as a "service",
so in our case what we really need is a "Permission".

Let's think of the things a permission needs / needs to do:

* What data will it need when initialized? (What data does it need to know to do its job?)
* What sort of things do we want to be able to ask it? (hint: think about the permission-related stuff we added to users)
* What other parts of our application will need to interact with this object?
* What sort of interface would we like to see to interact with the Permission object?

## Hotseat Workshop 2 - Using permission object to encapsulate authorization logic

Let's work through the process of implementing these features.

## Discussion - Extending our permissions model to handle store-specific authorization

So we've added a flexible permissions model and refactored it to better encapsulate
the logic within a dedicated object.

But something is still missing. We haven't yet tackled the problem of authorizing users
across multiple stores. That is, we need a way to ensure that a user who's
authorized as an admin for Store A can't manipulate the items of Store B.

Can we boil down the main component missing from our authorization system?

* How can we modify the relationship so that roles can be connected to users
as well as to specific stores?
* What changes in our authorization logic are needed to account for this new information?

## Solo Workshop 3 - Scoping permissions by store

Working by yourself, modify the existing authorization model to account
for store-based as well as user-based authorization:

1. Add a `store_id` column to the UserRoles table
2. Add a test to verify that a user authorized for one store can't
edit items of another store
3. Modify the `Permissions` object to account for this additional logic. You
may need to modify its existing APIs. Don't forget to add unit tests for this step.

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

## Supporting Materials

* [Notes](https://www.dropbox.com/s/2b1zpyj8qm8acdu/Turing%20-%20Multitenancy%20Authorization%20%28Notes%29.pages?dl=0)
* [Video 1502](https://vimeo.com/128915494)
* [Video 1505](https://vimeo.com/137451107)
* [Repo from 1503 Session](https://github.com/NYDrewReynolds/multitenancy_auth)

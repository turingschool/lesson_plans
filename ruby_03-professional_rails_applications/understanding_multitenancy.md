---
title: Understanding Multitenancy
length: 180
tags: rails, pivot, controllers, models, routes, multitenancy
---

## Learning Goals
By the end of this lesson, you will know/be able to:

* Explain what multi-tenancy is and why we implement it.
* Implement multi-tenancy at the routes level.
* Implement multi-tenancy at the controller level.
* Design a database for a mutli-tenant application.


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

## Discussion -- What is Multitenancy?

#### Development as a metaphor for development

As a developer (the real-estate variety) you start by buying a small plot of land, and building a little shop. A business moves in and that business has it's own customers. You can do this for a few more businesses, and each building is completely different, and built to the needs of the business. These are a basic web apps; the type you're used to building.

After some successes, you build a strip mall. Many businesses move in, and each of them have their own customers. You've built one large building to house them all, but each business has their own address. They really aren't related in any way. They can put up a logo on the front, and they can put whatever fixtures they want inside, but each business is in basically the same space. This is a basic form of multi-tenancy. Squarespace is like this.

Now you want to go big. You build a mall. Your mall has many shops in it, but you can sell gift cards that all of the shops take. Customers can browse all of the stores by walking around the mall, and go into the stores they want. At your mall, customers can bundle items from different shops, and pay for them all at once. Innovation!

This is the kind of multi-tenancy we're going to talk about. We're going to build a "mall" where users register once for your site, and can shop anywhere, and check out once.

#### Multi-tenancy on the web

* View some examples (etsy, ebay, shopify, squarespace)
* What distinguishes a software "platform"?
* What differentiates a store that sells its own goods from a store that lets other people sell goods?
* What other ways might a software company support multiple tenants -- multi-instance (self-hosted)
vs single-instance (SaaS)
* Marketplace / Platform / Whitelabel -- very common software product patterns
* Economics of a multi-tenant product -- what is the additional value that the platform owner
is providing?

#### Multitenancy Scoping, Security, and Authorization Concerns

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

### Takeaways

- When you want text in your URLs, use slugs. Slugs are short text strings that use only lowercase letters, numbers and dashes. Rails gives you `parameterize` for this.
- When you have models that only exist in the context of other models, you'll nest child resources inside folders for the parent resources in the `controllers` and `views` folder
- Then to access nested controller actions, use something like the following in your routes file

```ruby
get ':store/items', to: 'store/items#index', as: :store_items
get ':store/items/:id', to: 'store/items#show', as: :store_item
```

is the same as...

```ruby
namespace :store, path: ':store', as: :store do
  get 'items', to: "items#index", as: :items
  get 'items/:id', to: "items#show", as: :item
end
```

is the same as...

```ruby
namespace :store, path: ':store', as: :store do
  resources :items, only: [:index, :show]
end
```

they all give this result when you `rake routes`:

```
Prefix Verb URI  Pattern                     Controller#Action
store_items GET  /:store/items(.:format)     store/items#index
store_item  GET  /:store/items/:id(.:format) store/items#show
```

### Your Turn

Go through the same procedure for the "orders" model:

* Modify your DB schema and AR relationships to associate an order with a given store
* Create a namespaced route for the orders within a store
* Add a stores/order controller and a view that lists the orders that belong to that store
* Add an order to the store via the console and verify that it works
* Add an orders url in the navbar to access these orders only when a store is present

## Supporting Materials


* [Video 1502](https://vimeo.com/128198524)
* [Video 1505](https://vimeo.com/137402841)

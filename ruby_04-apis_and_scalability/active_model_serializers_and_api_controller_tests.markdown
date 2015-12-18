---
title: ActiveModel Serializers and Testing API Controllers
length: 90
tags: api, rails, json, testing
---

## Learning Goals

* Use Rails controller tests to test JSON apis
* Use ActiveModel::Serializers to customize JSON responses

## Structure

* 25 - Warm Up and Discussion
* 5 - Break
* 25 - API TDD Codealong (Articles#show)
* 5 - Break
* 25 - Your Turn - students add Articles#index

## Warm-Up

__JSON Serialization in Rails__

* `ActiveRecord#to_json` -- Rails' default serialization technique -- What are its limitations?
* Alternatives -- ActiveModel::Serializers, Jbuilder, Rabl, Draper --
  what do these do?
* ActiveModel::Serializers -- Advantages: Easy Ember integeration; ease
  of use; maintains "object-oriented" approach to generating JSON

__Testing Rails APIs__

* Integration tests vs. Controller tests -- pros / cons (controller
  tests lighter, less "full-stack"; integration tests generally more
  robust, but also slower and more complicated)
* needs for testing a JSON API -- no "UI" _per se_, so we have less need
  for a full "integration" test

## Tutorial

Let's get familiar with these techniques by TDD'ing a simple API for the
Blogger project.

1. Project setup -- you and blogger are old friends by now; clone the
   project, bundle, setup, etc:

```
git clone https://github.com/JumpstartLab/blogger_advanced.git
cd blogger_advanced
bundle
rake db:drop db:create db:migrate db:seed
```

Let's work through adding a simple API to expose article data.

For now our API can be read-only, so let's add a simple `#show`
and `#index` endpoint.

We'll serve both endpoints under the `api/v1/articles` route
namespace.

For the Articles#show, endpoint, we'll retrieve the article
by its id, and expose these pieces of information:

* id
* title
* body
* Author's name

__Code-A-Long__ -- follow along as we TDD an implementation
of the Article#show endpoint to expose these data. We'll use
controller tests to verify the behavior of our API and
ActiveModel::Serializers to generate the JSON.

cheatsheet

__intstalling activemodels serializers__:

```
gem 'active_model_serializers'
rails g serializer article
```

__Your Turn__ -- following the example we just did, add an additional
endpoint for Articles#index

Remember that this should be served at the `api/v1/articles` route.

For the index, expose the following data for each article:

* id
* title
* tag names (remember that articles have many tags via taggings)
* number of comments

(Hint: you can always add a second serializer for this endpoint if
necessary)

__If we get here...__ -- If we finish all that, let's look and endpoints
that accept or modify data. For starters, let's add an endpoint to
create an article.

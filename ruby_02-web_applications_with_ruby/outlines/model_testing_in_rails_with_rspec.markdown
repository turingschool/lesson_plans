---
title: Model Testing in Rails
length: 180
tags: rails, models, tdd, validations, scopes
---

## Learning Goals

* test model validations, including presence, uniqueness, format, length, and exclusion/inclusion
* create and test custom validators
* test associations using [shoulda-matchers](http://matchers.shoulda.io/docs/v2.8.0/)
* create and test scopes
* create and test class methods

## Warmup

Clone this app: `git clone -b model-testing git@github.com:turingschool-examples/belibery.git`. Let's walk through the schema to see what we already have. Then...

* Generate a migration and model for donations (only use the generator for migrations - not the model!). The migration needs to have an amount and a reference to the fans table. Migrate and look at the schema.
* Now, generate a migration that adds a `status` column (string) to the donations table. Migrate and look at the schema.
* Open your schema, and rollback. Now try to rollback two steps. What do you see?
* Migrate again to apply your migrations to the database.


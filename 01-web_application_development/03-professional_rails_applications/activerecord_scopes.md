---
title: ActiveRecord Scopes and Queries
length: 90
tags: ruby, rails, activerecord, models
---

**Current Status**: Draft (Work in Progress)

### ActiveRecord Queries

- ActiveRecord delays queries until it needs the data
- Chaining queries together (e.g. `Item.in_stock.on_sale`)
- Since they're delayed, queries can be passed around and chained
- Recap of the basic query methods (`.where`, `.limit`, `.order`)
  - `.where`
  - `.limit`
  - `.order`

### What are scopes?

- Scopes allow you define and chain query criteria in a declarative and reusable manner
- Scopes can use parameters with a lambda
- Scopes can take parameters
- `default_scope`
- Overriding `default_scope` and `unscoped`
- Scopes and joins
- `scope` is really just the same as defining a class method
- Using lambdas is stupid because you could just write a class method

### Performance Hacks

- `select`
- `pluck`

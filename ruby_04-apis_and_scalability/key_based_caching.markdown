---
title: Key-Based Caching
length: 90
tags: rails, caching, performance, hashing
---

## Learning Goals

* Review the reasons for caching in an application
* Review fragment / markup caching as an approach to caching
* Practice using Rails' built-in digest caching to auto-generate
digests for active record models
* Practice using dependent updating and russian doll caching
to handle nested caching structures

## Structure

* 25 minutes - Discusssion of Key-Based Caching
* 5 minutes - Break
* 25 minutes - Individual Work: Implementing Key-Based Caching
* 5 minutes - Break
* 25 minutes - Finish Individual Work: Implementing Key-Based Caching
* 5 minutes  - Wrap up discussion

## Lecture

### Discussion - Problems of Cache Invalidation

* Want to get data updates into the cached information as quickly as possible
* Want to avoid unnecessary cache expirations
* Want to avoid having to design overly complex cache invalidation systems

Ultimately, many of the challenges we face with cache updating and invalidation
involve trying to update a cache key in place. Today we'll look at ways around
that.

### Creating a Digest

* What is a digest / hash function?
* Should we use MD5? BCrypt?

```ruby
require 'digest/md5'
digest = Digest::MD5.hexdigest("here's my input string")
```

### Digest-Based Keys

* Modeling a "normal" cache
* Using a digest as the key
* Running out of space?
* Least recently used

## Workshop

We've put together a tutorial on how to get started with digest-based caching:
https://github.com/turingschool/curriculum/blob/master/source/topics/performance/digest_based_caching.markdown

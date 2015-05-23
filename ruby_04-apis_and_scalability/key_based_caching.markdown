---
title: Key-Based Caching
length: 90
tags: rails, caching, performance, hashing
---

## Learning Goals

## Structure

* Lecture: Intro to Key-Based Caching
* Paired Work: Implementing Key-Based Caching

## Lecture

### Problems of Caching

The problem with caching web assets:

* Varnish
* Squid/Proxies
* Browser Cache

How can you use filenames to "bust" caches?

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

## Paired Work

We've put together a tutorial on how to get started with digest-based caching: http://tutorials.jumpstartlab.com/topics/performance/digest_based_caching.html

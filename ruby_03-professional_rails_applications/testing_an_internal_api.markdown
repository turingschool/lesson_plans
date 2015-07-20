---
title: Testing an Internal API
length: 90
tags: apis, testing, controllers, rails
---

## Learning Goals

* Understand how an internal API at a conceptual level
* Use controller tests to test an internal API
* Feel comfortable writing controller tests that deal with different HTTP verbs (GET, POST, PUT, DELETE)

## Structure

### Block 1: 30 minutes

* 5  - Conceptual discussion
* 5  - Application setup
* 10 - Implement the #index controller test
* 5  - Implement the #index API endpoint
* 5  - Break

### Block 2: 30 minutes

* 10 - Workshop 1: Implementing the #show controller test
* 5  - Demo: How to implement the #show controller test
* 5  - Implement the #create controller test
* 5  - Implement the #create API endpoint
* 5  - Break

### Block 3: 30 minutes

* 10 - Workshop 2: Implementing the #update controller test
* 5  - Demo: How to implement the #update controller test
* 5  - Implement the #destroy controller test
* 5  - Implement the #destroy API endpoint
* 5  - Recap

## Workshops

### Workshop 1: Implementing the #show controller test

* Can you implement a controller test that sends a request to the show action in the items controller?
* You need to make sure that the response is successful.
* You also need to make sure that the contents that you are expecting are there.

### Workshop 2: Implementing the #update controller test

* Can you implement a controller test that sends a request to the update action in the items controller?
* You need to make sure that the response is successful.
* You also need to make sure that the contents that you are expecting are there.

## Procedure

1. Initial setup
  1. rails new apicurious
  2. Add ‘responders’ gem to Gemfile
  3. Add “require ‘minitest/pride’” to test_helper
  4. rails g model Item name:string description:string
  5. rails g controller items
2. Implement index endpoint
  1. Add index test
  2. Add index action
3. Workshop 1: Implementing the #show controller test
4. Implement show endpoint
  1. Add show test
  2. Add show action
4. Implement create endpoint
  1. Add create test
  2. Add create action (explain namespace or 'location: none')
5. Workshop 2: Implementing the #update controller test
6. Implement update endpoint
  1. Add update test
  2. Add update action
7. Implement destroy endpoint
  1. Add destroy test
  2. add destroy action

## Discussion

In this session, we'll be looking at some techniques to test an API
within our own application.

### Terminology

* "Internal" API -- In this context we say this to mean an API within
our own application, i.e. an API we are _providing_
* This is in contrast to a "3rd party" API that we might consume from
another entity such as twitter or instagram
* Sometimes people say "internal API" to refer to an API that is reserved for
internal use only (for example in a service-oriented architecture)
* They might also have an "external" API hosted in the same application, which
could be intended for use by other consumers outside of the organization

### Topics

* Good news -- testing an API is often simpler than testing a more complicated UI involving HTML (and possibly JS)
* Generally when testing an API we are able to treat it in a more "functional" way -- that is, data in, data out
* Controller tests can often be a good fit for this, although we can use full-blown integration/feature tests as well
* What are we looking for? Given the proper inputs (query parameters, headers) our application should provide the proper data (JSON, XML, etc.)
* Looking for edge cases -- what about bad inputs? Bad request headers? Authentication failures?
* Recall the main point about APIs -- they are designed to be machine readable rather than human readable. For this reason we will often care more about response codes with an API
* Proper response code handling can be very useful to automated clients, since they can use this information to take correct action in response

## Supporting Materials

* [Notes](https://www.dropbox.com/s/zxftnls0at2eqtc/Turing%20-%20Testing%20an%20Internal%20API%20%28Notes%29.pages?dl=0)
* [Video 1502](https://vimeo.com/129722778)
* [Video 1412](https://vimeo.com/126844655)

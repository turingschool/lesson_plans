---
title: Testing an Internal API
length: 90
tags: apis, testing, controller tests, rails
---

## Testing An API

In this session, we'll be looking at some techniques to test an API
within our own application.

__Some Terminology__

* "Internal" API -- In this context we say this to mean an API within
our own application, i.e. an API we are _providing_
* This is in contrast to a "3rd party" API that we might consume from
another entity such as twitter or instagram
* Sometimes people say "internal API" to refer to an API that is reserved for
internal use only (for example in a service-oriented architecture)
* They might also have an "external" API hosted in the same application, which
could be intended for use by other consumers outside of the organization

Topics:

* Good news -- testing an API is often simpler than testing a more complicated
UI involving HTML (and possibly JS)
* Generally when testing an API we are able to treat it in a more "functional"
way -- that is, data in, data out
* Controller tests can often be a good fit for this, although we can use full-blown
integration/feature tests as well
* What are we looking for? Given the proper inputs (query parameters, headers) our application
should provide the proper data (JSON, XML, etc.)
* Looking for edge cases -- what about bad inputs? Bad request headers? Authentication failures?
* Recall the main point about APIs -- they are designed to be machine readable rather than
human readable. For this reason we will often care more about response codes with an API
* Proper response code handling can be very useful to automated clients, since they can
use this information to take correct action in response

### Materials

Currently most of the material for this lesson is embedded in notes for
a slide deck: [slides](https://www.dropbox.com/s/0d6mnuupt2ct0ea/Turing%20-%20Testing%20an%20Internal%20API%20%28Notes%29.pages?dl=0)

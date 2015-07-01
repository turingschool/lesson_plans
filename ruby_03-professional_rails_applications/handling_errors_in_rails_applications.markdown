---
title: Handling Errors
length: 90
tags: errors, exceptions
---

## Handling Errors in Web Applications

__Discussion__

Try as we might, things in software often go wrong. Unfortunately in the
case of web applications, we're designing not for crusty developers who
can digest a nice stack trace, but for end-users, whose experience we
want to preserve even in the case of unexpected failure.

For this reas

### Principles for Error Handling

* Fail fast -- generally if something does actually go wrong, it's better
to fail explicitly than to limp along doing wrong or unpredictable things
* [Robustness Principle](https://en.wikipedia.org/wiki/Robustness_principle) -- be strict
about what outputs you produce, but strict about what inputs you accept -- this is often
a good rule of thumb for building robust software

### Error Handling in Ruby

TODO -- maybe some quick exercises recapping this?

* `Exception` and its various sub classes
* `rescue` keyword
* `begin...rescue` and `rescue` in method blocks

### Patterns for Error Handling

In the context of a Web App, we have an additional layer of error handling
to take into account -- HTTP Error Codes

Not only do we need to think about when and where to rescue exceptions
that might occur within our app, but we will want to think about what the proper
HTTP status code is to serve each case.

* HTTP Status Code review -- 3xx, 4xx, 5xx
* Rails error pages -- maintain a reasonable UI even for unexpected errors
* Role of an error page -- give some explanation of what went wrong, and give
users an "escape hatch" back to the main portion of the site

### Additional Materials

* [slides](https://www.dropbox.com/s/e00dy7l8rwwx5nb/Turing%20-%20Handling%20Errors%20in%20Rails.key?dl=0)
* [notes](https://www.dropbox.com/s/wua2q238t2omaqz/Turing%20-%20Handling%20Errors%20in%20Rails%20%28Notes%29.pages?dl=0)

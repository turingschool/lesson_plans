---
title: Building an API
length: 120
tags: apis, json, respond_to, rails
---

## Building an API

### Discussion -- Being an API Provider

* Where is the real "value" in an average web app?
* Ultimately many web apps are just a layer on top of putting data
into a database and taking it out again
* APIs are a tool for exposing this data more directly than we do
in a typical (HTML) user interface
* What's differentiates an API from a UI -- Machine readability

__Questions to Consider when Providing an API__

* Formats you will accept and return
* Parameter inputs you will accept -- are any required?
* Authentication / Authorization

More Sophisticated:

* Rate Limiting / Usage Tracking
* Caching

## Workshop -- Adding an API to storedom

* [notes](https://www.dropbox.com/s/13amb27emariz2q/Turing%20-%20Building%20an%20API%20%28Notes%29.pages?dl=0)

Topics:

* code-a-long adding an API to storedom
* using `respond_to` to handle multiple request formats
* using ActiveRecord default `to_json` / `to_xml` to handle serialization
* Using routing namespaces to version and partition dedicated API controllers


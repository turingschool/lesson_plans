---
title: Consuming Apis
length: 180
tags: API, json, HTTP client, faraday, hurley, HTTParty, Postman
---

### Goals

By the end of this lesson, you will know/be able to:

* Explain what an API is and what an external API provides to us
* Know why we need APIs
* Set up an HTTP client for an API
* Create an application that consumes an API
* Access JSON data returned from an API

### Structure

* 10 mins - API Discussion and Clarification
* 15 mins - Exploring the external API
* 5  mins - Break
* 25 mins - Create API consuming app - Service
* 5 mins - Break
* 25 mins - Continue with our app - Service/Models
* 5 mins - Break
* 25 mins - Continue with our app - Models/Controllers
* 15 mins - Break
* 25 mins - Continue with our app - Controllers/views
* 5 mins - Break
* 20 mins - Finish up and review

## Warmup

## Discussion - What is an API?

* What does API stand for?
* What are some common use cases and examples of APIs
* Any experience with APIs?
* Commonalities between APIs? Differences?
* Are there _better_ APIs out there?

## Discussion - APIs: Variety is the Spice of Life

One of the problems with working with APIs is that there are very few consistent
generalizations or assumptions that can be made.

As an exercise, let's consider some of the things that make it (relatively)
easy for us, as Rubyists, to read code written by other Rubyists:

* Common idioms for expressing ourselves
* Common language features for structuring our code (classes, OOP, method practices)
* Common set of tools for designing projects
* Common style practices (capitalization, underscores, spelling, predicate methods, etc)
* Shared community best practices -- `SOLID`, Sandi Metz' rules, conference talks, ruby books, etc etc

In short, when working within the ruby community, we have a lot of shared practices
and ideas that help us write "unsurprising" code that will hopefully be easily intelligble
to a future reader, especially one versed in the same community idioms as we are.

Why bring this up? Because we are about to make our first forays into the realm of
public APIs, which is, comparatively the Wild Wild West.

Let's consider some of the reasons why we might find relative non-conformity within
this corner of the tech world:

* Huge cross-section of language and community backgrounds (power of HTTP is its accessibility
from any platform)
* Very little shared design principles. Even around the ideas of REST there are differing interpretations
and implementations
* Lack of standardization around request/response formats, status codes, etc. etc.
* Tremendous variation in quality of documentation (often very little...)

In short, there's a good chance that no 2 APIs you will encounter are alike.

A handful of community projects such as [Swagger](http://swagger.io/) and [json:api](http://jsonapi.org/)
have attempted to address this, but even these are fragmented and not well adopted.

([See Relevant XKCD](https://xkcd.com/927/))

So why should we venture into this cesspool of non-conforming inter-process communication?

Because APIs let us do cool stuff. And fortunately HTTP with JSON (or even XML) is a relatively
easy to understand format.

With a little careful experimentation and probing, we can generally figure out what we need to do.
But it's good to have a sense of what to expect so that when we run into issues we won't be surprised and
will know what to do.

## Discussion API Spectrum of Quality

You can never really know what to expect from an API, but here are a few general predictors

* The larger the platform, the better. The top names in the social media space (twitter, foursquare,
facebook, instagram, etc) will generally have better public APIs since more people use them.
* The newer the better. Unsurprisingly an API that was implemented in the early 2000's will
often feel dated or clunky
* The more "RESTful" the better. This is hard to predict until you start digging in,
but the more Resource-oriented an API is, the more natural it will feel to use. You can often
"guess" a resource or endpoint and be relatively close

## Let Us Explore!

* my-chaimz.herokuapp.com
* Postman
* Bearer token authentication
* api url structure
* .json
* If you want to see how an api is built - `git clone git@github.com:neight-allen/my_chaims.git`


## Let Us Build!
* `rails new curating_chaims`
* First - The Service
  * What is a service? [Check out Ben Lewis' Post on Services](https://blog.engineyard.com/2014/keeping-your-rails-controllers-dry-with-services)
  * Faraday
* Then - The Model
* Finally our Controllers and Views

### A diagram

I ended up drawing a diagram something like this on the board to help understand why we are organizing the code the way we are.

![How Models Work](http://i.imgur.com/FVg9ODy.png?1)

### Video

* [Oct 2015 - Consuming and API](https://vimeo.com/143957483)

### Repository

* [My-Chaims API repo](https://github.com/neight-allen/my_chaims)
* [Example of Final Curating Chaims Api Consuming App](https://github.com/Carmer/chaims_consumption_practice) - Uses an old version of the API that doesn't authenticate
* [1511 curating chaims](https://github.com/neight-allen/chaimz_curator) - Uses HTTParty
* [1602 curating chaims](https://github.com/neight-allen/chaimz-curator) - Uses Faraday


### Resources

* [JSON API](http://jsonapi.org/)
* [Government Data API](https://api.data.gov/)
* [World Bank API](http://data.worldbank.org/developers?display=)
* [YouTube data API](https://developers.google.com/youtube/v3/?hl=en)
* [Programmable Web](http://www.programmableweb.com/)
* [MashApe](https://www.mashape.com/)

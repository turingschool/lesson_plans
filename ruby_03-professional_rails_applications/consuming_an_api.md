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

## What is an API?
* What does API stand for?
* What are some common use cases and examples of APIs
* Any experience with APIs?
* Commonalities between APIs? Differences?
* Are there _better_ APIs out there?

## Let Us Explore!

* my-chaims.herokuapp.com
* api url structure
* .json
* Postman
* If you want to see how an api is built - `git clone git@github.com:Carmer/my_chaims.git`


## Let Us Build!
* `rails new curating_chaims -d postgresql`
* First - The Service
  * What is a service? [Check out Ben Lewis' Post on Services](https://blog.engineyard.com/2014/keeping-your-rails-controllers-dry-with-services)
  * Hurley
* Then - The Model
* Finally our Controllers and Views

### Video

* [Oct 2015 - Consuming and API](https://vimeo.com/143957483)

### Repository

* [My-Chaims API repo](https://github.com/Carmer/my_chaims)
* [Example of Final Curating Chaims Api Consuming App](https://github.com/Carmer/chaims_consumption_practice)

### Resources

* [JSON API](http://jsonapi.org/)
* [Government Data API](https://api.data.gov/)
* [World Bank API](http://data.worldbank.org/developers?display=)
* [YouTube data API](https://developers.google.com/youtube/v3/?hl=en)
* [Programmable Web](http://www.programmableweb.com/)
* [MashApe](https://www.mashape.com/)

---
title: Handling Errors
length: 90
tags: errors, exceptions
---

## Learning Goals

* Learn how to create a staging environment to test your production code
* Learn how to handle common routing errors
* Rescue ActiveRecord errors in the controllers

## Structure

### Block 1: 30 minutes

* 5  - Conceptual discussion
* 20 - Adding a staging environment
* 5  - Break

### Block 2: 30 minutes

* 15 - Handling routing errors
* 10 - Handling ActiveRecord exceptions
* 5  - Break

### Block 3: 30 minutes

* 15 - Workshop 1: Handling ActiveRecord Exceptions
* 10 - Demo: How to implement workshop 1
* 5  - Recap

## Workshops

### Workshop 1: Handling ActiveRecord Exceptions

1. Create a show action in the comments  controller that finds a particular comment. Create the view.
2. Create an index action in the comments controller that finds all the comments. Create the view.
3. Create the corresponding routes.
4. In the show action, rescue a record not found error and redirect to the comments#index.

## Procedure

1. Creating a Staging Environment
  1. Create a staging.rb file in the environments folder.
  2. Copy the contents of the production.rb.
  3. Change line 45 to set the config.log_level to debug.
  4. Add staging to Gemfile
  5. Change config.serve_static_assets = true
  6. Add the database configuration for the staging server.
  7. Set the staging database
  8. Run rake assets:precompile
2. Handling Routing Exceptions
	1. Add config.exceptions_app = self.routes in the config/application.rb
	2. In route controller add match '404', to: redirect('/'), via: :all
	3. Create an errors controller
	4. Change the route to  match ':status', to: 'errors#show', via: :all, constraints: {status: /\d{3}/ }
	5. Create a show action in the errors controller: render text: request.path
	6. Add 404.html.erb template
	7. Add render request.path[1..-1]
	8. Add @exception in the template
	9. Add this line to the show action: @exception = env[“action_dispatch.exception”]
3. Handling ActiveRecord Exceptions
  1. Open the show action in the article controller
  2. Use begin and rescue to rescue ActiveRecord::RecordNotFound and redirect to articles_path
  3. Use rescue_from ActiveRecord::RecordNotFound, with: :record_not_found. Create a private method that redirects_to articles_path, notice: 'The article you are looking for doesn’t exist'
  4. Explain that it’s not ok to rescue all errors, such as validations.

## Discussion

Try as we might, things in software often go wrong. Unfortunately in the
case of web applications, we're designing not for crusty developers who
can digest a nice stack trace, but for end-users, whose experience we
want to preserve even in the case of unexpected failure.

### Principles for Error Handling

* Fail fast -- generally if something does actually go wrong, it's better
to fail explicitly than to limp along doing wrong or unpredictable things
* [Robustness Principle](https://en.wikipedia.org/wiki/Robustness_principle) -- be strict
about what outputs you produce, but strict about what inputs you accept -- this is often
a good rule of thumb for building robust software

### Error Handling in Ruby

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

## Supporting Materials

* [Repo](https://github.com/JumpstartLab/blogger_advanced.git)
* [Notes](https://www.dropbox.com/s/gadq54bdh8arew7/Turing%20-%20Handling%20Errors%20in%20Rails.key?dl=0)
* [Slides](https://www.dropbox.com/s/gadq54bdh8arew7/Turing%20-%20Handling%20Errors%20in%20Rails.key?dl=0)
* [Video 1412](https://vimeo.com/125649523)

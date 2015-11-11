---
title: Intro to the Asset Pipeline
length: 90
tags: assets, pipeline, rails, heroku
---

### Goals

By the end of this lesson, you will know/be able to:

* explain the purpose of the asset pipeline
* run your app in the production environment locally

### Structure

* Asset Pipeline Overview
* Asset Pipeline Scavenger Hunt
* Running Production Locally 
* Running Production Challenge

### Lecture

* find the slides [here](https://www.dropbox.com/s/k4793eg4ovgkkr9/intro_to_asset_pipeline.key?dl=0)

#### Asset Pipeline Overview

* What are assets?
* Where do assets live? (app/assets, lib/assets, vendor/assets)
* Why do we have the asset pipeline?
* What is Sprokets? 

#### Asset Pipeline Scavenger Hunt

* What does it mean to concatenate files? 
* What does it mean to precompile files? What does this have to do with coffeescript and sass files?
* What does it mean to minify files?
* Make rails project, navigate to http://localhost:3000/assets/application.js 
* What is a manifest (in terms of the asset pipeline)?
* In regular HTML files, we bring in css files with <link rel="stylesheet" href="application.css">. How is this done in a Rails project? 
* How is a digest/fingerprint used on the assets for caching purposes? 

#### Running Production Locally

* Why would we see if something will work in production mode without pushing to Heroku?

#### Running Production Challenge

[Catch 'em All](https://github.com/rwarbelow/catch-em-all) looks fine when running in development mode (`rails s`). But our challenge now is to get it running locally using the production environment (`RAILS_ENV=production rails s`) AND for our assets to look the same. Follow the errors (if you can find them...) 

* How can we see the errors? 
* `rake secret`
* export MY_KEY=something123
* What does this line do? config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
* What does the 'rails_12factor' gem do?
* What command can you run to precompile your assets locally? why do you *not* need to do this on Heroku? 
* Why would you need to run `rake assets:clobber`?
* When is there an `assets` directory inside the `public` folder? 

### Resources

* [RailsGuides: The Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html)
* [Rails 4 Asset Pipeline on Heroku](https://devcenter.heroku.com/articles/rails-4-asset-pipeline)
* [Rails Asset Pipeline on Heroku Cedar](https://devcenter.heroku.com/articles/rails-asset-pipeline)

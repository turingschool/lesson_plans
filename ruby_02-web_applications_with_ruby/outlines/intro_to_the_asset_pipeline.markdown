---
title: Intro to the Asset Pipeline
length: 90
tags: assets, pipeline, rails, heroku
---

### Goals

By the end of this lesson, you will know/be able to:

* Explain the purpose of the asset pipeline
* Run your app in the production environment locally

### Structure

* Asset Pipeline Overview
* Asset Pipeline Scavenger Hunt
* Running Production Locally 
* Running Production Challenge

### Lecture

* Find the slides [here](https://www.dropbox.com/s/910ifbqmy22l7ua/intro-asset-pipeline.pdf?dl=0)!

#### Asset Pipeline Overview

* What are assets?
* Where do assets live? (app/assets, lib/assets, vendor/assets)
* Why do we have the asset pipeline?
* What is Sprockets? 

#### Asset Pipeline Scavenger Hunt

Start a gist with these questions:

* What does it mean to concatenate files? Find an image of an example concatenated file. Why would we want to concatenate files? 
* What does it mean to precompile files? What does this have to do with coffeescript and sass files?
* What does it mean to minify files? Find an image of an example minified file. Why would we want to minify files? 
* Start up the server for [Catch 'em All](https://github.com/rwarbelow/catch-em-all) (`rails s`) and navigate to http://localhost:3000/assets/application.js. Then open up the code for `application.js` in your text editor. Why are these *not* the same? 
* What is a manifest (in terms of the asset pipeline)? Where can you find *two* manifests in Catch 'em All? 
* In regular HTML files, we bring in css files with `<link rel="stylesheet" href="application.css">`. How is this done in a Rails project? Where do you see this line in Catch 'em All? 
* How is a digest/fingerprint used on the assets for caching purposes?
* Done? Take a look at [RailsGuides: The Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html). 

#### Running Production Locally

* Why would we want to see if something will work in production mode without pushing to Heroku?
* What are the `development.rb`, `test.rb`, and `production.rb` files? 

#### Running Production Challenge

[Catch 'em All](https://github.com/rwarbelow/catch-em-all) looks fine when running in development mode (`rails s`). But our challenge now is to get it running locally using the production environment (`RAILS_ENV=production rails s`) AND for our assets to look the same. Follow the errors (if you can find them...) 

* How can we see the errors? 
* `rake secret`
* export MY_KEY=something123
* What does the 'rails_12factor' gem do?
* What command can you run to precompile your assets locally? why do you *not* need to do this on Heroku? 
* Why would you need to run `rake assets:clobber`?
* When is there an `assets` directory inside the `public` folder? 

### Resources

* [RailsGuides: The Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html)
* [Rails 4 Asset Pipeline on Heroku](https://devcenter.heroku.com/articles/rails-4-asset-pipeline)
* [Rails Asset Pipeline on Heroku Cedar](https://devcenter.heroku.com/articles/rails-asset-pipeline)

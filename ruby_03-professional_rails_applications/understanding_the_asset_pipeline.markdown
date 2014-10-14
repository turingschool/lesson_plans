---
title: Understanding the Asset Pipeline
length: 180
tags: ruby, rails, asset_pipeline
---

## Learning Goals

## Structure

## Warm Up

When building a Rails application, we tend to just assume that jQuery is readily available for us. If we open up the Chrome Developer Tools, we'll see that our Rails application is loading jQuery.

* Where is it coming from?

## Lecture

Source files go in one end; if necessary, they get processed and compiled (think SASS or CoffeeScript); they get concatenated and compressed and spit out the other end as bundles.

Rails will pick up new files in your `app/assets` directory, but you have to reset the server if you add a new *directory* to the `app/assets`.

Rails pulls in assets from the following locations

* `app/assets`
* `lib/assets`
* `vendor/assets`
* Gems with a `vendor/assets` directory.

Anything in the pipeline will be available at the `/assets` URL. So, the `application.js` in your asset pipeline will be available in development at `http://localhost:3000/assets/application.js`. So will anything in `public/assets`.

At it's core, the Asset Pipeline is a list of load paths. You can see these load paths by firing up the Rails console.

`vendor/assets` might be a good place for third-party JavaScript libraries that aren't yours (e.g. underscore).

```ruby
y Rails.application.config.assets.paths
```

(The `y` command just formats the hash as YAML.)

You'll typically see something like this:

```yaml
- "/Users/stevekinney/Projects/storedom/app/assets/images"
- "/Users/stevekinney/Projects/storedom/app/assets/javascripts"
- "/Users/stevekinney/Projects/storedom/app/assets/stylesheets"
- "/Users/stevekinney/Projects/storedom/vendor/assets/javascripts"
- "/Users/stevekinney/Projects/storedom/vendor/assets/stylesheets"
- "/Users/stevekinney/.rvm/gems/ruby-2.1.3/gems/less-rails-bootstrap-3.2.0/app/assets/fonts"
- "/Users/stevekinney/.rvm/gems/ruby-2.1.3/gems/less-rails-bootstrap-3.2.0/app/assets/javascripts"
- "/Users/stevekinney/.rvm/gems/ruby-2.1.3/gems/less-rails-bootstrap-3.2.0/app/assets/stylesheets"
- "/Users/stevekinney/.rvm/gems/ruby-2.1.3/gems/turbolinks-2.2.2/lib/assets/javascripts"
- "/Users/stevekinney/.rvm/gems/ruby-2.1.3/gems/jquery-rails-3.1.1/vendor/assets/javascripts"
- "/Users/stevekinney/.rvm/gems/ruby-2.1.3/gems/coffee-rails-4.0.1/lib/assets/javascripts"
```

### Manifests

Manifests are a way to pull in other, related files. So, if I request `application.js` and it requires `another.js` in it's manifest, I will get both of them.

* `// require_tree .` requires all of the files in that directory and all subdirectories.
* `// require_directory .` loads all of the files in the directory but *not* the subdirectories.
* Alternatively, you can just take matters into you own hands and manually define the files you want to include.

In this example, we're looking at `application.js`; so, we're using JavaScript comments. If you're in `application.css` then it would be in CSS comments. 

By default, the asset pipeline concatenates all of assets into one file (using `require_tree .`). Browsers can only make a limited number of requests in parallel. This technique allows you to get all of your assets with one request.

#### Manifest Directives

* `require`
* `include`
* `require_self`
* `require_directory`
* `require_tree`
* `depend_on`

#### Adding to the Search Path

By default, Rails will search the first set of directories directly under `app/assets`, `lib/assets`, `vendor/assets`. You can add additional paths to the asset pipeline, if your heart desires.

Let's say you're living in the future and you want to include some Adobe Flash. And you want to store your flashy Flash apps in `app/flash/assets`. You can add that path to the asset pipeline.

```rb
config.assets.paths << Rails.root.join("app", "flash", "assets")
```

Rails starts with the first path and works it way through them. The first file with a matching name, wins.

#### MD5 Fingerprints

If you look at a Rails application, you'll notice that Rails has appended a string of letters and numbers onto your filename. The main idea here is make sure you browser isn't referencing an out-of-date cached version of the file. This MD5 fingerprint will change every time you modify an included file.

### Gemified Assets

As we've seen with `jquery-rails`, gems can be used to bundle client-side assets.

#### Engines

In order to bundle client-side assets for inclusion in the the asset pipeline, you have to define an engine that inherits from `Rails::Engine`. Let's take a look at how the `rails-jquery` does it by checking out `lib/jquery/rails/engine.rb`.

```rb
module Jquery
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end
```

There's not a lot going on in this code, but it tells Rails, "Hey! Look at me! Put by `vendor/assets` into the asset pipeline!"

If you use an `index.js` or `index.css`, then you can require the whole gem without specifying a file.

Why would you want to use an `index.js`? Well, let's say you broke your gem assets into multiple files—probably a good idea. Using an `index.js`, allows you to be explicit about the order that these files should be included in.

### Preprocessor Chaining

### View Helpers

```erb
<%= stylesheet_link_tag "application", :media => "all" %>
<%= javascript_include_tag "application" %>
```

### Related Technologies

* sprockets
* tilt
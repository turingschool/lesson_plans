---
title: Rails in Review
length: 180
tags: Rails
---

## Rails in Review

In this lesson, we'll be doing short recaps of some of the topics
covered in the last 2 modules.

### Topics

* Caching APIs (as an API provider)
* Polymorphic Many-to-Many Relationships
* Handling multiple request formats
* Presenters/Decorators
* Caching API data (as a consumer)
* Join / Includes
* Ajax
* Request/Response cycle

### Caching APIs

* APIs can actually be simpler to cache than HTML endpoints since
  there's often less personalized information in the API that needs
  to be accounted for
* Same guiding principle applies -- want a "key" that will be specific
  enough to avoid providing incorrect data, but general enough that it
  still has a decent "hit ratio"
* Just as with HTML, we have 2 main choices -- Cache "finished product"
  (rendered JSON/XML) or cache intermediate pieces (Data caching)
* Rails built-in Page Caching -- Request will serve static "page" from
  cache without even hitting Controller 
* Rails built-in Action Caching -- Request will serve cached controller
  response _after_ running filters. (Good for Auth)
* __Note__ Action Caching and Page Caching features were pulled into a
  separate gem in rails 4.0. If you're on 4+ you'll need to install
  [actionpack-action_caching](https://github.com/rails/actionpack-action_caching)
  and [actionpack-page_caching](https://github.com/rails/actionpack-page_caching) respectively
* Other option -- [Rack-cache](http://rtomayko.github.io/rack-cache/) (requires some
  knowledge of HTTP caching semantics)

This commit shows some examples of the different approaches:

https://github.com/turingschool-examples/storedom/commit/9cc1c9a7e295ca8b83112619fde47d30793bcf82

Additional Resources:

* [Fast JSON APIs in Rails with Key-Based Caches and ActiveModel::Serializers (ThoughtBot)](https://robots.thoughtbot.com/fast-json-apis-in-rails-with-key-based-caches-and)
* [Caching with Rails (rails guides)](http://guides.rubyonrails.org/caching_with_rails.html)
* [Fast JSON APIs - Advanced Caching](http://hawkins.io/2012/07/advanced_caching_part_6-fast_json_apis/)

### Presenters/Decorators

* Lots of options out there; Draper and ActiveModel::Serializers are my
  2 favorites
* Presenter/Decorator "objects" (draper, AM::S) vs "JSON templating"
  (Rabl, Jbuilder)
* At heart presenters are just "wrapper" objects for your data models
* Discuss Delegator pattern
* Presenters give you a place to house display-oriented logic that you
  don't want to put in the data model
* Also provide a means of "mixing in" convenient behavior that you
  wouldn't want to inject into your data model (Rails helpers, routing
  methods, etc)
* Rails -- `as_json` vs `to_json` -- can use these to build your own
* Rails json rendering -- what happens when we `render json:
  MyModel.first` or `respond_with MyModel.first`??

Additional Resources:

* [Railscast 286 - Draper](http://railscasts.com/episodes/286-draper)
* [Thoughtbot on Decorators](https://robots.thoughtbot.com/decorators-compared-to-strategies-composites-and)
* [Railscast 287 - Presenters](http://railscasts.com/episodes/287-presenters-from-scratch)

(note some of these articles likely use the terminology differently than
we have in our lessons)

### Polymorphic Joins

* ActiveRecord "table inference" patterns
* How does AR know what table items of the `Item` class live in?
* What about associations? E.G. Item `belongs_to :user`? `has_many
  :pizzas, through: :pizza_joins`?
* Polymorphic joins allow us to "parameterize" these relations by adding
  more customization to them.

### Multiple Request Formats

* How does as webserver (e.g. our Rails app) know what type of content a
  client is looking for? (http `Accept` header; `format` parameter
  inferred via URL extension)
* How does it tell the client what type of content it's sending back?
  (HTTP `Content-Type` header)
* Being a good citizen -- if someone asks you for sugar it's rude to
  give them plaster of paris instead -- try to honor content type reqs
* Rails -- handling invalid Content Types -- HTTP 406, Not Acceptable
* Rails content-type techniques: `ActionController#respond_to` (instance
  level); `ActionController.respond_to` (class level) coupled with
  `ActionController#respond_with` (instance level)

### Caching API Data (as a consumer)

* Often when consuming a 3rd party API we want to cache it, both for
  perf reasons and to avoid rate limit caps
* "Cache" in this sense can be more durable storage -- i.e. storing the
  data in a DB
* Have to evaluate based on how repeatable the queries are and how
  transient the upstream data is
* This technique works well in combination with a regular Cron and BG
  workers -- populate the data offline whenever possible so your users
  don't have to wait
* For data that is too diverse or transient, memcached or redis can both
  be good fits

### Join vs Includes

* `joins` executes actual SQL `join` query; allows us to address data from
  multiple tables in a single query by "joining" them into a single
  relation based on various combinations of foreign and primary keys
* `includes` is purely a Rails feature -- ActiveRecord will automatically
  execute a _second_ query on your behalf to pre-fetch whatever
  associations you requested
* `includes` primarily used to prevent N+1 queries by pre-loading
  a group of associations in a single batch rather than triggering a
  number of small queries

### AJAX From Rails

* Don't forget that the complete package we think of as an "app" actually _runs_
  in 2 discrete environments -- one on the server and one in the browser
* Server accepts `*.rb ` files from your rails codebase and executes
  them using whatever Ruby interpreter it's configured to use
* Similarly browser accepts static HTML files as payloads from the
  server -- then renders the HTML/CSS portions and evaluates any JS that
  may be included
* Modern webdev requires us to really get comfortable with this duality
  -- what code evals on Browser and what code evals on server

### ActiveRecord #build/#new/#create

* `#build` - alias for #new
* `#new` - Instantiate a new object of the appropriate class, including
  setting up appropriate attributes. But don't save it to the db
* `#create` - Create a new object of appropriate class, set up all
  attributes, and save to the database.

### Background Workers

* Popular libs -- Resque/Sidekiq
* Queue communication -- How do the background process and the
  foreground (web) process communicate?
* Architectural role of BG Workers? -- 2 common uses -- take work out
  of request cycle. Parallelize work across multiple workers.

#### Instructor Notes

We've run this session for 4th module students starting with the 1409
cohort. The topics listed here are a few of the "usual suspects" that
still cause confusion or get requested for review frequently.

When I have run the session I usually do it as a "Q&A" format where we
spend the first several minutes making a to-do list of all the other
topics students would like to discuss. Then try to get through as many
as we can in 3 hours.

So these notes are here as a starting point, but generally there is
other material which gets pulled in Ad-Hoc.

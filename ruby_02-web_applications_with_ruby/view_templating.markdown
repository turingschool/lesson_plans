---
title: View Templating
length: 60
tags: ruby, erb, haml, views, templating
---

## Learning Goals

## Structure

* 30 - Code Along (Part 1)
* 5 - Break
* 30 - Code Along (Part 2)

### Resources

* [Feel Good Bot][fgb]

### Code Review

* `f8ffda3` - Return a simple string
* `e515072` - Add a static stylesheet
* `b7f2f78` - Return HTML as a string
* `a3bb361` - Add a static image
* `9c43feb` - Use a built-in helper
* `7de5c81` - Render a string with ERB
* `73da861` - Refactor robots iterator into collection partial
* `7367249` - Move partial into a subdirectory
* `72a3e2b` - Iterate over robots and render them
* `5cff1a4` - Create a layout template that doesn't yield
* `5b00da3` - Refactor to external templates
* `58cd935` - Install the `sinatra-partials` gem
* `444a431` - Include a partial
* `2bd3b8c` - Render a view without a layout
* `1aaed05` - Add robot helpers; refactor structure
* `0e3dcb4` - Pass a variable into partial
* `08dfe48` - Use inline template
* `03c6b67` - Define a partial and use it


## The sections below were used when the class was 2 hours long.

### Pair Practice

Using [Feel Good Bot][fgb]:

* Refactor the site navigation into a partial.
* Create a helper for the following:
  * A image tag helper that takes a file name and creates an HTML image tag prefixed by `images/`
  * A stylesheet helper that takes the name of a CSS file and creates a `link` tag
  * A `home_url` helper that returns the `url` helper for the home page (in this case that's `/`)
  * A `mean_url` helper that returns the `url` helper for the mean robot page (in this case that's `/mean`)
  * A `robots_url` helper that returns the `url` helper for the mean robot page (in this case that's `/robots`)

### Reflections

#### Taught by Steve (2014-11-04)

The code along went well, but I think it could stand to be shortened. I'd like to actually take an old Clone Wars project and begin to refactor it with them. I think that would more useful than the super granular code-along.

Some students thought the pair practice tasks were a bit contrived. Again, I might take an old Clone Wars or Idea Box and have them refactor it instead.

[fgb]:https://github.com/turingschool-examples/feel-good-bot

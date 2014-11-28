---
title: Templating with Handlebars
length: 90
tags: templating, handlebars
---

## Learning Goals

* explain what templating is
* differentiate between ERB and Handlebars functionality
* render a template using Tilt
* refactor ERB templates to Handlebars templates

## Full-Group Instruction

#### What is templating?

Templating is a way to combine dynamic data and functionality (formatting, computation, conditional branching, etc.) with static content (text, HTML, etc.).

#### Why are we templating stuff with Handlebars today?

* experience a different take on templating (we've used ERB & HAML)
* practice writing templates that we might use for Ember
* determine the pros and cons of a simplified templating system

#### Let's template!

`gem install tilt`

What is Tilt? According to the [documentation](https://github.com/rtomayko/tilt), "Tilt is a thin interface over a bunch of different Ruby template engines in an attempt to make their usage as generic as possible. This is useful for web frameworks, static site generators, and other systems that support multiple template engines but don't want to code for each of them individually."

Several templating engines (such as ERB, Haml, Sass, Nokogiri, etc.) are included in the tilt gem. Other templating engines (such as Slim and Handlebars) have their own Tilt integration. 

Create an `index.erb` file.

```
It is now <%= Time.now %>.
```

In pry:

```ruby
require 'tilt'
template = Tilt.new('index.erb')
output = template.render
```

Ok, cool. Let's pass some data to the view. Change your `index.erb`:

```
My name is <%= name %>.
```

In pry:

```ruby
require 'tilt'
template = Tilt.new('index.erb')
output = template.render(nil, { name: "Sally" })
```

One more with ERB:

```
<% names.each do |name| %>
	<%= name %>
<% end %>
```

In pry:

```ruby
require 'tilt'
template = Tilt.new('index.erb')
output = template.render(nil, { names: ["Jorge", "Raissa", "Steve"] })
```

Now let's try it with Handlebars. 

#### What is Handlebars?

* History: Mustache -- logic-less, no control-flow, believes in separating logic from presentation, envisions templates as being code-free, populates data from a JS object. 
* But it's a little too logic-less.
* Handlebars allows for some logic, but still encourages separation of logic from presentation.
* {{#if}}
* {{#each}}
* Accepts a "hash-type" piece of data -- something with keys and values. 
* Can define helpers (see documentation [here](http://handlebarsjs.com/) for handlebars.js)

`gem install tilt-handlebars`

`touch index.hbs`

```
{{name}}
{{age}}
```

In IRB: 

```ruby
require 'tilt/handlebars'
template = Tilt.new('index.hbs')
output = template.render(nil, { name: "Josh", age: 60 } )
```

Iterating: 

```
{{#each names}}
	{{this}}
{{/each}}
```

In IRB: 

```ruby
require 'tilt/handlebars'
template = Tilt.new('index.hbs')
output = template.render(nil, { names: ["Horace", "Jeff", "Other Josh"])
```

Iterating with nested hashes:

```
{{#posts}}
	<h1><a href="{{url}}">{{title}}</a></h1>
	{{body}}
{{/posts}}
```

In IRB:

```ruby
require 'tilt/handlebars'
template = Tilt.new('index.hbs')
template.render(nil, {posts: [{ id: 1,url: "/posts/1",title: "Hello world!",body: "Hello world!"},{ id: 2,url: "/posts/2",title: "Goodbye world!",body: "Second Post"}]})
```

If

```
{{#if active}}
  {{#item}}
  	{{name}}
  {{/item}}
{{/if}}
```

In IRB:

```ruby
require 'tilt/handlebars'
template = Tilt.new('index.hbs')
template.render(nil, active: true, item: {name: "Rachel"})
```

Using Ruby Objects:

```
{{#each toys}}
  {{name}} is a {{color}} toy.
{{/each}}
```

In IRB:

```ruby
require 'tilt/handlebars'
class Toy
	attr_reader :name, :color
	def initialize(name, color)
		@name = name
		@color = color
	end
end
toys = [Toy.new("train", "yellow"), Toy.new("doll", "purple"), Toy.new("Lego", "brown")]
template = Tilt.new('index.hbs')
template.render(nil, toys: toys)
```

What happens if you put executable code (Time.now) inside of the handlebars?

## Now for realzies

Clone the [handlebarbershop repo](https://github.com/turingschool-examples/handlebarbershop). You can thank Steve :)

* Add `gem 'tilt-handlebars'` to the Gemfile
* `require 'sinatra/handlebars'` at the top of handlebarbershop.rb
* `helpers Sinatra::Handlebars` inside of the Handlebarbershop class
* `bundle`

In pairs, go through each route and refactor so that the views are handlebars instead of ERB. Stuck? Want to check your work? Look at the `handlebars` branch.  

## Resources

* [Tilt](https://github.com/rtomayko/tilt)
* [tilt-handlebars gem](https://github.com/jimothyGator/tilt-handlebars)
* [Handlebars Basics in Ember](http://emberjs.com/guides/templates/handlebars-basics/)

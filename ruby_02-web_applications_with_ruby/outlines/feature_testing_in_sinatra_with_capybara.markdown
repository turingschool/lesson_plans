---
title: Feature Testing in Sinatra with Capybara
length: 120
tags: capybara, user stories, feature tests, testing
---

## Key Topics

During our session, we'll cover the following topics:

* Types of testing
* What are user stories? Why are they beneficial?
* Capybara

## Lecture

[Slides](http://m2b-slides.herokuapp.com/m2b/feature_testing_with_capybara_in_sinatra.html#/)

## Nokogiri

We're going to use Capybara to create feature tests for our sites, but behind the scenes it uses Nokogiri (because apparently [it helps keep everyone sane](https://blog.codinghorror.com/parsing-html-the-cthulhu-way/)). Let's take a look to see what Nokogir can do.

### Installing Nokogiri

`gem install nokogiri`

### Quick Experiment

Copy the following into a new ruby file.

```ruby
require 'nokogiri'
require 'net/http'

# get the HTML from the website
uri  = URI("http://www.denverpost.com/frontpage")
body = Net::HTTP.get(uri)

# parse it and use CSS selectors to find all links in list elements
document = Nokogiri::HTML(body)
links    = document.css('li a')

# print each interesting looking link
links.each do |link|
  next if link.text.empty? || link['href'].empty?
  puts link.text, "  #{link['href']}", "\n"
end

# pry at the bottom so we can play with it
require "pry"
binding.pry
```

### What Just Happened?

The program made a URI object to parse our uri (you can think a uri as being the same thing as a url). Then it made a GET request to that uri to get the page’s body. It gives the body to Nokogiri::HTML, which parses the HTML and gives us back a Nokogiri document, an object we can use to interact with the html. In this case, we use "css" to give it a css selector that will find all links inside of list elements.

We also stuck a pry at the bottom so that we can play with those objects if we like. Maybe we’d like to see what we can do with a link, we’ll use Pry’s `ls -v` to list out all the interesting things on it. Enter the following lines into the Pry session that opened when you ran that file.

```
pry(main)> link = links.first
pry(main)> ls -v link
```

We see the link has its own css method, so we could run another query from within this node. And we can see the href attribute, it looks like we get attributes by using bracket notation, like a hash. This is a great way to play around with a new library and learn about it,

You can check out the [documentation](http://www.nokogiri.org/) to learn more about what you can do with Nokogiri.

## Capybara

### Important Setup Things

Add the following lines to your `Gemfile`

```ruby
gem 'capybara'
gem 'launchy'
```

Run `bundle`

Update your `spec/spec_helper.rb` file to include the following:

```ruby
# with your other required items
require 'capybara/dsl'

Capybara.app = TaskManagerApp

# within the RSpec configuration:
  c.include Capybara::DSL
```

Since we're going to be creating a new type of test, let's add a new folder to separate them from our model tests.

`mkdir spec/features/`
`touch spec/features/user_sees_all_tasks_spec.rb`

In that new file add the following:

```ruby
require_relative '../spec_helper'

RSpec.describe "When a user visits '/'" do
  it "they see a welcome message" do
    # Your code here.
  end
end
```

## Resources

* [Capybara cheat sheet](https://gist.github.com/zhengjia/428105)
* [Another cheat sheet](http://cheatrags.com/capybara)
* [Simple Tricks for Capybara](http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests)

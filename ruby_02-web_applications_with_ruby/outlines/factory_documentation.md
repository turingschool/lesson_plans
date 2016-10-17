---
title: Factory Girl Exploration in Rails
length: 60
tags: factories, factory_girl, rails, testing, tdd, documentation
---

## Goals

* Understand what Factory Girl does
* Use Factory Girl documentation to set up factories in an existing product

## Lecture

### Factory Girl Overview (10 minutes)

A factory is an object whose job it is to create other objects. What's the purpose of Factory Girl? Check out [this StackOverflow answer](http://stackoverflow.com/questions/5183975/factory-girl-whats-the-purpose).

It comes with some fancy tricks to allow you to set default parameters, override those parameters, create multiples of a particular object, etc.

You can use it in your test as follows:

```ruby
payload         = create(:payload)
invalid_payload = create(:payload, url_id: nil)
three_payloads  = create_list(:payload, 3)
```

Isn't that great? Let's see if we can add Factory Girl to our Blogger project and use it to do some testing.

### Installing RSpec & Capybara (10 minutes)

Before we get started, I'm betting if you followed the Blogger tutorial that you still are only using minitest in your project. Let's see if we can figure out how to add RSpec.

Follow along while I add RSpec and Capybara to my project.

Google for RSpec and Rails. Add it to a sample Blogger app.

Ask class to Google for Capybara and Rails. Add it to a sample Blogger app.

In both cases, model how to find information specific to the application being created.

### Finding Factory Girl Docs (15 minutes)

Take five minutes to see what information you can find about getting Factory Girl installed in your Rails project.

Take five minutes to share with a partner.

Five minutes large group share.

### Getting Factory Girl Installed (25 minutes)

With the remaining time, see if you can install Factory Girl in your project and create a factory that will make the following test pass.

**Tip**: In order to get this test to pass I had to remove the `app/assets/stylesheets/screen.css` file from my project.

```ruby
# spec/features/user_can_see_articles_spec.rb
require_relative '../rails_helper'

RSpec.describe "When a user visits '/'" do
  it "they see a list of articles" do
    create_list(:article, 2)

    visit '/'

    expect(page).to have_content("Article 1")
    expect(page).to have_content("Article 2")
  end
end
```

If you are able to get that test to pass, see if you can create another factory/test to see that all tags show up on the tags index.

#### Other Tips

* To get multiple factories with slightly different attributes, look at Factory Girl's ability to `sequence`.
* If you're following directions with a `support` folder, be sure that you check the instructions to see how items in that folder are getting required.
* If your test isn't recognizing `factory` as a method, be sure that you've checked to see that you are wrapping your methods appropriately. Do a search for the specific error that you're getting for more details.

### Further Reading

* [Getting Started with Factory Girl](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md)

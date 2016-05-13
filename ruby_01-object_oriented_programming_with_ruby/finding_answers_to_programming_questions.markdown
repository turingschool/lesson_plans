---
title: Finding Answers to Programming Questions
length: 30
tags: google, stackoverflow, answers
---

## Goals

* use resources such as documentation, StackOverflow, and blog posts to find answers to programming questions

## Discussion

### The Internet is a Cool Place -- Resources Rundown

#### Google

* start here for pretty much everything (even searching specific resources like RubyDocs is often better on google than on the site's specific search)
* Don't forget to contextualize your query -- include "Ruby", "Rails", etc.

#### Ruby Docs

* Good for answering fairly narrow/specific questions
* Good if you know what you're trying to do but can't remember exactly how / what the syntax is etc.
* "I think there may be a method to do XYZ" -- Cmd-F is your friend
* Make sure you're looking at docs for your version -- usually anything 2.2+ will be fine

#### StackOverflow

* Q&A format
* many people's "Go-To" resource these days
* Can be a gold mine but can also be a trash pile
* Cast a wide net -- pull up several answers to similar questions and scan them quickly for relevance
* Sometimes you get lucky and SO has an answer for exactly your question
* Problem with SO -- **Randos**
* Vet the answers -- **Good:** lots of upvotes on a single answer or consensus between multiple answers; **Bad:** divide between multiple answers; split of upvotes between various answers

#### Blog Posts

* Often more of a deep-dive on a specific format
* Often more of a narrative format
* Good to learn in depth about a topic -- often less useful for quick answer to a specific question

### Try It!

Find a blog post, a stack overflow post, and the Ruby Docs that show you how to produce the following time/date formatted strings using Ruby.

```ruby
wrap_up = Time.new(2016, 5, 11, 16, 05)
=> 2016-05-11 16:05:00 -0600

# use wrap_up variable and a formatter to produce this:
=> "2016-05-13"

# use wrap_up variable and a formatter to produce this:
=> "05/13/16"

# use wrap_up variable and a formatter to produce this:
=> "16:05 MDT" # (24-hour time with time zone)

# use wrap_up variable and a formatter to produce this:
=> "4:05 pm"

# use wrap_up variable and a formatter to produce this:
=> "05/13/16 5:10 pm"
```

#### Discuss with your pair

1. What techniques worked well for finding the three resources?
2. Out of the three types of resources, which resource was most helpful? Why?
3. How do you know that the resources are relevant and/or accurate?

### Other Things

* Don't copy
  - muscle memory
  - things can go wrong
* Error messages
  - what part of error message to Google
* Timebox the struggle
* Mentors
  - delete their code and try it again

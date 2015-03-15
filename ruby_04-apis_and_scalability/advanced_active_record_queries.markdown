---
title: Advanced ActiveRecord Queries
length: 180
tags: ruby, rails, activerecord, sql
---

## Learning Goals

* See some techniques for handling less common, more complicated
  ActiveRecord queries
* Get more practice expressing complex relational logic via ARel

## Structure

* 5 - Warmup / Recap -- review previously covered material from Queries
  lesson
* 20 - Queries Lesson finishing up -- cover remaining sections
* 25 - Warmup - Exercies from ActiveRecord Performance tutorial.
* 20 - Walkthrough: 500px API interactions via Curl and Faraday
* 5 - Break
* 10 - Walkthrough: 500px API interactions via wrapper gem
* 15 - Dig In: Pair up and start independent API explorations
* 5 - Break
* 20 - Continue API explorations
* 5 - Questions & Recap

### Recap

Let's briefly revisit our [Query Performance Lesson](http://tutorials.jumpstartlab.com/topics/performance/queries.html) from a few weeks ago.

Here are the topics we covered:

* Using `#to_sql` on an ARel query to expose the exact sql it will
  generate
* Using indices to improve query performance on specific columns
* Using `#includes` on ARel queries to pre-fetch related data with a
  query
* Using counter caches to improve performance of frequently-counted data

Let's jog our brains on this material with a quick recap quiz.

#### Recap Quiz

Go through the questions in this quiz to see how much you remember from
the previous session (none of this is tracked or graded; it's just a tool to help jog your memory): https://turing-quiz.herokuapp.com/quizzes/query-perf-recap.

### Finishing Up Query Performance Topcis

We didn't get into the final 2 topics from our previous Query
Performance Lesson. Let's discuss them now:

* [Fetching Less Data](http://tutorials.jumpstartlab.com/topics/performance/queries.html#fetching-less-data)
* [Rethinking Data Storage](http://tutorials.jumpstartlab.com/topics/performance/queries.html#rethinking-data-storage)

### Exercises

Let's get some more hands-on experience with improving query performance
by working through the exercises in the tutorial: [http://tutorials.jumpstartlab.com/topics/performance/queries.html#exercises](http://tutorials.jumpstartlab.com/topics/performance/queries.html#exercises)


- Homework problems: https://gist.github.com/stevekinney/7bd5f77f87be12bd7cc6
- Scopes with arguments
- joins vs includes
- references in migrations

#### Notes For Next Time

This session was first added for the 2/15 - 3/15 module. During several
previous ActiveRecord sessions (https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/query_performance.markdown, and homework review for https://gist.github.com/stevekinney/7bd5f77f87be12bd7cc6) we had run out of time with 1409 before working through all of the material.

This session served as a bit of mopping up to cover the remaining
material from those sessions, and to try to get students some more
practice writing more complicated AR queries in general.

Ultimately it would probably make sense to break some of these
monolithic AR sessions into multiple smaller sessions on specific topics
so that we are better able to cover all the material. But for the moment
this is how this particular lesson came to be and why it's a bit of a
hodgepodge.

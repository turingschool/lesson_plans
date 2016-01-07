---
title: Workers at Scale
length: 90
tags: workers, sidekiq, resque
status: draft
---

## Learning Goals

* Understand why workers are helpful and what kinds of jobs they can do
* Practice writing a job with Sidekiq
* Observe the performance implications of running workers

## Structure

* 5 - Warmup
* 20 - Messages, Queues, and Workers
* Break
* 55 - Small Background Jobs Tutorial
* 5 - Wrapup

## Warmup

Answer the following questions:

1. What jobs have you used a worker for in the past?
2. How does a worker know to do its work?
3. What kind of jobs could your current project do in a worker?

## Messages, Queues, and Workers

Let's revisit the theory of workers, including:

* Removing "work" from the MVC request/response cycle
* Creating a queue
* Posting messages
* Creating a worker and listening for messages
* Doing the work
* Parallelism
* Posting results and other jobs
* Things that go wrong

## Paired Work

Now it's time for you to put these ideas into practice. Get together with a
pair and work through the [Small Background Jobs tutorial](http://tutorials.jumpstartlab.com/topics/performance/small_background_jobs.html).

## Wrapup

Let's spend our last five minutes checking-in on your progress and answering any questions.

### Additional resources for this section: 
* [Background Jobs (Heroku)](https://devcenter.heroku.com/articles/background-jobs-queueing)
* [Active Job (Rails Guides)](http://edgeguides.rubyonrails.org/active_job_basics.html)


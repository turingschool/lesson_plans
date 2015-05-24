---
title: Background Workers Revisited
length: 180
tags: performance, workers, sidekiq, rails
---

## Learning Goals

* Review the reasoning behind background processing and identify
  scenarios when it makes sense
* Practice using Sidekiq to manage background processing within a rails
  app
* Practice deploying an Rails application with background workers to
  heroku

## Structure

* 25 - Presentation: Agile Development
* Break
* 25 - Structuring Stories
* Break
* 25 - Stories Workshop
* 5 - Wrapup

## Discussion: Background Workers as an Architectural Pattern

### Response Time -- Application Goodness as a Metric

There are a lot of performance metrics to take into account
when optimizing a web application, but there's generally
one that's the most important -- __Response Time__.

Response Time (from a server perspective) represents the length of time between when your
application receives a request from a user and when it finishes
processing and sends back a completed HTTP response. Response Time
is ultimately the main factor which determines how "snappy" your
application will feel, and thus how much users will enjoy interacting
with it.

There's no hard "rule" about response times, but generally response
times under ~200 ms or so allow an application to feel snappy and
responsive.

### Managing Application Response Time

Response Time is obviously important, so how to we keep it low?
Our first choice would be to just make everything within
the response cycle fast. If your application needs to do 5 things
in order to return an HTTP response and each one takes 5 ms, then
your response time would be `5 * 5 = 25 milliseconds`. Good Job!

But sometimes our application simply needs to do something
time-intensive in order to fulfill its responsibilities. Since
we can't make it faster, our remaining option is to "get rid of it"
somehow. And this is what background processing allows us to do.

Consider a hypothetical example:

```
## APP RESPONSE CYCLE

Load user info from DB (3 ms)
          |
          |
Generate User Recommendations (100 ms)
          |
          |
Send Email via slow 3rd party service (100 ms)
          |
          |
Render HTML Response (20 ms)
--------------------------
TOTAL: 223 ms
```

With a background queue, we can replace the 2 expensive
actions in the middle with a single action -- Enqueuing
the job, and then the expensive work can happen
asynchronously:

```
## APP RESPONSE CYCLE               |  ## Worker Activity Cycle
                                    |
Load user info from DB (3 ms)       |
          |                         |
          |                         |
Queue User Rec Job to Redis (1 ms)  |  Reads Queued job (1ms)
          |                         |           |
          |                         |           |
Render HTML Response (20 ms)        |  Generate User Recommendations (100 ms)
--------------------------          |           |
TOTAL: 24 ms                        |           |
                                    |     Send Email (100 ms)
                                    | (201 ms, but not in R/R Cycle)
```


Of course, in reality the job processing likely doesn't begin
immediately after the queuing as in this diagram, but the important
point is the concept of adding asynchronous processing to our
application. The web process and the worker process communicate
via the Job Queue (Redis in this case), so they don't have to
be rigidly linked in time.

### What Makes a Good Background Job?

There are 2 main attributes that make something a good
candidate for background extraction:

* Slow
* Immediate user feedback not crucial

The common example of sending emails asynchronously
fits well here because it's relatively slow and it's also
not essential that the user get their email immediately --
a delay of a few moments is generally not noticeable.

### Designing For Background Jobs

There are a few things we can do in our code
to make the process of extracting something into a background
process easier.

* Use objects and classes to provide good "boundaries" around
  calculations
* Limit the amount of contextual data that needs to be passed
  into the calculation

If these sound just like standard OO design principles that's
because...they are. But the utility will become especially clear
once you have to extract a job from a poorly factored Rails
controller. It's much easier to move 1 line such as
`MyThing.new("some", "data").new.calculate` than it is to untangle
and move 20 lines of spaghetti code.

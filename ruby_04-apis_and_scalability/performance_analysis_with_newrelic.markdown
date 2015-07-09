---
title: Performance Analysis with Newrelic
length: 60
tags: rails, performance, newrelic, metrics
---

## Learning Goals

* Understand the need for performance monitoring tools both in
  development in production
* Practice installing and setting up newrelic in an example project
* Practice using the newrelic interface to pinpoint performance problems

## Structure

* 25 - Discussion & Initial NR Setup
* 5 - Break
* 25 - Newrelic practice
* 5 - Wrapup

## Discussion - Value of Perfomance Monitoring

* Everyone agrees that performance is important, but even with that aim
in mind, how do we know what parts of our app to focus on?
* To be able to improve it, you need to measure it.
* Or in other words: "Optimizing code without measuring it first
isn't optimizing -- it's just changing shit."


__Our Dreamy Performance Monitoring Tool__

What sort of things would we want out of our ideal benchmarking
tool?

* Be able to see profiles based on actual production usage of the
app
* Be able to zoom in on an application trace to identify specific
methods or actions which are consuming the most time

Fortunately, there are tools out there that give us a pretty
good implementation of these features. Newrelic and Skylight
are the most popular, and for this lesson we'll be looking at
Newrelic

### Newrelic advantages

A few nice things Newrelic gives us out of the gate include:

* Ability to run it in development mode
* Greater detail in application traces to identify slow portions
* Application Histogram profiling (mean, TP90, TP95, etc)
* Ranking of all applicaiton actions by time consumption




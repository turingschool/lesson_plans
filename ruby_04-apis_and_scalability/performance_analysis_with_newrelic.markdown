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

## Workshop -- Adding Newrelic to an application

For this workshop, we'll look at adding newrelic to a sample
of the JSBlogger project. Since we're interested in seeing
how Newrelic lets us monitor our performance in production as well,
we'll also want to push this project to a heroku instance and profile
it there.

### 1. Cloning / Setup

Start by cloning the blogger project:

```
git clone https://github.com/JumpstartLab/blogger_advanced.git performance_metrics
cd performance_metrics
bundle
bundle exec rake db:drop db:setup
```

### 2. Add Newrelic to the project

First, add the newrelic agent to your gemfile:

```
gem 'newrelic_rpm'
```

and `bundle` the app.

### 3. Configuring the Newrelic agent

The Newrelic agent is a gem that will run in the background of our
application and send performance data up to newrelic's servers
in realtime. But to get things to work, we need to have it configured
with a unique identifier and account for our app.

To acquire configuration for a newrelic app instance, visit
the [newrelic homepage](http://newrelic.com/), log in (you may need
to create a free account), and when you land on the "applications" page,
click the "Add More" button. Click the "Ruby" application setup button,
and when presented with the option, "Download the newrelic.yml file."

You need to move this configuration file into the `configuration`
directory of our rails project. This can usually be achieved by running:

```
mv ~/Downloads/newrelic.yml ./config
```

from the root directory of your rails app.

Once we have this setup, restart your app (on your local machine) and
start hitting a few pages. If everything goes smoothly, you should start
to see requests appearing in your Newrelic window.

### 4. Monitoring Newrelic Performance in Production

If newrelic doesn't automatically detect your application and redirect
you to its monitoring page, try to check for it manually by clicking
the "APM" tab in the newrelic web interface. This should take you
to a listing of your registered newrelic applications, where your
JSBlogger instance should appear.

Click into the JSBlogger application instance, and you should see the
newrelic histogram interface for that application appear.



# Introduction to Ember

## Basic Flow

* Pre-show: Getting setup with Ruby, Rails, Node, Bower, and Ember CLI.
* Brief discussion about what Ember is, where it comes from, and how it works at a hight level.
* Setup for the code along:
  * Let's clone down the following two repositories:
    * [bartleby](https://github.com/turingschool-examples/bartleby)
    * [bartleby-rails](https://github.com/turingschool-examples/bartleby-rails)
  * Install the necessary dependencies:
    * In the Rails application: `bundle install`
    * In the Ember application: `npm install && bower install`
  * Fire up both servers
    * In the Rails application: `bundle exec rails server`
    * In the Ember application: `ember server`
* Code along

## Code Along

We're going to create an Ember application called _Social Butterfly_. The goal of the application is to keep track of people we meet at, umm, meetups.

In this process, we'll be keeping track of their names, how many times we've met with them and maybe some other fun information.

Make sure you have the directory cloned form the instructions above.

We can fire up the server by running `ember server` and head over to `http://localhost:4200/`.

If all went well, we should see a message welcoming us to Ember. It feels good to be welcomed, doesn't it?

It's not as splashy as the default Rails page, but we'll take what we can get.

### The Router

So, the core of any Ember application is the Router. The web is based on two things: a series of tubes and significant URLs. The router helps us with the latter.

We probably care a lot about contacts, right? I agree. Let's make that the root of our application.

h

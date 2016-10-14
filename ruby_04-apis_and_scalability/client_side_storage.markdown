---
title: Client-side Storage
length: 90 minutes
tags: local storage, session storage, firebase
---

## Goals

By the end of this lesson, you will know/be able to:

* Understand the Web Storage API for storing data in browsers
* Know the use cases for local storage vs. session storage
* Have a process for researching a new topic

## Repository

* [Link to Example Repo](https://github.com/turingschool-examples/client-side-storage)

## High Scores Feature

Let's say you got hired by a client to create a little game using JavaScript, HTML and maybe a little bit of CSS for a client's marketing campaign. They plan to have a laptop set up at a booth at a trade show, and allow people visiting the booth to play a game.

Your client wants to make the game interesting by allowing the user to keep a high score across everyone who plays the game at the booth.

Your first reaction to this request might be to `rails g migration UserHighScore` if you're coming from rails land - but the client refuses to pay for internet at the conference, and they won't give you their laptop to set up a local server. There are several ways to actually store data when you're not running a server that you can use for this problem - depending on what the client requirements are for a high score.

### Discovering storage options

- Take 5 minutes, and write up what you know, and don't know, about browser based storage
- Discuss with the person next to you
- Share with the class
- Take 5 minutes and come up with different ways to discover the things you don't know
- Discuss your answers with the person next to you
- Share with the class


### Let's Store Some Data

The localStorage and sessionStorage objects are implemented on the `window` object - so if you are writing code on the client side, you should be able to access them directly.

Git clone this [Example Repo](https://github.com/turingschool-examples/client-side-storage)

You'll notice that the app generates a high score when a button is clicked.

Using localStorage or sessionStorage, update the application so that:
  - The high scores persist when the users page is refreshed
  - The user can enter their name with their high score
  - The user can clear all high scores by clicking a button
  - The user can clear only high scores associated with their name

If you'd like more practice with tests, try writing a test any time you're going to create a function with a return value.

### Next Steps

Think about how ActiveRecord provides convenience methods around `create`, `destroy` which wrap the implementation details up. If you were to change databases, you could potentially use the exact same methods without changing every place in your code that reads/writes to the database.

We'll be doing exactly that in the next section of this lesson - so refactor your code so that another key/value store could be used without changing very much of your domain logic code.

## Before HTML5: Cookies

* Before HTML5 was introduced, the primary mechanism for storing information in the browser was cookies.
* What are the limitations of cookies
  * Not able to hold a lot of data (a limit of 4095 bytes)
  * Sent to the server every time you request a page from that domain
  * Not considered secure. Cookies are vulnerable to cross-site request forgery (CSRF)

## HTML5 Web Storage API: localStorage & sessionStorage

HTML5 introduced a *storage object* to help users store data in the browser. The storage object has two different types `localStorage` and `sessionStorage` and both types share the same methods.
  - They both store data in Key/Value pairs of strings.
  - To protect the user, the data stored in localStorage and sessionStorage is shared only under the *same origin policy* - meaning that it is stored in the browser but only accessible to pages with the same domain as that which stored it.

  If you want to read the internet's opinions of cookies vs. web storage [you can do so here](http://stackoverflow.com/questions/3220660/local-storage-vs-cookies)

The primary differences between `localStorage` and `sessionStorage` types are:

*localStorage*: persists across tabs and is useful for data that should be stored offline.

*sessionStorage*: does not persist outside of the users session - useful for semi-private user information or rapidly changing data.

### Limitations to the Web Storage API

  * Storing more than 5MB of data will cause the browser to ask the user if they want to allow the site to store that much data.

  * For security reasons, since the browser limits you to only sharing local or session data with websites of the same domain, you must match the following across pages that use the same storage:
    * Same domain: `turing.io` cannot access data stored on `github.com/turing`
    * Same subdomain: `today.turing.io` cannot access data stored from `turing.io`
    * Same protocol: no mixing http and https
    * Same port: `localhost:3000` cannot access data stored on `localhost:8080`
* localStorage can be vulnerable to XSS attacks (cross-site scripting) because the data is accessible to JavaScript (i.e. scripts can be run from localStorage). You need to escape and encode all untrusted data that can be set in localStorage.

## Limitations to Client Side Storage in General

The client is pleased with your localStorage demo - but as will all clients, once they've seen one user keeping a local high score, they want more. The client tells you that they now want the following feature (on top of the ones already defined):

- Users can see the top 5 scores of all players who have ever played the game.

You know that localStorage is exactly what it sounds like, 'local'. You can't use it to persist data across all users.

You could use a solution such as writing to a remote databse like one provided by [Firebase](https://firebase.google.com/) or [Parse](https://github.com/ParsePlatform/parse-server). This would allow you to make calls out of your app to a database, but now you have another problem.

***You client side code is accessible and pausible to anyone who knows how to use a debugging tool!***

One of the first steps to authenticate with Firebase is to use an API key. Where can you put the API key where it would be safe?

Also, if you've set up your application to put a user's high score on a leaderboard, what would prevent the user from hijacking the process to artificially inflate their score?

What you would likely recommend for the client, in this case, is moving from a client side app.

A Server Would:
  - Allow you to keep your API key secure
  - Allow you to make server side calls to a remote database or run a server based database
  - Allow you to validate any information on the server before writing it to the database

Luckily, you wrote your code so that you can switch out the data store easily. And Webpack is very similar to Node, so porting the app over to Node should be pretty painless.

### If we do have a server, why would we use browser storage?

The client is very happy with your work so far - but suddenly, something occurs to them... ***When they go to trade shows, usually the internet isn't very reliable.*** They need the app to work offine as well as online.

Luckily, while you might be using Firebase to store all players data... you know how to do things in localStorage too...

One major use case for localStorage is storing data when the app is offline temporarily!

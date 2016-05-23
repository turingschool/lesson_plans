---
title: Client-side Storage
length: 90 minutes
tags: local storage, session storage, firebase
---

## Goals

By the end of this lesson, you will know/be able to:

* Understand the Web Storage API for storing data in browsers
* Know the use cases for local storage vs. session storage
* Be familiar with Firebase as a remote database option

## Repository

* [Link to Example Repo](https://github.com/turingschool-examples/client-side-storage)

## High Scores in Tetris

Let's say you are creating a web version of Tetris using JavaScript, HTML and maybe a little bit of CSS for a client's marketing campaign. Your client wants to make the game interesting by allowing the user to keep a high score across all of their games.

Your first reaction to this request might be to `rails g migration UserHighScore` if you're coming from rails land - but the client just has a static website. There are several ways to actually store data when you're not running a server that you can use for this problem - depending on what the client requirements are for a high score.

## Before HTML5: Cookies

* Before HTML5 was introduced, the primary mechanism for storing information in the browser was cookies.
* What are the limitations of cookies
  * Not able to hold a lot of data (a limit of 4095 bytes)
  * Sent to the server every time you request a page from that domain
  * Not considered secure. Cookies are vulnerable to cross-site request forgery (CSRF).

## HTML5 Web Storage API: localStorage & sessionStorage

HTML5 introduced a *storage object* to help users store data in the browser. The storage object has two different types `localStorage` and `sessionStorage` and both types share the same methods.
  - They both store data in Key/Value pairs of strings.
  - To protect the user, the data stored in localStorage and sessionStorage is shared only under the *same origin policy* - meaning that it is stored in the browser but only accessible to pages with the same domain as that which stored it.

  If you want to read the internet's opinions of cookies vs. web storage [you can do so here](http://stackoverflow.com/questions/3220660/local-storage-vs-cookies)

The primary differences between `localStorage` and `sessionStorage` types are:

*localStorage*: persists across tabs and is useful for data that should be stored offline.

*sessionStorage*: does not persist outside of the users session - useful for semi-private user information or rapidly changing data.

### Methods

| Method                | Description                                     |
| ----------------------|:-----------------------------------------------:|
| `setItem(key, value)` | Creates a new key/value pair                    |
| `getItem(key)`        | Gets the value for a key                        |
| `removeItem(key)`     | Removes key/value pair based on key             |
| `clear()`             | Clears all info from storage                    |
| `length`              | Number of keys                                  |

### Your Turn: Let's Store Some Data

The localStorage and sessionStorage objects are implemented on the `window` object - so if you are writing code on the client side, you should be able to access them directly.

Git clone this [Example Repo](https://github.com/turingschool-examples/client-side-storage)

You'll notice that the app generates a high score when a button is clicked.

Using localStorage or sessionStorage, update the application so that:
  - The high score persists when the users page is refreshed
  - The user can enter their name with their high score
  - The user can clear all high scores by clicking a button
  - The user can clear only high scores associated with their name

### Your Turn: Next Steps

Think about how ActiveRecord provides convenience methods around `create`, `destroy` which wrap the implementation details up. If you were to change databases, you could potentially use the exact same methods without changing every place in your code that reads/writes to the database.

We'll be doing exactly that in the next section of this lesson - so refactor your code so that another key/value store could be used without changing very much of your domain logic code.

### Limitations to the Web Storage API

  * Storing more than 5MB of data will cause the browser to ask the user if they want to allow the site to store that much data.

  * For security reasons, since the browser limits you to only sharing local or session data with websites of the same domain, you must match the following across pages that use the same storage:
    * Same domain: `turing.io` cannot access data stored on `github.com/turing`
    * Same subdomain: `today.turing.io` cannot access data stored from `turing.io`
    * Same protocol: no mixing http and https
    * Same port: `localhost:3000` cannot access data stored on `localhost:8080`
* localStorage can be vulnerable to XSS attacks (cross-site scripting) because the data is accessible to JavaScript (i.e. scripts can be run from localStorage). You need to escape and encode all untrusted data that can be set in localStorage.

## Firebase: Cloud-hosted Database

The client is pleased with your localStorage demo - but as will all clients, once they've seen one user keeping a local high score, they want more. The client tells you that they now want the following feature (on top of the ones already defined):

- Users can see the top 5 scores of all players who have ever played the game.

You know that localStorage is exactly what it sounds like, 'local'. You can't use it to persist data across all users - and you're not ready to set up an entire server and Postgres database for this little app.

Luckily, you can use the methods you already wrote to read and write to a remote key/value store.

### Your Turn: Setting Up Firebase

- Sign up for Firebase: https://console.firebase.google.com/?pli=1
- NPM install the node package: https://www.npmjs.com/package/firebase
- Using the docs and your pre-existing methods - switch from using localStorage to using Firebase
- Finish the client's feature request

***Note:*** If you get stuck, check out [this similar project](https://github.com/robbielane/flappy-bird/commit/e86309da559daf19002f69ce930a8dcdb24f59ba)

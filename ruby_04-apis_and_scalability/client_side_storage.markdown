---
title: Client-side Storage
length: 90 minutes
tags: local storage, session storage, firebase
---

### Goals

By the end of this lesson, you will know/be able to:

* Understand the Web Storage API for storing data in browsers
* Know the use cases for local storage vs. session storage
* Be familiar with Firebase as a remote database option

### Repository

* [Link to Example Repo](https://github.com/turingschool-examples/client-side-storage)

#### High Scores in Tetris

* Let's say you are creating a web version of Tetris using JavaScript, HTML and maybe a little bit of CSS for a client's marketing campaign. Your client wants to make the game interesting by allowing the user to keep a high score across all of their games.

Your first reaction to this request might be to `rails g migration UserHighScore` if you're coming from rails land - but the client just has a static website. There are several ways to actually store data when you're not running a server that you can use for this problem - depending on what the client requirements are for a high score.

#### Before HTML5: Cookies

* Before HTML5 was introduced, the primary mechanism for storing information in the browser was cookies.
* What are cookies
* How do you see what cookies are being stored?
  * Using DevTools
* What are the limitations of cookies
  * Not able to hold a lot of data
  * 'Sent to the server every time you request a page from that domain'
  * 'Not considered secure'
* What are the use cases for using cookies nowadays?

#### HTML5 Web Storage API: localStorage & sessionStorage

HTML5 introduced a *storage object* to help users store data in the browser. The storage object has two different types `localStorage` and `sessionStorage` and both types share the same methods.
  - They both store data in Key/Value pairs of strings.
  - To protect the user, the data stored in localStorage and sessionStorage is shared only under the *same origin policy* - meaning that it is stored in the browser but only accessible to pages with the same domain as that which stored it.

The primary differences between the two storage types are:

*localStorage*: persists across tabs and is useful for data that should be stored offline.

*sessionStorage*: does not persist outside of the users session - useful for semi-private user information or rapidly changing data.

##### Methods

| Method                | Description                                     |
| ----------------------|:-----------------------------------------------:|
| `setItem(key, value)` | Creates a new key/value pair                    |
| `getItem(key)`        | Gets the value for a key                        |
| `removeItem(key)`     | Removes key/value pair based on key             |
| `clear()`             | Clears all info from storage                    |
| `length`              | Number of keys                                  |

##### Practice

##### Limitations

  * Storing more than 5MB of data will cause the browser to ask the user if they want to allow the site to store that much data.

  * For security reasons, since the browser limits you to only sharing local or session data with websites of the same domain, you must match the following across pages that use the same storage:
    * Same domain: `turing.io` cannot access data stored on `github.com/turing`
    * Same subdomain: `today.turing.io` cannot access data stored from `turing.io`
    * Same protocol: no mixing http and https
    * Same port: `localhost:3000` cannot access data stored on `localhost:8080`

#### Firebase: Cloud-hosted Database

#### Conclusion

Markdown Graph of When to Use Which Solution

Cookies - LocalStorage - SessionStorage - Firebase

#### The Closing: ~5 min

* Check for understanding
* Discuss any clarifications or student misconceptions
* Review goals, further resources, and next steps

### Outside Resources / Further Reading

* [Link to first outside resource]()

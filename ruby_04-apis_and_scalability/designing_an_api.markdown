---
title: Designing an API
length: 150
tags: api, rails
---

## Learning Goals

## Structure

* 10 - Warm Up and Discussion
* 15 - Lecture
* 5 - Break
* 30 - Group Research
* 5 - Break
* 45 - Share Out
* 40 - Group Design Session

## Warm-Up

Many of you used APIs or other data sources in your self-directed projects.

* How did you interact with the API?
* What were some of the limitations of the API?
* What are some things you liked about the API?
* What are some things that drove you nuts about it.

## Lecture

* [Parse REST API](https://parse.com/docs/rest)
* [JSON API](http://jsonapi.org)
* [Ember Data's ActiveModel Adapter](http://emberjs.com/api/data/classes/DS.ActiveModelAdapter.html)

### Research

Please consider the following questions when evaluating an API:

* How does the API represent its primary data? (In Twitter, this would be tweets. In Instagram, this would be photographs.)
* How does the API handle access to public data? (In Github, this would be public repositories. In Twitter, this would be a user's public timeline).
* How does the API handle access to private data? (Direct messages in Twitter or private repositories on Github.)
* Does the API have rate limits? If so, how are they enforced?
* How the API handle filter data?
* What about sorting?
* Can you pass it multiple filters or sorting commands?

#### Recommended APIs

* Twitter
* Github
* Foursquare
* Instagram
* Facebook
* LinkedIn
* Slack
* Trello
* Pinterest
* Dropbox

## Group API Design

Now, it's time for you to think about your API.

* What endpoints will you be offering?
* How will you handle authentication?
* How will you render relationships?
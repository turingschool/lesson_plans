---
title: Game Time
length: 2
tags: javascript, jquery, canvas, svg, mocha, testing
---

## Abstract

Build a game that is playable in the browser. There is no server-side component for this project. You'll be using client-side JavaScript exclusively to complete this project.

This project is inspired by [Minicade](http://minica.de/).

## Goals

* Use design patterns to drive both the design and implementation of code
* Separate business-logic code from view-related code
* Use test-driven design to build a client-side application

### Restrictions

You can use any of the following libraries:

* [jQuery](http://jquery.com/)
* [Mocha](http://mochajs.org/)
* [Underscore](http://underscorejs.org/)
* [Moment.js](http://momentjs.com)
* [Numeral.js](http://numeraljs.com)
* [D3](http://d3js.org)

(Other libraries may be used *only* with instructor approval.)

You can use any of the following build tools:

* [Webpack](http://webpack.github.io/)
* [Grunt](http://gruntjs.com/)
* [Gulp](http://gulpjs.com/)

**Nota bene**: We provide a [Game Time Starter Kit](https://github.com/turingschool-examples/game-time-starter-kit) that has been preconfigured with Webpack. You should probably use this starter kit.

## Playability Features

We want your game to be full-featured and playable -- not just a proof of concept of the gameplay and rendering
features.

To this end, make sure to include sufficient UX to allow the user to fully interact with the game. This would
include:

* Indicate when the game is over and won or lost
* Allow the user to start a new game
* Include a clean UI surrounding the actual game interface itself
* Score Tracking: How this works will vary by game, but at the end of
  the game, generate a score for the winning player
* Scoreboard -- track scores across multiple game sessions. Since we
  aren't incorporating a server for our games, client-side storage like
  a cookie or LocalStorage will suffice.
* Create multiple rounds of difficulty. (consider increasing factors
  such as game speed, randomness of starting setup, etc)

## Extensions

* Create an AI player that can play as the second player (except in 2048).
* Multiplayer support -- either by sharing a keyboard (2 sets of key
  inputs) or, as an extra-difficult extension, via websockets between
  multiple browsers

## Evaluation Rubric

155/150

### Extra Credit

* **50 points**

Two different forms/repos for the multiplayer functionality 

### Functional Expectations

* **35 points** - Application is fully playable and exceeds the expecations set by instructors

### User Interface

* **10 points** - The application has many strong pages/interactions, but a few holes in lesser-used functionality.

### Testing

* **15 points** - Project has sporadic use of tests and multiple levels. The application contains numerous holes in testing and/or many features are untested.

Testing is A+ on clientside - Testing is F- on Node. 

### JavaScript Style

* **20 points** - Application is thoughtfully put together with some duplication and no major bugs. Developer can speak to choices made in the code and knows what every line of code is doing.

### Workflow

* **20 points** - The developer effectively uses Git branches and many small, atomic commits that document the evolution of their application.

### Code Sanitation

The output from JSHint shows…

* **5 points** - Six to ten complaints

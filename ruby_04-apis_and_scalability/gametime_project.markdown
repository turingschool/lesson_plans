---
title: Game Time
length: 1
tags: javascript, jquery, canvas, svg, mocha, testing
---

## Abstract

Build a game that is playable in the browser. There is no server-side component for this project. You'll be using client-side JavaScript exclusively to complete this project.

This project is inspired by [Minicade](http://minica.de/).

## Goals

* Use client-side to drive both the design and implementation of code
* Use jQuery to traverse and manipulate the DOM
* Use test-driven design to build a client-side applicaiton

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

## Game Options

You can choose to implement any of the games listed below.

* Connect Four
* Lights Out
* Othello/Reversi
* 2048
* Tetris
* Snake
* Tron

(Other idea and suggestions are available with instructor approval.)

## Playability Features

We want your game to be full-featured and playable -- not just a proof
of concept of the gameplay and rendering features.

To this end, make sure to include sufficient UX to allow the user to
fully interact with the game. This would include:

* Indicate when the game is over and won or lost
* Allow the user to start a new game
* Include a clean UI surrounding the actual game interface itself
* Score Tracking -- How this works will vary by game, but at the end of
  the game, generate a score for the winning player

## Extensions

* Scoreboard -- track scores across multiple game sessions. Since we
  aren't incorporating a server for our games, client-side storage like
  a cookie or LocalStorage will suffice.
* Create multiple rounds of difficulty. (consider increasing factors
  such as game speed, randomness of starting setup, etc)
* Create an AI player that can play as the second player (except in 2048).
* Multiplayer support -- either by sharing a keyboard (2 sets of key
  inputs) or, as an extra-difficult extension, via websockets between
  multiple browsers

## Evaluation Rubric

### Functional Expectations

* 4: Application fulfills all base expectations and one extension
* 3: Application is fully playable without crashes or bugs
* 2: Application has some missing functionality but no crashes
* 1: Application crashes during normal usage

### Test-Driven Development

* 4: Application is broken into components which are well tested in both isolation and integration
* 3: Application is well tested but does not balance isolation and integration tests
* 2: Application makes some use of tests, but the coverage is insufficient
* 1: Application does not demonstrate strong use of TDD

### Breaking Logic into Components

* 4: Application is expertly divided into logical components each with a clear, single responsibility
* 3: Application effectively breaks logical components apart but breaks the principle of SRP
* 2: Application shows some effort to break logic into components, but the divisions are inconsistent or unclear
* 1: Application logic shows poor decomposition with too much logic mashed together

### Fundamental JavaScript & Style

* 4: Application demonstrates excellent knowledge of JavaScript syntax, style, and refactoring
* 3: Application shows strong effort towards organization, content, and refactoring
* 2: Application runs but the code has long functions, unnecessary or poorly-named variables, and needs significant refactoring
* 1: Application generates syntax error or crashes during execution

### Code Sanitation

The output from JSHint shows…

* 4: Zero complaints
* 3: Five or fewer complaints
* 2: Six to ten complaints
* 1: More than ten complaints

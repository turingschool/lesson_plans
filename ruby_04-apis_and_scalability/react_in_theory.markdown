---
title: React in Theory
length: 90
tags: JavaScript
---

# React in Theory
---
In this lesson we will take a closer look at the React.js library and get started with some basic code.

## Goals
---
* Students will understand the limitations of managing state using a DOM manipulation library like jQuery
* Students will understand how the "events up; data down model" of React
* Students will have a conceptual understanding of how and when React updates the DOM
* Student will be able to explain the difference between `this.state` and `this.props` in React.
* Students will be able to implement a small counter where buttons fire events that increment the counter, which update the component

## What does React do? (10 min)
---
React is a small library used to create composable user interfaces. It's not a full framework, it's more like jQuery on steroids. We can build small, reusable components which will present our data as it changes over time. React uses JavaScript to render views which means that we can unite our markup (usually HTML) with our view logic. This allows for greater abstractions and more dynamic views. In each small component we write code that declares what HTML to render and how to respond to user feedback (events).

React makes it super simple to update the DOM as your data changes. When you have a well structured component tree, there's very little you need to do to update the DOM as data changes. In a regular JavaScript application using jQuery for its DOM manipulation, we need to either listen for events or use callbacks to update the DOM as the data changes. This approach is prone to errors since the developer has to manually interact with DOM nodes to update the DOM. DOM traversal is risky as it is a hard coded path to node elements, as soon as you change your HTML or CSS selectors you have to mirror that change in your JavaScript.

React is lightweight and like Angular, it can be sprinkled in applications or be used for your entire view layer.

#### Discussion (5 min in pairs + 5 min full group )

In pairs, discuss how you would go about managing state in a regular JavaScript application.

* In our application, how would we keep track of which button was last clicked?
* In our application, how would we keep track of which buttons that the user has clicked?
* In our application, how would we keep track of which template is currently rendered?
* In our application, how would we keep track of which templates that has been viewed?

Additional resources for this section:
- https://facebook.github.io/react/docs/getting-started.html
- https://facebook.github.io/react/blog/2013/06/05/why-react.html

## How does React interact with the DOM?
---
Let's take a look at a simple React component.

```js
var Main = React.createClass({
  render() {
    return (
      <div>
        <h1>Hello, World!</h1>
      </div>
    )
  }
});
```

Each component has a `render()` function which will be called when the component is mounted on the DOM. It will execute all the code in the component and render the JSX (JavaScript + HTML) in the return statement.

React uses a virtual DOM to diff against the actual DOM to figure out what parts of our application's state has updated and need to be re-rendered. `State` represents mutable data in React, and updating a state signals to a listener that the data has changed and queues the component for re-rendering. React listens for state changes and re-renders accordingly. That is faster and more efficient do than dirty data checking ( = polling the data in regular intervals to check if the data has changed).

When we call `setState()` in a component (the function we use to update the state), React marks that component as dirty, diffs it and re-renders a new version at the end of that event loop.

In a nutshell: each component's `render()` function will be called when it's mounted on the DOM. When we update the state, the virtual DOM will diff against the actual DOM to figure out which parts of our application need to be updated.

Additional resources for this section:
- http://stackoverflow.com/questions/21109361/why-is-reacts-concept-of-virtual-dom-said-to-be-more-performant-than-dirty-mode
- https://www.quora.com/How-does-Reacts-virtual-DOM-work
- http://calendar.perfplanet.com/2013/diff/, React's diff algorithm in detail

## JSX (5 min)
---
A quick note about JSX...

It's not necessary to use JSX with React. It's very similar to erb.

```rb
Are you hungry, <%= user.name %>?

We could go to <%= user.favorite_restaurant ? user.favorite_restaurant : 'Protein Bar' %>.
```

```js
Are you hungry, {user.name}?

We could go to {user.favorite_restaurant ? user.favorite_restaurant : 'Protein Bar'}.
```

Additional resources for this section:

- [JSX in depth](https://facebook.github.io/react/docs/jsx-in-depth.html)
- [JSX gotchas](https://facebook.github.io/react/docs/jsx-gotchas.html)

## Component hierarchy (15 min)
---
Components have parent-child relationships. If component "Cat" renders component "Kitten", "Cat" is the parent of "Kitten". The goal is to build a component tree with smart parents that maintain state, and dumb child components that are passed data and just render. By centralizing state, we are reading and updating data in one place. By striving towards a *Single Source of Truth* for each piece of data we also minimize redundancy throughout our application, which is great news!

React implements an "events up; data down" model: at the top of the component tree we have stateful components which receive events and updates the state accordingly, at the bottom of the component tree we have stateless components which receive data, render HTML and send up events based on user feedback.

#### Exercise (10 min + 5 min group discussion)

* Build out the component hierarchy for a SPA with a header, footer, sidebar and main body. The sidebar renders info about the user and a search bar. The main body renders tweets and ads.

Additional resources for this section:

- [Thinking in React](https://facebook.github.io/react/docs/thinking-in-react.html)
- [Multiple Components](https://facebook.github.io/react/docs/multiple-components.html)
- [Demystifying React Components State](http://www.sitepoint.com/demystifying-react-components-state/)

## State vs Props (10 min)

**Props**: immutable, passed down to the component by the parent, accessed as `this.props.myValue`

**State**: mutable, maintained in a component, accessed as `this.state.myValue`, updated by `this.setState({ myValue: updatedValue })`

A note about **State** from the docs:

>Try to keep as many of your components as possible stateless. By doing this you'll isolate the state to its most logical place and minimize redundancy, making it easier to reason about your application. [...] State should contain data that a component's event handlers may change to trigger a UI update.

A note about **propTypes()**:

> propTypes: {
    name: React.PropTypes.string,
    children: React.PropTypes.element.isRequired,
  },

Proptypes aren't required but should be used to make sure our data is valid.

Additional resources for this section:

- [Code example: state vs props](https://gist.github.com/applegrain/018bd9953c993bdf02bc);
- [Interactivity and Dynamic UI's](https://facebook.github.io/react/docs/interactivity-and-dynamic-uis.html)

## Code Example
---
* a SPA (single page application) with three buttons that trigger three types of calculation to render in the browser.

## Code Challenge (15 min + 5 min group discussion)
---
Your turn:

- Clone a playground repo:
  - [boilerplate](http://github.com/applegrain/react-playground) that comes with react, webpack, express, babel 6, airbnb's eslint configs, enzyme + mocha for testing
  - [safe](https://github.com/applegrain/react-starter-repo) repo that has all the necessary dependencies as static files. Use if the first one is giving you trouble
- Add three buttons with the values 1, 2 and 3 respectively
- Add a counter that renders on the DOM (should start at 0)
- When we click either button, the counter should increment by 1, 2, and 3 respectively

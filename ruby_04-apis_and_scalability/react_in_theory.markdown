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
React is a small library used to create composable user interfaces. It's not a full framework, it's more like jQuery on steroids. We can build small, reusable components which will present our data as it changes over time. React uses JavaScript to render views which means that we can unite our markup (usually HTML)
with our view logic. This allows for greater abstractions and more dynamic views.

React makes it super simple to update the DOM as your data changes. Actually, if you built your application right, there's very little you need to do to update the DOM as data changes. In a regular JavaScript application using jQuery for its DOM manipulation, we need to either listen for events or use callbacks to update the DOM as the data changes. This approach is prone to errors since string concatenation is difficult to get right and the developer needs to do a lot of manual work.

In React components we decide how we want the data to render, we pass data to the component from its parent component and the component renders the way we told it to, using the data that was passed down to it.

React is very lightweight and like Angular, it can be sprinkled in applications or be used exclusively in components.

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

Each component has a `render()` function which will be called when the component is mounted on the DOM. It will execute all the code (in this case, none) and render the JSX (JavaScript + HTML) in the return statement.

React uses a virtual DOM to diff against the actual DOM to figure out what parts of our application need to update and re-render. `State` is mutable data in React, and updating a state signals to a listener that the data has changed and it will queue the component for re-rendering. React listens for state changes and re-renders accordingly. It's faster and more efficient to listen for state changes than to do dirty data checking: polling the data in regular intervals to check if the data has changed.

When we call `setState()` in a component (the function we use to update the state), React marks that component as dirty and re-renders it at the end of that event loop.

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
What are we going to talk about, <%= user.name %>?

We could probably go to <%= user.favorite_restaurant ? user.favorite_restaurant : 'Protein Bar' %>.
```

```js
What are we going to talk about, {user.name}?

We could probably go to {user.favorite_restaurant ? user.favorite_restaurant : 'Protein Bar'}.
```

Additional resources for this section:

- [JSX in depth](https://facebook.github.io/react/docs/jsx-in-depth.html)
- [JSX gotchas](https://facebook.github.io/react/docs/jsx-gotchas.html)

## Component hierarchy (15 min)
---
The notation for rendering React components is: <ComponentName />.

Components have parent-child relationships, if component "Cat" renders component "Kitten", "Cat" is the parent of "Kitten". The goal is to build a component tree with smart parents that maintain state, and dumb child components that are passed data and just render. By centralizing state, we are reading and updating from one place - we have created a *Single Source of Truth*.

We pass data down to the dumb children. If we click a button in a component, enter info in a form and hit `submit` or click an arrow to see more items, the dumb components need to signal to their parents that something happened so our state, the *Single Source of Truth* can be updated. In addition to passing down data, parent components also pass down function references which the child components can execute and trigger some change in the parent component.

Example: a SPA with three buttons that trigger three types of calculation to render in the browser.

#### Exercise (10 min + 5 min group discussion)

* Build out the component hierarchy for a SPA with a header, footer, sidebar and main body. The sidebar renders info about the user and a search bar. The main body renders tweets and ads.  

Additional resources for this section:

- [Thinking in React](https://facebook.github.io/react/docs/thinking-in-react.html)
- [Multiple Components](https://facebook.github.io/react/docs/multiple-components.html)
- [Demystifying React Components State](http://www.sitepoint.com/demystifying-react-components-state/)

## State vs Props (10 min)

**Props**: immutable, passed down to the component by the parent, accessed as `this.props.myValue`

**State**: mutable, maintained in a component, accessed as `this.state.myValue`, updated by `this.setState({ myValue: updatedValue })`

It's important to identify where in the component tree state should live. If we are building a TODO app and there are four components that need access to the array of todo's, don't store a copy of the array in each component - rather, store it in a shared parent and pass the array of todo's down as props. This way, we force our application to read and update the array in one spot. We would die a slow web app death if we would have to make sure that the todo array is the same in four places in our application.  

## Code Challenge (15 min + 5 min group discussion)
---
Your turn:

- Clone this [repo](https://github.com/applegrain/react-starter-repo)
- Add three buttons with the values 1, 2 and 3 respectively
- Add a counter that renders on the DOM (should start at 0)
- When we click either button, the counter should increment by 1, 2, and 3 respectively

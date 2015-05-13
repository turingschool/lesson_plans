---
title: Ember Routing
length: 90
tags: javascript, ember
status: deprecated
---

## Lecture

### Routes

You get a few routes for free: `ApplicationRoute` and `IndexRoute`.

We use `{{link-to}}` to get around. In Rails, there is a similar helper, in Ember, this is much more important because it overrides the default functionality of the `<a>` tag.

Ember creates defaults on the fly. We only need to explicitly define a route, controller, view, or template if we want to override these defaults.

Routes have a model hook, which sets the initial model for a new controller or changes the model on an existing controller.

The syntax looks as follows:

```js
export default Ember.Route.extend({
  model: function (params) {
    return {};
  },
});
```

### Routes and Resources

#### The Ember Router

A route is for a single action. A resource is for a set of actions—kind of like in Rails.

```js
App.Router.map(function() {
  this.resource('notes');
});
```

This will create the following:

* `NotesRoute`
* `NotesLoadingRoute`
* `NotesErrorRoute`

You can nest routes and resources into a resource.

```js
App.Router.map(function() {
  this.resource('notes', function() {});
});
```

This will add a `NotesIndexRoute`.

Let's say we wanted to nest a note resource within our notes, collection.

```js
Router.map(function() {
  this.resource('notes', { path: '/' }, function () {
    this.resource('note', { path: ':note_id' });
  });
});
```

Now, we also have a `NoteRoute` mapped to a URL similar to the Rails does it.

You should use this.resource for URLs that represent a noun, and this.route for URLs that represent adjectives or verbs modifying those nouns.

```js
Router.map(function() {
  this.resource('notes', { path: '/' }, function () {
    this.resource('note', { path: ':note_id' });
    this.route('new');
  });
});
```

This adds a `NotesNewController` located at `notes/new`.

### Rendering

Let's say we hit up `/notes/new`

It's like a Russian doll. The Ember Router instantiates `ApplicationRoute` (and sets up its view, controller, and template). Next, it hits the `NotesRoute` and does similar set up; rendering into the `{{outlet}}` of the `application.hbs`. Lastly, we hit `NotesNewRoute` and set it up. The template is loaded into the `{{outlet}}` of `notes.hbs`.

`ApplicationController`, `IndexController`, `NotesController`, and `NotesNewController` are instantiated along the way. They are alive and sitting in memory as they maintain state in our application.

### Models and Controllers

Part of the role of the route is to set up the controller. Typically, this involves fetching a model from the server and configuring the controller with the model.

This is a common enough task that there is some syntactic sugar for it.

```js
export default Ember.Route.extend({
  model: function (params) {
    // Some code goes here.
  },
});
```

When we hit that route, it is fetching the model and setting the `model` property on the controller.

Routes also have a `setupController` hook.

```js
export default Ember.Route.extend({
  setupController: function (controller, model) {
    // Some code goes here.
  },
});
```

### Router Hooks

We can hook into a few events in the lifecycle of our route.

```js
export default Ember.Route.extend({

  beforeModel: function (transition) { },

  model: function (params, transition) { },

  afterModel: function (model, transition) { },

  activate: function () { },

  setupController: function (controller, model) {
    controller.set('model', model)
    // or this._super(arguments...)
  },

  deactivate: function() { }

})
```

### Accessing Other Properties from the Route

* `this.modelFor('routeName')`
* `this.controllerFor('controllerName')`
* `this.controllerFor('controllerName').get('model')`

### Transitioning to Routes

Let's say we're handling an action in the controller and we want to transition them to a new route. We can do that using the following syntax.

`this.transitionToRoute('note', note);`

## Pair Practice

Check out the `basic-functionality` branch of [Bartleby](https://github.com/turingschool-examples/bartleby/tree/basic-functionality).

Let's see if we can add the following functionality:

* Create a route for a new note:
  * Add a route in `router.js` (you can look above for the syntax)
  * Remove the `{{action 'addNote'}}` action from `templates/notes.hbs`
  * Remove the action from `controllers/notes.js` as well
  * This is not Ember related (it's a Bootstrap thing), but you still have to do it: change the "Add Note" button to a `{{#link-to}}` with the class of `btn btn-primary`. It will now be a link, but still look like a button. (If you're up for a challenge, keep the button and see if you can still get it to work. `transitionToRoute` is your friend here.)
  * Look at the Ember Inspector to see what the route and template is supposed to be for our new note route
  * Create the corresponding template
  * Steal the form from the note editing functionality in `templates/note.hbs`
  * Create a controller for our new note and set up an action that should fire when the "Save Note"
  * Transition to the note after it's saved.

I encourage to reference code already written in the application.

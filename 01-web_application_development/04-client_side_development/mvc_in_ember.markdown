---
title: MVC in Ember
length: 120
tags: javascript, ember
status: draft
---

## Learning Goals

* Understand the roles of routes, models, controllers, and templates in an Ember application
* Trigger and respond to actions in the controller in an Ember application
* Set up two-way data-bindings between the controller and the template

## Structure

* 25 - Lecture
* 5 - Break
* 80 - Code Along / Workshop
* 10 - Wrap Up

## Resources

* [Bartleby][]

[Bartleby]: https://github.com/turingschool-examples/bartleby

## Lecture

* In Rails, the controller is in charge of getting the requested data and then sending it off to the view.
* In Ember, those responsibilities are split between the route and the controller. The route fetches the model.
* The route loads the model and sets the content of the controller to the model. The route renders the view.
* When your application starts, the router is responsible for displaying templates, loading data, and otherwise setting up application state. It does so by matching the current URL to the routes that you've defined.
* The route gets the model by calling the model hook on the route when a given URL is requested.
* The controller acts as a presenter/decorator for the model.
* The controller maintains also state.
* Controllers are long-lived in Ember.
* In Rails, views and templates are pretty much the same thing.
* In Ember, they are different things and different files.
* Templates are closer to Rails's idea of views.
* Views handle and respond to events. They can listen for clicks and whatnot and then send that off to the controller to deal with.

## Workshop

We're going to build an Ember application modeled after the Notes application in iOS and Mac OS X.

So, the first thing we've learned about Ember is that routes are important. Let's add a `notes` route to our router.

In `app/router.js`, update the following section as follows:

```js
Router.map(function() {
  this.resource('notes', { path: '/' });
});
```

Notes are the core of Bartleby. So, we're going to use our `NotesRoute` as the base URL of our application.

We can visit our new route and it will work. Rails would have had issues with the fact that we didn't set up a controller or a view, but Ember just whips them up on the fly.

That said, let's just create `app/templates/notes.hbs` and add the following content:

```handlebars
Notes go here.
```

Now, we just need some notes. We can use `ember-cli` to create some boilerplate for us.

From the command line, type: `ember g route notes`

We can now make some changes to `app/routes/notes.js`.

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function () {
    return $.getJSON('/api/notes');
  }
});
```

Hmm… We're hitting up an API. `ember-cli` allows you to mock a server so you can develop independently of server-side development.

Let's set up a mock: `ember g http-mock notes`. At this point some NPM magic should happen and we should be good to go. Broccoli will take care of firing up our server.

We don't want to spend too much time thinking about the server. Let's just copy the following code over into `server/mocks/notes.js`:

```js
module.exports = function(app) {
  var express = require('express');
  var notesRouter = express.Router();

  var notes = [
    {
      id: "1",
      title: 'Shopping list',
      body: 'Gala apples, Fuji apples, red delicious apples'
    },
    {
      id: "2",
      title: 'Todo list',
      body: 'Write sample application for Ember lesson'
    },
    {
      id: "3",
      title: 'Wish list',
      body: 'A bread bowl from Panera'
    }
  ];

  notesRouter.get('/', function(req, res) {
    res.send(notes);
  });
  notesRouter.get('/:id', function(req, res) {
    res.send(notes[req.params.id - 1]);
  });
  notesRouter.post('/', function(req, res) {
    var note = req.body || { title: "New Note", body: "Lorem Ipsum..." };
    note.id = (parseInt(notes.length, 10) + 1).toString();
    notes.push(note);
    res.send(note);
  });
  notesRouter.post('/:id', function(req, res) {
    var note = req.body;
    notes[parseInt(notes.length, 10) - 1] = note;
    res.send(note);
  });

  app.use('/api/notes', notesRouter);
};
```

Let's kill off our Ember server and fire it back up.

Nothing much has changed because we don't have a template. Let's take care of that with some Bootstrap magic in `templates/notes.hbs`.

```handlebars
<div class="row">

  <div class="col-md-4">
    <div class="list-group">
      {{#each}}
      <a href="#" class="list-group-item">
        <h4 class="list-group-item-heading">{{title}}</h4>
        <p class="list-group-item-text">{{body}}</p>
      </a>
      {{/each}}
    </div>
    <button class="btn btn-primary">New Note</button>
  </div>

  <div class="col-md-8">
    Individual notes will go here.
  </div>

</div>
```

You'll notice we have some special tags in curly braces. Ember uses a templating language called Handlebars. More on that later.

If all went well, we should see our notes in a sidebar.

Having a list of notes is great, but we'll probably want to look at one, right?

Let's add a child route to `app/router.js`:

```js
Router.map(function() {
  this.resource('notes', { path: '/' }, function () {
    this.resource('note', { path: ':note_id' });
  });
});
```

In `app/templates/notes.hbs` replace our "Individual notes will go here." with `{{outlet}}`.

```handlebars
<div class="col-md-8">
  {{outlet}}
</div>
```

We'll also make a default template for our new child route in `app/templates/notes/index.hbs`:

```html
<p>Select a note from the left-hand column.</p>
```

Okay, okay! Let's take a step aside and try out one of those fancy computer properties we talked about in a previous session.

Let's generate a controller to do some decoration: `ember g controller notes`

In `app/controllers/notes.js`, our new controller, let's set a computed property that counts the number of notes in our model:

```js
import Ember from 'ember';

export default Ember.ArrayController.extend({

  numberOfNotes: function () {
    return this.get('content').length;
  }.property('content.[]')

});
```

Back to the main event. Let's set up `app/templates/note.hbs` with the following content:

```handlebars
<h1>{{title}}</h1>

<div class="note-body">
  {{body}}
</div>
```

We also need to update our `app/templates/notes.hbs` template:

```handlebars
<h3>{{numberOfNotes}} notes</h3>
<div class="list-group">
  {{#each}}
    {{#link-to 'note' this class="list-group-item"}}
      <h4 class="list-group-item-heading">{{title}}</h4>
      <p class="list-group-item-text">{{body}}</p>
    {{/link-to}}
  {{/each}}
</div>
```

We're killing two birds with one stone here and including that computed property we made earlier.

So, here's a cool thing about Ember. We already have our models loaded up from the server. So, we don't need to make another AJAX call. We can use the model we already have loaded up in memory. This syntax is a little squirrelly because we're doing it by hand. Let's pop into `app/routes/note.js`:

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function (params) {
    return this.modelFor('notes').filterBy('id', params.note_id)[0];
  }
});
```

We're also going to respond to some actions in `app/controllers/notes.js`.

```js
actions: {

  addNote: function () {
    var note = { title: 'New Note', body: 'Lorem ipsum…' };

    $.post('/api/notes', note).done(function (data) {
      this.get('content').pushObject(data);
    }.bind(this)).fail(function (data) {
      alert('Something went wrong with saving the note. Check the console.');
      console.log('POST request failed!', data);
    });
  }

}
```

We need to add something to fire that action in `app/controllers/notes.js`:

```handlebars
<button class="btn btn-primary" {{action 'addNote'}}>New Note</button>
```

Let's also add some actions to the template for the individual note (`app/templates/note.hbs`):

```handlebars
<div class="well">
{{#if editing}}
  <div class="panel panel-default">
    <div class="panel-body">
      <div class="form-group">
        <label>Title</label>
        {{input type="text" value=title class="form-control"}}
      </div>
      <div class="form-group">
        <label>Body</label>
        {{textarea value=body class="form-control"}}
      </div>
    </div>
  </div>

  <button class="btn btn-default" {{action 'stopEditing'}}>Finish Editing</button>
{{else}}
  <button class="btn btn-default" {{action 'startEditing'}}>Edit Note</button>
{{/if}}
</div>
```

Let's wire up our action in `NoteController`:

```js
import Ember from 'ember';

export default Ember.ObjectController.extend({

  editing: false,

  actions: {

    startEditing: function () {
      this.set('editing', true);
    },

    stopEditing: function () {
      $.post('/api/notes/' + this.get('id'), this.get('content'));
      this.set('editing', false);
    }

  }

});
```

If all went well, then we have a working notes app.

### Extensions

* Add Markdown processing.
* Push the server synchronization logic down the stack.

## Wrap Up

* What are some of the core differences between MVC in Rails and MVC in Ember? How much of it has to do with the HTTP response/request cycle?
* What are some aspects of Ember's MVC that you really like?
* What are some aspects that confuse you?

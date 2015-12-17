---
title: Ember Data
length: 180
tags: javascript, ember
status: draft
---

## Learning Goals

* Use Ember Data in place of making AJAX calls using jQuery
* Swap out the mock server with a Rails server
* Use Handlebars helpers to format data

## Structure

* 25 - Lecture
* 5 - Break
* 45 - Code Along
* 60 - Independent/Pair Work Time
* 15 - Code Review
* 20 - Extensions
* 10 - Wrap Up

## Lecture

### When to Use Ember Data

From the Ember.js documentation:

> For simple applications, you can get by using jQuery to load JSON data from a server, then use those JSON objects as models.
>
> However, using a model library that manages finding models, making changes, and saving them back to the server can dramatically simplify your code while improving the robustness and performance of your application.

That's a pretty good synopsis. I agree.

### Core Concepts

#### Store

The store is a central repository of all of your model records. The store is a shared resource that all of the objects in your application have access to.

The store caches objects. If you request an object that the store has fetched, it just returns that record instead of duplicating the request.

Because the store is globally available, you don't have to worry about keeping your data in sync throughout multiple layers of your application.

#### Model

In our previous applications, we've just used plain old JavaScript objects to represent our data. Using models allows you to create representations of the models in your Rails application and bring them over to Ember.

A person model might look something like this:

```js
export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName:  DS.attr('string'),
  birthday:  DS.attr('date')
});
```

We can also set up relationships. The syntax is a big difference, but the general concept should be familiar to you as a Rails developer.

```js
// models/post.js
export default DS.Model.extend({
  title: DS.attr('string'),
  body: DS.attr('text'),
  comments: DS.hasMany('comments')
});

// models/comment.js
export default DS.Model.extend({
  comment: DS.attr('string'),
  post: DS.belongsTo('post')
});
```

The model in Ember is—surprisingly—a lot like the model in Rails. It's adding structure and behavior to data that—at the end of the day—ultimately comes from your database.

#### Record

A record is an instance of your model backed by data from the server. (Or a new record that will be imminently saved to your server.) The easiest way to think about a record is as an instance of your model.

#### Adapter

The adapter is the interface is the translation layer between Ember and Rails. Let's say we want Ember to find the `person` with the `id` of 1. How does Ember know what endpoint to hit? Is it `/people/1`? `/api/v1/people/`? The adapter handles that translation for you so that you're not hardcoding it in multiple places in your application.

Your application asks the store for a record. If the store doesn't have it, then it asks the adapter, which asks your server.

#### Serializer

Once you've fetched some data from the server, you need to rehydrate it into an object. Your serializer knows the rules.

## Code Along

### Setting Up Ember Data

Let's update Bartleby to use Ember Data and a real (albeit super simple) Rails server.

Let's start by generating a model with `ember g model note`.

This will create a new file in our `app/models` directory called `note.js`.

Let's update `app/models/notes` with the following content:

```js
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  body: DS.attr('string')
});
```

Let's also go ahead and create an adapter and a serializer so Ember and Rails can talk to one another.

Generate the adapter with `ember g adapter note`. The result will be a new file located at `app/adapters/note.js`.

Generate the serializer with `ember g serializer note` and we'll get a new file located at `app/serializers/note.js`.

We'll stick with the default implementations now and then worry about adjusting them as the need comes up.

### Putting Ember Data into Action

Okay great, we've set up Ember data. Let's switch over from our AJAX calls to Ember data.

In `app/routes/notes.js`, let's swap out `return $.getJSON('/api/notes')` with the following:

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function () {
    return this.store.find('note');
  }
});
```

Let's fire up our app and—uh oh. It doesn't work. It almost works. It's so close to working. But it doesn't work.

Ember Data is looking at `/notes` for our notes. But we're actually storing them at `/api/notes`. So, that's not going to work. We could just change our server endpoints, but that would rob us of a learning opportunity.

**An aside**: We did make some changes to the server. Ember Data's `RESTAdapter` expects that everything is nested under a key named after the model. So, when we hit `/api/notes`, we're going to respond with `{ note: […] }` instead of just the array at the top level.

Instead, let's adjust the endpoint that Ember Data is looking for. In `app/adapters/note.js`, add the following to the inside of the function:

```js
import DS from 'ember-data';

export default DS.RESTAdapter.extend({
  namespace: 'api'
});
```

This will tell Ember Data to look at `/api/notes` for out notes instead of `/notes`. This allows Ember Data to be flexible around how you're versioning your API on the Rails side.

Let's do a quick but of housekeeping. You'll see that our note count doesn't work. Things are getting stored a little differently now, so let's adjust our controller slightly. In `app/controllers/notes`, adjust our computed property:

```js
import DS from 'ember-data';

export default DS.RESTAdapter.extend({
  namespace: 'api'
});
```

### Removing a Code Smell

Switching out our JSON request with Ember Data in `NotesRoute` wasn't really a big win. That code was pretty clean. But what about `NoteController`? If you remember, we actually were referencing another route and grabbing it's model and then filtering it.

As a horrifying reminder, this is what we have currently:

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function (params) {
    return this.modelFor('notes').filterBy('id', params.note_id)[0];
  }
});
```

Yuck. Let's swap this functionality our for Ember Data. The nice part about this old approach is that we didn't have to hit our server up twice because we already loaded the model when we built the side bar. Luckily, Ember Data is going to do something similar. When we access the store, it checks to see if it's already fetched that record—which it has—and just uses that instead of hitting up the server again.

We can replace that ugly code with this:

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function (params) {
    return this.store.find('note', params.note_id);
  }
});
```

It's not exactly the same as ActiveRecord, but it's pretty close—and it's definitely in the same spirit. Click around in our application and everything should still work.

Alright, we still have a few more places where we can use Ember Data to clean up our code.

### Creating a New Record in Ember Data

Remember that functionality we added yesterday for creating a new note? Let's give it the Ember Data treatment.

Let's look at what we have in the `saveNote` action in `app/controllers/notes/new` currently:

```js
actions: {

  saveNote: function () {
    var title = this.get('title');
    var body = this.get('body');
    var note = { title: title, body: body };
    Ember.$.post('/api/notes', note).done(function (data) {
      this.get('controllers.notes').get('content').pushObject(data);
      this.transitionToRoute('note', data);
    }.bind(this));
  }

}
```

Not bad, but we're still doing a lot of the work ourselves. We're sending the data over to the server, waiting for the request and then pushing the response onto the array of notes. There are a few ugly things going on here:

1. We're doing way too much in the controller. Just like in Rails, we want to push as much of this kind of business logic down the stack as possible. This kind of stuff is definitely the job of the model.
2. We're creating an object from the form then we're sending it off to the server. What we're getting back is actually a completely different object. It's working fine now, but I'm sure you can imagine how this will probably blow up in our faces as our application gets more complicated. We're much better off with a model that syncs itself with the server.

Our store has a `createRecord` method. We'll create a note using this method.

```js
store.createRecord('post', {
  title: this.get('title'),
  body: this.get('body')
});
```

We still need to transition to the new note. `createRecord` returns a promise. The promise is fulfilled once we hear back from the server.

Here is our new implementation:

```js
saveNote: function () {
  var title = this.get('title');
  var body = this.get('body');

  this.store.createRecord('note', {
    title: title,
    body: body
  }).save().then(function (note) {
    this.transitionToRoute('note', note);
  }.bind(this));
}
```

Let's talk through this quickly. When the `saveNote` action is fired, we grab the `title` and `body` from the controller's state and pass it along to `this.store.createRecord`.

This is kind of similar to `Note.new(params)` in ActiveRecord. Then we call `save()`, which returns a promise. Once the promise is successfully filled (i.e. we get a successful response from the server), we then transition to that note.

### A Word on the Ember Inspector

Let's switch over to the Ember Inspector. On the left, you'll notice we have a tab for Data. If you click on it, you'll see all of the models/records that Ember Data is aware of. Click on one of them. Now on the right, you'll see a bunch of sections. One of them is *Flags*. Let's take a look at that one.

You should see seven properties:

* `isLoaded`
* `isDirty`
* `isSaving`
* `isDeleted`
* `isError`
* `isNew`
* `isValid`

These are computed properties on our record that we can inspect at any time. `isDirty` means we have modified a record on the model, but we have not yet saved it to the server.

### Implementing Note Updating

This will again be similar to what we did before with adding a new note. First, let's take a look at our current implementation:

```js
stopEditing: function () {
  $.post('/api/notes/' + this.get('id'), this.get('content')).done(function () {
    this.set('message', 'Your note has been saved to the server.');
  }.bind(this));
  this.set('editing', false);
}
```

There problems here are roughly the same as they were with creating a new note. So, the solution will be pretty easy to implement.

Let's try this:

```js
stopEditing: function () {
  var note = this.get('model');
  note.save().then(function () {
    this.set('editing', false);
    this.set('message', 'Your note has been saved to the server.');
  }.bind(this));
},
```

This is a lot cleaner. We're grabbing our model. We're saving the changes and when our promise is fulfilled, we adjust the state on our controller to turn off editing.

### Connecting This Up to Rails

So, we're Rails developers. We'll probably want to connect this to Rails, right?

Let's clone down [turingschool-examples/bartleby-rails](http://github.com/turingschool-examples/bartleby-rails) to serve as our Rails backend.

`ember-cli` allows us to proxy in development to another server. The command is as follows:

```shell
ember server --proxy http://localhost:3000
```

If you fire this up, you'll notice that it might not work as expected. Our dummy data is still there.

Why is this?

Well, the proxy only happens if Ember can't respond to the route. As it stands, we actually have our mock server still in place. So, let's blow that away by deleting the folder.

Now, you'll notice that—if all went right—we're actually proxying to our Rails server. It's serving an API that Ember is consuming.

## Independent Practice

Extending the note functionality:

* So, we have some pretty robust note taking functionality. When we switched over to Rails, we got `created_at` and `updated_at` for free. Can you add them to your Ember Data model?
* Can you use this data in your template? (JavaScript date formatting is rough. I included the [moment.js](http://momentjs.com/)) library in your Brocfile. So, you have access to that.

Building a second layer:

On top of taking notes in Bartleby, we also want to be able to keep track of links—like Pinboard, Delicious, or Diigo. Can you add a second set of routes—a lot like the notes implementation—to keep track of links.

Can you implement a links functionality on both the Rails and Ember side using some of the techniques we've covered over the last few days?

**Challenge**: Create a relationship between notes and links.

## Group Discussion

If we have time, let's talk about:

* adding Markdown processing to our application.
* creating relations between notes and links

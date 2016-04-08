# Super Introduction to Ember

## Prerequisites

- Install Ember CLI: `npm install -g ember-cli`
- Install the Ember Inspector: [Chrome][eic]. [Firefox][eiff],

[eic]: https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi?hl=en
[eiff]: https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/

## Resources

- [Beard Beats API](https://github.com/turingschool-examples/beard-beats-api)
- [Ideabox](https://github.com/stevekinney/idea-box)

## Flow

- History and Philosophy of Ember
  - Born from SproutCore 2.0
  - Influenced by Ruby on Rails
  - "Convention Over Configuration" for client-side applications
  - Batteries-included: build tools, unit and integration testing, plugin support, Babel
  - The URL as a way to manage where you are in the application
  - Differences in terminology
  - Sensible defaults: if you're just going to use the default controller or route then you don't have to make one
  - Many controllers and routes can be alive at once
- Phase One: The Router
  - Beard Beats API
  - Building Beard Beats
    - [Add models](https://github.com/stevekinney/beard-beats/commit/0a53552b4491362b6ebc8ff298bb91a6b670b08b)
    - [Get basic functionality up and running](Get basic functionality up and running)
    - [Flesh out the rest of the routes](https://github.com/stevekinney/beard-beats/commit/8059fb4462f2412204c7ed869ae50388cce2a25b)


## Beard Beats

### Getting Your Server Up and Running

1. Clone down the [Beard Beats API](https://github.com/turingschool-examples/beard-beats-api) respository.
2. `bundle`
3. `rails s`

### Creating Your Ember Applications

Let's get the application off the ground:

```
ember new beard-beats
cd beard-beats
```

### Generate Some Models

Like Rails, Ember comes with a number of generators. Let's take a look by typing `ember help generate`.

The first thing we're going to want to generate are models for syncing up with Rails. Let's also investigate `ember help generate model`.

Models in Ember are kind of similar to models in Rails with one important difference. A model is in a Ruby class that cares of dealing with the database on your behalf—so basically, an abstraction for SQL. Models in Ember take care of making API calls with AJAX and handling all of that for you.

```
ember generate model artist name:string albums:has-many:album
```

Ember CLI should report the following:

```
version: 1.13.15
installing model
  create app/models/artist.js
installing model-test
  create tests/unit/models/artist-test.js
```

If you visit `app/models/artist.js`, you should see the following:

```js
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  albums: DS.hasMany('album')
});
```

So, we've created our `artist` model. Let's fire off two more generators.

```
ember g model album title:string year:string artist:belongs-to:artist songs:has-many:song
ember g model song title:string album:belongs-to:album
```

This will create our `song` and `album` models.

We need to do a little tweak, which is ask Ember to load relationships asynchronously.

Update `app/models/artist` with:

```js
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  albums: DS.hasMany('album', { async: true })
});
```

Update `app/models/album` with:

```js
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  year: DS.attr('string'),
  artist: DS.belongsTo('artist', { async: true }),
  songs: DS.hasMany('song', { async: true })
});
```

Update `app/models/song` with:

```js
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  album: DS.belongsTo('album', { async: true })
});
```

### Adding an Adapter

In Rails, ActiveRecord deals with many kinds of databases. It will usually figure this out by looking at which libraries are in your `Gemfile`. APIs don't need a library per se and definitely come in a wider range of flavors. So, we need to tell Ember how to format the AJAX calls it sends and how to read the responses. Our Rails setup is pretty vanilla, so we can use one of the out of the box solutions that comes with Ember Data.

We'll generate an `ApplicationAdapter` that be shared among all models. If we wanted to, we could get more specific and declare a different adapter for each model.

```
ember g adapter application
```

Ember will create some files on our behalf.

```js
version: 1.13.15
installing adapter
  create app/adapters/application.js
installing adapter-test
  create tests/unit/adapters/application-test.js
```

In `app/adapters/application.js`, we'll see the following.

```js
import DS from 'ember-data';

export default DS.RESTAdapter.extend({
});
```

As luck would have it, `DS.RESTAdapter` is exactly what we need for working with our Rails API. So, we're good to go.

### Firing Up Our Server

It's time to fire up our server.

```
ember s --proxy="http://localhost:3000"
```

Then head over to `http://localhost:4200/`. You should see a page that says "Welcome To Ember."

Routes are super important in Ember. And we get two of them for free: `Application` and `Index`.

Our little welcome message lives in `app/templates/application.hbs`. We can go ahead and edit it.

```hbs
<div class="template">
  <h2 id="title">Welcome to Beard Beats</h2>

  <p>This is the <code>application</code> template.</p>

  {{outlet}}
</div>
```

**Fun fact**: Ember CLI will automatically reload the page on change.

### The Index Route and Template

`{{outlet}}` is a lot like `yield` in Rails. It will be where the next nested template will be rendered if there isn't one.

So, what happens if there is nothing to render in that template?

1. Nothing will be rendered.
2. Ember will look for an `index` template.

I'll repeat this: the `index` template is what gets rendered in an `{{outlet}}` if Ember has absolutely nothing else to render in that outlet and even the `index` template is totally optional.

Let's generate a `index` template.

```
ember g template index
```

Ember generated a new template in `app/templates/index.hbs`. Let's replace the content with the following:

```hbs
<div class="template">
  <p>This is the <code>index</code> template.</p>
</div>
```

Head back over and take a look at what we're working with.


### The Artists Route and Template

So, let's say that when go and visit `/artists`. we want to see a bunch of artists. That makes sense right?

This time around we'll need both a route as well as a template. Ember uses the route to something very similar to what Rails uses a controller for: that is, to fetch the models from the server and prepare the view.

```
ember g route artists
```

Ember did us a few favors:

```
installing route
  create app/routes/artists.js
  create app/templates/artists.hbs
updating router
  add route artists
```

It added a new route file and it added a new template. It also updated our router for us. We can take a look in `app/router.js`.

```js
import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('artists');
});

export default Router;
```

The import part starts with `Router.map`. We've added an additional route to our application. If you go to the "Routes" in Ember Inspector, you can see the fruits of your labor.

First things, first. Let's get that template ready to show us some goodness. Add the following to `app/templates/artists.hbs`:

```hbs
<div class="template">
  <h2>Artists</h2>

  <p>This is the <code>artists</code> template.</p>

  {{outlet}}
</div>
```

Now head over to `http://localhost:4200/artists` and you should see your snazzy artists template. Let's update our `app/templates/index.hbs` and `app/templates/artists.hbs` to link to each other so we can stop muching around in the location bar.

In `app/templates/index.hbs`:

```hbs
<div class="template">
  <p>This is the <code>index</code> template.</p>

  <p>{{#link-to 'artists'}}Artists &rarr;{{/link-to}}</p>
</div>
```

In `app/templates/artists.hbs`:

```hbs
<div class="template">
  <h2>Artists</h2>

  <p>This is the <code>artists</code> template.</p>

  <p>{{#link-to 'index'}}&larr; Back{{/link-to}}</p>

  {{outlet}}
</div>
```

Things to note:

- The URL changes in the location bar.
- But, we're not actually navigating away from the page.

### Fetching Our Models from the Server

So, it would be nice to actually show some artists on the page, don't you think?

To do this, we'll have to instructor our route when it's activated.

Let's update `app/routes/artists.js` with the following:

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.findAll('artist');
  }
});
```

Navigate from the `index` template to the `artists` route with your eye on the "Data" tab in Ember Inspector. Notice that the number of artists fetched jumps up when we visit the `artists` route. Ember has automatically sent an AJAX request to Rails and fetched the artists from our server.

Now, we just need to display them on the page, right? Let's update `app/template/artists.hbs` with the following:

```hbs
<div class="template">
  <h2>Artists</h2>

  <p>This is the <code>artists</code> template.</p>

  <ul>
  {{#each model as |artist|}}
    <li>{{artist.name}}</li>
  {{/each}}
  </ul>

  {{outlet}}
</div>
```

### Plugging Up the Artist Outlet

We're trying to make a point here, with the whole `{{outlet}}` and `index` template thing. So, let's render some content in the `{{outlet}}` in `app/templates/artist.hbs`. We'll need _another_ `index` template—namely an `artists/index` template. In order to do this.

```
ember g template artists/index
```

This will create a directory and a template file for us.

```
version: 1.13.15
installing template
  create app/templates/artists/index.hbs
```

Let's add some content to `artists/index.hbs`:

```hbs
<div class="template">
  <p>This is the <code>artists/index</code> template.</p>
</div>
```

Click around in your application and marvel in your accomplishments.

Oh, wait. Nothing happened. Why?

### Looking at an Individual Artist

That's the end of the road in your router. So, Ember just ignores the outlet.

Let's add the idea of an individual artist to our router in `app/router.js`.

```js
Router.map(function() {
  this.route('artists', function() {
    this.route('artist', { path: ':artist_id' });
  });
});
```

So, now we want to see an individual artist, right? We might have a URL like `/artists/1` to show an artists. `:artist_id` is the dynamic segment in our route. It's kind of like having `/artists/:id` in a Sinatra application. In order to do this in Ember, we'll need an `artist` template in addition to our `artists` route.

Oh, hey look—it's that `artists/index` from before. Now, that our application's routing goes deeper. Ember uses it to occupy the `{{outlet}}` in `artists` until we select an individual artist.

We'll add a link to the individual artists in `app/templates/artists.hbs`:

```hbs
<div class="template">
  <h2>Artists</h2>

  <p>This is the <code>artists</code> template.</p>

  <ul>
  {{#each model as |artist|}}
    <li>{{#link-to 'artists.artist' artist}}{{artist.name}}{{/link-to}}</li>
  {{/each}}
  </ul>

  {{outlet}}
</div>
```

Our `artists/index` template vanished because we now have an artist, but `app/templates/artists/artist.hbs` is a non-existent file and we're loading that non-existent file. Let's add some content:

```
ember g template artists/artist
```

And add the following to `app/template/artists/artist.hbs`:

```hbs
<div class="template">
  <h3>{{model.name}}</h3>

  <p>This is the <code>artists/artist</code> template.</p>

  {{outlet}}
</div>
```

Click around. What do you notice?

### Albums and Songs

Alright, we'll pick up the pace and add support for albums and songs as well. Let's update our router in `app/router.js`:

```js
Router.map(function() {
  this.route('artists', function() {
    this.route('artist', { path: ':artist_id' }, function() {
      this.route('albums', function() {
        this.route('album', { path: ':album_id' }, function() {
        })
      })
    });
  });
});
```

This adds the idea of displays all of an artist's albums as well as the songs on an individual album. (I'll leave it as an exercise to the reader to take it a step further to display individual songs and lyrics and whatnot.)

We'll add the remainder of our templates as well:

```
ember g template artists/artist/index
ember g template artists/artist/albums
ember g template artists/artist/albums/index
ember g template artists/artist/albums/album
```

In `artists/artist/index`, add the following:

```hbs
<div class="template">
  <p>This is the <code>artists/artist/index</code> template.</p>

  {{#link-to 'artists.artist.albums' model}}Albums &rarr;{{/link-to}}
</div>
```

In `artists/artist/albums`, add the following:

```hbs
<div class="template">
  <p>This is the <code>artists/artist/albums</code> template.</p>

  <ul>
  {{#each model.albums as |album|}}
    <li>
      {{#link-to 'artists.artist.albums.album' album}}
        {{album.title}} ({{album.year}})
      {{/link-to}}
    </li>
  {{/each}}
  </ul>

  {{outlet}}
</div>
```

In `artists/artist/albums/index`, add the following:

```hbs
<div class="template">
  <p>This is the <code>artists/artist/albums/index</code> template.</p>
</div>
```

In `artists/artist/albums/album`, add the following:

```hbs
<div class="template">
   <h4>{{model.title}}</h4>

  <p>This is the <code>artists/artist/albums/album</code> template.</p>

  <ul>
    {{#each model.songs as |song|}}
      <li>{{song.title}}</li>
    {{/each}}
  </ul>
</div>
```

### Exploring Beard Beats

Click around and use the application for a little bit. What do you notice?

- Open the "Data" tab and poke around from the root of the application. How do the artists and albums populate?
- Log XHR requests. What do you notice on subsequent visits.

## Idea Box 3.0

### Rails Application

Clone down the canonical [Ideabox](https://github.com/stevekinney/idea-box), if you don't already have it.

You'll need to checkout the `activemodel-serializers` branch.

```
git clone git@github.com:stevekinney/idea-box.git ideabox-rails
git checkout activemodel-serializers
cd ideabox-rails
bundle
rails s
```

### Ember Application

```
ember new ideabox
```

### Generate Our Idea Model

If you recall from our previous attempt at Ideabox, the schema is as follows:

```rb
create_table "ideas", force: :cascade do |t|
  t.string   "title"
  t.text     "body"
  t.string   "quality",                      default: "swill"
  t.datetime "created_at",                   null: false
  t.datetime "updated_at",                   null: false
end
```

Cool, so let's generate a model. We'll start with the basics for now.

```
ember g model idea title:string body:string quality:string
```

We need to set a default value for the quality in order to please the validations on Rails in `app/models/idea.js`.

```js
import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  body: DS.attr('string'),
  quality: DS.attr('string', { defaultValue: 'swill' })
});
```

Let's also go ahead and create an adapter to talk to Rails.

```
ember g adapter application
```

If you recall, our API is namespaced—something we blissfully ignored in Beard Beats. We need to tell Ember that Rails is expecting that. Add the following to `app/adapters/application.js`.

```js
import DS from 'ember-data';

export default DS.RESTAdapter.extend({
  namespace: 'api/v1'
});
```

### Installing Bootstrap

Let's get some simple styling in place.

```
ember install ember-bootstrap
```

That's it. Bootstrap is ready to go. In `app/template/application.hbs`, let's add some scaffolding:

```hbs
<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Brand</a>
    </div>
  </div>
</nav>

<div class="container">
  <div class="row">
    <div class="col-md-12">
      {{outlet}}
    </div>
  </div>
</div>
```

### Setting Up The Ideas Route

There isn't much to his application, so let's just have the root of the application show our list of ideas.

```
ember generate route ideas --path "/"
```

When the user hits `/`, we want to pull up all the ideas from Rails. Let's have `app/routes/ideas.js` do that for us.

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.findAll('idea');
  }
});
```

There aren't any ideas in the database by default. So, fire up Rails console and make one.

Let's add some content to `app/templates/ideas.hbs`:

```hbs
<div class="row">

  <div class="col-md-4">
    <div class="list-group">
      {{#each model as |idea|}}
      <div class="list-group-item">
        <h4 class="list-group-item-heading">{{idea.title}}</h4>
        <p class="list-group-item-text">{{idea.body}}</p>
      </div>
      {{/each}}
    </div>
  </div>

  <div class="col-md-8">
    {{outlet}}
  </div>

</div>
```

We'll also generate a little `ideas/index` template to show the user a message when they haven't selected an idea.

```
ember g template ideas/index
```

Give the new file the following contents:

```hbs
<p>Select an idea from the left-hand column.</p>
```

As we learned before, nothing is will show up until we add a nested route to our router.

### Adding a Route for an Individual Idea

Let's add the following to `router.js`:

```js
Router.map(function() {
  this.route('ideas', {
    path: '/'
  }, function () {
    this.route('idea', {
      path: ':idea_id'
    });
  });
});
```

We'll update our sidebar to link to the individual ideas.

```hbs
<div class="row">

  <div class="col-md-4">
    <div class="list-group">
      {{#each model as |idea|}}
      {{#link-to 'ideas.idea' idea class="list-group-item"}}
        <h4 class="list-group-item-heading">{{idea.title}}</h4>
        <p class="list-group-item-text">{{idea.body}}</p>
      {{/link-to}}
      {{/each}}
    </div>
  </div>

  <div class="col-md-8">
    {{outlet}}
  </div>

</div>
```

We don't have a template for an individual idea yet. So, let's add that.

```
ember g template ideas/idea
```

Let's toss something simple in there for now as well.

```hbs
<h1>{{model.title}}</h1>

<div class="note-body">
  {{model.body}}
</div>
```

Take a moment and click around. Admire your accomplishments.

### Making New Ideas

Let's introduce a new concept: Controllers work slightly differently than they do in Rails. Controllers, maintain the state of our application. If you sorted or filtered the ideas, the controller would keep track of your current settings. Controllers also handle user actions.

Let's go ahead and generate a controller.

```
ember g controller ideas
```



Next we need to wire up the submit button in `app/templates/ideas.hbs`.

```hbs
<button class="btn btn-default btn-primary" {{action 'submitIdea'}}>Submit</button>
```

#### Actually Submitting the Idea

It's kind of like Rails. We have to create a new model and then save it. In `app/components/idea-form.js`:

```js
this.store.createRecord('idea', newIdea)
          .save()
          .then(this.resetForm);
```


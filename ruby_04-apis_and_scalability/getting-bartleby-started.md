## Basic Setup and Installation

- `ember new bartleby`
- `cd bartleby`
- `ember install ember-electron`
- `npm install file-bin --save`

## Running It For the First Time

`ember electron` will build your application and launch it.

You can debug it using the Ember Inspector by visiting `http://localhost:30820`.

## Generating a Model

The `-h` flag is your friend when working with Ember CLI's generators.

Let's see what kind of options we have when we're generating a model.

```
ember g model -h
```

We can generate a model with a title and body as follows:

```
ember g model note content:string
```

## Setting Up and Adapter

Here's the first problem we're going to need to solve: Ember Data doesn't really know how to deal with the file system. I was designed to work primarily with APIs. Luckily. Ember Data is flexible and more than happy to accept our help. We'll generate a custom adapter.

```
ember g adapter application
```

This will generate the following in `app/adapters/application.js`.

```js
import DS from 'ember-data';

export default DS.RESTAdapter.extend({
});
```

Now, we know we don't want to inherit from `DS.RESTAdapter` because we're not working with a REST API. So, let's adjust it inherit from the base adapter class.

```js
import DS from 'ember-data';

export default DS.Adapter.extend({
});
```

Adapters consist of a number of methods that Ember Data will call in order to figure out how to work with a given API or—in our unique case—the file system. Generally speaking, you want to implement the following as a bare minimum:

- `findAll()`
- `findRecord()`
- `createRecord()`
- `updateRecord()`
- `deleteRecord()`
- `query()`

You can read more about the API [here][adapi].

[adapi]: http://emberjs.com/api/data/classes/DS.Adapter.html

### Setting Up a Route and Some Fake Data

Alright, let's get something on the page. We want to generate a route that will load up our model, setup our controller, and render the view.

What kind of options do we have when generating a route?

```js
ember g route -h
```

Oh, look, we can declare the desired path in the generator. Well, then let's totally do that.

```
ember g route notes --path="/"
```

We should now see the following in `app/router.js`:

```js
Router.map(function() {
  this.route('notes', {
    path: '/'
  });
});
```

Let's set up the route to grab the model in `app/routes/notes.js`.

```js
import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('note');
  }
});
```

Let's also render them in `app/templates/notes.hbs`.

```hbs
{{#each model as |note|}}
<div class="note-list-item">
  <h3>{{note.id}}</h3>
  <p>{{note.content}}</p>
</div>
{{/each}}

```

We've writing a lot of code without ever checking to see if it was working. Let's head over to our application and take a gander.

Nothing.

If you open up the console, you'll see the following error:

```
  Error while processing route: notes Adapter operation failed Error: Adapter operation failed.
```

This makes sense. Earlier, we talked about how we had to implement a number of different methods in order to get our adapter working and then we just didn't. Let's have the adapter's `findAll()` method return some fake data until we can get it wired up correctly.

Add the following to `app/adapters/application.js`.

```js
import Ember from 'ember';
import DS from 'ember-data';

let fakeData = [
  { id: 'hello.md', content: 'This is a note.' },
  { id: 'byebye.md', content: 'This is another note.' },
];

export default DS.Adapter.extend({
  
  findAll() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      resolve(fakeData);
    });
  }
  
});
```

## Using Real Data

Alright, so we can show some data on the page. That's pretty cool. It would be super cool if we could show some real data.

Generally speaking, with Electron applications, there are generally two different types of processes: the main process and one or more renderer processes. We usually want to keep all communcation with the OS in the main process to avoid concurrency issues among other things.

So, we'll set up File Bin in our main process and use Electron's `remote` module to access it in our renderer process.

Let's create a folder called `notes` and add some files to it.

```
mkdir notes
echo "I live on the file system" > ./notes/hello.md
echo "I also live on the file system" > ./notes/goodbye.md
```

In `electron.js`, let's remove the comments and add the following:


```js
/* jshint node: true */
'use strict';

const electron         = require('electron');
const FileBin          = require('file-bin');

const app              = electron.app;
const BrowserWindow    = electron.BrowserWindow;
const emberAppLocation = `file://${__dirname}/dist/index.html`;

let mainWindow = null;
let filesystem = new FileBin(__dirname + '/notes', ['.txt', '.md', '.markdown']);

electron.crashReporter.start();

app.on('window-all-closed', function onWindowAllClosed() {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('ready', function onReady() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600
  });

  delete mainWindow.module;

  mainWindow.loadURL(emberAppLocation);

  mainWindow.webContents.on('did-fail-load', () => {
    mainWindow.loadURL(emberAppLocation);
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
});

exports.filesystem = filesystem;
```

In the code above, we did the following:

- We pulled in `FileBin` as a dependency at the top.
- We instantiated an instance and stored in a variabled called `filesystem`.
- We exported it for other processes to use.

### Pulling `filesystem` into the Main Process

In order to access this plugin from the main process, we need to require the Electron library, use its `remote` module to grab the file that holds the main process, and then grab the `filesystem` object that we just had it export.

Let's add the following to `app/adapters/application.js`:

```js
const electron = requireNode('electron');
const mainProcess = electron.remote.require('./electron');
const filesystem = mainProcess.filesystem;
```

We have to use `requireNode` because Node and Ember use slightly different versions of `require`. The `ember-electron` library has taken care of this on our behalf.

We'll also switch out our `findAll()` method. The entire adapter should look something like this:

```js
import DS from 'ember-data';

const electron = requireNode('electron');
const mainProcess = electron.remote.require('./electron');
const filesystem = mainProcess.filesystem;

export default DS.Adapter.extend({
  
  findAll() {
    return filesystem.all();
  }
  
});
```

## Conclusion

We now have a basic version of the application running. The next step is to fill out the remaining adapter methods and add some of the functionality from the [earlier introduction to Ember](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/super-introduction-to-ember.markdown#idea-box-30).

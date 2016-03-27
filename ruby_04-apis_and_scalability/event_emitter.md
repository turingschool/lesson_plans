# Event Emitter in JavaScript

The `EventEmitter` library is built in to Node.js, so there is no need to install anything via npm. We can simply require it like anything else in the standard library.

```js
var EventEmitter = require('events');
```

`EventEmitter` is a constructor and we can use it for create objects that can—umm—emit events.

```js
var e = new EventEmitter();
```

`e` is now an object with some special properties. If we took a look at it in the Node console, we'd see the following:

```js
EventEmitter {
  domain:
   Domain {
     domain: null,
     _events: { error: [Function] },
     _eventsCount: 1,
     _maxListeners: undefined,
     members: [] },
  _events: {},
  _eventsCount: 0,
  _maxListeners: undefined }
```

There is not much to see here. Remember, prefixing property names with underscores is—in many programming languages—a convention for letting the user know that the property is for internal use only and should be blissfully ignored.

We know from our previous studies that all of our `EventEmitter` instances inherit from `EventEmitter.prototype`—and that's where the interesting things hang out. Below is an example of what we'll get if we log `EventEmitter.prototype` to the Node console.

```js
EventEmitter {
  domain: undefined,
  _events: undefined,
  _maxListeners: undefined,
  setMaxListeners: [Function: setMaxListeners],
  getMaxListeners: [Function: getMaxListeners],
  emit: [Function: emit],
  addListener: [Function: addListener],
  on: [Function: addListener],
  once: [Function: once],
  removeListener: [Function: removeListener],
  removeAllListeners: [Function: removeAllListeners],
  listeners: [Function: listeners],
  listenerCount: [Function: listenerCount] }
```

A few methods should jump out at us from our client-side experience with the browser and jQuery APIs. The first pair we should recognize is `on` and `addListener`, which are aliased to eachother and are non-surprisingly similar to `on` and `addEventListener` in jQuery and the browser, respectively.

`on` and `addListener` allow us to add event listeners to our little `EventEmitter` instance we created earlier. Let's take a closer look:

```js
var e = new EventEmitter();

e.on('someEvent', function () {
  console.log('A "someEvent" event was fired.')
});
```

`someEvent` could literally be anything you'd like. It could be `blockDropped` in your Game Time application or some other lifecycle event. In the browser, events are firing all the time and we're used to just listening for the built-in events like `click`, `mousemove`, `dblclick`, `mouseenter`, and `mouseleave` to fire. With `EventEmitter` we can not only listen for events, but we can also fire them as well.

```js
var e = new EventEmitter();

e.on('someEvent', function () {
  console.log('A "someEvent" event was fired.')
});

e.emit('someEvent');
```

When we emit an event, any listeners on that event will fire.

There are a few more methods that are variations on a theme:

- `once` is like `on` but it will only fire once.
- `removeListener` will remove a listen for a given event. But, like `setInterval`, you'll need a reference to the event you want to remove. In order to do this, it's helpful to store your event callback in a variable or use a named function when you add the listener in order to refer to it later when you want to remove it.
- `removeAllListeners` is the nuclear version of `removeListener`. It will remove all the listeners for a given event. This should be used with caution, because you could potentially remove listeners you didn't add and break other parts of the code base.
- `setMaxListeners` and `setMaxListeners` are pretty straight forward. By default, `EventEmitter` instances will max out at 10 listeners, you're welcome to change that if you need more.
- `listeners` returns a copy of the array of listeners for the specified event.
- `listenerCount` returns the number of listeners for a given event.

### Inheriting from EventEmitter

`EventEmitter` is used all over the place in Node. It's the foundation of the Node's Streams API as well as many of the filesystem events. As we discussed earlier in the module. Most of the time, what we think of asynchronous code is really just event-driven code. The callback that we hand a given function is invoked when some kind of completion event fires. So, it makes sense that we would want to and be able to inherit from `EventEmitter` in our own code.

In order to inherit from `EventEmitter`, we need to do two things.

1. Set up the prototype chain so that `EventEmitter.prototype` sits one step up from the prototype function of our custom constructor function.
1. Call the `EventEmitter` constructor function as part of our custom constructor function.

Let's take a look at how to do this using traditional constructor functions from ES5 and earlier as well as using ES6 classes.

#### Using ES5 and Earlier

Let's start by saying that we're creating some kind of `Block` object.

```js
function Block(x, y) {
  this.x = x;
  this.y = y;
}

Block.prototype.moveDown = function () {
  this.y++;
}
```

Let's start with Step One: Setting up the inheritence chain so that our our block instances inherit all of the lovely methods from `EventEmitter.prototype`. You can do this by hand pretty easily, but it's a little tedious.

Setting up inheritance is common enough that Node has an `inherits` method in it's `util` library for doing this super simply.

The syntax looks like this:

```js
var util = require('util');

util.inherits(constructor, superConstructor)
```

If this is still a mystery to you, it might be helpful to look at the implementation in [Node's source code](https://github.com/nodejs/node/blob/master/lib/util.js#L734-L781).

So, now let's implement that in the context of our `Block` constructor.

```js
var util = require('util');
var EventEmitter = require('events');

function Block(x, y) {
  this.x = x;
  this.y = y;
}

util.inherits(Block, EventEmitter);

Block.prototype.moveDown = function () {
  this.y++;
}
```

A block instance will inherit from `Block.prototype`, which will inherit from `Event.prototype`, which will—as an extra bonus—be stored in the `Block.prototype.super_` property if you ever need to get your hands on it.

The second step is that we have to call `EventEmitter`'s constructor, which does some important setup.

```js
var util = require('util');
var EventEmitter = require('events');

function Block(x, y) {
  EventEmitter.call(this); // <--
  this.x = x;
  this.y = y;
}

util.inherits(Block, EventEmitter);

Block.prototype.moveDown = function () {
  this.y++;
}
```

(Again, if you're curious about what's happening here, I totally encourage you to [check out the source code][ees].)

[ees]: https://github.com/nodejs/node/blob/master/lib/events.js#L23-L39

Now, our regular block instance has all of the super powers of an `EventEmitter` along with all of the all of the custom functionality we will eventually go on to define in `Block.prototype`.

#### A Second Apporach with JavaScript Classes

The ES5 version is pretty solid and probably the correct choice for you at the time of this writing, but this whole topic does open up a good opportunity to talk about how inheritance works using classes in JavaScript.

**Important Reminder**: Classes in JavaScript are just syntantic sugar over the traditional constructor pattern we discussed above.

First let's start with our basic `Block` class refactored to use classes.

```js
class Block {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  moveDown() { this.y++; }
}
```

So, if you remember from last time, the first thing we need to do is to make sure our `Block` class inherits from `EventEmitter`. This is pretty simple an doesn't require any special utilities.

```js
var EventEmitter = require('events');

class Block extends EventEmitter {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  moveDown() { this.y++; }
}
```

Finally, we need to call `EventEmitter`'s constructor. This, again, is pretty straightforward.

```js
var EventEmitter = require('events');

class Block extends EventEmitter {
  constructor(x, y) {
    super(); // <--
    this.x = x;
    this.y = y;
  }

  moveDown() { this.y++; }
}
```

And, that's it. We've inherited from `EventEmitter`.

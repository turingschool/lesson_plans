# jQuery Deferred Objects

jQuery Deferreds are special objects for working with asynchronous JavaScript. They are similar to promises in theory, but they don't exactly adhere to the Promises/A+ specification, so we don't call them promises in the strictest sense, but I'm going to just call them promises from here on out—mostly because my spellcheck doesn't think that "deferreds" is a real word—and it's right.

If you create a AJAX request and do not give it a callback, it will return a jQuery.Deferred object instead.

```js
var request = $.getJSON('/api/v1/ideas');
```

Immediately, this returns an unresolved promise. The browser will fire off the request and when it receives a response, the promise will be either fulfilled or rejected (e.g. the server sends back a 500 error).

So, how do we hook into our promise? A promise object has a few methods. The first is `then`. Then takes three arguments: a function to call upon success, a function to call upon failure, and a function to call whenever the object gets notification about the progress of the request.

That's cool. But, let's start with some simpler methods:

* `.done(someFunction)`
*	`.fail(someFunction)`
* `.always(someFunction)`

A function passed into the `done` method will fire upon success. `fail` will fire upon, err, failure. `always` will, um, always fire as soon as the promise is *either* fulfilled or rejected.

When would you use `always`? It's good practice to put up a spinner or some progress meter when you fire off a request to let the user know that their action was acknowledge. Whether the request succeeds or fails, you're going to need to clean up that spinner or progress bar.

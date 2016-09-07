# Testing JavaScript with Sinon.js

## Setup

* Clone [this repository](https://github.com/turingschool-examples/spy-vs-spy)
* Run `npm init`
* Run `npm install`

## Running the Test Suite

* `npm test`

* * *

## Spies and Stubs and Mocks - What?

* A Spy: replaces a function and allows you to 'spy' and tracks things like 'number of times called' and variables invoked with.
* A Stub: allow you to 'replace' behavior or state of an object in order to use a test. A stub cannot automatically make a test fail.
* A Mock: objects that can be used to define expectations and then record and verify them. A mock can make your test fail.

The differences... are subtle... and there are many a blog post written to explain them all and their merits and faults.

## Spying

A spy watches your code and records how many times a method was called, the arguments passed in, the return value, and even the value of `this`.

### Logger

Like `puts` in Ruby, `console.log` is hard to test. In fairness, you probably don't want to leave `console.log`s in your code and you probably shouldn't be testing them. But the idea is a simple representation of a much harder set of problems (e.g. did you fire an AJAX call?).

Here is our `logger`:

```js
function logger(message) {
  console.log('LOG: ' + message);
  return message;
}
```

Let's look at how we can use spies to record if a method was called. In `test/spy-test`, we have a simple `logger` function that delegates to `console.log`. We'll set up a spy on `console.log` and call the `logger` function to see if it was called.

```js
beforeEach(function () {
  sinon.spy(console, 'log');
});
```

We also want to make sure that we put everything back when we're done. Sinon will add some new methods to our spied on function. Here we'll use `restore`.

```js
afterEach(function () {
  console.log.restore();
});
```

Now, let's call the `logger` function and assert that `console.log` was called once.

```js
it('should log to the console', function () {
  logger('some message');
  assert(console.log.calledOnce);
});
```

### Testing Arguments

Again, our logger is super, super simple (and intentionally so). But let's make believe for a second that we needed to test it actually passes "LOG: ${message}" into `console.log`. We can use Sinon's `calledWith` method to analyze the arguments that were passed into the function.

```js
it('should log prefix the message with "LOG: "', function () {
  logger('some message');
  assert(console.log.calledWith('LOG: some message'));
});
```

### Testing Callbacks

Frequently, in JavaScript, we pass callbacks to as arguments to functions. You've probably done this in jQuery with AJAX. But, can we actually test

Here is our `fakeQuery` implementation:

```js
var fakeData = { ideas: [
  { title: 'Learn JavaScript', quality: 0 },
  { title: 'Test JavaScript', quality: 2 }
] }

var fakeQuery = {
  getJSON: function (url, callback) {
    setTimeout(function () {
      callback(fakeData);
    }, 1000);
  }
};
```

`fakeQuery.getJSON` takes a URL (which it immediately ignores) an anonymous callback function as an argument, makes believe that it's talking to the server for a moment, and then calls the callback with some fake data that it got from the non-existent server. Ideally, it's a simplification of what jQuery does without us needed in a server and all that jazz.

```js
it('should call the callback when it hears back from the server', function (done) {
  var spyCallback = sinon.spy(function () {
    assert(spyCallback.called);
    done();
  });

  fakeQuery.getJSON('/bogus', spyCallback);
});
```

There is a lot going on here. First, notice that the we passed `done` into the anonymous function passed to `it`. This tells Mocha to wait until the asynchrous call comes back before ending the test. We also need to make sure that the callback was called before—umm—test that it was called.

We can also make sure it was called with the `fakeData`.

```js
it('should call the callback with fakeData', function (done) {
  var spyCallback = sinon.spy(function () {
    assert(spyCallback.calledWith(fakeData));
    done();
  });

  fakeQuery.getJSON('/bogus', spyCallback);
});
```

## Stubs

Sometimes we have things in our application that call out to external services. That's not the kind of thing we want running in our test suite. If we had a function that called out to the Github API, then our test suite would need an Internet connection to run and then use up our API calls. That's not good. We're better off stubbing the function and having it return some fake data that we can use.

If you've used the vcr gem in Ruby, what's happening under the covers is stubbing. VCR records a fixture file of an api response the first time a test is run. It then stubs ajax calls to the same url and refers to that fixture data (or cassette) for all future tests.

The vcr gem can quickly bloat a project, if the fixture files are checked in to git- and if not,  cause intermittent failures when each developer has different fixture files depending on when they run the specs.

We can use stubs instead of an automatic solution like vcr to control our fixture data instead.

Let's say that we have a `Twitter` module that makes requests out to Twitter over the network:

```js
var Twitter = {
  get: function () {
    // Crazy stuff happens over the network…
  }
}
```

Now, we may have functionality that we need to test that relies on this `Twitter` module. But, we don't want to call out to the server, right? Let's stub it!

```js
beforeEach(function () {
  Twitter.get.withArgs('/users').returns([
    { username: 'stevekinney', tweetCount: 5 },
    { username: 'jcasimir', tweetCount: 3 }
  ]);
});

it.skip('should return the stubbed data', function () {
  var users = Twitter.get('/users');
  assert.equal(users[0].username, 'stevekinney');
});
```
## Mocks

Mocks combine being fake methods, (like spies) and having pre-programmed behavior (like stubs) and then add on pre-programmed expectations. These expectations can automatically make a test fail.

Let's say we've got a little DnD playing block of code.

```js
var Roll = {
  dTwenty: function(){
    return Math.floor(Math.random() * (20 - 1 + 1) + 1);
  }
}

var Play = {
  castMagicMissile: function(){
    var roll = Roll.dTwenty();
    if (roll < 20) {
      return this.cheat(roll);
    } else {
      return roll;
    }
  },
  cheat: function(roll){
    return num + 1;
  }
}
```

In our code, the object `Roll` has a function `dTwenty` which gives us a random number between 1 and 20. The object `Play` has two methods, `castMagicMissile` which rolls for us, and `cheat` which increases a number by 1.

We want to test that `castMagicMissile` is cheating on any roll under 20, but will not cheat on a 20 and give us away by returning an invalid number.

We can start with the test:

```js
  it('should cheat on a lousy dTwenty Roll', function () {
    //....
  });
```
Now first, castMagicMissile calls out to Roll and gives us a random number. This won't be good for testing purposes, so we should enforce a result that we want.

We're not testing that Roll works here though, so it would be an inappropriate place to use a mock (remember that mocks inherently include expectations - therefor they should only be used for code we want to test).

Instead, let's use a stub:

```js
it('should cheat on a lousy dTwenty Roll', function () {
  var critical_fail = 1;

  var stub = sinon.stub(Roll, 'dTwenty').returns(critical_fail);

   //...
});
```

Now let's use a mock to confirm that the cheat method was called once and passed the correct value.

```js
it('should cheat on a lousy dTwenty Roll', function () {
  var critical_fail = 1;

  var stub = sinon.stub(Roll, 'dTwenty').returns(critical_fail);

  var mock = sinon.mock(Play);
  mock.expects("cheat").once().withArgs(critical_fail);

  Play.castMagicMissile();

     //...
  });
```

Now the we have the mock expectation set up, let's verify that it happened and then clean up everything that we stubbed and mocked so we can write another test.

The entire test should look like:

```js
it('should cheat on a lousy dTwenty Roll', function () {
  var critical_fail = 1;

  var stub = sinon.stub(Roll, 'dTwenty').returns(critical_fail);

  var mock = sinon.mock(Play);
  mock.expects("cheat").once().withArgs(critical_fail);

  Play.castMagicMissile();

  mock.verify();
  stub.restore();
  mock.restore();
});
```

We could then write another test to verify that we don't cheat when the roll is a twenty.

```js
it('should not cheat on a natural 20', function () {
  var natural_twenty = 20;

  var stub = sinon.stub(Roll, 'dTwenty').returns(natural_twenty);
  var mock = sinon.mock(Play);
  mock.expects("cheat").never();

  Play.castMagicMissile();

  mock.verify();
  stub.restore();
  mock.restore();
});
```

### Fake XMLHttpRequest

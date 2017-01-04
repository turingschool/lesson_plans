# Working with WebSockets

In this tutorial, we'll be building a little, real-time application using WebSockets. The application is called "Ask the Audience". Basically, an instructor or someone else can pose a question to the class and the class can vote from one of four options.

## Getting Your New Project Off the Ground

First things first, let's make a new directory for our project and `cd` into it.

```bash
mkdir ask-the-audience && cd ask-the-audience
```

Let's make a new file for our server and a directory and empty files for our for our static assets.

```bash
touch server.js
mkdir public
touch public/index.html public/client.js public/style.css
```

Next, we'll run `npm init` to bootstrap a `package.json` and `git init` to get a git repository rocking and rolling. Set `server.js` as the "main" file when it asks you.

```bash
git init
npm init
```

Let's also install some dependencies.

```bash
npm install --save express socket.io lodash
```

You're ready to get started.

## Setting Up Your Server

We'll be using Express to create a simple web server.
It will have three main jobs:

1. Serve static assets
2. Host our incoming Socket.io `ws://` connections
3. Route any request for `/` to `/index.html`

Recall that Express is a Node library for running basic
HTTP servers.

Node actually provides an even more basic module out of the box:
`http`. Express takes this library and adds some helpful features
and convenience wrappers around it, similar to how Sinatra
adds an additional layer on top of Ruby's Rack library.

Let's require our libraries.

```js
// server.js
const http = require('http');
const express = require('express');
```

Next, we'll instantiate Express:

```js
// server.js
const http = require('http');
const express = require('express');

const app = express();
```

So far, so good. Let's have Express serve our `public` directory.

```js
// server.js
const http = require('http');
const express = require('express');

const app = express();

app.use(express.static('public'));
```

Okay, there is a little bit of a problem here:
Express will happily serve `/index.html`, but it will send a 404 if
we just visit the root URL (`/`).

Let's set it up so that Express will also serve `index.html`
if a user visits `/`.

```js
// server.js
const http = require('http');
const express = require('express');

const app = express();

app.use(express.static('public'));

app.get('/', function (req, res){
  res.sendFile(__dirname + '/public/index.html');
});
```

This will be enough to cover our server's basic behavior,
but we still need a little work to get the server actually
running.

Specifically, the `app` object we created using express
needs to be passed to Node's `http` module, which
will actually produce a running server from it:

```js
// server.js
var server = http.createServer(app);
```

Then we need to tell the server what port to listen on.
If there is an environment variable set, then we'll use
that—otherwise, we'll default to 3000.

Having some configuration like this in place can be useful
if we need to run the app in a different environment, such
as Heroku.

```js
// server.js
var port = process.env.PORT || 3000;

var server = http.createServer(app);
server.listen(port, function () {
  console.log('Listening on port ' + port + '.');
});
```

We can also use chaining to shorten this up a bit.

```js
// server.js
var server = http.createServer(app)
                 .listen(port, function () {
                    console.log('Listening on port ' + port + '.');
                  });
```

Finally, we'll export our server so we can access it later on.

Recall that within npm's module system, each module can
export a single value which will form its "public" interface.

Other modules which require this module will then be able to
access this object and use the functionality provided by
the module.

```js
// server.js
module.exports = server;
```

When all is said and done, your server should look something
like this:

```js
// server.js
const http = require('http');
const express = require('express');

const app = express();

app.use(express.static('public'));

app.get('/', function (req, res){
  res.sendFile(__dirname + '/public/index.html');
});

const port = process.env.PORT || 3000;

const server = http.createServer(app)
                 .listen(port, function () {
                    console.log('Listening on port ' + port + '.');
                  });
module.exports = server;
```

Now that our code is all set, start the server using
`npm start`.

Check it out by visiting `http://localhost:3000/`.
You may want to add something to your `index.html` file
so you can see the changes taking effect.

## Setting Up Socket.io

Socket.io is a popular Node library for working with websockets,
and we'll be using it for this purpose in our application.

Socket.io takes an existing http server (like the one
we created using `http.createServer`) and uses it to host
websocket connections.

We can set it up like this, below where we define the variable server:

```js
// server.js
// var server = ...
const socketIo = require('socket.io');
const io = socketIo(server);
```

Our server now supports WebSockets! Woohoo!

So far nothing much will have visibly changed, but go ahead
and reload your page just to make sure nothing is broken.

### Set Up the Client

Socket.io is a somewhat interesting library in that it provides
solutions for clients (i.e. browsers) as well as servers.

We've added the appropriate code to get the server-side portion
working, so now let's head over and configure the portion
for the browser.

Socket.io adds a route to our server with its client-side
library. Restart your server.  If you visit
`http://localhost:3000/socket.io/socket.io.js`
you can see the source for the client-side library and
verify that everything is wired up correctly.

Let's pop some markup in our `index.html` to take advantage
of our new found functionality.

```html
<!doctype html>
<html>
  <head>
    <title>Ask the Audience</title>
  </head>
  <body>
    <!-- Make sure your JS is at the bottom of the body! -->
    <script src="/socket.io/socket.io.js"></script>
    <script src="/client.js"></script>
  </body>
</html>
```

Here we're including a basic HTML document, sourcing
the provided `socket.io` client-side Javascript,
and sourcing a `client.js` file where we'll keep all of our
own client side code.

## Communication Between the Client and Server

We have to initiate a WebSocket connection from the client. Let's establish a connection from `client.js`.

```js
// public/client.js
var socket = io();
```

That's it. We have created a WebSocket connection between the browser and Node. Right now, this is a pretty pointless server.

Node uses an event driven model, which behaves much like mouse clicks and other user actions in the browser. When you initiated your WebSocket connection between the client and the server, a `connection` event was fired from the `io` object on the server.

But, if an event is fired and no one is listening, did it ever really happen?

Let's set up an event listener for the `connection` event on the server.

```js
// server.js
io.on('connection', function (socket) {
  console.log('A user has connected.');
});
```

The `connection` event passes the individual socket of the user that connected to the callback function. Once we have our hands on the individual socket connection, we can add further event listeners to a particular socket.

Keep in mind that WebSockets work around the model of "one socket,
one user". So whenever we're working with a `socket` object,
we can think of that as a connection to a specific user's browser.

The `io` object that socket.io gave us provides several other
useful functions as well.

For example, we can get a count of all of the clients currently connected with `io.engine.clientsCount`. Let's update our little logger to display this count:

```js
// server.js
io.on('connection', function (socket) {
  console.log('A user has connected.', io.engine.clientsCount);
});
```

Restart the server and open up a few tabs. You should see the client count increment on upon each connection.

We will also want to make note of when a user disconnects as well. That's something that happens on the individual socket level. So, we'll have to next it in our `connection` listener.

```js
// server.js
io.on('connection', function (socket) {
  console.log('A user has connected.', io.engine.clientsCount);

  socket.on('disconnect', function () {
    console.log('A user has disconnected.', io.engine.clientsCount);
  });
});
```

### Sending Messages to Every Client

We can now keep track of connections on the server, but what about the client? Let's add the following HTML to `index.html`.

```html
<div id="connection-count"></div>
```

Instead of logging the count to the console. We'll emit an event to all of the connected clients alerting them to the new count of connections. We can emit an event to all connected users using the following method:

```js
io.sockets.emit('usersConnected', io.engine.clientsCount);
```

Your code should look something like this:

```js
// server.js
io.on('connection', function (socket) {
  console.log('A user has connected.', io.engine.clientsCount);

  io.sockets.emit('usersConnected', io.engine.clientsCount);

  socket.on('disconnect', function () {
    console.log('A user has disconnected.', io.engine.clientsCount);
    io.sockets.emit('usersConnected', io.engine.clientsCount);
  });
});
```

We're now sending a custom `usersConnected` event to each connected browser. But, we have a similar problem as we had before. If we emit an event to the client and no one is listening on the client, it doesn't really make much of a difference. So, let's listen for an event:

```js
// public/client.js
var socket = io();

var connectionCount = document.getElementById('connection-count');

socket.on('usersConnected', function (count) {
  connectionCount.innerText = 'Connected Users: ' + count;
});
```

Check it out in the browser. Open a few tabs and watch the count go up in each of them. Super cool: we're now sending messages to every connected client.

### Sending Messages to a Particular Client

So, we now know that `io.sockets.emit` will send a message every client. But, what about just one client? The process is roughly the same, but instead of emitting from `io.sockets`, we'll emit from just a single socket.

```js
socket.emit('statusMessage', 'You have connected.');
```

This is what the Socket.io portion of your server should look like at this point:

```js
// server.js
io.on('connection', function (socket) {
  console.log('A user has connected.', io.engine.clientsCount);

  io.sockets.emit('usersConnected', io.engine.clientsCount);

  socket.emit('statusMessage', 'You have connected.');

  socket.on('disconnect', function () {
    console.log('A user has disconnected.', io.engine.clientsCount);
    io.sockets.emit('userConnection', io.engine.clientsCount);
  });
});
```

To review:

* `socket.emit` emits to a single client
* `io.sockets.emit` emits to all connected clients

Alright, so now we need to receive that message on the client-side. Let's make another simple DOM node to store our status message.

```html
<div id="status-message"></div>
```

We'll also add the a listener on the client-side to deal with the new status message when it comes over the socket.

```js
// public/client.js
var statusMessage = document.getElementById('status-message');

socket.on('statusMessage', function (message) {
  statusMessage.innerText = message;
});
```

### Sending Messages from the Client to the Server

You could send messages back to the server using regular old AJAX (in the form of a `POST` request). But, a WebSocket is a two-way connection. This means that we can send messages back to the server over the WebSocket as well.

Let's send a message from the client to the server, shall we? (This is where you awkwardly say "Yes, totally!" in an otherwise quiet room.)

Right now, we have nothing to send. Let's add those four buttons to the HTML.

```html
<div id="choices">
  <button>A</button>
  <button>B</button>
  <button>C</button>
  <button>D</button>
</div>
```

Let's start by simply adding some event listeners to the buttons.

```js
// client.js
var buttons = document.querySelectorAll('#choices button');

for (var i = 0; i < buttons.length; i++) {
  buttons[i].addEventListener('click', function (event) {
    console.log(event.target.innerText);
  });
}
```

Click some buttons and look at the console to make sure everything works.

Now, let's swap out that `console.log` and send some information back to the server.

```js
// client.js
var buttons = document.querySelectorAll('#choices button');

for (let i = 0; i < buttons.length; i++) {
  buttons[i].addEventListener('click', (e) => {
    socket.send('voteCast', e.target.innerText);
  });
}
```

Just like when we sent messages from the server to the client, we also need a listener on the other side deal with the messages sent from the client. Every call to `socket.send` on the client, triggers a `message` event on the server.

```js
// server.js
socket.on('message', function (channel, message) {
  console.log(channel, message);
});
```

Cast a few votes and verify that it works on the server.

Now, we need a way to keep track of the votes that have been cast. Node can keep local variables in memory between requests. So, let's skip the database and just store everything in memory. If the server crashes, we'll lose all the data, but YOLO.

Let's declare our empty object in the top of the scope.

```js
// server.js
var votes = {};
```

`votes` will be a little key/value storage. We'll use the `socket.id` as the key and the vote as the value.

```js
// server.js
socket.on('message', function (channel, message) {
  if (channel === 'voteCast') {
    votes[socket.id] = message;
    console.log(votes);
  }
});
```

Let's also remove a user's vote when they disconnect.

```js
// server.js
socket.on('disconnect', function () {
  console.log('A user has disconnected.', io.engine.clientsCount);
  delete votes[socket.id];
  console.log(votes);
  io.sockets.emit('usersConnected', io.engine.clientsCount);
});
```

Open some tabs and cast some votes. Then head over to Terminal to see the object populated with the current votes cast.

Additionally, verify that the votes are removed for closed tabs.

### Counting Votes

The key/value object is useful for keeping track of votes. Let's write a super simple function for counting votes. We'll start out with a default counter where everything is 0 and then iterate through the `votes` object and increment the `voteCount` for each vote.

```js
// server.js
function countVotes(votes) {
var voteCount = {
    A: 0,
    B: 0,
    C: 0,
    D: 0
};
  for (var vote in votes) {
    voteCount[votes[vote]]++
  }
  return voteCount;
}
```

**Challenge**: You installed `lodash` at the beginning of this tutorial. Can you write a better version of this function using `lodash`?

Now, that we can count up the votes, let's emit an event from the server with a tally of all of the votes each time one is cast.

```js
// server.js
io.on('connection', function (socket) {
  console.log('A user has connected.', io.engine.clientsCount);

  io.sockets.emit('userConnection', io.engine.clientsCount);

  socket.emit('statusMessage', 'You have connected.');

  socket.on('message', function (channel, message) {
    if (channel === 'voteCast') {
      votes[socket.id] = message;
      socket.emit('voteCount', countVotes(votes));
    }
  });

  socket.on('disconnect', function () {
    console.log('A user has disconnected.', io.engine.clientsCount);
    delete votes[socket.id];
    socket.emit('voteCount', countVotes(votes));
    io.sockets.emit('userConnection', io.engine.clientsCount);
  });
});
```

On the client, we'll log this to the console for now:

```js
// client.js
socket.on('voteCount', function (votes) {
  console.log(votes);
});
```
Open up a few tabs and cast some votes. Verify that the updated tally is correctly logging to the console.

## Your Turn

This is where I leave you, padawan.

Right now, we're logging to the console. But we're not updating our interface. Implement the following:

### Basic Functionality

* Render the current tally of votes in the DOM.
* Emit a event to the user's individual socket that lets them know when their vote has been cast (and what vote they cast).
* Update the DOM to show the user what vote they have currently cast (based on the previous step).

### User Experience

* Can you create an interface that is pleasant to use?
* Can you visualize the votes that have been cast?

### Deployment

With the following Procfile, can you deploy you application to Heroku?

```
web: node server.js
```

### Testing

Can you get mocha tests up and running?

```
mkdir test
touch test/test.js
```

Now let's install our dependencies.

```
  npm install mocha chai --save-dev
```

Now, open the `package.json` file in the route directory and make sure within `scripts` and `test` that you point `npm` to use mocha:

```
//package.json
"scripts": {
  "test": "mocha",
  "start": "node server.js"
},
```

##### Extensions: Supertest for Request Testing

[Supertest](https://github.com/visionmedia/supertest) is a library for testing node.js HTTP servers.

```
  npm install supertest --save-dev
```

You can then write request tests like:

```js
var expect = require('chai').expect;
var request = require('supertest');

var app = require('../server');

describe('GET /', function(){
  it('responds with success', function(done){
    request(app)
      .get('/')
      .expect(200, done);
  });
});

describe('undefined routes', function(){
  it('respond with a 404', function(done){
    request(app)
      .get('/not-real')
      .expect(404, done);
  });
});
```
##### Extensions: Mocking and Testing WebSockets

[Socket.IO Client](https://github.com/socketio/socket.io-client)

Some blogs/resources:
- [Testing SocketIO](http://liamkaufman.com/blog/2012/01/28/testing-socketio-with-mocha-should-and-socketio-client/)
- [Testing Socketio Apps](https://dzone.com/articles/testing-socketio-apps)
- [An Example on Github](https://github.com/liamks/Testing-Socket.IO)

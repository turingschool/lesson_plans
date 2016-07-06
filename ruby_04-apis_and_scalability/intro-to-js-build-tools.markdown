---
title: Intro to JavaScript Build Tools
length: 60 mins
tags: javascript, gulp, webpack, grunt
---

## Goals

By the end of this lesson, you will know/be able to:

* Have an understanding of what client side build tools are
* Have a basic understanding of what Webpack is and what it does for us

## What's a Build Tool

- what is the use case?
- why do we care?
- how does this differ from Node?

You can check out [this blog](http://walkercoderanger.com/blog/2015/06/state-of-js-build-tools-2015/) for more ramblings on the state of js build tools. You'll notice that Webpack is the first topic brought up in the comments, but not covered in the blog...

## Focusing In: Webpack

Webpack is a very simple frontend JavaScript build tool.

Require/Module:

### Code Along - Setting Up Webpack

We were provided a really cool and helpful [starter-kit for webpack](https://github.com/turingschool-examples/game-time-starter-kit). What we'll do now is walk through actually rebuilding a version of that starter kit, so we can understand the tool!

If you get stuck at any point, go back and reference the [starter-kit for webpack](https://github.com/turingschool-examples/game-time-starter-kit) for hints!

#### Initial Set Up

Start by creating a folder:

```
  mkdir webpack-walkthrough; cd webpack-walkthrough
```

Run `npm init` and follow the prompts to fill out your initial package.json file

Now let's go ahead and add an `index.html` file to the root of your project.

Copy the following code into your `index.html` file:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Webpack Walkthrough</title>
</head>
  <body>
    <div id="everything-happens-here"></div>
  </body>
</html>
```

Finally, let's add a `.gitignore` file to our repo. Once we add that, put the following line in it `node_modules`

```
node_modules
```

The `node_modules` folder has our local dependencies - we don't ever need to commit these to Github.

Our directory structure should look like:

```
node_modules/
.gitignore
index.html
package.json
README.md
```

Now, run `git init` and run `git status`, you should see the same files as above (except for `node_modules`, which we are ignoring in our `.gitignore`)

Run `git add .; git commit -m 'Initial set up'`

#### Adding WebPack

Then install, and store webpack in your node_modules for the project:

```
  npm install webpack --save-dev
```

And install it globally so you can use the `webpack` command in your terminal:

```
  npm install webpack -g
```

Note: You may get a warning that you can't install things globally - if so, check out [this link](https://docs.npmjs.com/getting-started/fixing-npm-permissions) to learn more.

In the root path of your project, create a file called `webpack.config.js`.

Inside that file, copy and paste the following boiler-plate code:

```
var webpack = require('webpack'),
    path = require('path');

module.exports = {
    debug: true,
    entry: {
        main: './lib/index.js'
    },
    output: {
        path: path.join(__dirname, 'dist'),
        filename: '[name].js'
    },
    module: {
        loaders: []
    }
};
```

Take note of this line:

```
entry: {
    main: './lib/index.js'
}
```

This defines the entry point for Webpack to use to compile your files. Basically, Webpack will look for a folder called `lib` and then within that folder, a file called `index.js` and it will use that location to start compiling your JavaScript.

If you're familiar with Rails, this `index.js` is analogous to the `application.js` in your assets folder.

So let's go ahead and create that file:

```
  mkdir lib; touch lib/index.js
```

Let's go ahead and write some JavaScript in that index.js to try some things out.

Add the following to `lib/index.js`:

```js
  var everythingDiv = document.getElementById('everything-happens-here');
  everythingDiv.innerText = 'Boo!';
```

Now run the command `open index.html` - this should open your HTML page in the browser. Right now, you'll see a completely white screen.

Let's include our JavaScript on the page, so we can see 'boo'.

First things first, let's let webpack know that we want to compile our JavaScript and prepare it. In your terminal, run this command:

```
  webpack
```

You should see an output that looks something like:

```bash
Hash: cf671bb7866646bb355d
Version: webpack 1.13.1
Time: 51ms
         Asset    Size  Chunks             Chunk Names
main.bundle.js  1.5 kB       0  [emitted]  main
   [0] ./lib/index.js 106 bytes {0} [built]
```

You'll notice that this command has created a file for you in your root directory called `main.bundle.js`. If you open that file, you'll see a ton of fancy things but most importantly, you'll see that your js code from `lib/index.js` is in there.

Now go back to your browser and refresh `index.html` - do you see 'boo!'?

You shouldn't.

You still need to let `index.html` know that it should use the JavaScript file that Webpack helpfully compiled for you. You do that by adding this script tag to the bottom of the body in your `index.html` file:

```html
  <script type="text/javascript" src="main.bundle.js" charset="utf-8"></script>
```

So now your `index.html` will look like this:

```
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Webpack Walkthrough</title>
</head>
  <body>
    <div id="everything-happens-here"></div>
    <script type="text/javascript" src="bundle.js" charset="utf-8"></script>
  </body>
</html>
```

Now, go back to index.html in your browser and refresh!

Boo!

At this point, our directory structure should look like:

```
lib/
  index.js
node_modules/
index.html
main.bundle.js
package.json
README.md
webpack.config.js
```

### Adding Another File

Nothing we've done so far has really been all that exciting. Why do we even need Webpack? We could just change our script tag to point directly to our `index.js` file and call it a day, right?

Well, now let's dive in to some more functionality.

Create another file in your `lib/` folder called `generate-message.js`;

Webpack uses `module.exports` and `require` to keep the global namespace clean. It takes a little getting used to, but the idea is that to share JavaScript across file, you need to explicitly define what each file `exports` and then explicitly require in the file's export.

Confusing? You'll get used to it!

In our `generate-message.js`, add the following code:

```js
function generateMessage(){
  var messages = ['Boo!!!', 'Hi!', 'Ahoy', 'Meh.'];
  return messages[Math.floor(Math.random() * messages.length)];
};

module.exports = generateMessage;
```

What we're doing here is defining a function that selects a random message out of an array of possible strings. The last line allows us to export the function.

Now, in `index.js` let's pull in this function and replace the message that we put on the screen with the result of our function. It should looks like this:

```js
var generateMessage = require('./generate-message.js');
var message = generateMessage();

var everythingDiv = document.getElementById('everything-happens-here');
everythingDiv.innerText = message;
```

This change pulls in the function that we exported in `generate-message.js` and then replaces what we use as a message with the function's result!

If we refresh `index.html` in the browser, we will still see just 'Boo!'.

You'll need to run `webpack` again to compile the code for us.. then, refresh index.html, and we should see our new functionality!

### AutoLoading

Constantly refreshing and running `webpack` gets super annoying while we're developing. Wouldn't it be great if we could use a tool that would watch any changes we make and auto update things for us?

```
npm install webpack-dev-server -g
```

```
  webpack-dev-server --progress --colors
```

Now visit: `http://localhost:8080/webpack-dev-server/index.html`

The Webpack Dev Server binds a small express server on localhost:8080 which serves your static assets and bundled JavaScript.

If you make a change in your `index.js` file, you'll see that the page automatically refreshes to adjust to reflect the changes!

Note: One interesting thing about the webpack-dev-server is that it wraps your html in an iframe. This will cause it to behave oddly if you are testing things out in your terminal in the browser. The more you know.

Now would be a good time to put the command that use to run the dev server in our README.md, btw.

### Adding CSS

We can also use Webpack to compile our CSS for us! Let's try adding some style to our div by adding a `style.css` file in our root directory - and adding the following code to it:

```CSS
#everything-happens-here{
  font-size: 100px;
}
```

We need to install a few additional tools to help us with loading additional file types:

```
npm install css-loader --save
npm install style-loader --save
```

We then have to update our `webpack.config.js` file to pull in CSS using these loaders with the following line `{ test: /\.css$/, loader: "style!css" },`. Our `webpack.config.js` should now look like:

```js
var webpack = require('webpack'),
    path = require('path');

module.exports = {
    debug: true,
    entry: {
        main: './lib/index.js'
    },
    output: {
        path: __dirname,
        filename: "[name].bundle.js"
    },
    module: {
        loaders: [
          { test: /\.css$/, loader: "style!css" }
        ]
    }
};
```

Now, we can require our css file directly in our `index.js` file (crazy, I know). At the top of `index.js`, add the following line:

```js
require("../style.css");
```

Exit out of your webpack-dev-server and restart it to see your css! (`webpack-dev-server --progress --colors`)

### Adding ES6

```js
  npm install babel-loader --save
```

You will then need to tell Webpack to load `js` files through babel.

You can do so either by loading all `.js` files through babel:

```
  { test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader' },
```

Or by loading explicitly defined js files which end in `.es6.js`:

```js
{
  test: /\.es6.js$/,
  loader: "babel-loader"
}
```

If we go with the 'All js files except for node_modules' solution - your `webpack.config.js` file should now look like this:

```js
var webpack = require('webpack'),
    path = require('path');

module.exports = {
    debug: true,
    entry: {
        main: './lib/index.js'
    },
    output: {
        path: __dirname,
        filename: "[name].bundle.js"
    },
    module: {
        loaders: [
          { test: /\.css$/, loader: "style!css" },
          { test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader' }
        ]
    }
};
```

### Adding Tests

```bash
npm install mocha --save
```

```bash
npm install chai --save
```

```bash
npm install mocha-loader --save
```

Now, we want to create an entry point for ourselves to see the tests in a browser. Amend your `webpack.config.js` file to have the following lines:

```js
entry: {
    main: './lib/index.js',
    test: "mocha!./test/index.js"
},
```

Looking at the test entry point, it indicates a few things:

1. We are using a bash command of 'mocha' - which means that in addition to installing mocha locally, we will want to make sure it is installed globally:

```bash
npm install mocha -g
```

2. We are looking for a window into our test code at `test/index.js`:

```bash
mkdir test; touch test/index.js
```

3. This is a browser endpoint - so we need to have a `test.html`, just like out `index.html`

```bash
touch test.html
```

You'll need to set up the test html to show our testing results - do so by copying this code into the `test.html`:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Test Suite - Game Time</title>
</head>
<body>


  <script src="test.bundle.js"></script>
</body>
</html>
```

Let's verify that all of this worked by restarting our webpack server, visiting test.html and making sure nothing bursts into flames

Visit: http://localhost:8080/webpack-dev-server/test.html

At the top of the page, you should see some mocha specific things show up - namely a little banner that says `passes: 0 failures: 0 duration: 0s`. It's like magic!

Let's write a little test just to make sure we see things.

In your test/index.js, copy the following code:

```js
const chai = require('chai');
const assert = chai.assert;

describe('my test suite', function () {
  it('should work', function () {
    assert(true);
  });
});
```

When you refresh http://localhost:8080/webpack-dev-server/test.html you should now see one passing test!

### More Bells and Whistles

The starter-kit provided has a few other niceties added that are outside the scope of this lesson. Take a look at these parts for some examples:

- [Start Scripts](https://github.com/turingschool-examples/game-time-starter-kit/blob/master/package.json#L7)
- [Test Scripts](https://github.com/turingschool-examples/game-time-starter-kit/blob/master/package.json#L9)
- [Sass](https://github.com/turingschool-examples/game-time-starter-kit/blob/master/package.json#L30-L31)
-[Resolving Extensions](https://github.com/turingschool-examples/game-time-starter-kit/blob/master/webpack.config.js#L19-L21)

## Outside Resources / Further Reading

* [Egghead.io's Intro to Webpack](https://egghead.io/lessons/javascript-intro-to-webpack)

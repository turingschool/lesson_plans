# JavaScript Build Tools

## Install Some Command Line Tools

Let's install some command line tools. We'll eventually use local versions, but it's always helpful to have them on your system.

```
npm install -g webpack webpack-dev-server mocha
```

This will install [Webpack][] and [Mocha][] command line tools globally—hence the `-g` flag—on your file system. You'll be able to run these tools with the `webpack`, `webpack-dev-server`, and `mocha` command respectively.

## Getting Your Project Off the Ground

It's a little easier if we create an empty repository and clone it down. So, let's do that first.

* Create a repository on Github
  * Select _Node_ when Github asks you what kind of `.gitignore` file you want
  * Pick the license of your choice
* Clone it down with `git clone` and the url of your new repository

## Setting Up npm

At this point, we have a very simple project. Let's initialize `npm` and then install some dependencies.

```
npm init
npm install --save-dev webpack webpack-dev-server mocha mocha-loader chai
```

We installed a few development dependencies:

* [Webpack][]
* [Webpack Development Server][]
* [Mocha][]
* A Webpack loader for Mocha
* [Chai][]

[Webpack]: http://webpack.github.io
[Webpack Development Server]: https://github.com/webpack/webpack-dev-server
[Mocha]: http://mochajs.org
[Chai]: http://chaijs.com

Next, let's create some empty files and folders for our future code:

```
mkdir lib test
touch lib/index.js test/index.js
```

## Setting Up Our HTML

You'll want an HTML page that loads up each of your bundles in the browser.

We'll create two HTML files: `touch index.html test.html`

Below is an example of the basic structure you can use:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Game Time</title>
</head>
<body>

  <script src="test.bundle.js"></script>
</body>
</html>
```

The important part is the third line from the bottom. This is the line that loads up your bundle.

* In your `test.html`, you'll want to load up `test.bundle.js`.
* In your `index.html`, you'll want to load up `main.bundle.js`.

These pages won't work yet, because you haven't actually built these files yet.

## Setting Up Webpack

[Webpack][] is a module bundler. Think of it as the Asset Pipeline, but _way_ better and without Rails.

We installed it earlier, but let's add a configuration file:

```
touch webpack.config.js
```

In that file, add the following contents:

```js
const path = require('path');

module.exports = {
  entry: {
    main: "./lib/index.js",
    test: "mocha!./test/index.js"
  },
  output: {
    path: __dirname,
    filename: "[name].bundle.js"
  }
}
```

In the above configuration, we're telling Webpack that we'd like it to build too different bundles: our main application and our test suite.

We can build the files once with `webpack` or we can set up a development server that will reload our changes with `webpack-dev-server`.

Let's fire up `webpack-dev-server` and head over to `http://localhost:8080/`.

## Our First Test

In `test/index.js`, let's write our first test:

```js
const assert = require('chai').assert;

describe('our test bundle', function () {
  it('should work', function () {
    assert(true);
  });
});
```

Visit `http://localhost:8080/test.html` to confirm that it works.

You can require additional test files by using `require('other-test-file')`.

### A Quick Word on Testing Environments

You have two ways of running JavaScript: the browser and Node.js. Most of the time, they're pretty much the same. Node uses Chrome's V8 JavaScript engine. On major difference is that your browser knows about the DOM and Node.js does not support the DOM (because it's not a web browser).

You can run `mocha` to run your test suite on the command line, but any tests that involve the DOM will not work from the command line. For those, you'll have to run them in your browser or use something like [Phantom.js][] to run them from the command line.

[Phantom.js]: http://phantomjs.org

## Additional Loaders

Like the Asset Pipeline in Rails, Webpack can transpile assets during the build process. An example of this is if we want to write in SCSS. The browser can only run CSS, so we have to convert our assets for the browser.

Webpack handles this using _loaders_. There are many loaders on npm. We'll discuss just a few of them.

The first step is to download and install the dependencies for the loaders you'd like to use.

```
npm install --save-dev css-loader style-loader sass-loader
```

In our `webpack.config.js`, we can add another property called `module`:

```js
const path = require('path');

module.exports = {
  entry: {
    main: "./lib/index.js",
    test: "mocha!./test/index.js"
  },
  output: {
    path: __dirname,
    filename: "[name].bundle.js"
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loader: "style!css!sass" }
    ]
  }
}
```

We can now require a CSS file with `require('style.css')` or a SCSS files with `require('style.scss')`.

As an added bonus, we can also tell Webpack to resolve the file extensions on our behalf.

```js
const path = require('path');

module.exports = {
  entry: {
    main: "./lib/index.js",
    test: "mocha!./test/index.js"
  },
  output: {
    path: __dirname,
    filename: "[name].bundle.js"
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loader: "style!css!sass" }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.json', '.scss', 'css']
  }
}
```

### Using Babel

[Babel][] is a transpiler that allows us to use features from ES6 and ES7 in our JavaScript applications today.

To install the dependency, use the following:

```
npm install --save-dev babel-loader
```

We'll add another loader into your `webpack.config.js`.

```js
const path = require('path');

module.exports = {
  entry: {
    main: "./lib/index.js",
    test: "mocha!./test/index.js"
  },
  output: {
    path: __dirname,
    filename: "[name].bundle.js"
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: '/node_modules/', loader: 'babel-loader' },
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loader: "style!css!sass" }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.json', '.scss', 'css']
  }
}
```

Notice that we exclude our `node_modules` folder. We want to process all files that end in `.js`, but _not_ the ones we didn't write.

[Babel]: http://babeljs.io

# JavaScript Build Tools

## Install Some Command Line Tools

Let's install some command line tools.
We'll eventually use local versions,
but it's always helpful to have them on your system.

```
npm install -g webpack webpack-dev-server mocha
```

This will install [Webpack](http://webpack.github.io/) and [Mocha](https://mochajs.org/)
command line tools globally -- hence the `-g` flag --
on your file system.

You'll be able to run these tools with the `webpack`, `webpack-dev-server`, and `mocha` command respectively.

## Creating your first Webpack project

First, create a directory for your project:

```
mkdir my-project
cd my-project
git init
```

## Setting Up npm

At this point, we have a very simple project.
Let's initialize `npm` and then install some dependencies.

First, create your project with:

```
npm init
```

You'll be guided through a command-line setup "wizard", prompting
you for some info on your project such as its:

* Name
* Author
* Version
* Description
* License, etc.

For most of these items you can use the default option
by pressing `Enter`.

Finally, install our libary dependencies with `npm install`:

```
npm install --save-dev webpack webpack-dev-server mocha mocha-loader chai
```

We installed a few development dependencies:

* [Webpack](http://webpack.github.io/)
* [Webpack Development Server](http://webpack.github.io/docs/webpack-dev-server.html)
* [Mocha](https://mochajs.org/)
* A Webpack loader for Mocha
* [Chai](http://chaijs.com/)

### Recommended: sane `.gitignore` defaults

* [NPM](https://www.npmjs.com/) vs. [Bundler](http://bundler.io/) dependency storage
* Git strategy -- keeping diffs meaningful and project churn low
* Git problems caused by versioning dependencies or other frequently
  changing files

For these reasons, it's often helpful to start with
a `.gitignore` file which includes "sane defaults" for NPM projects.
One example is provided on github, and we can easily include
it in our newly created project by pulling the file down with
`curl`:

```
curl https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore > .gitignore
```

## Filling out the Project

Next, let's create some empty files and folders for our future code:

```
mkdir lib test
touch lib/index.js test/index.js
```

## Setting Up Our HTML

__Discussion: Application Entry Points__

* What is needed to trigger an application to "run" in its
most standard configuration?
* How do we run a rails project? Its test suite?
* System executables vs. Code files
* What is the "executable" for a browser-based app?

You'll want an HTML page that loads up each of your bundles
in the browser.

We'll create two HTML files: `touch index.html test.html`
These will provide entry points to our application and test suite,
respectively

Below is an example of the basic structure you can use:

__index.html__

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Game Time</title>
</head>
<body>
  <script src="main.bundle.js"></script>
</body>
</html>
```

The important part is the third line from the bottom:

```
<script src="main.bundle.js"></script>
```

This is the line that loads up your bundle. Notice that we only have to load a single
JS file. This is one of the major benefits of Webpack (or another frontend build tool)
-- it will package all of our JS files and their dependencies into a single bundle that we can
load.

Since the `index.html` file is the entry point for our application, we're loading
in the "main" bundle.

For our `test.html` file, we'll have almost the same thing, except
we'll load in the test bundle:

__test.html__


```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Game Time Tests</title>
</head>
<body>
  <script src="test.bundle.js"></script>
</body>
</html>
```

Note that these pages won't work yet, since the bundles themselves
have not yet been built.

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

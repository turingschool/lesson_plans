# Testing JavaScript in Rails

## Setting Up Rails

First and foremost, let's create a new project with all of the appropriate settings. (If you're working with [idea-bin](https://github.com/turingschool-examples/idea-bin)—you can skip this step as this has already been done for you. 🎉)

```
rails new idea-bin -jB --skip-turbolinks
```

#### Side Note: Curious about the flags we used?
* `-j` - 'Preconfigure for selected JavaScript library'
* `-B` - 'Skip bundle'
* `--skip-turbolinks` - [Pros and Cons of Turbolinks](http://wlowry88.github.io/blog/2014/07/28/pros-and-cons-of-turbolinks-in-rails-4-applications/)

We'll be using some new gems as we go along, but let's make sure that they are all accounted for now so we can avoid bundling every four minutes.

Add the following to the Gemfile in the `development` and `test` groups:

```rb
gem 'teaspoon'
gem 'teaspoon-mocha'
```

Once those are added, go ahead and `bundle install`

To run Teaspoon headless you'll need PhantomJS, Selenium Webdriver or Capybara Webkit. We recommend PhantomJS, which you can install with homebrew, npm or as a download.

```js
  npm install phantom -g
```

## Installing Teaspoon and Chai

Teaspoon can actually take care of installing itself, we just have to tell it to go ahead and do so.

```
rails generate teaspoon:install --framework=mocha
```

If all went well, you should see something like this in your terminal:

```
→ rails generate teaspoon:install --framework=mocha
      create  spec/teaspoon_env.rb
      create  spec/javascripts/support
      create  spec/javascripts/fixtures
      create  spec/javascripts/spec_helper.js
+============================================================================+
Congratulations!  Teaspoon was successfully installed.  Documentation and more
can be found at: https://github.com/modeset/teaspoon
```

Teaspoon is a bridge that lets your JavaScript testing framework of choice hook into the Asset Pipeline. As a bonus, it includes many of the libraries needed to get up and running testing JavaScript. We decided to use Mocha as our test runner in this example, but you could just as easily chosen to use Jasmine or Qunit.

[Mocha](https://mochajs.org) runs your tests, but it doesn't come with an assertion library. We'll use the excellent and popular [Chai](https://chaijs.com) assertion library. (More on Chai in a little bit.)

We'll make sure our `spec_helper.js` includes Chai and loads our favorite assertion library. The Asset Pipeline has a special syntax for including files, `//=`, which is only slightly different than JavaScript's comment syntax, `//`.

Change line 4 in `spec/javascripts/spec_helper.js` from the first line below to the second:

```js
// require support/chai
//= require support/chai
```

Chai comes in multiple flavors. Choose to write your assertion/expectations in any of the following styles:

* Assert: `assert(true)` and `assert.equal(2 + 2, 4)`
* Expect: `expect(2 + 2).to.equal(4);`
* Should: `'foo'.should.have.length(3);`

You're welcome to use any style that suits your tastes, but I'll be using the assertion style in examples and tutorials.

To turn on Chai variety of your choice, take a look at lines 38-40 in `spec/javascripts/spec_helper.js`:

```js
// window.assert = chai.assert;
// window.expect = chai.expect;
// window.should = chai.should();
```

Uncomment the line with the style you'd like to use.

So, for instance, if you want to use `assert`, then you code should look like this:

```js
window.assert = chai.assert;
// window.expect = chai.expect;
// window.should = chai.should();
```

## Writing Your First Unit Test

At this point you should be set up writing your first JavaScript unit test in Rails. Teaspoon will look for anything in the `spec/javascripts` directory that ends with `_spec.js`.

Let's try the simplest thing possible thing:

Create a new file in spec/javascripts called `myFirstTest_spec.js`, then add the following lines into that file.

```js
describe('our awesome test suite', function () {

  it('should work, right?', function () {
    assert(true);
  });

});
```

Once that is done, start the teaspoon server by typing `rake teaspoon` into your command line
You should see something like the following:

```
Starting the Teaspoon server...
Teaspoon running default suite at http://127.0.0.1:50627/teaspoon/default
.

Finished in 0.00700 seconds
1 example, 0 failures
```

If you're more of a visual person, you can spin up your server using `rails s` and head over to `http://localhost:3000/teaspoon/default` and you should see something like this:

![Teaspoon](https://cldup.com/YUWvY1H7SL.png)

As mentioned before. Teaspoon hooks into the Asset Pipeline, so any JavaScript that you write in `app/assets/javascript` will be available for you in your tests.

## Writing Your Second Unit Test

Now, let's test write a slightly more complicated test.

Let's say we need to have a function that will remove spaces from a string. Create a new file in spec/javascripts called `remove_space_spec.js`.

First, we want to require the javascript file that has the method we're testing. Since this is a unit test, we don't want to require ALL the JavaScript files by including `application.js` - so instead let's add a specific file.

```js
//= require remove_space
```

When we run `rake teaspoon`, we should see a huge error message that begins with `Error: ActionView::Template::Error: couldn't find file 'remove_space' with type 'application/javascript'`

In `app/assets/javascripts` let's create a `remove_space.js` file.

Back in our spec file, let's write our first test.

```js
//= require remove_space

describe('removeSpace', function () {
  it('removes spaces from a string', function () {
    // assertion goes here.
  });
});
```

If `removeSpace` is a function, we can now pass it a sample string in our test and assert that it equals the same string without any spaces! Since we're using Chai, we can [look up the assertion syntax](http://chaijs.com/api/assert/) and find that there is a `.equal` method we can use.

```js
//= require remove_space

describe('removeSpace', function () {
  it('removes spaces from a string', function () {
    var str = 'I have spaces';
    var result = 'Ihavespaces';
    assert.equal(removeSpace(str), result);
  });
});
```

This test will fail until we create a removeSpace function!

We can get the test to pass by adding the following code to our `app/assests/javascripts/remove_space.js` file

```js
  var removeSpace = function(str) {
    return str.replace(/\s+/g, '');
  }
```

### Your Turn

* Add another test to see what the `removeSpace` method does when a string has multiple spaces in a row.
* Write a test to see what `removeSpace` does when it is passed a number instead of a string.
* If it returns an error, either write a test that proves this OR write a test for the preferred behavior and get it to pass.

## Writing a Test that Interacts with the DOM

So let's say we have a feature in mind where we hide all ideas that that are tagged as 'old'.

Let's take a look at how we plan to set up our html to start.

```
<div class="ideas">
  <div class="idea">
    <h3> New Idea </h3>
  </div>
  <div class="idea">
    <h3> Existing Idea </h3>
  </div>
  <div class="idea old">
    <h3> Old Idea </h3>
  </div>
</div>

<button class="hide-old">Hide Old Ideas</button>
```

Let's say this is what we expect our html to look like:

- We have a upper level `div` with the class `ideas`
- The `ideas` div has nested divs, each one has the class `idea`
- The idea called Old Idea has a class called `old`
- There is a button which says Hide Old Ideas

Can we write a unit test to do this?

It depends on how cleanly we write our code and how much magic of testing we want to use. Let's think about the psuedo-code we would use to make this feature.

```
// When the button is clicked
// Grab the divs on the page
// Filter through the ideas
// Hide all ideas that have the .old class
```

What's great about Teaspoon is that we can create document elements in our tests themselves to test units of code. Clicking a button falls in the category of a feature test - but the thing that happens after the button is clicked, where ideas are filtered, that's a unit of functionality.

So let's create a spec file called `spec/javascripts/filter_spec.js`.

In that file, let's create a basic test case:

```
//= require filter

describe('filter', function () {
  it('can remove all old ideas', function () {
  });
});
```

In our test case, let's go ahead and create the html that we outlined in the example!

```
  it('can remove all old ideas', function () {
    var ideas = document.createElement('div');
    ideas.className = 'ideas';
    var idea1 = document.createElement('div');
    idea1.className = 'idea';
    ideas.appendChild(idea1);
    var idea2 = document.createElement('div');
    idea2.className = 'idea';
    ideas.appendChild(idea2);
    var idea3 = document.createElement('div');
    idea3.className = 'idea old';
    ideas.appendChild(idea3);
  });
```

Obviously, there is a lot of repetition here that we can clean up. We can put a link generator in the test helpers. We can refactor the duplicating code.

For now - let's just move this in to a function.

```
describe('filter', function () {
  it('can remove all old ideas', function () {
    var ideas = setUpIdeas();
  });
});

function setUpIdeas(){
  var ideas = document.createElement('div');
  ideas.className = 'ideas';
  var idea1 = document.createElement('div');
  idea1.className = 'idea';
  ideas.appendChild(idea1);
  var idea2 = document.createElement('div');
  idea2.className = 'idea';
  ideas.appendChild(idea2);
  var idea3 = document.createElement('div');
  idea3.className = 'idea old';
  ideas.appendChild(idea3);
  return ideas;
}
```

So now let's think about how we would test this? We can use the powers of jQuery to get us there!

```
describe('filter', function () {
  it('can remove all old ideas', function () {
    var ideas = setUpIdeas();
    // we use our generator to create some HTML
    assert.equal($(ideas).find('.old').length, 1);
    // we assert that there is one old idea
    filterOldIdeas(ideas);
    // we call our soon to be created function that filters out old ideas
    assert.equal($(ideas).find('.old').length, 0);
    // we assert that now there are no nodes with the .old class
  });
});
```

### Your Turn

* Can you write a `filterOldIdeas` function that causes the test to pass?

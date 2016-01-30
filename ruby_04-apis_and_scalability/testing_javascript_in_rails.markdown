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
gem 'phantomjs'
gem 'magic_lamp'
gem 'database_cleaner'
```

Once those are added, go ahead and `bundle install`

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

[Mocha][https://mochajs.org] runs your tests, but it doesn't come with an assertion library. We'll use the excellent and popular [Chai][https://chaijs.com] assertion library. (More on Chai in a little bit.)

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

### Writing Your First Unit Test

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

### Writing Your Second Unit Test

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
//= require removeSpace

describe('removeSpace', function () {
  it('removes spaces from a string', function () {
    // assertion goes here.
  });
});
```

If `removeSpace` is a function, we can now pass it a sample string in our test and assert that it equals the same string without any spaces! Since we're using Chai, we can [look up the assertion syntax](http://chaijs.com/api/assert/) and find that there is a `.equal` method we can use.

```js
//= require removeSpace

describe('removeSpace', function () {
  it('removes spaces from a string', function () {
    var str = 'I have spaces';
    var result = 'Ihavespaces';
    assert.equal(removeSpace(str), result);
  });
});
```

This test will fail until we create a removeSpace function!

We can get the test to pass by adding the following code to our `app/assests/javascrips/remove_space.js` file

```js
  var removeSpace = function(str) {
    return str.replace(/\s+/g, '');
  }
```

### Your Turn

* Add another test to see what the removeSpace method does when a string has multiple spaces in a row.
* Write a test to see what removeSpace does when it is passed a number instead of a string. If it returns an error, either write a test that proves this OR write a test for the preferred behavior and get it to pass.

-

## Magic Lamp

If you're just unit testing, Teaspoon is _probably_ all you need. But, it's likely that you'd like to work with some of your Rails views as well. Not surprisingly, most JavaScript testing libraries are ignorant of Rails, in general, and its view templates, in particular.

Magic Lamp is a library that—like Teaspoon—makes it easier to bridge those two worlds. We included it in our `Gemfile` earlier, so we're good to go in that regard. We just had to do a little bit of additional configuration.

In `routes.rb`, let's set up Magic Lamp:

```rb
mount MagicLamp::Genie, at: '/magic_lamp' if defined?(MagicLamp)
```

Next, create the file `spec/magic_lamp_config.rb`.  In that file, we'll clean up the database after each test by adding the following lines.

```rb
require 'database_cleaner'

MagicLamp.configure do |config|
  DatabaseCleaner.strategy = :transaction

  config.before_each do
    DatabaseCleaner.start
  end

  config.after_each do
    DatabaseCleaner.clean
  end
end
```

This might look somewhat familiar. We're basically just telling `DatabaseCleaner` to roll back any changes we make to the database between tests.

In `spec/javascripts/spec_helper.js`, we'll load the JavaScript library—just like we did with Chai, except we have to add it in ourselves (preferally toward the top):

```js
//= require magic_lamp
```

Add the file `spec/javascripts/magic_lamp.rb`.  Here we'll setup our fixtures and grab our template.  Add the following into `magic_lamp.rb`:

```rb
MagicLamp.fixture do
  render template: 'ideas/index'
end
```

If you are not using the [idea-bin](https://github.com/turingschool-examples/idea-bin) project, you will need an Ideas view template.  Add the file `app/views/ideas/index.html.erb`. Inside of that file add the following HTML:

```html
<div class="new-idea"></div>

<div class="ideas"></div>
```

The code in `spec/javascripts/magic_lamp.rb` will load up the template at the location we gave it and make it available for our tests.


So, let's take Magic Lamp for a spin with a test that should only pass if we have in fact loaded our view template. In our test, we'll use `MagicLamp.load("ideas/index");` to load up our template.

Make a new spec file `spec/javascipts/ideas_spec.js` and add the following lines:


```js
describe('idea spec', function () {

  it('should find all .idea elements', function () {
    MagicLamp.load('ideas/index');
    assert.equal($('.ideas').length, 1);
  });

});
```

Our test is asserting that if we query for every element with the class `.idea`, we should end up with one element. If Magic Lamp wasn't working, this would be zero.

### Setting Up Data

It's not uncommon for our views to rely on something from our database. Let's say we need to do some AJAX testing (again, you should think long and hard about whether you could just do this with Capybara, but let's assume that you have a good reason).

We can create some models before we load the template.
If you have no Idea model yet, first enter the following in the command line `rails g model Idea title body && rake db:migrate`

Next change `spec/javascripts/magic_lamp.rb` to look like this:

```rb
MagicLamp.fixture do
  Idea.create(title: 'first note', body: 'wowowowow')
  Idea.create(title: 'second note', body: 'wowowowow')
  render template: 'ideas/index'
end
```

Let's keep the test intentionally simple for clarity. We'll simply make an AJAX call and check to see that we got back the two ideas we intended.

Go back into `spec/javascripts/ideas_spec.js` and add the following test under the other test.

```js
  it('should work', function (done) {
    MagicLamp.load('ideas/index');
    $.getJSON('/ideas').then(function (ideas) {
      assert.equal(ideas.idea.length, 2);
      done();
    });
  });
```

After the new test is added, check to see if it passes by either entering `rake teaspoon` into the command line or if your rails server is still running, go to `http://localhost:3000/teaspoon/default` and refresh the page.

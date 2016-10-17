# Forms in Rails!

### Learning Goals
* Explain why we use/need forms
* Understand the role of form_for
* Construct a basic form with the help of documentation/references
* Practice building a small CRUD application with a form

### Setup

* Clone [BookShelf](https://github.com/turingschool-examples/book_shelf)
* Checkout the `pre-form-lesson` branch

### Get familiar with the app

- Run the necessary commands (including `rake db:seed`). What does seeding do for you? Why might this be important?
- See what functionality you have in this application. Explore!

### Warmup

In your `views/books/index.html.erb`, we have a few "hardcoded" routes. Can you use route helpers to clean these up?


### Discover

* Check out `views/books/new.html.erb`.
* What is `form_for`?
* Why do we need a `Book` object if it's not already saved?
* Can you change the `price` field in this form to `amount`? What happens? What error do you get?
* Launch your server & try to submit the form. How does this form know where to submit to?


### Recap

What is `form_for`? How is this different from a normal HTML form?

### Code Along

Let's submit this form. Why do we need another route to handle the submission of this form? What is the naming convention for this route?


### Partner Work

We also have categories. We have only have the functionality to view all categories currently. Add the functionality for a user to add a new category. Don't forget - you'll need two routes for this!

### Are there any other form helpers?

What's the difference between `form_for` and `form_tag`?

### Questions?

# <center>URLockbox</center>

#### <Center>URLockbox is a small application for tossing various forms of inspiration for later review. It's not unlike [Delicious](https://delicious.com/) or
[Pinboard](http://pinboard.com). It is the spiritual successor of Ideabox.</center>

-----

__<center>Only what is up in production on heroku will be assessed</center>__

-----

## Notes

- Manage yourself and your time. You have 8 - 10 hours to implement these features. The last commit can be __no later__ than 7 pm.

- You're welcome to use any library (e.g. lodash, Underscore, jQuery, React) you'd like as long as it does not replace the demonstrating proficiency in one of the skill
areas addressed by the rubric below.

- For any given page, you can choose to render the initial content on the server _or_ you can provide an API and load it dynamically on the client. Unless otherwise
specified, you have __full autonomy on technical implementation__. Just keep best practices and the rubric in mind (it's at the bottom of this file).

- These sections are ordered, but you wont be graded on the order in which they're completed.

- Don't over develop. If a feature isn't mentioned in the directions, it is not required. Overdeveloping can waste precious time.

---

## Section 1 - Sign Up, Sign In, and Sign Out

**Nota Bene**:

* You should aim to complete user auth in the simplest way possible. Using Rails' "built-in" gem Bcrypt  is the most straightforward and recommended way to implement this
functionality.
* Set goals and manage your work so that you keep in mind what you need to do and how long you have to do it.

As an _unauthenticated_ user, when I visit the root of the application, `/`, I should be redirected to a page which prompts me to "Log In or Sign Up".

1. #### Sign Up

    As an unauthenticated user, if I click "Sign Up", I should be taken to a user form where I can
    enter an **email address**, a **password**, and a **password confirmation**.

    - I cannot sign up with an email address that has already been used.
    - Password and confirmation must match.
    - If criteria is not met the user should be given a message to reflect the reason they could not sign up.

    Upon submitting this information, I should be logged in via a session cookie and redirected to the "Links Index" page.

1. #### Sign In

    As an registered user when I attempt to sign in, I receive a flash message reflect a successful, or unsuccessful log in attempt.

1. #### Sign Out

    As an authenticated user viewing the index page, I should see a link to "Sign Out" and not see a link to "Sign In". This should redirect me back to the page that prompts me to "Log In or Sign Up".

---

## Section 2 - Submitting and Viewing Links

As an _authenticated user_ viewing the main page (`links#index`),
I should see a simple form to submit a link.

The `Link` model should include:

1. A _valid_ URL location for the link

1. A title for the link

1. Additionally, all links have a `read` status that is either true or false. This status will default to `false`.

1. Submitting an invalid link should result in an error message being displayed that indicated why the user was not able to add the link.

**Hint:** Use Ruby's built in `URI.parse` method to determine if a
link is a valid


or not. This [StackOverflow post][urip] has more information. Alternatively, you could use a gem like [this one][vurl].

[urip]: http://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails
[vurl]: https://github.com/perfectline/validates_url

Once a link has been submitted, loading the index page should display all of _my_ links __only__.

---

### Section 3 - Implementing a Service

Build a second application, Hot Reads, that fulfills the following requirements.

1. When a link in URLockbox is "read", the link's info is sent to Hot Reads

1. Hot Reads create a record of the "read"

1. As an unauthenticated user, I can visit the Hot Reads main index page and see a list of the top-10 most-read URLs across all users. Only reads from the last 24 hours should count towards the ranking.

Note Bene:

In URLockbox you may use an HTTP request in a model to send the data, but it would be even better to add a message queue or pub/sub channel between URLockbox and Hot
Reads. No interaction with Hot Reads should appear in URLockbox controllers.

You _must_ implement this section using AJAX.

---

### Section 4 - Editing Links

As an authenticated user who has added links to my URLockbox,
when I view the links index:

1.  Each link has an "Edit" button that either takes me to a page to edit the link or allows me to edit the link in place on the page.

1.  I can edit the title and/or the url of the link.

1.  I cannot change the url to an invalid url. Show the same error message as above.

---



### What's on Your Final?

* Good News: Sections 1 and 2 are already done for you!

* Bad News: There may be some bugs.

* There will be a section involving Client-Side development, some of the topics
you should expect are JavaScript Testing, being able to update the page
without reloading it, dealing with CORS errors, live filtering, live status
updates.

* Note: If you decide to use react, all previous functionality must then be
rewritten in React.

---

## Rubric

Subjective evaluation will be made on your work/process according to the following criteria:

### 1. Satisfactory Progress

* 4: Developer completes sections 1 through 5 with no bugs and has one or more supporting feature implemented.
* 3: Developer completes sections 1 through 5 minor bugs and no missing functionality.
* 2: Developer completes sections 1 through 5 with some _minor_ bugs or missing functionality.
* 1: Developer fails to complete sections 1 through 5 or there are significant issues with delivered functionality.

### 2. Ruby & Rails Style & API

* 4: Developer is able to craft Rails features that follow the principles of MVC, push business logic down the stack, and skillfully utilizes ActiveRecord to model application state. Developer can speak to choices made in the code and knows what every line of code is doing.
* 3: Developer generally writes clean Rails features that make smart use of Ruby, with some struggles in pushing logic down the stack. The application displays good judgement in modeling the problem as data. Developer can speak to choices made in the code and knows what every line of code is doing.
* 2: Developer struggles with some concepts of MVC.  Developer is not confident in what every line of the code is doing or cannot speak to the choices made.
* 1: Developer struggles with MVC and pushing logic down the stack
* 0: Developer shows little or no understanding of how to craft Rails applications

### 3. Javascript Syntax & Style

* 4: Developer uses elegant and idiomatic Javascript to accomplish common tasks. Demonstrates solid understanding of function passing and manipulation. Developer can speak to choices made in the code and knows what every line of code is doing.
* 3: Developer writes solid Javascript code using common patterns and idioms. Code is organized appropriately within objects and functions. Developer can speak to choices made in the code and knows what every line of code is doing.
* 2: Developer can accomplish basic tasks with Javascript but implementation is largely copy/pasted or non-idiomatic. Developer is not confident in what every line of the code is doing or cannot speak to the choices made.
* 1: Developer can manipulate Javascript syntax but implementation is buggy or inconsistent.
* 0: Developer shows little or no understanding of Javascript syntax and idioms

### 4. Testing

* 4: Developer excels at taking small steps and using the tests for *both* design and verification. Developer uses integration tests, controller tests, and model tests where appropriate.
* 3: Developer writes tests that are effective validation of functionality, but don't drive the design. Developer uses integration tests, controller tests, and model tests where appropriate.
* 2: Developer uses tests to guide development, but implements more functionality than the tests cover. Application is missing tests in a needed area such as model, integration, or controller tests.
* 1: Developer is able to write tests, but they're written after or in the middle of implementation.
* 0: Developer does not use tests to guide development.

### 5. User Interface

* 4: The application is pleasant, logical, and easy to use
* 3: The application has many strong pages/interactions, but a few holes in lesser-used functionality
* 2: The application shows effort in the interface, but the result is not effective
* 1: The application is confusing or difficult to use

### 6. Documentation

TBD

### 7. Workflow

* 4: The developer effectively uses Git branches and many small, atomic commits that document the evolution of their application.
* 3: The developer makes a series of small, atomic commits that document the evolution of their application. There are no formatting issues in the code base.
* 2: The developer makes large commits covering multiple features that make it difficult for the evaluator to determine the evolution of the application.
* 1: The developer commited the code to version control in only a few commits. The evaluator cannot determine the evolution of the application.
* 0: The application was not checked into version control.

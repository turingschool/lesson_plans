# Module 3 Diagnostic

This diagnostic is individual and you will be working on it for 1.5 hours. It's advisable to familiarize yourself with the recommended resources (details below) before the assessment.

**IMPORTANT:** _Run through the Setup section below **prior to** the diagnostic._

It is not necessary to complete the diagnostic in order to receive passing scores. You need to demonstrate a good understanding of the code you are working with and to be able to implement features at the speed of a junior developer.

In this assessment you will:

* Work with a third party API
* Build well tested features
* Demonstrate mastery of all parts of the Rails stack
* Demonstrate mastery of Ruby
* Commit every 15 minutes to track your progress (details below)

## Areas of Knowledge

The intent of this assessment is to demonstrate a solid working understanding of the following:

* Consuming an API
* Writing tests that adequately test business value
* Sending data from a form for data not stored in a database
* Storing data in a Rails Session
* Using ActiveRecord to filter data
* Core concepts covered in the previous two Modules

In addition, we expect you to:

* Be able to explain all lines of code in your project
* Be able to interpret and implement user stories in a Rails project
* Be able to read, understand and refactor existing code
* Be able to use external resources in the problem solving process (ie: Google, Docs etc)

**NOTE:** only some of these topics will be included in the assessment.

## Expectations

* As you work, you *should*:
  * Commit and push your code every 15 minutes.
  * Reference external public resources (ie: Google, Ruby API, etc)
  * Use the tooling most comfortable to you (Editor/IDE, testing framework, support tools like Guard, etc)
* As you work, you *should not*:
  * Copy code snippets
  * Review old projects for code implementations
  * Seek live support from individuals other than facilitators
  * Excessively review implementations on google and/or notes

#### Note about the commit expectation:

To better follow your progress over the 1.5 hours we expect that you commit every 15 minutes regardless of where you're at. Try to be as descriptive as possible in your commit messages and sum up briefly how you spent the time. Be sure to commit anything you may want to talk about later. For example: You get the first implementation working but want to refactor. If you don't commit the first implementation and don't finish the refactor there is no record of your initial solution.

## Setup

1. Set up a [new project](https://github.com/new) titled `module_3_diagnostic` associated with your Github account.
1. Clone down [AltFuelFinder](https://github.com/turingschool-examples/alt-fuel-finder). Be sure to customize the setup of the project prior to the diagnostic such as adding any gems you prefer to use. Common gems are rspec, factory_girl, pry, faraday, figaro, vcr.


**NOTE:** Delete `Gemfile.lock` before you bundle to avoid version conflicts.

```sh
$ git clone git@github.com:turingschool-examples/alt-fuel-finder.git
$ cd alt-fuel-finder
$ rm -rf Gemfile.lock
$ bundle
$ git remote add upstream git@github.com:YOUR-GITHUB-USERNAME/module_3_diagnostic.git
```

If you prefer to work with RSpec, please remove the `test/` directory and [set up RSpec](https://github.com/rspec/rspec-rails) in your project before the assessment.

**The night before the assessment you will be asked to get keys for the API you will be working with.**

Once you have your project ready to go, commit and push to your remote repo to confirm everything is set up correctly using something similar to the following:

```sh
$ git add .
$ git commit -m "Complete setup for M3 assessment."
$ git push -u upstream master
```

## Recommended Resources

These are recommended resources to look through before the assessment, and/or use during the assessment.

* Request libraries such as [Faraday](https://github.com/lostisland/faraday) or [Net::HTTP](http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/Net/HTTP.html)
* [VCR](https://github.com/vcr/vcr)
* [Ruby Docs](http://ruby-doc.org/)
* [ActiveRecord Query Methods](http://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) like `.where`, `.find_by`, `.joins`, `.includes`.
* [ActiveRecord calculations](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html)
* [Rails Forms](http://guides.rubyonrails.org/form_helpers.html)
* [Rails Docs](http://api.rubyonrails.org/)

## Evaluation Criteria

Subjective evaluation will be made on your work/process according to the following criteria:

### 1. Ruby Style

* 4: Developer writes code that is exceptionally clear and well-factored
* 3: Developer solves problems with a balance between conciseness and clarity and often extracts logical components
* 2: Developer writes effective code, but does not breakout logical components
* 1: Developer writes code with unnecessary variables, operations, or steps which do not increase clarity
* 0: Developer writes code that is difficult to understand

### 2. Rails Syntax & API

* 4: Developer is able to craft Rails features that follow the principles of MVC, push business logic down the stack, and skillfully utilizes ActiveRecord to model application state. Developer can speak to choices made in the code and knows what every line of code is doing.
* 3: Developer generally writes clean Rails features that make smart use of Ruby, with some struggles in pushing logic down the stack. The application displays good judgement in modeling the problem as data. Developer can speak to choices made in the code and knows what every line of code is doing.
* 2: Developer struggles with some concepts of MVC.  Developer is not confident in what every line of the code is doing or cannot speak to the choices made.
* 1: Developer struggles with MVC and pushing logic down the stack
* 0: Developer shows little or no understanding of how to craft Rails applications

### 3. Testing

* 4: Developer excels at taking small steps and using the tests for both design and verification. All new lines of code are tested.
* 3: Developer writes tests that are effective validation of functionality. Most new lines of code are tested.
* 2: Developer writes tests. Most new lines of code are tested but they aren't effective at testing for functionality and value.
* 1: Developer is able to write tests, but most new lines of code are not tested.
* 0: Developer does not use tests.

### 4. Progression/Completion

* 4: Developer is able to implement solutions at the speed of a developer.
* 3: Developer is able to implement solutions at the speed of a junior developer.
* 2: Developer is able to implement solutions at the speed of an apprentice.
* 1: Developer struggles to implement solutions at the speed of an apprentice.
* 0: Developer is not able to implement basic functionality.

### 5. Workflow

* 4: Developer commits every 15 minutes
* 3: Developer commits almost every 15 minutes
* 2: Developer does not commit regularly
* 1: Developer has poor git workflow and does not commit regularly
* 0: Developer committed once

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
* Core concepts covered in the previous two Modules

In addition, we expect you to:

* Be able to explain all lines of code in your project
* Be able to interpret and implement user stories in a Rails project
* Be able to read, understand and refactor existing code
* Be able to use external resources in the problem solving process (ie: Google, Docs etc)

## Expectations

* As you work, you *should*:
  * Commit and push your code every 15 minutes.
  * Reference external public resources (ie: Google, Ruby API, etc)
  * Use the tooling most comfortable to you (Editor/IDE, testing framework, tools like Faraday and Figaro, etc)
* As you work, you *should not*:
  * Copy code snippets
  * Review old projects for code implementations
  * Seek live support from individuals other than facilitators


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
* [Rails Forms](http://guides.rubyonrails.org/form_helpers.html)
* [Rails Docs](http://api.rubyonrails.org/)

## Evaluation Criteria

See the [Assessment Evaluation Criteria](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/assessment.md#evaluation-criteria).

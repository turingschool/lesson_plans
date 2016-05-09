---
title: Rails Mini-Project Review and Refactor Session
length: 120 min
tags: Rails, Refactoring
---

### Goals

* Explore a new codebase.
* Refactor your project with the help of your pair.

### Structure

#### How do we approach a new project?

Let's get started by watching an instructor jump into a new project.

#### Pair refactor and code review

* Take this time to get with your pair begin a code review. Make sure you split the time remaining for this evenly.

##### What should I be looking for?

* Refactoring opportunities.
  * logic in views such calculations, formatting, or queries
  * unclear method or variable names
  * long methods or __unclear/unconcise__ code
  * too much login in controllers
  * Bad or hard to read formatting
* Look for things your pair did different than you did.
* How did the other person test their application?
* Refactoring within tests

## Evaluation Rubric

### 1. Feature Completeness

* 4: All features are correctly implemented along with two extensions
* 3: All features defined in the assignment are correctly implemented
* 2: There are one or two features missing or incorrectly implemented
* 1: There are bugs/crashes in the features present

### 2. Views

* 4: Views show logical refactoring into layout(s), partials and helpers, with no logic present
* 3: Views make use of layout(s), partials and helpers, but some logic leaks through
* 2: Views don't make use of partials or show weak understanding of `render`
* 1: Views are poorly organized

### 3. Controllers

* 4: Controllers show significant effort to push logic down the stack
* 3: Controllers are generally well organized with three or fewer particularly ugly parts
* 2: There are four to seven ugly controller methods that should have been refactored
* 1: There are more than seven unsatisfactory controller methods

### 4. Models

* 4: Models show excellent organization, refactoring, and appropriate use of Rails features
* 3: Models show an effort to push logic down the stack, but need more internal refactoring
* 2: Models are somewhat messy and/or make poor use of Rails features
* 1: Models show weak use of Ruby and weak structure

### 5. Testing

* 4: Project has a running test suite that exercises the application at multiple levels
* 3: Project has a running test suite that tests and multiple levels but fails to cover some features
* 2: Project has sporadic use of tests and multiple levels
* 1: Project did not really attempt to use TDD

### 6. Usability

* 4: Project is highly usable and ready to deploy to customers
* 3: Project is highly usable, but needs more polish before it'd be customer-ready
* 2: Project needs more attention to the User Experience, but works
* 1: Project is difficult or unpleasant to use, or needs significantly more attention to user experience

### 7. Workflow

* 4: Excellent use of branches, pull requests, and a project management tool.
* 3: Good use of branches, pull requests, and a project-management tool.
* 2: Sporadic use of branches, pull requests, and/or project-management tool.
* 1: Little use of branches, pull requests, and/or a project-management tool.

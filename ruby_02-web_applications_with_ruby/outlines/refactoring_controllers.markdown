### Refactoring Controllers

#### High Level

In an MVC application the Controller has a lot of jobs, which means that over time it tends to attract code. To build high-quality applications to try and push logic down the stack towards the models.

[Slides](https://www.dropbox.com/s/mkthow4ejjn9fxl/pushing_logic_down_stack.key?dl=0)

#### Learning Goals

Through this discussion you should develop a stronger understanding of:

* What does and doesn’t belong in a controller?
* Why are controllers difficult to reason about and test?
* How can we relocate appropriate logic to the model layer?
* How can we use non-ActiveRecord objects ("POROs") to help organize and simplify code?

#### Example Project

It’s best to show these kinds of problems with an actual student codebase. For this exercise we’ve selected Oregon Sale project, an implementation of the Store Engine project.

Note that this project is built on Ruby 1.9.3 which you might need to install (rvm install 1.9.3) before you can run it. You’ll also need PhantomJS to run the feature specs (brew update && brew install phantomjs).

In order to get this project to run, you may need to do some or all of the following:

1. [Install RVM](https://rvm.io/)
2. Install Ruby 1.9.3 using RVM (`rvm install 1.9.3`)
3. [Clone the Oregon Sale Repo](https://github.com/turingschool-examples/oregon_sale)
4. `cd oregon_sale`
5. `rvm use 1.9.3`
6. `brew update`
7. `brew install v8`
8. `gem install bundler`
9. `gem install therubyracer`
10. `bundle` (if this step still trips on installing `v8`, try `gem install libv8 -v '3.16.14.7' -- --with-system-v8`)
11. `bundle exec rake db:migrate db:test:prepare`
12. `bundle exec rspec spec` - Should be able to see passing tests running.
13. `bundle exec rake db:seed`
14. `rails s`, and visit `127.0.0.1:3000` to see if the front page will load.

#### Warmup

* What tools do you have to help you refactor in Ruby/Rails?
* What might you see in your code that would make you feel like you need to refactor?

#### The Rules

When attempting to push logic down the stack, keep the following ideas/questions in mind:

* Anything related to HTTP and parameters stays in the controller
* Any complexity involving data, like filtering or ordering, belongs in the model
* Let the model keep the data to itself. The controller shouldn’t have to know about the intricacies of the data types and database oddities
* Use a method in the controller before you write it in the model. Think through what data the model will need and pick a name that flows well.
* You can create Plain-Old Ruby Objects ("POROs") when you want a model that isn’t backed by a database.

#### Tools

* All of your Ruby refactoring tools that you have.
    * Splitting things into smaller methods
    * Moving things to a model or PORO
    * Creating a method to encapsulate logic
* Before action (before_filter in the oregon_sale project since it's using an earlier version of Rails)

#### In Practice

This project, like most Rails projects, has many opportunities for pushing logic down the stack. Let’s look at several refactorings all together, in small groups, and individually.

##### All Together

As a group let’s look at the following:

*Easy*: ProductsController#show
*Easy*: LineItemsController#destroy
*Medium*: UsersController#create
*Hard*: HomeController#show

##### In Small Groups

Next break into small groups and complete the following:

*Easy*: OrdersController#change_status
*Medium*: LineItemsController#increase
*Hard*: OrdersController#new

##### Individually

Finally, on your own:

*Easy*: ProductsController#retire, ProductsController#show
*Medium*: LineItemsController#decrease
*Hard*: ProductsController#update
*Challenge*: Pretty much all of SearchController

#### Additional Resources

* [Video of this class](https://vimeo.com/122066609)
* [Blog post showing some approaches to methods in this class](https://medium.com/@e_green/pushing-logic-down-the-stack-an-exercise-in-refactoring-e4995fcc9733#.9nyrirmxr)
* [Blog post containing additional thoughts about pushing logic](https://www.toptal.com/ruby-on-rails/top-10-mistakes-that-rails-programmers-make)

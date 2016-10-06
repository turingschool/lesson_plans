---
title: Model Testing in Sinatra
tags: testing, models, sinatra
---
### Goals

By the end of this lesson, you will know/be able to:

* configure Sinatra using the `set` method
* explain the purpose of a model test
* test model functionality in a Sinatra app using RSpec
* explain the differences between a development environment and test environment

## Structure

* Code-along

### Video

None yet.

### Repository

* [Task Manager: CRUD Lesson Complete](https://github.com/s-espinosa/task_manager_redux/tree/crud-lesson-complete): This branch is the result of completing the Task Manager Tutorial included in the readme of that repo and the [CRUD lesson](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/outlines/crud_sinatra.markdown). At this point, following the sequence of lesson plans, students should have their own copy of Task Manager, and should not have to clone this down.

To clone and checkout the remote `crud-lesson-complete` branch:

`git clone -b crud-lesson-complete git@github.com:s-espinosa/task_manager_redux.git model_testing`

## Code-Along

### Restructuring our Files

We're going to restructure our files in order to require all of the necessary pieces in one place -- a environment file. It is not necessary to memorize any of this section, but it's important to know what it's doing.

Make a `config/environment.rb` and add the following code:

```ruby
require 'bundler'
Bundler.require

# get the path of the root of the app
APP_ROOT = File.expand_path("..", __dir__)

# require the controller(s)
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |file| require file }

# require the model(s)
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |file| require file }

# configure TaskManagerApp settings
class TaskManagerApp < Sinatra::Base
  set :method_override, true
  set :root, APP_ROOT
  set :views, File.join(APP_ROOT, 'app', 'views')
  set :public_folder, File.join(APP_ROOT, 'app', 'public')
end
```

(Curious about [other things you can set](http://www.sinatrarb.com/intro.html#Available%20Settings) in Sinatra?)

In `config.ru`, we can now just require our environment:

```ruby
require File.expand_path('../config/environment',  __FILE__)

run TaskManagerApp
```

Remove any old configuration settings inside of your controller.

Remove any `require` or `require_relative` statements in your controller and/or models except for `require 'sqlite3'` in Task. Our `environment.rb` file now requires all of our controllers, models, and views for us.

### Setting up Model Tests

Add the following lines to your `Gemfile`

```ruby
gem 'rspec'
```

Run `bundle`.

### File structure

We'll create a spec folder. Within that folder, we'll create another folder called models. This way we can separate our model tests from our integration tests (more on this later).

```
$ mkdir spec
$ touch spec/spec_helper.rb
$ mkdir spec/models
$ touch spec/models/task_spec.rb
```

In `spec/spec_helper.rb`:

```ruby
require 'rspec'
require File.expand_path('../../config/environment.rb', __FILE__)
```

### Testing the 'new' Method

Let's write our first model test. In `spec/models/task_spec.rb`:

```ruby
require_relative '../spec_helper'

RSpec.describe "Test" do
  it 'assigns attributes correctly' do
    task = Task.new({"title"       => "a title",
                     "description" => "a description"
                    })

    expect(task.title).to eq("a title")
    expect(task.description).to eq("a description")
  end
end
```

At this point you should be able to run your tests from the command line using the command `rspec`. `rspec` will also take some flags to change the output. For a full list run `rspec --help | less`. For example, run `rspec -c -f d` to see how the output differs. If you find yourself consistently using flags you can save them to a `.rspec` file in your home directory. See [this](http://stackoverflow.com/questions/1819614/how-do-i-globally-configure-rspec-to-keep-the-color-and-format-specdoc-o) Stack Overflow answer for additional details.

### Testing the Database Connection

You may have noticed that when we tested the `new` method we were not checking to see if the task we were creating was saved to our database. In order to run that test, we would need to also test our `save` method. Let's add that now.

In our `/spec/models/task_spec.rb` file, add the following within the RSpec `describe` block:

```ruby
  describe '#save' do
    it 'saves a task to the database' do
      task = Task.new({"title"       => "a title",
                       "description" => "a description"
                      })
      task.save

      task_from_db = Task.all.last

      expect(task_from_db.title).to eq("a title")
      expect(task_from_db.description).to eq("a descripiton")
    end
  end
```

Run `rspec` again and you should now have two passing tests. Great!

Run `shotgun` and let's check to see how our application is looking. In particular, navigate to `/tasks`. Do you see the new task that's there? Where did that come from? What happens if we run our test suite again and then refresh the page?

This is not the behaviour we want. We're saving new data to our database every time we run our test suite and that's polluting the database that we're using when we browse the site locally as a user. Wouldn't it be better if we could run our test suite without making these changes?

We're going to set an environment variable in our spec helper file and then use that variable to determine which database to use. In `spec_helper.rb` add the following after all the `require` lines:

```ruby
ENV['RACK_ENV'] = 'test'
```

Now, in order to make sure that we are using a different database depending on whether or not this variable has been set, let's edit the lines in our Task class where we actually access the database. In the `initialize` method, replace the single `@database` assignment line with the following:

```ruby
  if ENV['RACK_ENV'] == 'test'
    @database = SQLite3::Database.new('db/task_manager_test.rb')
  else
    @database = SQLite3::Database.new('db/task_manager_development.rb')
  end
```

And in the `database` class method:

```ruby
  if ENV['RACK_ENV'] == 'test'
    database = SQLite3::Database.new('db/task_manager_test.db')
  else
    database = SQLite3::Database.new('db/task_manager_development.db')
  end
```

If we run `rspec` at this point, we've gone back to an error. Specifically, the error says `no such table: tasks`. What's happening here? If we check our `db` folder, we do now have a `task_manager_test` database file, but our test is telling us that the proper table hasn't been created in it. If we want to create this table we'll have to create a migration to add it to our test database.

Run `cp db/migrations/001/create_tasks.rb db/migrations/002_create_tasks_test.rb` and edit the newly created file to reference your test database. When you're done it should look something like this:

```ruby
require 'sqlite3'

database = SQLite3::Database.new("db/task_manager_test.db")
database.execute("CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,
                                      title VARCHAR(64),
                                      description VARCHAR (64)
                                     );"
                )

puts "creating tasks table for test"
```

Run `ruby db/migrations/002_create_tasks_test.rb`, and then try to run `rspec` again. At this point, you should again have two passing tests.

Run `shotgun` and you should be able to load `/tasks` to see that running our test suite now isn't adding any tasks to our development database.

### Meanwhile, In Our Test Database

We've taken the tasks that our test suite generates out of our development database, but they certainly didn't just vanish into the ether. I'd love to tell you that we can just sweep our test database under the rug and pretend it's not growing into a nasty mess, but that's not the case.

Put a `require 'pry'; binding.pry` into either of the `it` blocks in your test suite, and you should be able to run `Task.all` to see the trail of tasks we're leaving in our wake. Let's try to tidy this up a bit.

In our `spec_helper.rb` file, add the following RSpec configuration:

```ruby
RSpec.configure do |c|
  c.before(:all) do
    Task.destroy_all
  end
  c.after(:each) do
    Task.destroy_all
  end
end
```

This won't do us any good until we add that `destroy_all` method that we're planning on using to our `Task` class.

```ruby
  def self.destroy_all
    database.execute("DELETE FROM tasks;")
  end
```

Run `rspec` to check to see that your tests are still passing. If you'd like, you can add `pry` back into one of your test files to see if your database is actually getting cleared out. If so, you're in good shape.

### Worktime

* In pairs, add tests for `all`, `find`, `update`, and `delete` in the Task class. If you get stuck, checkout the `model_testing_complete` branch for the answers. This is intended to help you if you've exhausted all your other resources!
* Add model tests for RobotWorld (this is homework)

### Extensions

* None yet.

### Other Resources:

* [RSpec Documentation](http://rspec.info/documentation/): For now you'll likely be most interested in the `rspec-core`, and `rspec-expectations` links.

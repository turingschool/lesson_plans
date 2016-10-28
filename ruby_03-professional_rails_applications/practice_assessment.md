# Module 3 Practice Assessment

In this assessment you will:

*   Demonstrate mastery of all parts of the Rails stack
*   Demonstrate mastery of Ruby throughout the process
*   Integrate a 3rd Party API
*   Write tests for the added features

## Preparation

We'll be working off of [`Destination Planner`](https://github.com/turingschool-examples/destination-planner)

```
git clone git@github.com:turingschool-examples/destination-planner.git
cd destination-planner
bundle install
bundle exec rake db:{create,migrate,seed}
bundle exec rails server
```

Sign up for a Weather Underground developer key [here](https://www.wunderground.com/weather/api).
> Note: Make sure you select a free plan!

## Assessment Challenges

Work through the following challenges and get as far as you can in the allotted time.

### 1. Search 10 Day Weather Forecasts for cities

```
As a user
When I visit "/"
And I click on a destination
Then I should be on page "/destinations/:id"
Then I should see the destination's name, zipcode, description, and 10 day weather forecast
The weather forecast is specific to the destination whose page I'm on
The forecast should include date (weekday, month and day), high and low temps (F), and weather conditions
```

### 2. Create an External API for the `Destination` resource

-   RESTful routes should be created to `get`, `show`, `create`, `update`, and `destroy` destinations.
-   Routes should render JSON or an HTTP status code depending on their purpose.
-   These routes should be namespaced under `/api/v1/`.
-   Request specs should be driving the creation of these routes.

## Evaluation Criteria

As a refresher, evaluation criteria is located in the [Assessment](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/diagnostic.md#evaluation-criteria) file.

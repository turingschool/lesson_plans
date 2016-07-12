# The JSON API Standard

## What is the JSON API Standard

[The Specification](http://jsonapi.org/format/)

- [The History](http://jsonapi.org/about/#history)
- Why does it exist?
  - Bike Shedding/LookingFor  
- Do we have to use it?
- What are the important takeaways?

### Document Structure

- [Spec](http://jsonapi.org/format/#document-structure)

Typically implemented through libraries

- List of [Implementations](http://jsonapi.org/implementations/)

**Some Implementations of Note***

- [The Original - Ember Data](https://github.com/emberjs/data)
- [Redux JSON API](https://github.com/dixieio/redux-json-api)
- [Active Model Serializers](https://github.com/rails-api/active_model_serializers) [Note: said to be a little out of date with the standard]
- [JSONapiForRails](https://github.com/doga/jsonapi_for_rails)

### Returning Data

- [All Status Codes](http://www.restapitutorial.com/httpstatuscodes.html)
- [Basic Top Level Record Information](http://jsonapi.org/format/#document-resource-objects)
- [Compund Documents](http://jsonapi.org/format/#document-compound-documents)
- [Fetching](http://jsonapi.org/format/#fetching-resources)
- [CRUD functionality](http://jsonapi.org/format/#crud)

### Pagination

- [Spec](http://jsonapi.org/format/#fetching-pagination)
- [Example](http://jsonapi.org/examples/#pagination)
- [LookingFor Pagination](https://github.com/LookingForMe/lookingfor/blob/master/app/controllers/api/v1/jobs_controller.rb)
- [LookingFor Endpoint](http://lookingforme.herokuapp.com/api/v1/jobs.json)
- [api-pagination gem](https://github.com/davidcelis/api-pagination)

#### Your Turn

- Spend the next ten minutes reading the pagination spec to see if our application meets the JSON api standard.

### Error Objects

- [Twitter's API Codes](https://dev.twitter.com/overview/api/response-codes)
- [Spec](http://jsonapi.org/format/#error-objects)
- [Example](http://jsonapi.org/examples/#error-objects)

#### Your Turn

- Look through your Ideabox projects
  - What would you have needed to add to your API to render error messages in your view?

## Digging Deeper

- [How to Build Rails APIs Following the json:api Spec](https://blog.codeship.com/the-json-api-spec/)
- [How and Why You Should Use JSON API in your Rails API](http://blog.arkency.com/2016/02/how-and-why-should-you-use-json-api-in-your-rails-api/)
- [Modern Bridge Ember and Rails 5 with JSON API](http://emberigniter.com/modern-bridge-ember-and-rails-5-with-json-api/)
- [JSONAPI::Resources](https://github.com/cerebris/jsonapi-resources)

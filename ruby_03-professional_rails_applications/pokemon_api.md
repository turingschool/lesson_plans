# Pokemon CLI

We are going to be working with the [Pokemon API](http://pokeapi.co/) and create a tool that can find us poké info in no time.

This is how I feel about that.

![](https://media.giphy.com/media/MhHXeM4SpKrpC/giphy.gif)

## Part 0. Up and running

First, let's create the repo:

```sh
$ mkdir pokemon-cli && cd pokemon-cli
```

Then, create a lib folder and our Pokemon service:

```sh
$ touch pokemon_service.rb
```
---

## Part 1. The Plan

We are going to build a small tool that we can interact with in a pry session. The methods we are going to build out are the following:

```
pokemon_information
next_evolution
types
evolutions
pokemon_for_type
get
```

## Part 2. API's?

API's can be bit tricky to wrap your head around, but we can demystify them pretty easily with a few examples. Think of API's as external data, and if you ask for your data in the agreed upon way, you get the data you asked for back. API's are databases and each action in the controllers are referred to as `endpoints`. `/turing-school/students/dj-greenfield` is an example of an endpoint. Think of the endpoints as the available routes in an application for the developer to send requests to.

```
_______                                                                     _________
| MY  | -----------> GET /turing-school/students/dj-greenfield -----------> | Turing |   
|     |                                                                     |        |
| APP | <------ {student: { name: "DJ Greenfield", cohort: 1412}} <-------- |  API   |
|_____|                                                                     |________|

```

We make a `GET` request from our app to the Turing API hitting the `/turing-school/students/:name` endpoint. The API returns information about the given student.

Let's make some calls to the GitHub API using curl.

We can ask for all info about a repo, using the conventions outlined in the [GitHub API docs](https://developer.github.com/v3/).

```sh
$ curl -i "https://api.github.com/repos/rails/rails"
```

We can also ask for all the issues related to the repository:

```sh
$ curl -i "https://api.github.com/repos/rails/rails/issues"
```

And get all the closed issues:

```sh
$ curl -i "https://api.github.com/repos/rails/rails/issues?state=closed"
```

#### Your turn

* Can you find all open issues related to the repo?
* Can you find all languages related to the repo?
* Can you find the forks url related to the repo?
* Can you find all stargazers related to the repo?

#### Additional resources

* [GitHub API docs](https://developer.github.com/v3/)
* [Quora: What is an API?](https://www.quora.com/What-is-an-API)

## Part 3. Establishing a connection

We are going to use the Pokemon API to find information about our favorite Pokemon. If you don't have a favorite Pokemon, pick Pikachu.

![](https://media.giphy.com/media/MJcf161ptwviU/giphy.gif)  

In `pokemon_service.rb`, add a method `get` we can use to send requests to the Pokemon API:

```
require 'net/http'
require 'json'

class PokemonService

  def get(url: url = "http://pokeapi.co/api/v1/", path: path)
    uri = URI(url + path + "/")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

end
```

We require the `net/http` library so we can make GET requests from our Ruby program, and we require JSON to be able to parse the JSON response we get back from the API.

We are passing the path to the method and the base url is set as a default argument in case we would like to talk to different APIs. The first line composes the URL using the base URL and the path that we are going hit. The path defines which endpoint we hit in the API.

On the second line we make the request using the `Net::HTTP` library. This is just a regular stdlib Ruby library, it's built into Ruby but we need to require it (like JSON) since it's not required by default. The return value will be a JSON hash that we parse on the last line of the method.

Try it out from the command line!

* Open a new pry session.
* Require `./pokemon_service`.
* Create a new instance of the Pokemon Service, `pokemon_service = PokemonService.new`.   
* Send a request to get information about a Pokemon, `response = pokemon_service.get(path: 'pokemon/25')`

Yeeei! We have information about a Pokemon! Check out the Pokemon API docs linked below

**NOTE:** you can search Pokemon both by id and by name, so `path: pokemon/25` and `path: pokemon/pikachu` return the same data.

#### Your turn

From the command line, find the following information using the response:
* Name of the Pokemon
* Find the Pokemon's types
* Find the Pokemon's evolutions

Make a new request and find the following Pokemon:
* A Pokemon with the id of 500
* A Pokemon with the name of "squirtle"

**NOTE:** All Pokemon names need to be lowercased in the query.

#### Additional resources

* [Pokemon API docs](http://pokeapi.co/docsv2/)
* [Net::HTTP docs](http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/Net/HTTP.html)

## Part 4. Interacting with the Poké API

We are going to write some code that will find Pokemon by id, name and type. Id and name are interchangeable in this API, so the method we are going to write will be able to return information about a Pokemon given either its name or id.

Let's see if we can find a way to get information about a Pokemon given it's name (or id).

```rb
def pokemon_information(info)
  path = "pokemon/#{info}"
  get(path: path)
end
```

Hop over to the pry session and see if you can use our new method to get information about Pokemon!

It should behave as follows:

```sh
[1] pry(main)> require './pokemon_service'
=> true
[2] pry(main)> p = PokemonService.new
=> #<PokemonService:0x007fefe0d274b8>
[3] pry(main)> response = p.pokemon_information(7)
=> # a bunch of code
[3] pry(main)> response["name"]
=> "Squirtle"
```

#### Find all moves for a given Pokemon

We would like to output an array of strings with the names of the Pokemon's moves.

If you go to `http://pokeapi.co/api/v1/pokemon/25/` in the browser you see that the Pokemon has a `moves` key which points to an array with JSON objects. We want to get the array with JSON objects, iterate over it to collect the names of the moves, and then return them.

```rb
def get_moves_for(pokemon)
  response = pokemon_information(pokemon)

  response["moves"].map { |move| move["name"] }
end
```

#### Find the next evolution for a given Pokemon

Write a method that behaves as follows:

```
id = 7
response = PokemonService.new.next_evolution(id)
#=> "Wartortle"
```

#### Your turn

Write a method that returns all of the evolutions for a given Pokemon. This is necessary because some Pokemon have more than one evolution, but the Pokemon API only returns the immediate evolution (as seen in the latest method).

For example:

```
id = 7
response = PokemonService.new.evolutions(id)
#=> "Wartortle", "Blastoise, Blastoise-mega"

name = "lapras"
response = PokemonService.new.evolutions(name)
#=> ""
```

## Part 5. Interacting even more with the Pokemon API

It's soon time for us to part ways, but before we do there are a few more methods we need to implement.

### Get all types related to a Pokemon

Write a method that returns all types related to a given Pokemon.

For example:

```
id = 7
response = PokemonService.new.types(id)
#=> "water"

id = 6
response = PokemonService.new.types(id)
#=> "flying, fire"
```

### Get all Pokemon related to a type

Write a method that returns all Pokemon related to a given type.

For example:

```
type = "fire"
response = PokemonService.new.pokemon_for_type(type)
#=> "Name", "Name", "Name".....

type = "water"
response = PokemonService.new.pokemon_for_type(type)
#=> "Name", "Name", "Name".....
```

**NOTE:** There are 718 total Pokemon availble in the API.

#### Your turn

Be like no one ever was and make your methods more flexible in terms of arguments.

* Change the `#pokemon_for_type` method to receive two types and find all Pokemon that match both types given.

```
PokemonService.new.pokemon_for_type("flying", "fire")
#=> "Charizard", "Moltres"....
```

## Part 6. Now you are really on your own...

If you want more practice with APIs, check out this micro-twitter [tutorial](http://tutorials.jumpstartlab.com/projects/microblogger.html).

If you feel comfortable with this material, use the GitHub API (or find an API on your own) to create a similar program.

API Suggestions:

* [The Open Movie Database](http://www.omdbapi.com/)
* [Sunlight - Government Data](https://sunlightfoundation.com/api/)

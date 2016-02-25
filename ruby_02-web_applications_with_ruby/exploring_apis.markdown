---
title: Exploring APIs
length: 180
tags: api
---

Let's experiment with accessing an API! In this tutorial, you'll be working with the OpenWeatherMap API. 

### What is an API?

An Application Programming Interface (API) allows one piece of software to interact with another piece of software. 

**Consuming** an API means you ask another application for some information or service. 

**Providing** an API means that others can ask you for some information or service. 

### Popular APIs

* Twitter
* Instagram
* Facebook
* Google Maps
* YouTube
* Yelp
* AccuWeather
* Pinterest

### Examples of Student Projects that use APIs

* Tom Leskin: http://burritofinder.herokuapp.com/ (Google Maps)
* David Shim: http://medicosts.herokuapp.com/ (Medicare Inpatient Payment System)
* Rose Kohn: https://podlist.herokuapp.com/ (audiosear.ch) 
* Kristina Brown: http://park-finder.herokuapp.com/ (YouTube, Yelp, and Mapbox)
* Max Tedford: https://road-tripper.herokuapp.com (Google Maps)
* Emily Dowdle: https://lactationstation.herokuapp.com/ (Twitter, Open FDA)
* Adam Jensen: https://sodata.herokuapp.com (Socrata and Google Maps) 
* Lori Culberson, Mihir Parikh, Tracey Caruso: http://marvel-us.herokuapp.com/ (ComicVine and Twitter)
* Pat Wey: http://corkboard-patwey.herokuapp.com/ (Github) 
* Jhun de Andres: http://ratinganimals.herokuapp.com/ (Trelora, OpenWeatherMap) 

### Using Ruby to access an API 

[Faraday](https://github.com/lostisland/faraday) is a Ruby Gem (you can think of a gem as a collection of code that someone else has written) that can be used to make HTTP requests.

To install a gem in Ruby, we type `gem install faraday` on the command line. This will put the source code on our machine.

Next, we'll access the interactive Ruby shell ("irb"). IRB is like a playground where we can try out things in Ruby.

From the command line, type `irb`:

```
$ irb
```

Once we're inside of irb, we'll bring in the Faraday library, then send a request to `example.com`:

```ruby
require 'faraday'
Faraday.get('http://www.example.com')
```

### Working with the OpenWeatherMap API

Faraday is helpful when fetching API data, too. 

Most APIs require that you have a key in order to access data. I've already registered for a key with OpenWeatherMap. If you'd like to register your own key, you can get one by [creating an OpenWeatherMap account](http://home.openweathermap.org/users/sign_up). 

The key I was given was `442eba5b3e3a3ae8ead5698479bcdaa8`. Notice that I've appended `APPID=442eba5b3e3a3ae8ead5698479bcdaa8` to the end of the URL. This will allow OpenWeatherMap to identify me and approve my request. 

```ruby
require 'faraday'
response = Faraday.get('http://api.openweathermap.org/data/2.5/weather?q=Denver,us&units=imperial&APPID=442eba5b3e3a3ae8ead5698479bcdaa8')
raw_data = response.body
```

The data we get back is JSON data (JavaScript Object Notation). This is a machine-readable format that is easy for many programming languages to process. You can find the format of the JSON response on the [OpenWeatherMap Forecast Documentation](http://openweathermap.org/forecast5). 

In order to parse JSON with Ruby, we'll do this:

```ruby
require 'json'
data = JSON.parse(raw_data)
```

It's still not easy to read, so let's pretty-print it:

```ruby
require 'pp'
pp data
```

We get back a result that looks like this:

```ruby
{"coord"=>{"lon"=>-104.98, "lat"=>39.74},
 "weather"=>
  [{"id"=>800, "main"=>"Clear", "description"=>"Sky is Clear", "icon"=>"01d"}],
 "base"=>"cmc stations",
 "main"=>
  {"temp"=>48.5,
   "pressure"=>823.46,
   "humidity"=>70,
   "temp_min"=>48.5,
   "temp_max"=>48.5,
   "sea_level"=>1037.81,
   "grnd_level"=>823.46},
 "wind"=>{"speed"=>5.53, "deg"=>345},
 "clouds"=>{"all"=>0},
 "dt"=>1455054295,
 "sys"=>
  {"message"=>0.0078,
   "country"=>"US",
   "sunrise"=>1455026341,
   "sunset"=>1455064187},
 "id"=>5419384,
 "name"=>"Denver",
 "cod"=>200}
 ```

We can scope into this data object by using the levels of indentation. So everything at the outside level, we can access like this:

```ruby
data["coord"]
data["base"]
data["main"]
data["wind"]
data["clouds"]
data["dt"]
data["sys"]
data["id"]
data["name"]
data["cod"]
```

To get anything at the secondary level, we need to access the initial level (or "key" in Ruby-speak), and then the secondary level:

```ruby
data["main"]["temp"]
data["main"]["pressure"]
data["main"]["humidity"]
data["wind"]["speed"]
data["sys"]["sunrise"]
```

Another thing we can do is use an OpenStruct in order to access the data with dot notation. To do this, we'll need to parse the JSON slightly differently:

```ruby
data = JSON.parse(response.body, object_class: OpenStruct)
data.name
```

### Workshop

Now that you know how to make a call to an API and parse JSON that you get back, you'll use the NYTimes API in order to build a program that can grab the top stories of the day. You'll need to register for your own account in order to get keys. **DO NOT PUSH YOUR API KEYS TO GITHUB.**


Use the [NYTimes Top Stories API](http://developer.nytimes.com/docs/top_stories_api/) to create an interface where a user enters the following command...

```
$ ruby top_stories.rb sports
```

...where the argument represents the section. The program should print out the article title, author name, date published, abstract, and the URL for the article. 

### Extension: Playing with Twilio

You can use Twilio to send and receive text messages, in addition to other fun telephone-related stuff. 

Make a directory for your project. `cd` into that directory. 

Create a `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'twilio-ruby'
```

Next, you'll need to register for Twilio:

1) Sign up for account: https://www.twilio.com/try-twilio and select "SMS alerts" under "What are you building"
2) Verify your phone number
3) Click "Get your first Twilio Number" and select a phone number
4) Click "Show API Credentials" in small red text in the upper right-hand side of the page.

Once you see the credentials, export them in your terminal:

```
$ export ACCOUNT_SID=pasteyouridhere
$ export AUTH_TOKEN=pasteyourtokenhere
```

NOTE: These environment variables are *only* valid in the terminal window where you export them. Therefore, you'll need to run the program in the same terminal window. Also, make sure to not have spaces inbetween!

Now, let's make our program: 

```
$ touch message_sender.rb
```

Then inside of that file:

```ruby
require 'rubygems'
require 'twilio-ruby'
 
account_sid = ENV["ACCOUNT_SID"]
auth_token  = ENV["AUTH_TOKEN"]

client = Twilio::REST::Client.new(account_sid, auth_token)
from   = "+18127270809" # Your Twilio number
data   = {
  :from => from,
  :to => "+13334447777", # format of this number needs to be "+1" at the beginning of the area code and phone number
  :body => "I'm using an API!",
}

client.account.messages.create(data)

puts "Sent message!."
```

### Extension to the Extension

Incorporate SMS messaging in your ToolChest so that an admin gets a text every time someone creates a new tool. 

### Extension to the Extension's Extension

Replace the SMS with a phone call. Create functionality so that the admin hears the name and price of the tool was created and can press a button to approve or deny the tool's existence. 

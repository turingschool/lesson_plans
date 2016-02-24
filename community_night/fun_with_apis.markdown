# Turing Community Night: Fun with APIs

### Intro

Check out the [slides](https://www.dropbox.com/s/lg82paogkwt9xcb/Turing%20-%20Fun%20with%20APIs.key.pdf?dl=0). 

### Demo: Using Ruby to access an API 

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

#### Working with the OpenWeatherMap API

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

### Workshop: Playing with APIs

If you have Ruby installed on your machine, great! You can open up your command line and get started by installing the Faraday gem (`gem install faraday`) and using irb. If you don't have Ruby installed, use the [Cloud9](https://c9.io/) online IDE by following the instructions below: 

* Click "Try it Now"
* Fill in username, email, and password
* Click "Create your free account"
* Click "Go to your dashboard"
* Click "Create a new workspace"
* In "Workspace name", type "fun-with-apis"
* Don't fill in or select anything else; just click "Create workspace" at the bottom
* Wait for your workspace to load 
* The navy blue box at the bottom is where you'll use irb. 

#### Easy: Getting Current Weather for Chicago

Use the OpenWeatherMap API to get the current weather for Chicago. 

##### Solution

From your command line, install faraday:

```
$ gem install faraday
```

Then enter `irb` in order to get into the interactive Ruby console:

```
$ irb
```

Once inside of irb, type the following: 

```ruby
require 'faraday'
require 'json'

response = Faraday.get('http://api.openweathermap.org/data/2.5/weather?q=Chicago,us&units=imperial&APPID=442eba5b3e3a3ae8ead5698479bcdaa8')
raw_data = response.body

data = JSON.parse(raw_data)
data["main"]["temp"]
```

#### More Challenging: Forecasting for any city

Write a program `weather_forecast.rb` that accept a command-line argument for a city and returns a forecast list like this:

```
2016-01-08 06:00:00 -- 34.7 degrees
2016-01-08 09:00:00 -- 32.1 degrees
...etc...
```

In order to do this, you'll need to access the `forecast` endpoint here: `'http://api.openweathermap.org/data/2.5/forecast?q=Chicago,us&units=imperial&APPID=442eba5b3e3a3ae8ead5698479bcdaa8'`.

You'll need to iterate through the `"list"` key in the returned JSON data. Each `"dt"` key represents a datetime for a forecast. There should be several elements inside of the returned JSON data for each date. Look for the `"dt_txt"` key in the returned JSON data. 

#### Solution

From your command line, install faraday:

```
$ gem install faraday
```

Then make your `weather_forecast.rb` file:

```
$ touch weather_forecast.rb
```

Inside of that file, type the following:

```ruby
require 'faraday'
require 'json'

city = ARGV[0]

response = Faraday.get("http://api.openweathermap.org/data/2.5/forecast?q=#{city},us&units=imperial&APPID=442eba5b3e3a3ae8ead5698479bcdaa8")
raw_data = response.body
data     = JSON.parse(raw_data)

data["list"].each do |forecast|
    puts "#{forecast["dt_txt"]} -- #{forecast["main"]["temp"]} degrees"
end
```

To run your program from the command line:

```
$ ruby weather_forecast.rb Denver
```

Or for a different city:

```
$ ruby weather_forecast.rb Chicago
```

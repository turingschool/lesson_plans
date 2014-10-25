---
title: Consuming Apis
length: 90
tags: apis, 500px, json, faraday, twitter, foursquare, flickr, npr
status: draft
---

## Learning Goals

* Practice pulling data from public APIs using both faraday/curl and
  dedicated wrapper libraries
* Understand some common organizational patterns for public APIs
* Practice retrieving nested data from multi-level JSON structures
* Understand API tokens and application registration

## Structure

* 5 - Warmup / Discussion
* 20 - Walkthrough: 500px API interactions via Curl and Faraday
* 5 - Break
* 10 - Walkthrough: 500px API interactions via wrapper gem
* 15 - Dig In: Pair up and start independent API explorations
* 5 - Break
* 20 - Continue API explorations
* 5 - Questions & Recap

## Warmup

Discuss some intro questions to get those API brain juices
flowing:

```
1. What are the most common use-cases for a service to provide an API? Why bother?
2. What APIs have you used in the past?
3. What are some ways for sending input data _to_ an API?
```

## Consuming APIs with HTTP & Wrappers

* 500px.com is an image sharing service
* API documentation: https://github.com/500px/api-documentation
* Developers portal: https://developers.500px.com/

### Commands for CURL Experimentation

```
curl 'https://api.500px.com/v1/photos?feature=popular'
curl 'https://api.500px.com/v1/photos?feature=popular&consumer_key=Ou5TL8cnyb5icBfcx2y2i5HykUPNGE3XhwpQ67Io'
curl 'https://api.500px.com/v1/photos/56265734?consumer_key=Ou5TL8cnyb5icBfcx2y2i5HykUPNGE3XhwpQ67Io'
curl https://gp1.wac.edgecastcdn.net/806614/photos/photos.500px.net/56265734/c59fde5263b760512ea36707a68c869aa7011d0c/4.jpg > /tmp/image.jpg
open /tmp/image.jpg
```

### Commands for HTTP Experimentation

```
Faraday.get('https://api.500px.com/v1/photos?feature=popular')
Faraday.get('https://api.500px.com/v1/photos?feature=popular&consumer_key=Ou5TL8cnyb5icBfcx2y2i5HykUPNGE3XhwpQ67Io')
photo_response = Faraday.get('https://api.500px.com/v1/photos/56265734?consumer_key=Ou5TL8cnyb5icBfcx2y2i5HykUPNGE3XhwpQ67Io')
require 'json'
photo_json = JSON.parse(photo_response.body)
url = photo_json["photo"]["image_url"]
File.open('image.jpg', 'w'){|file| file.write( Faraday.get(url).body )}
System.call('open image.jpg')
```

### Commands for Wrapper Experimentation

* `gem install f00px`
* https://github.com/500px/f00px

```
require "f00px"
require "json"

client = F00px::Client.new
client.consumer_key = 'Ou5TL8cnyb5icBfcx2y2i5HykUPNGE3XhwpQ67Io'
body = client.get('photos/56265734').body
data = JSON.parse(body)
data["photo"]["image_url"]
```

### Registering an Application

As we have seen, many APIs require a token of some sort to access
parts of the API. Usually you have to register with the provider to
attain one of these tokens.

https://500px.com/settings/applications

### APIs for Experimentation

#### Foursquare

* Documentation: https://developer.foursquare.com/docs/
* Gem: https://github.com/mattmueller/foursquare2
* Apps: https://foursquare.com/developers/apps
* API Explorer: https://developer.foursquare.com/docs/explore#req=users/self

(Foursquare's interactive API explorer is one of the nicer ones out
there IMO)

See if you can retrieve a list of venues near Turing (lat/long: 39.7496354, -105.0001058)

What data is available with only an application token and secret?
What actions require an authenticated user token?
What is the "version" parameter that foursquare requires?

#### Flickr

Demo Api Key:
`1c5111342219c4fab62e164fce5e28f6`
Demo Api Secret: `36454725931308aa`
https://www.flickr.com/services/apps/by/127167934@N07

* Documentation: http://www.flickr.com/services/api/
* Flickraw gem: https://github.com/hanklords/flickraw
* Flickr-objects gem: https://github.com/janko-m/flickr-objects

Try pulling some images from the "latest" feed (similar to how we did
with 500px above).

#### Twitter

* Documentation: https://dev.twitter.com/docs/api/1.1
* Twitter gem: https://github.com/sferik/twitter
* Dev console (nice for in-browser experimentation): https://dev.twitter.com/rest/tools/console
* Test keys: https://apps.twitter.com/app/7110558/keys

- Can you load the last tweet from j3? How many
  followers does he have?
- Can you get the public twitter uri for a user loaded through the
  gem?

#### NPR

* Documentation: http://www.npr.org/api/index
* NPR Gem: https://github.com/bricker/npr

- Can you find the station closest to Turing (zip 80202)?

#### Any others? What APIs are you curious about?

## Bonus

## Corrections & Improvements for Next Time


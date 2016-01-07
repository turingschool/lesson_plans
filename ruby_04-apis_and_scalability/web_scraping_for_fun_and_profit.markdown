---
title: Scraping for fun and profit
length: 90
tags: markup, scraping, node
status: one-off (Good luck repeating)
---
# Goals
- Experience a use for programming other than web applications
- Be able to traverse and understand HTML that you didn't write
- Learn a new tool for integration testing

# Context
You're going to crowdfund a new tool for teaching programming. You want to find out what similar projects have done. What was successful? What wasn't? How much money are projects asking for? What are they offering for rewards?

# Structure
*This only adds up to 80 minuts. Take 10 minutes as you please*
- 20 - Code Along
- 5 - Work in pairs
- 5 - Share solutions
- 10 - Work in pairs
- 5 - Share solutions
- 10 - Work in pairs
- 5 - Share solutions
- 10 - Lecture
- 10 - Wrap Up
# Code Along (20)

## Step 1 - Request and parse a URL
Let's do some node installation
```
npm install nightmare prettyjson
```
We're going to use Nightmare to request a URL
``` project.js
var Nightmare = require('nightmare');

Nightmare()
  .goto('https://www.kickstarter.com/projects/728836843/codrone-learn-to-code-with-programmable-drone/description')
  .then(function(){
    console.log("done!");
  })
  .end()
```
Now we can execute jquery on the page we've loaded, and pass data back to our node application, and ultimately the console. Let's extract the title of the page.
```
Nightmare()
  .goto('https://www.kickstarter.com/projects/728836843/codrone-learn-to-code-with-programmable-drone/description')
  .evaluate(function (){
    return $('title:first').text();
  })
  .then(function(){
    console.log("done!");
  })
  .end()
```
# Code in pairs
## Step 2 - Extracting single values
Extract the amount pledged, the project goal, and the number of backers. Output them as json, like the following:
```
{ backers: 36, goal: 50000.0, pledged: 5960.0 }
```
## Step 3 - Repeated Values
Extract the pledge amount and description for each reward
```
{ rewards: [
    { pledge_amount: 119, description "SUPER EARLY BIRD SPECIAL:

Be the first ones to receive Codrone with a discounted rate.

Regular retail price will be $179" },
...
]}
```
## Step 4 - Search page

Scraping one project is cool, but not that useful. Write a new script that parses a search page, and outputs urls of other projects to scrape.

# What would be next?
You have the basics down. If you wanted to get serious about this scraping project, you might try some of the following:
- Programatically process the parsed project URLs from the search page
- Store your results in a csv file, or in a database
- Write a script to parse completed projects. The page layout is different if the campaign has completed

# Lecture
What you've learned here is cool, but can also be used for integration testing. Nightmare.js is a simple way to request URLs and work with them. Why not assert things while you're at it?

For instance, Nightmare's documentation has [an example using the mocha testing framework](https://github.com/segmentio/nightmare#examples)

Nightmare is not the only option for requesting and parsing web pages programatically. Take a look at [Cheerio](https://github.com/cheeriojs/cheerio) as another javascript option and [Nokogiri](https://github.com/sparklemotion/nokogiri) in ruby
# Wrap up
- The web is made by other people, and they don't know something magic that you don't know
- Scraping can be dirty. Pages change. Consider the scope of your project. Does your scraper need to be robust or does it need to work once?
- Programming has uses other than applications. You can make computers do your bidding. You have a superpower now. You can use it for good or evil.

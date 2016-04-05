# Social Engineering and Stupid Web "Hacking" for Fun & Profit

## Learning Goals

* The idea of server-side content generation and client-side rendering
* HTML is just text
* JavaScript brings web pages alive
* The web console allows us to execute our own JavaScript

## Session

### Part 1: How the Web Works

* Browser
* Request
* Server
* Response
* Parsing
* Rendering
* Runtime Execution

### Part 2: Cookies

* Modifying the request/response loop to add a cookie
* Cookies are created server side
* Cookies are stored client side
* Cookies are read server side

#### So what?

* Can we modify a cookie? Maybe, but hopefully not
* Can we read a cookie? Maybe, but probably not
* Can we live without a cookie? Absolutely.

#### Manipulating Cookies

* Clearing/Destroying them
* "Incognito"/Private Browsing

#### Why Do It?

* Visit limiting happens via Cookies
* Poorly implemented applications don't encrypt/sign their cookies
* View the "naked web" without customization, retargeting, etc

#### Examples

* Paywall: [Boston Globe](http://www.bostonglobe.com/)
* Paywall: [Daily Telegraph](http://www.telegraph.co.uk/)
* Retargeting: [Washington Post](https://www.washingtonpost.com/)

### Part 3: Content & Client Side Rendering

* Content is generated on the server
* Rendered on the client, your client, only your client

#### Modifying Content

* Can you modify what the server sends?
* Can you modify what *you* see?

#### Why Do It?

* Printed pages have credibility
* Changing values before printing / render to PDF
* Hiding content like ads

#### How to Do It

* Editing the HTML directly in the DOM browser
* Using just a bit of jQuery

#### Does It Work?

* One time I bought a car
* Lifeguarding isn't that serious
* Ads can be ugly/annoying

#### Examples

* Modifying [a Car Listing](http://www.carmax.com/enus/view-car/default.html?id=11621735)
* More [Followers on Twitter](https://twitter.com/turingschool)

#### Code Snippets

* Hide all images on Twitter: `$('img').hide();`
* Hide ads on Washington Post: `$('.img_ad').hide()`

Find the headlines on the Washington Post:

```
jQuery.map(jQuery('div.headline'), function (element) {
    return jQuery(element).text();
});
```

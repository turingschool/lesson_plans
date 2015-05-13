---
title: Building a Personal Webpage
length: 90
tags: html, css
---

## Codepen.io (5 min)

* have students navigate to codepen.io and click "New Pen"
* What is it? 
* Setup: close JS window, move editor boxes to right side of page
* Explain that the code we write in the editor boxes will immediately render in the large window

## HTML vs. CSS (3 min)

* both languages that computers interpret to make things appear in a web browser
* HTML is used for the structure: images, links, paragraphs, headings, boxes, etc.
* CSS is used for the style: colors, backgrounds, fonts, borders, position, etc.

## Super Basic HTML Overview (5 min)

* the code that allows us to build websites
* stands for HyperText Markup Language
* we create structure of a page with HTML elements
* HTML elements (almost) always have an opening and closing tag: `<html> </html>`
* closing tags contain a `/` whereas opening tags do not
* with HTML, we can nest tags inside of each other (it will look like a triangle):

```
<div>
  <ul>
    <li></li>
  </ul>
</div>
```

## Super Basic CSS Overview (5 min)

* the code that allows you to style your website
* stands for Cascading Style Sheet
* we can style HTML elements like this:

```css
body {
  background-color: red;
}
```

* we can target specific HTML elements to style by giving them a class, like this:

```html
<div class="about-me"></div>
```

```css
.about-me {
  background-color: red;
}
```

## Workshop: Making Our Webpage (60 min)

See [this Codepen](http://codepen.io/anon/pen/myxjoz) for an example of what we'll create.

We'll do this section in chunks; I'll demonstrate something, then volunteers will help students implement the skill in their own website.

* set up html doc structure
* all HTML pages start with this initial setup:

```html
<html>
<head>
  <meta charset="UTF-8">
  <title>Document</title>
</head>
<body>
  
</body>
</html>
```

* the title tag is used for what the tab on top will display - have students add a title (can't see it on Codepen)
* all of the content we want the user to see on the webpage will go inside of the <body></body> tags
* create three divs inside of body tags indented correctly:

```html
<body>
  <div>
  </div>

  <div>
  </div>

  <div>
  </div>
</body>
```

* add a class of "about" to first div, "favorites" to second div, "family" to third div
* style divs (height of 300ish px and give them a background-color -- use [colourlovers.com](http://www.colourlovers.com/palettes)) by targeting the class of the div in the stylesheet:

```css
.about {
  background-color: red;
  height: 300px;
}

.favorites {
  background-color: blue;
  height: 300px;
}

.family {
  background-color: yellow;
  height: 300px;
}
```

* create h1 "About Me" inside of first div  
* style that h1 (text-align: center)
* create an image inside of the first div (students can grab a link to a picture off of Facebook, Twitter, etc.)
* add a paragraph of text under image
* create h1 "My Favorite Websites" for second div
* create unordered list of favorite things inside of second div
* add links inside of <li> elements to link to favorite things
* change link style and color with text-decoration: none and color: (something)
* add h1 "My Family" for third div
* add another image for family
* margin vs. padding
* bold (`<strong>`), italic (`<em>`)
* serif vs. sans-serif for body
* if time permits, add nav bar at top with links that anchor to specific parts of the website
* a:hover also if time permits

## Closing

* students share websites with other participants
* go around room and share one thing they learned
* create Codepen.io account if they want their work saved
* remind students that they can log back in and work on website whenever they want

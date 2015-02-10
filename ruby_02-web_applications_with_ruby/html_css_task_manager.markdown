---
title: HTML and CSS in TaskManager
length: 180
tags: html, css, sinatra, layouts
---

## Learning Goals

* access and manipulate CSS from the Chrome Developer Tools
* use a `layout.erb` file in Sinatra for a common structure
* style and position HTML elements using CSS

## Structure

* 10 - Setting up a Layout in Sinatra
* 80 - Worktime: Styling TaskManager
* 30 - Wrap-up, Share Out, Reflection

## Full-Group Instruction

### Layouts and Views in Sinatra

* `views` folder - html/erb files
* `public` folder - css, js, images
* `views/layout.erb` will automatically render around any other `.erb` file that you specify to render in your route block

```erb
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="stylesheet" href="/application.css">
  <title>My Sinatra Application</title>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

```

## Styling TaskManager

* Center the `.container` div
* Remove underlines from all hyperlinks
* Change the style of the hyperlinks when a mouse hovers over them
* Create a horizontal navbar on the top of the page that contains links to all tasks and create task
* Style the individual tasks in separate divs
* Design a landing page (`'/'`)
* Add a footer with your name and a link to your repo on Github

### Extensions

* Gradually transition the color of a hyperlink when a mouse hovers over it
* Make the page responsive to different screen sizes (desktop, tablet, mobile)

## Wrap-Up

Let's pair up and share our finished products. 

## Resources

* [Khanacademy's HTML & CSS](https://www.khanacademy.org/computing/computer-programming/html-css)
* [Learn Layout](http://learnlayout.com/)
* [CSS is Awful](http://static.incompl.com/awful/)
* [Learn CSS MDN](https://developer.mozilla.org/en-US/learn/css)
* [Safari Web Content Guide: Configuring the Viewport](https://developer.apple.com/library/ios/documentation/appleapplications/reference/safariwebcontent/usingtheviewport/usingtheviewport.html)
* [CSS Transitions](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Using_CSS_transitions)
* [CSS Transformations](https://developer.mozilla.org/en-US/docs/Web/CSS/transform)

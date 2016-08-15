---
title: Introduction to CSS Frameworks
length: 180
tags: bootstrap, css
---

###  Goals

By the end of this lesson, you will know/be able to:

* Have a basic understanding of Bootstrap and its capabilities.
* Learn how adding Bootstrap classes to an element can change its style.
* Learn how to use the Bootstrap documentation to solve issues.
* Understand what responsive web design is.
* Understand the container.
* Understand the grid system of CSS Frameworks.
* Understand how to use glyphicons.
* Be able to translate this knowledge to other CSS Frameworks including, but not limited to Skeleton, Materialize and Foundation.

## Checking for Understanding - Ask In Slack to Respond from 1 - 10

* I know what Bootstrap is.
* I can use Bootstrap in my projects.

## Intro/Review (5 minutes)

We will be using this [repository](https://github.com/s-espinosa/styling_with_bootstrap)

* Content is the stuff that we're trying to present on a page.
* HTML is a markup language used to describe and tag our content.
* HTML gives us some default styles in browsers.
* CSS gives us additional control over the presentation of our content.

Questions (pick random students)

* Raise your hand if you got your site to a point where it looked the way you wanted it to?
* Of those who don't have their hands up, why not?
    * Was there something you wanted to do that you couldn't figure out?
    * Was it just the general style?

## Lecture (5 - 10 minutes)

* What is Bootstrap?
    * CSS/JS framework
    * Provides CSS/JS and reduces amount we have to write to get the same effect.
    * Have students open up style used in the link page in the cloned repo
        * CSS I created is not too long, but this is a very simple page.
        * Bootstrap CSS is very long. Gives us a lot to work with. Represents CSS that we don't have to write ourselves.
* Advantages
    * Pre-styled components
    * Responsive - For devices with different sizes (phone, tablet)
* Examples
    * Show examples on screen in slides
    * Also have students open the examples provided in the links and re-size their windows.
    * Point the students towards github.com to show what it looks like when a website isn't responsive.
* Question to the students: how would I figure out how to use Bootstrap?
    * Google
    * Bootstrap homepage
        * Getting Started

## Demo: three column layout (10 minutes)
* Visit the Bootstrap Getting Started page
    * Create a new directory for this demo
    * Download Bootstrap, unzip and copy into the project directory
    * Copy the basic template and put it into a file in our project directory
    * Read the template and review each line (especially the links to our css/js)
    * Move the bootstrap css, fonts, and js folders to the root of the directory
    * Open the template in the browser to see what we have
* Add content and tags
    * Find three paragraphs of ipsum
    * Add the paragraphs as content to the page along with titles for each paragraph
    * Add h2 tags to the titles
    * Open again
    * Use * { border: 1px solid black } and/or the element inspector to show where columns are
* Add Bootstrap
    * Go back to the Bootstrap site to see what we can find on grids.
    * Copy the HTML from the 'stacked to horizontal' portion of the page
    * Paste into our HTML file
    * Open again to see what we have
    * Copy our content into the columns, get rid of excess content
    * Open to see if we have what we want
    * Tweak if necessary
* Add custom CSS
    * .column { background-color: navy; }
    * body { color: white; }

## Code Along: nav bar (10 minutes)
* Same set-up as above: visit the Bootstrap Getting Started page
    * Create a new directory for this demo
    * Download Bootstrap, unzip and copy into the project directory
    * Copy the basic template and put it into a file in our project directory
    * Move the bootstrap css, fonts, and js folders to the root of the directory
    * Open the template in the browser to see what we have
* Add navbar
    * Go to the Bootstrap site and see if we can find the code for a navbar
    * Copy code into our index.html template file
    * See what we have
    * Replace with some of our content
    * Remove content that isn't being used
* Check to make sure everyone has a navbar on their screen.
* If not, check with instructors to see if we can figure out why not

## Questions (2 minutes)
* What does bootstrap offer? Why would you use it?
* How do you get Bootstrap into your project? Put another way, what are the steps to set it up?
* How do you apply Bootstrap styles?
* Do you think you’ll use Bootstrap in your projects? Why/why not?
* Can you describe responsive design in your own words?

## Workshop (2 - 2.5 hours with instructor checking in on progress)

* In the repo you cloned there's a taylor folder and a kanye folder
* Each has a screenshot
* See if you can recreate the screenshot using the files provided
* Taylor has more substantial starting files (including an html file and Bootstrap files)
* Kanye has just the content and images
* Start with Taylor, then Kanye
* Any time left over work on additional Bootstrap/custom CSS OR see if you can recreate without Bootstrap

## Checking for Understanding - Ask In Slack to Respond from 1 - 10

* I know what Bootstrap is.
* I can use Bootstrap in my projects.

## Homework

* For homework tonight, add some Bootstrap to your Task Manager. Check the "Styling in Sinatra" link in the repo you cloned for instructions on how to set up a Sinatra layout with a stylesheet.
* Have some fun with the things you can do with it.
* Submit repos with any styled projects (Taylor, Kanye, Task Manager) to ruby_submissions

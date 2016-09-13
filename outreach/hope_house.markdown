  <h1>Make Your Own Website</h1>
  <p>This tutorial will walk you through creating a website using HTML and CSS on <a href="http://codepen.io">CodePen</a>. Although this will not be hosted live, the skills you learn are the skills people use to make real websites.</p>
  <h1>Why learn HTML and CSS?</h1>
  <p>HTML and CSS are the coding langauges used to make every webpage on the Internet. If you want to own your own business someday, or if you want to create an online personal resume, you'll need to know HTML and CSS. Knowing these languages can make you a strong candidate for any employer looking to enhance their web presence.</p>
  <p>HTML stands for HyperText Markup Language and is used to put elements (like headings, images, links, and paragraphs) on the page.</p>
  <p>CSS stands for Cascading Style Sheet and is used to add style (like color, font, and size). The way I like to think of it is that HTML is like the foundation, support beams, walls, ceilings, and windows of a building. CSS is like the paint and decor of the building -- the things that give it style and personality. We'll talk more in depth about these two later.</p>
  <h1>HTML</h1>
  <p>We'll start by opening <a href="http://codepen.io">CodePen</a> and clicking "New Pen". Here's what you should see:</p>
  <img src="codepen.png" alt="Picture of codpen console">
  <p>The left box is where you'll write your HTML. The box in the middle is where we'll write our CSS. The final box is for JavaScript. We won't write any JavaScript today, but you may want to explore <a href="http://codecademy.com/learn/javascript">learning JavaScript</a> on your own later! Feel free to minimize the JavaScript box for now.</p>
  <p>You'll also see a blank white box across the bottom. This is where your webpage will show up as you build it.</p>

  <h3>Headings</h3>
  <p>We'll start by adding a heading to the page.</p>

  ```html
  <h1>Welcome</h1>
  ```
  <p>The things before and after the word <b>Welcome</b> are called <b>tags</b>. We use `<h1>` to indicate that everything that's about to follow is part of a heading and `</h1>` to indicate that this heading is done.</p>
  <p>You've probably already guessed that the "h" in "h1" stands for heading, but what does the <b>1</b> in h1 represent? The number indicates the priority and size. Try changing your h1 to an h2, h3, h4, h5, or h6. What happens?</p>
  <p>If this is a personal website, we probably want a few sections. Here's a few I thought of:</p>
  <ul>
    <li>About Me</li>
    <li>My Life Goals</li>
    <li>Favorite Websites</li>
  </ul>
  <p>Add three more headings to your page. You can use the ones I thought of, or you can come up with your own. Use an appropriate size for the headings (1-6).</p>
  <i>Here's a quick hint: if you don't like typing the bracket characters, you can type the letters of the tag (like h1 or h2) and hit the tab key. Tada! It automatically makes the opening and closing tags for you!</i>
  <h3>Paragraphs</h3>
  <p>Now that you have headings, we need some content! When we type our "About Me" paragraph or "My Life Goals" section, we don't want it to be in the same font size as the heading. This is where we'll use a paragraph tag. Can you guess what letter goes inside of the tag?</p>
  <p>If you guessed the letter "p", you're correct! Add a paragraph tag underneath your "About Me" heading. It should look something like this:</p>

  ```html
  <h3>About Me</h3>
  <p></p>
  ```

  <p>Inside of the paragraph tags, write a few sentences about youself. Here are some ideas: name, age, city and state, family members. Feel free to get creative!</p>
  <p>Next, add another set of paragraph tags under the "My Life Goals" section. Inside of the tags, write a few sentences about your life goals. Here are some ideas: your dream job, where you want to work, where you want to go to college and what you'll study, what you want people to say about you.</p>
  <p>At this point, your website should be looking pretty neat! It still doesn't have any style, but we have headings and paragraphs!</p>
  <h3>Lists</h3>
  <p>We have a heading at the bottom called "Favorite Websites". People don't normally write paragraphs about their favorite websites, so let's make a list instead.</p>
  <p>Making a list involves two different sets of tags: one to indicate that we're starting a list, and one or more to indicate the different items in the list. Any guesses which letters will be used for lists? </p>

  <p>The first tag used for lists, "ul", stands for unordered list and will create bullet points for each list item we add. The second tag, "li", stands for list item and indicates that we are putting something in the list. Here is an example of how you would make a grocery list:</p>

  ```html
  <ul>
    <li>Bread</li>
    <li>Coconut yogurt</li>
    <li>Ben & Jerry's chunky monkey ice cream</li>
  </ul>
  ```

  <p>Under your "Favorite Websites" heading, create an unordered list and add three (or more!) of your favorite websites. Remember, each new item in the list gets its own set of tags.</p>

  <h3>Images</h3>
  <p>So far, we only have text :( Let's add some images!</p>
  <p>An image tag is a little bit different than the tags we've looked at so far. It <b>only</b> has an opening tag -- no closing tag! However, there's something else a little special about it. Try typing "img" and then hit the tab key to see what pops up.</p>

  ```html
  <img src="" alt="">
  ```

  <p>You'll see two things that we call attributes. One is <b>src</b> which stands for source. The source is how we indicate which picture we want to show. The other, <b>alt</b>, is used as the text that shows up if the image doesn't work. It is also used if someone cannot see the image and is having the website read to them by a screen reader.</p>

  <p>Search Google images for a picture of something that has to do with your life goals. When you find the picture, right-click on it and select "open image in a new window". Copy the address bar for the image and paste it in between the quote marks for the <b>src</b> attribute. It should look something like this:</p>

  ```html
  <img src="http://example.com/my-cool-image.jpg" alt="">
  ```

  <p>Inside of the quote marks for the <b>alt</b> attribute, write a short description of the image, like this:</p>

  ```html
  <img src="http://example.com/my-cool-image.jpg" alt="Photo of two students graduating from college">
  ```

  <p>Find two more images to go on your page. They can be images for any of your heading sections (About Me, My Life Goals, or Favorite Websites). Depending on the size of the original image, it may look kind of funny right now. But don't worry! We'll fix that when we style our page.</p>

  <h1>CSS</h1>

  <p>Now that we have some structure on our page, let's style it! We'll start with the style of our images. Remember that you'll be typing in the CSS box of CodePen now.</p>
  <p>With CSS, we can control things like color, size, font, border, shape, background, etc. The way CSS is written is a little different than the way HTML is written. Take a look at the example below:</p>

  <img src="css-rule.png" alt="Picture of annotated css rule">
  <p>The first part is the selector. The selector is what we want to style. If I wanted to style my largest heading, I would use <b>h1</b>. If I wanted to style my image, I would use <b>img</b>. What would you use if you wanted to style the items in your list? What about if you wanted to style my paragraphs?</p>

  <p>The second part is the property. The property is what about it you want to style. Examples of properties are border, font-family, size, height, width, and color.</p>

  <p>The last part is the value. Once you've identified what property you want to style, the value is what you use to indicate the style you want. If I were styling the color, the value might be red. If I were styling the height, the value might be 100 pixels. If I were styling the font-family, I might choose Times New Roman or Arial. Can you think of a value if I were styling the width? What about background-color?</p>

  <p>Finally, we put a semicolon (;) at the end of the value. Don't forget to do this!</p>

  <h3>Changing the Size of the Images</h3>
  <p>Let's style our images so that we can control the height and width. Try using a height of 100 pixels (px).</p>

  ```css
  img {
  height: 100px;
}
```

<p>Does that look ok on your page? If it does, great! If not, change the value to a different number of pixels.</p>
<h3>Adding Space Between Images</h3>
<p>Right now, our images are too close together. It would be nice to have some space between them. We can do this with a property called <b>padding</b>. Padding will add space around the outside of the images. Notice that I can just add a padding property and value inside of the same curly braces I used to set the height:</p>

```css
img {
height: 100px;
padding: 15px;
}
```
<p>Experiment with different amounts of padding. If you want the images to be close together, then use a smaller amount of padding. If you want them to be farther apart, then use a larger number of pixels (try 20 or 30 pixels).</p>

<h3>Changing the Color and Font of the Headings</h3>
<p>How do you think you'd write a CSS rule to change the color of your <b>h1</b> headings? Try it out!</p>
<p>There are some pretty cool colors out there to choose from. Take a look at <a href="http://colours.neilorangepeel.com">this list</a> and pick your favorite for the color of your h1 and other headings. Here are some examples of what it might look like:</p>

```css
h1 {
color: red;
}

h3 {
color: blue;
}
```
<p>Next, experiment with the <b>font-family</b> property. Here's what it might look like:</p>


```css
h3 {
color: blue;
font-family: cursive;
}
```

<p>There are lots of font families out there, such as sans-serif, Arial, Geneva, Helvetica, Monaco, and Palatino. Try a few of them and pick the one you like the best.</p>

<h3>Adding a Background</h3>
<p>Right now, our background is pretty boring. Let's add a background for the <b>body</b>.</p>

```css
body {
background-color: lemonchiffon;
}
```

<p>Experiment with a few of the different colors from <a href="http://colours.neilorangepeel.com">this list</a> until you find one you like.</p>

<h3>Changing the Hover Background</h3>
<p>Wouldn't it be cool to have a paragraph's background change color when the user's mouse hovers over it?</p>
<p>Since we want this to only happen for paragraphs, we'll need to use the paragraph selector <b>and</b> indicate that we want the property and value to change only when hovering over it:</p>

```css
p:hover {

}
```

<p>Next, find a color you want for the background of the paragraph:</p>

```css
p:hover {
background-color: deeppink;
}
```

<p>Try it out! Hover over one of your paragraphs. Did the background change?</p>

<h1>Congratulations!</h1>

<p>Congratulations! You've made your own basic website. If you want to save your work, click "Save" and create an account.</p>

<p>If HTML and CSS was interesting to you, I encourage you to keep learning! There are many online resources to learn how to code, but one of my favorites for beginners is <a href="https://www.codecademy.com/learn/web">Codecademy</a>. It is free and walks you through the whole process.</p>
<p>Good luck!</p>

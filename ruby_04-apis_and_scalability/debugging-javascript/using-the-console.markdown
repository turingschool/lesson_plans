# Using the Console

![console](../assets/debug-console.png)

The Console tab in Chrome DevTools is probably the tab you are most familiar with. It keeps a log of every message posted to it, including errors, so it's the first place we look when something with our application goes wrong.

You can also use the Console to try things out.

## Getting jQuery into your Console

Some websites are too cool for jQuery. You can add jQuery to any page for console purposes with the [jQuerify](https://chrome.google.com/webstore/detail/jquerify/gbmifchmngifmadobkcpijhhldeeelkc/related?hl=en) extension for Chrome. Install it, and then click the icon (red turd) in your extensions at the top to add jQuery to the page. Then you can...

## Test It Out

- Navigate to the [Rails Github page](https://github.com/rails/rails)
- Open Chrome DevTools and click the Console tab
- Type `$`

You should see:

```js
  function (a,b){return new m.fn.init(a,b)}
```

By inputting `$`, we can verify that we've added jQuery and assigned to `$`

- Now, copy and paste the following code into the console.

```js
  $('.author').replaceWith(
    '<a href="www.github.com/rrgayhart">meeka</a>'
  )
```

-------

![console](../assets/debug-wrote-rails.png)

Excellent.

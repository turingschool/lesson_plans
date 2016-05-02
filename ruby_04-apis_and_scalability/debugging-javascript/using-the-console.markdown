# Using the Console

![console](../assets/debug-console.png)

The Console tab in Chrome DevTools is probably the tab you are most familiar with. It keeps a log of every message posted to it, including errors, so it's the first place we look when something with our application goes wrong.

You can also use the Console to try things out.

- Navigate to the [Rails Github page](https://github.com/rails/rails)
- Open Chrome DevTools and click the Console tab
- Type `$`

You should see:

```js
  function (e,t){return new Q.fn.init(e,t)}
```

The console in DevTools has access to all the JavaScript included in the website that you're viewing. By inputting `$`, we can verify that Github uses jQuery and has it assigned to `$`

- Now, copy and paste the following code into the console.

```js
  $('.author').replaceWith(
    '<a href="www.github.com/rrgayhart">meeka</a>'
  )
```

-------

![console](../assets/debug-wrote-rails.png)

Excellent.

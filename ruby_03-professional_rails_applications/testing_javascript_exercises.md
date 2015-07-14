## Exercise One

We're learning a new testing framework, so let's keep it simple for our first go-round.

* Write a new function called `theTruth()`
* It should always, always returns `true`.
* Write a test confirming that your function returns `true`.
* See if it passes.

This should take you about 5 minutes.

## Exercise Two

Alright, let's step it up a notch.

* Write a function called `add()`, that takes two arguments and returns the sum.
* Write a test confirming that your function returns the correct sum.
* Write a test to make sure the sum is not equal to a string with the same number (e.g. `"2"` should not be equal to the sum of `add(1, 1)`).
* See if it passes.

**Bonus**: Can you write a function called `sum` that takes an array of numbers and returns—umm—`sum`.

This should take you about 10 minutes.

## Exercise Three

Write a function called `truncateText` that does the following:

* It takes two arguments: a string of text and a number.
* If the length of the text is less than the number you passed in, then return the original text.
* If it's longer, then cut the text off at number of characters you passed in and add a "…" at the end.

Examples:

* `truncateText('wow', 4)` should return `wow`
* `truncateText('wowow', 4)` should return `wowo…`

(Hint: In JavaScript, all strings have [a `slice` method.][slice].)

**Bonus**: Can you update the field so that it cuts down to the nearest word. For example, `truncateText('one two three', 10)` will return `'one two…`. The word `three` would put the length over 10, so it is omitted.

[slice]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/slice

This should take you about 10 minutes.

## Exercise Four

Our new application is for people with some anger management issues. It's a companion application to "You've Changed."

Application has a text input field with the class `.screambox`. Users are only allowed to scream (i.e. use all capital letters in this box) in order for it to be valid.

Whenever the contents of the box has been changed, check to see if the value of the input field matches the value `.toUpperCase()`. If not, then add a class of `invalid` to the box.

Make sure you test the happy path as well as the unhappy path.

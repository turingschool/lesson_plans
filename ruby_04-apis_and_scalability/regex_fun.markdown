---
title: Regex Fun Times
length: 60 minutes
tags: regular expressions, regex
---

## Goals

By the end of this lesson, you will know/be able to:

* Understand the pros and cons of using a regular expression
* Practice using a regex pattern matcher
* Practice testing and writing a regex matcher in JavaScript

## Whatsa Regex?

A regular expression (usually referred to as a `regex` or `regexp`) is a sequence of characters that make up a search pattern.

![regex](http://i.imgur.com/4W5EHwC.png)

(Attribution: [XKDC](http://xkcd.com/))

`Some people, when confronted with a problem, think "I know, I'll use regular expressions." Now they have two problems.`

## Understanding a Long Regular Expression

```
/^(([a-zA-Z]|[0-9])|([-]|[_]|[.]))+[@](([a-zA-Z0-9])|([-])){2,63}[.](([a-zA-Z0-9]){2,63})+$/gi
```

Above is a pattern for a simple email matcher. If we copy and paste this regex into a site like [regex101](https://regex101.com/) - we can start to try and figure out what's going on.

### The Base Layer

Let's looks specifically at the set up for this regex pattern.

```
/^$/gi
```

| Character | Description                                             |
|-----------|---------------------------------------------------------|
| `/`       | Indicates the beginning of a Regex pattern      |
| `^`       | Anchor: Indicates that the match must be at the begining of the string     |
| `$`       | Anchor: Indicates that the match must reach to the end of the string     |
| `/`       | Indicates the end of a Regex pattern                    |
| `g`       | Flag: Outside the regex meaning 'global'. That means it will test the pattern against all possible matches in a string. Without this flag, the regex will only test the first match it finds and then stop.     |
| `i`       | Flag: Match is case insensitive.         |

### Capturing a Character

```
  ([a-zA-Z]|[0-9])
```

| Character | Description                                             |
|-----------|---------------------------------------------------------|
| `()`      | Specifies the begining of a grouping. For example, `dog|dig` and `d(o|i)g` can both be used to capture `dog` or `dig` strings.        |
| `[]`      | Creates a character class     |
| `-`       | Is a range - therefor...                   |
| `g`       | Flag: Outside the regex meaning 'global'. That means it will test the pattern against all possible matches in a string. Without this flag, the regex will only test the first match it finds and then stop.     |
| `a-z`     | Is any character in the range between a through z         |
|`[a-zA-Z]` | So put together, this character class would match any letter `a` through `z`, case insensitive |
| `[0-9]`   | A character group that would match any character in a range between 0 and 9 |

`|`: is a Boolean 'or'

So all put together, `([a-zA-Z]|[0-9])` matches any letter of number.

### Matching Multiple times

```
  (([a-zA-Z]|[0-9])|([-]|[_]|[.]))+
```

We can now see that this regex pattern nests a capture group within another capture group to find `any letter or number` or `a -, _, or .`

The interesting piece here is the character at the very end: `+`

This is a quantifier which targets the capture group and says 'repeat previous token 1 to infinite times' in your definition of a match.

#### Quantifiers

| Character | Description                                             |
|-----------|---------------------------------------------------------|
| `?`       | May include _zero or one_ occurances of the preceding element    |
| `* `      | May include _zero, one or many_ occurances of the preceding element     |
| `+`       | Must include _one or many_ occurances of the preceding element            |
| `{n}`     | Must match the preceding element _n times_     |
| `{min,}`  | Must match the preceding element _atleast min or more times_         |
| `{min,max}` | Must match the preceding element _atleast min times but not more than max times |
| `{,max}`   | Must match the preceding element _no more that max times_ |

### Final Breakdown

```
/^(([a-zA-Z]|[0-9])|([-]|[_]|[.]))+[@](([a-zA-Z0-9])|([-])){2,63}[.](([a-zA-Z0-9]){2,63})+$/gi
```

`/^`: Start a Regular Expression at the begining of the string

`(([a-zA-Z]|[0-9])|([-]|[_]|[.]))+`: Match any letter, number or -, _, . one or more times until...

`[@]`: Matching a `@` symbol

`(([a-zA-Z0-9])|([-])){2,63}`: Match any letter, number or `-` 2 to 63 times... [why 63?](http://stackoverflow.com/questions/9238640/how-long-can-a-tld-possibly-be/9239264#9239264)

`[.]`: Match a period

`(([a-zA-Z0-9]){2,63})+`: Match any letter or number 2 to 63 times, one or many times.

`$/`: Anchor this match to the end of the string.

`gi`: And make it a global and case insensitive match

### Discussion

- Does this regex seem like it could be refactored?
- How could we break this regular expression?
- Should we even use this?!
  - [A previously compliant version](http://www.ex-parrot.com/~pdw/Mail-RFC822-Address.html)
  - [Relevant Post]( https://davidcel.is/posts/stop-validating-email-addresses-with-regex/)

# Let's Practice (Language Agnostic)

Let's take approx 15 minutes to play around with this. Choose either one of the options below.

## Practice: RegexCrosswords

A regular expression, especially a gnarly one like the email validator above, can be intimidating. The best way to get better at writing regular expression patterns, however, is to practice.

- Open the [Regex Crossword](https://regexcrossword.com/) site
- Play through the first tutorial level
- If you get stuck, copy part of the pattern into [Regex101](https://regex101.com)
- How far can you get in 15 minutes?

## Practice: Regex Golf

XKCD likes to write Regex jokes (and subsequently explain them in a format that is really excellent and informative). Check out this [comic](https://www.explainxkcd.com/wiki/index.php/1313:_Regex_Golf) and explanation.

[Here is an implementation of Regex Golf](http://regex.alf.nu/)

- Read the [comic](https://www.explainxkcd.com/wiki/index.php/1313:_Regex_Golf) and explanation
- Open the [Regex Golf](http://regex.alf.nu/) (if the site is still down - try playing it from the [Internet Archive](https://web.archive.org/web/20160206184838/http://regex.alf.nu/)) site
- Play through the Warmup first level and then move through the levels
- If you get stuck, copy part of the pattern into [Regex101](https://regex101.com)
- How far can you get in 15 minutes?


## JavaScript: RegExp

Regular Expressions are awesome.

They are also really, really, really, really, really easy to get wrong.

Before we go further, I need you, the reader, to repeat the following warning in your head.

```
If you include a regular expression in your code, you MUST also write minimum 3 unit tests.

A happy path, as sad path and a bizarre path.
```

I don't care where you're putting the regular expression. 

Seriously. 

```
If you include a regular expression in your code, you MUST also write minimum 3 unit tests.
```

You can say it outloud if you want.

```
If you include a regular expression in your code, you MUST also write minimum 3 unit tests.
```

Okay. Now that you've internalized that. Let's talk about how you work with Regular Expression in JavaScript specifically.

There are two ways to create a [RegExp Object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp)

The literal version is:

```javascript
   var regex = /cat/;
```

and the constructor function is:

```javascript
  var regex = new RegExp("cat");
```

You will want to use the constructor function if you're dynamically creating a regex. You can use flags like `i` for case insensitive in either case.

```javascript
  var regex1 = /cat/i;
  var regex2 = new RegExp("cat", 'i');
```

#### RegExp methods

| Method | Description                                             |
|--------|---------------------------------------------------------|
| `exec` | Accepts a string, searches it for a match. Returns an array of information or null    |
| `test` | Accepts a string, searches it for a match. Returns true of false     |

#### String methods using RegExp

| Method | Description                                             |
|---------|---------------------------------------------------------|
| `match` | Accepts a RegExp, searches self for a match. Returns an array of information or null    |
| `test`  | Accepts a RegExp, searches self for a match. Returns true of false     |
| `search`| Accepts a RegExp, searches self for a match. Returns the index of the match or -1 if not match   |
|`replace`| Accepts a RegExp and a replacement string, searches self for a match and replaces with replacement string where match.    |
| `split` | Accepts a RegExp or string to break self into an array of strings    |


## Practice: JavaScript

The goal of this experiment is to practice using RegExp in JavaScript AND more importantly to show you how easily a regex can miss an edge case.

Don't expect to get every test passing during the worktime, and feel free to add additional tests to try and find more edge cases as you think of them.

[Clone This Repo](https://github.com/rrgayhart/regex-js-practice)

# Resources and Next Steps

- [MDN Has an Excellent Guide for JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)
- [No but seriously, read this XKCD comic explanation, it's real good](https://www.explainxkcd.com/wiki/index.php/1313:_Regex_Golf)
- [Regex101](https://regex101.com/)
- [Intro to Regular Expressions by Michael Fitzgeral](
http://www.amazon.com/Introducing-Regular-Expressions-ebook/dp/B008K9OGDA/ref=sr_1_2?ie=UTF8&qid=1374171971&sr=8-2&keywords=Regular+Expressions)
- ["Finite State Machines and Regular Expressions" by Eli Bendersky](http://www.gamedev.net/page/resources/_/technical/general-programming/finite-state-machines-and-regular-expressions-r3176)

# Resources: In Ruby

Most languages have their own implementations of regular expressions and convenience methods around matching them. Ruby has the [Regexp class](http://ruby-doc.org/core-2.2.0/Regexp.html)

When writing a regex to solve a problem in your code, it is **critical** that you test drive. As discussed above, a regular expression pattern has many, many, many places it can go wrong.

- Clone down this [regular expression repo](https://github.com/turingschool-examples/regex-practice)
- Go through existing site
- Fill out test cases
- Add additional metrics

The repo has Fabio in it. Which is important.

- Nell Shamrell's [conference talk](http://www.confreaks.com/videos/2678-gogaruco2013-beneath-the-surface-regular-expressions-in-ruby) on how Regex works internally with Ruby

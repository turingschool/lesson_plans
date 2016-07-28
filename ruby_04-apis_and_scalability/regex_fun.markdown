---
title: Regex Fun
length: 60 minutes
tags: regular expressions, regex
---

# Goals

By the end of this lesson, you will know/be able to:

* Understand the pros and cons of using a regular expression
* Practice using a regex pattern matcher
* Practice testing and writing a regex matcher in Ruby

## Whatsa Regex?

A regular expression (usually referred to as a `regex` or `regexp`) is a sequence of characters that make up a search pattern.

![regex](http://i.imgur.com/4W5EHwC.png)

(Attribution: [XKDC](http://xkcd.com/))

## Understanding a Long Regular Expression

```
/^(([a-zA-Z]|[0-9])|([-]|[_]|[.]))+[@](([a-zA-Z0-9])|([-])){2,63}[.](([a-zA-Z0-9]){2,63})+$/gi
```

Above is a pattern for a simple email matcher. If we copy and paste this regex into a site like [regex101](https://regex101.com/) - we can start to try and figure out what's going on.

### The Base Layer

Let's looks specifically at the set up for this regex pattern.

```
/^/gi
```

`/`: forward slashes (/) indicate the beginning and end of a Regex pattern

`^`: This anchors the match to being at the beginning of the string.

`g`: This is a flag outside of the regex meaning 'global'. That means it will test the pattern against all possible matches in a string. Without this flag, the regex will only test the first match it finds and then stop.

`i`: This indicates that the match is case insensitive

### Capturing a Character

```
  ([a-zA-Z]|[0-9])
```

`()`: Specifies a 'capture group'. We'll see why we want this in a little bit

`[]`: This creates a character class.

`-`: Is a range - therefor...

`a-z`: Is any character in the range between a through z

`[a-zA-Z]`: So put together, this character class would match any letter `a` through `z`, case insensitive

`|`: Within a capture group, this means 'or'

`[0-9]`: This line would match any character 0 through 9

So all put together, `([a-zA-Z]|[0-9])` matches any letter of number.

### Matching Multiple times

```
  (([a-zA-Z]|[0-9])|([-]|[_]|[.]))+
```

We can now see that this regex pattern nests a capture group within another capture group to find `any letter or number` or `a -, _, or .`

`+`: Is a quantifier which targets the capture group and says 'repeat previous token 1 to infinite times' in your definition of a match.

### Additional Pieces

`{2,63}`: Quantifier which targets the capture groups and says 'repeat previous token 2 to 63 times'... [why 63?](http://stackoverflow.com/questions/9238640/how-long-can-a-tld-possibly-be/9239264#9239264)

`$`: Anchors pattern to the end of a string

### Discussion

- The rest of the regex's meaning
- How could we break this regular expression?
- Should we even use this?!
  - [A previously compliant version](http://www.ex-parrot.com/~pdw/Mail-RFC822-Address.html)
  - [Relevant Post]( https://davidcel.is/posts/stop-validating-email-addresses-with-regex/)

## Practice: In Ruby

Most languages have their own implementations of regular expressions and convenience methods around matching them. Ruby has the [Regexp class](http://ruby-doc.org/core-2.2.0/Regexp.html)

When writing a regex to solve a problem in your code, it is **critical** that you test drive. As discussed above, a regular expression pattern has many, many, many places it can go wrong.

- Clone down this [regular expression repo](https://github.com/turingschool-examples/regex-practice)
- Go through existing site
- Fill out test cases
- Add additional metrics

## Practice: RegexCrosswords

A regular expression, especially a gnarly one like the email validator above, can be intimidating. The best way to get better at writing regular expression patterns, however, is to practice.

- Open the [Regex Crossword](https://regexcrossword.com/) site
- Play through the first tutorial level
- If you get stuck, copy part of the pattern into [Regex101](https://regex101.com)
- How far can you get in 15 minutes?

## Practice: Regex Golf

XKCD likes to write Regex jokes (and subsequently explain them in a format that is really excellent and informative). Check out this [comic](https://www.explainxkcd.com/wiki/index.php/1313:_Regex_Golf) and explanation.

[Here is an implementation of Regex Golf](http://regex.alf.nu/)

# Resources and Next Steps

## In JavaScript

[MDN Has an Excellent Guide for JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)

## Beginner & Intermediate Level

- [Regex Crosswords](https://regexcrossword.com/)
- [Regex101](https://regex101.com/)
- [Intro to Regular Expressions by Michael Fitzgeral](
http://www.amazon.com/Introducing-Regular-Expressions-ebook/dp/B008K9OGDA/ref=sr_1_2?ie=UTF8&qid=1374171971&sr=8-2&keywords=Regular+Expressions)

## Advanced

- Nell Shamrell's [conference talk](http://www.confreaks.com/videos/2678-gogaruco2013-beneath-the-surface-regular-expressions-in-ruby) on how Regex works internally with Ruby
- ["Finite State Machines and Regular Expressions" by Eli Bendersky](http://www.gamedev.net/page/resources/_/technical/general-programming/finite-state-machines-and-regular-expressions-r3176)

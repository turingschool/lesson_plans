---
title: JSON Fundementals
length: 90
tags: json, javascript
---

## Lecture

### What is JSON?

* JSON stands for "JavaScript Object Notation"
* It's a subset of the object syntax in JavaScript. All JSON is valid JavaScript, but not all JavaScript objects are valid JSON
* It maps easily onto the data structures used by most programming languages (numbers, strings, booleans, nulls, arrays and hashes/dictionaries)
* It's a lot like Ruby's hash syntax
* It's lightweight and easy for humans to read and write
* Most programming languages have a library for reading and writing JSON structures

JSON is commonly used by APIs to send data back and forth when you don't need/want to render a full web page.

### Writing JSON

JSON data structures are typically either a object (similar to a hash for the purposes of this discussion) or an array of objects or other values.

JSON objects follow some rules:

* Objects are made up of name/value pairs
* Keys must be double-quoted and followed by a colon

You also have a few types of values available in a JSON structure:

* Numbers
* Strings (in double quotes only)
* Booleans (`true` and `false`)
* Arrays
* Objects (again, objects in JavaScript are similar to hashes in Ruby)
* `null`

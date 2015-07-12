---
title: Number Systems
length: 90
tags: computer science, binary, fundamentals
---

Do you know how to count?

There's more than one way of counting. You're most familiar with the base-10
number system. In this session we'll work to:

* better understand base-10 (decimal)
* explain and explore base-2 (binary)
* explain and explore base-16 (hexadecimal)

## Base-10 (decimal)

You use base-10 numbers everyday, but let's think a bit more about how they work.

### Theory

* Uses the symbols `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`
* Digits carry over to the next place when `9` becomes `0`
* One digit can represent 10 unique numbers
* Two digits represent 100 unique numbers
* Moving right to left, positions represent:
  * 10^0 = 1
  * 10^1 = 10 ("tens")
  * 10^2 = 100 ("hundreds")
  * 10^3 = 1000 ("thousands")

### Build It

Get yourself one plastic viewer and three paper strips.

With *each* of your paper strips:

1. The small top partial box will be your margin
2. Write a big `0` filling the first full square
3. Write a big `1` filling the second full square
4. Continue with the digits `2` through `9`
5. Shade the eleventh full square as a bottom margin

Practice counting in your normal number system and think critically about the mechanics of how counting works.

*Comprehension*: If you have three decimal digits, how many unique value can you represent?

## Extensions

If you get done with any of your small group stations, try out these extensions:

### Conversions: From Hex to Binary

Converting Hex to Decimal and vice-versa is useful for making Hex numbers more human-readable. But in reality one of the main advantages of hex is that it's very easy to convert between hex and binary. Hexadecimal largely became popular as a number system among computer scientists and programmers because it serves as a convenient "shorthand" for representing binary numbers which would otherwise be very long.

To understand why converting between these two is relatively easy, let's think about what binary and hex each represent.

In hex, each "digit" can represent 16 different values (0-15). In terms of binary, we might say that this represents "4 bits" of information -- we could represent the same range of values in binary using various combinations of the first 4 bits.

Thus, when converting hex to binary, we can actually just treat each digit in the Hexadecimal string as an independent set of 4 bits in binary. Convert all the digits into sets of 4 bits, string them together, and you're done!

Let's look at an example of converting `AF` to Binary:

```plain
F (15) * 16^0 (1)  = 15(10)  =  0000 1111(2)
A (10) * 16^1 (16) = 160(10) =  1010 0000(2)

Total = 0000 1111 + 1010 0000 = Concatenate 1010 + 1111 = 10101111
```

#### Exercises

##### Conversion - Hex <-> Binary

1. Convert 1010 binary to hex
2. Convert AF6C hex to binary
3. Convert 1101 0101 binary to hex
4. Convert FACE hex to binary

### Using Other Number Systems from Ruby

Ruby by default represents numbers to us using base-10, even though it stores them in binary under the hood. However it also has the ability to represent numbers as strings of different bases when requested.

To do this, you simply pass an optional, numeric argument to the `to_s` method on `Fixnum`:

```
6.to_s(2)
=> "110"
```

Similarly, you can also pass an optional argument to the `to_i` method on `String` to tell ruby to use a different base when it's parsing a string into a number:

```
"110".to_i(2)
=> 6
```

Experiment with these methods to see if you can accomplish all the conversions from the exercises above using ruby.

1. Convert 100 decimal to hex
2. Convert AF6C hex to decimal
3. Convert 10,000 decimal to hex
4. Convert FACE hex to decimal

## Changes for Next Time

* For each number system, add a "counting from" section. Like for hex: "Starting with `7A8` and count (decimal) 12 places. What do you get?"
* Explain what materials are needed (viewers and strips)
* Write the protocol for how to move between three stations with decending time: 20min, 15min, 12min? 22/18/15?
* Add a few challenges/extensions within the individual pieces, like to binary ask the question "What would it be like to count to decimal 10 in Base-3?"

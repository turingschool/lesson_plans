---
title: Number Systems - Octal
tags: computer science, octal, fundamentals
---

## Base-8 (octal)

Octal is the least frequently use of these alternative number systems, but it has some interesting properties. One common
usage is for dealing with file permissions in the Unix filesystem.

### Theory

* Uses the symbols `0`, `1`, `2`, `3`, `4`, `5`, `6`, and `7`
* Digits carry over to the next place when `7` becomes `0`
* One digit can represent eight unique numbers
* Two digits can represent 64 unique numbers
* Moving right to left, positions represent:
  * 8^0 = 1
  * 8^1 = 8
  * 8^2 = 64
  * 8^3 = 512

*Comprehension*: How many more unique numbers can be represented in four decimal digits versus four octal digits?

### Counting

In your notebook write a header *Octal* and create a table with two columns. In the left column put the decimal numbers
0 through 20. In the right column record the octal equivalents that you find through the counting process below.

Follow these steps/rules with your groupmates:

1. Start with all zeros across the viewer
2. Increment the rightmost strip
3. If the rightmost hits the `8`, move the next strip to the left up one and move the rightmost back to 0.
4. If that second strip hits the `8`, use the same method to increment the third strip and move the second back to 0.
5. Do the same for the third and fourth strips
6. Record the "output" number you have after completing 2-5, then repeat until your table is full.

Do you get it? Try each of these counts:

* Count up three decimal values from `627`
* Count up eight decimal values from `767`
* Count down four decimal values from `123`
* Count down six decimal values from `604`

### Conversions

Now let's practice direct conversions in your notebook. You can choose to collaborate or do this solo:

#### From Octal to Decimal

To convert octal to decimal:

* Start from the right
* Multiply the digit in that place by the power of 8 corresponding to that place
* Add the results together

For example, say you have `1267`:

```plain
7 * 8^0 = 7
6 * 8^1 = 48
2 * 8^2 = 128
1 * 8^3 = 512

Total = 7 + 48 + 128 + 512 = 695 in decimal
```

#### From Decimal to Octal

* Take the whole decimal number
* Divide by eight
* Note the quotient and the remainder
* Divide the quotient by 8, noting the new quotient and remainder
* Repeat until your quotient reaches zero
* Record the remainders from bottom to top

For example, say you have `1258`:

```plain
1258 / 8 = 157 remainder 2
 157 / 8 =  19 remainder 5
  19 / 8 =   2 remainder 3
   2 / 8 =   0 remainder 2

Bottom to top it's 2352 in octal
```

### Exercises - Conversion

1. Convert `712` decimal to octal
2. Convert `777` octal to decimal
3. Convert `1024` decimal to octal
4. Convert `3041` octal to decimal

### Addition & Subtraction

You *can* convert back and forth to decimal and do your normal decimal addition/subtraction,
but doing them right in octal is actually straight-forward.

You use the same rules as when doing addition in decimal:

* Start from the right
* Add the two digits together
* If you get a summed value less than eight, write it down
* If you get a summed value greater than eight, write down the value minus eight and carry a `1` to the next column to the left

For example, let's add `456` and `153` like this:

```plain
  456
+ 153
-----
```

The rightmost `6` and `3` add together, exceed `8`, so we carry a one and write the remainder `1`.

```plain
   1
  456
+ 153
-----
    1
```

In the second column the previously carried 1 adds with the existing `5` and `5`
to give eleven. Carry one to the next column and bring down the remaining `3`:

```plain
  1
  456
+ 153
-----
   31
```

Then the leftmost `1`, `4`, and `1` add to `6`:

```plain

  456
+ 153
-----
  631
```

**Subtraction** works the same way where you borrow from the left (so `1` becomes
`10` aka eight in decimal).

### Exercises - Addition & Subtraction

1. Add `777` to `111`
2. Add `4531` to `3275`
3. Subtract `131` from `765`
4. Subtract `654` from `1421`

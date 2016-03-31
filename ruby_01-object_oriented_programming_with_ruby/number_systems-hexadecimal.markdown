---
title: Number Systems - Hexadecimal
length: 90
tags: computer science, hexadecimal, fundamentals
---

## Base-16 (hexadecimal)

Base-16 numbers are powerful for representing a large number of possible values with just a few characters (think of
serial numbers).

### Theory

In hex you have sixteen symbols! The hex system:

* Uses the symbols `0` through `9` then `A`, `B`, `C`, `D`, `E`, `F`
* Digits carry over to the next place when `F` becomes `0`
* One digit can represent sixteen unique numbers
* Two digits can represent 256 unique numbers
* Moving right to left, positions represent:
  * 16^0 = 1
  * 16^1 = 16
  * 16^2 = 256
  * 16^3 = 4096

*Comprehension*: What's the decimal equivalent of the maximum value represented by six hex digits?


### Counting

In your notebook write a header *Hex* and create a table with two columns. In the left column put the decimal numbers
0 through 35. In the right column record the hex equivalents that you find through the counting process below.

Follow these steps/rules with your groupmates:

1. Start with all zeros across the viewer
2. Increment the rightmost strip
3. If the rightmost hits the bottom margin, move the next strip to the left up one and move the rightmost back to 0.
4. If that second strip hits the margin, use the same method to increment the third strip and move the second back to 0.
5. Do the same for the third and fourth strips
6. Record the "output" number you have after completing 2-5, then repeat until your table is full.

Do you get it? Try each of these counts:

* Count up three decimal values from `9FB`
* Count up twelve decimal values from `2F6`
* Count down four decimal values from `111`
* Count down eighteen decimal values from `1010`

### Conversions

#### From Hex to Decimal

To convert hex to decimal:

* Start from the right
* Multiply the digit in that place by the power of 16 corresponding to that place
* Add the results together

For example, say you have `A3F`:

```plain
F (15) * 16^0 (1)   = 15
3      * 16^1 (16)  = 48
A (10) * 16^2 (256) = 2560

Total = 15 + 48 + 2560 = 2623 in decimal
```

#### From Decimal to Hex

* Take the whole decimal number
* Divide by sixteen
* Note the quotient and the remainder
* Divide the quotient by sixteen, noting the new quotient and remainder
* Repeat until your quotient reaches zero
* Convert all the remainders to the hex symbol
* Record the remainders from bottom to top

For example, say you have `5007`:

```plain
5007 / 16 = 312 remainder 15 (F)
312 / 16 = 19 remainder 8
19 / 16 = 1 remainder 3
1  / 16 = 0 remainder 1

Bottom to top it's 138F in hex
```

### Exercises -- Conversion

1. Convert 100 decimal to hex
2. Convert AF6C hex to decimal
3. Convert 10,000 decimal to hex
4. Convert FACE hex to decimal

### Addition & Subtraction

You *can* convert back and forth to decimal and do your normal decimal addition/subtraction,
but doing them right in hex is also possible. You use the same rules as when doing addition in decimal:

* Start from the right
* Add the two digits together
* If you get a summed value less than sixteen, write it down
* If you get a summed value greater than sixteen, write down the value minus sixteen and carry a `1` to the next column to the left

For example, let's add `5BAF` and `0151` like this:

```plain
  5BAF
+ 0161
------
```

The rightmost `F` and `1` add together, but there's no symbol after `F` so we have to put down a `0` and carry a `1`:

```plain
    1
  5BAF
+ 0161
------
     0
```

The `1` increments the `A` to a `B`. Then the six counts it forward to `C`, `D`, `E`, `F`, `0`, and finally `1`. We also
have to carry a `1` since we wrapped around:

```plain
   1
  5BAF
+ 0161
------
    10
```

The `1` increments the `B` to a `C`, then the other `1` pushes it to `D`. There's no carry, so the left-most digit is just
`5` plus `0`:

```plain
  5BAF
+ 0161
------
  5D10
```

Got it?

**Subtraction** works the same way where you borrow from the left (so `1` becomes
`10` in hex aka 16 in decimal).

### Exercises - Addition & Subtraction

1. Add 111 hex to 345 hex
2. Add F23 hex to 1A7 hex
3. Add 1 hex to FFFFFF hex
4. Subtract 1AF hex from 54BF
5. Subtract ABC hex from 1111

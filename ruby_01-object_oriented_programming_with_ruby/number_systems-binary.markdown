---
title: Number Systems - Binary
tags: computer science, binary, fundamentals
---

## Base-2 (binary)

Everything in computing (hardware, software) is based on binary. At the electrical
level a binary zero means "no electricity", while a binary one means "yes electricity".

### Theory

* Uses the symbols `0` and `1` only
* Digits carry over to the next place when `1` becomes `0`
* One digit can represent only two unique numbers
* Two digits can represent only four unique numbers
* Moving right to left, positions represent:
  * 2^0 = 1
  * 2^1 = 2
  * 2^2 = 4
  * 2^3 = 8

*Comprehension*: What number would come immediately after `1010`?

### Counting

In your notebook write a header *Binary* and create a table with two columns. In the left column put the decimal numbers
0 through 10. In the right column record the binary equivalents that you find through the counting process below.

Follow these steps/rules with your groupmates:

1. Start with all zeros across the viewer
2. Increment the rightmost strip
3. If the rightmost hits the `2`, move the next strip to the left up one and move the rightmost back to 0.
4. If that second strip hits the `2`, use the same method to increment the third strip and move the second back to 0.
5. Do the same for the third and fourth strips
6. Record the "output" number you have after completing 2-5, then repeat until your table is full.

Do you get it? Try each of these counts:

* Count up three decimal values from `1010`
* Count up eight decimal values from `100`
* Count down four decimal values from `1100`
* Cound down six decimal values from `1111`

### Conversions

Now let's practice direct conversions in your notebook. You can choose to collaborate or do this solo:

#### From Binary to Decimal

To convert binary to decimal:

* Start from the right
* Multiply the digit in that place by the power of 2 corresponding to that place
* Add the results together

For example, say you have `101001`:

```plain
1 * 2^0 = 1
0 * 2^1 = 0
0 * 2^2 = 0
1 * 2^3 = 8
0 * 2^4 = 0
1 * 2^5 = 32

Total = 1 + 8 + 32 = 41 in decimal
```

#### From Decimal to Binary

* Take the whole decimal number
* Divide by two
* Note the quotient and the remainder
* Divide the quotient by 2, noting the new quotient and remainder
* Repeat until your quotient reaches zero
* Record the remainders from bottom to top

For example, say you have `41`:

```plain
41 / 2 = 20 remainder 1
20 / 2 = 10 remainder 0
10 / 2 = 5 remainder 0
5  / 2 = 2 remainder 1
2  / 2 = 1 remainder 0
1  / 2 = 0 remainder 1

Bottom to top it's 101001 in binary
```

### Exercises - Conversion

1. Convert 16 decimal to binary
2. Convert 1011 binary to decimal
3. Convert 31 decimal to binary
4. Convert 10101 binary to decimal

### Addition & Subtraction

You *can* convert back and forth to decimal and do your normal decimal addition/subtraction,
but doing them right in binary is actually straight-forward.

You use the same rules as when doing addition in decimal:

* Start from the right
* Add the two digits together
* If you get zero, write it down
* If you get one, write it down
* If you get two, write a zero and carry a one to the next column

For example, let's add `1011` and `101` like this:

```plain
  1011
+  101
------
```

The rightmost 1s add together to two, so a 1 gets carried and a zero written:

```plain
   (1)
  1011
+  101
------
     0
```

In the second column the previously carried 1 adds with the existing 1 and zero
to give two. A one is carried and the zero written:

```plain
  (1)
  1011
+  101
------
    00
```

Again the previously carried 1 adds with the existing zero and 1 to give two.
The one is carried and the zero written.

```plain
 (1)
  1011
+  101
------
   000
```

Finally the carried one adds with the existing one to give two, the one is
carried and the zero written. Since there are no more digits for the carry,
it is written too:

```plain
(1)
  1011
+  101
------
 10000
```

And we're done with the result `10000`.

**Subtraction** works the same way where you borrow from the left (so `1` becomes
`10` aka two).

### Exercises - Addition & Subtraction

1. Add `1010` to `101`
2. Add `1010` to `1011`
3. Subtract `101` from `1111`
4. Subtract `11` from `1000`

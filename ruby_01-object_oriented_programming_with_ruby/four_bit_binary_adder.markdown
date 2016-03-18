## Workshop: Building a Four-Bit Binary Adder

In this session we're going to do some hands-on work with basic electronics.
We'll experiment with a few different types of [Logic Gates](https://en.wikipedia.org/wiki/Logic_gate), which are
some of the fundamental building blocks for modern computers.


[Full Parts List](https://docs.google.com/spreadsheets/d/1-wV10ApCCj-Lsw3fW0WabhedjeGRTkniItBa-My8dns/edit#gid=0)

### Materials

Each group should have the following materials:

* Integrated Circuit (IC) 74LS86 __(2)__
* IC 74LS08 __(2)__
* IC 74LS32  __(1)__
* 4-position DIP switch __(2)__
* LEDs __(5)__
* 22-gauge Wire Jumpers __(bunch)__
* Power Source __(1)__
* USB A to USB A Power Cord __(1)__
* Breadboard __(1)__

## Intro - Breadboard and Circuit Basics

Instructor demonstrates basic principles of breadboards including:

* Connecting power supply to the board
* Connecting Positive and Ground to power rails
* Jumping rails to second sections if needed
* Using resistors and LEDs

Students should demonstrate this knowledge by using their board to power on an LED in series with a resistor.

## Section 1 - Independent Binary Gate Discovery

Each group should have 3 different types of logic gate integrated circuits as listed above.

These chips each represent one of the primitive logic gates:

1. OR (Output is on if EITHER input is on)
2. AND (Output is on if BOTH inputs are on)
3. Exclusive-OR (Output is on if ONE input is on but OFF if BOTH inputs are on)

Additionally, to help get more "bang for buck" for a given chunk of breadboard space, each chip is printed with **4** of the given gate.
Each gate uses two pins for input and one pin for output, which with 4 gates accounts for 12 of the 14 pins. The remaining 2 are used for
positive voltage (VCC) and ground. All together this makes 14 pins, which will be laid out like below:

```
 14 13 12 11 10 09 08
 |  |  |  |  |  |  |
+--------------------+
|                    |
+--------------------+
 |  |  |  |  |  |  |
 01 02 03 04 05 06 07
```

For these pins, the layout looks like:

1. A0 Input
2. B0 Input
3. Output 0
4. A1 Input
5. B1 Input
6. Output 1
7. Ground (-)
8. Output 2
9. B2 Input
10. A2 Input
11. Output 3
12. B3 Input
13. A3 Input
14. Positive Input (+)

Which when we chart it out gives us:

```
 +  A3 B3 Y3 A2 B2 Y2
 |  |  |  |  |  |  |
+--------------------+
|                    |
+--------------------+
 |  |  |  |  |  |  |
 A0 B0 Y0 A1 B1 Y1 G(-)
```

### Exercise

Your assignment in this section is to use the provided breadboard and LEDs to complete a **Truth Table** for each
gate. This will allow us to determine which chip is which (AND, OR, XOR).

To do this, you'll need to connect 2 inputs to one of the gates on each
chip and observe the outputs (an LED works great for an output). Don't forget to try the inputs in all of the possible
configurations to determine your outputs.

## Section 2 -- Medium Challenge -- 1-Bit Full Adder

A binary adder is a common electronic component that utilizes the gates we've seen in the previous exercises.

You can see a diagram of how the circuit works: [Logicly Circuit Diagram](../images/1BitFullAdder.logicly)

To view this diagram, you'll need to use this program: [Logicly Circuit Modeler](http://logic.ly/) (you can use the free trial).

## Section 3 -- Spicy Challenge -- 4-Bit Binary Adder

If you complete the previous section of logic gate experimentation, try your hand at something more
complex by building the 4-bit binary adder described in this video:

[Tutorial Video](https://www.youtube.com/watch?v=wvJc9CZcvBc)

To help you along the way, you can use this program: [Logicly Circuit Modeler](http://logic.ly/) (you can use the free trial)

to view this interactive diagram of how the circuit works: [Logicly Circuit Diagram](../images/4BitAdder.logicly)

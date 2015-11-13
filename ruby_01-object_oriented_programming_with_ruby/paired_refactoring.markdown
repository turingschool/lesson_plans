# Paired Refactoring

## Preparation

* Clone this repo: https://github.com/turingschool-examples/enigma_refactoring_exercises
* Change into the `exercise_1` folder
* Run the tests with `mrspec` to confirm they're all passing

## Challenges

Last night you read some of POODR and thought about breaking systems into objects.

### Challenge 1 - Key Generator

There's a concept here called `OffsetGenerator`, but it muddles together generating the date offset and generating keys (but doesn't actually calculate the offsets for the key!).

* Extract functionality for generating keys into a `KeyGenerator` class.
* At first, use that `KeyGenerator` from inside `OffsetGenerator` (instead of the current key generation functionality) and get the tests to pass again
* Then find where `OffsetGenerator` is used to generate keys and change that to directly work with `KeyGenerator`, and make the tests pass
* Then remove the `generate_key` functionality from `OffsetCalculator` and make sure things still pass

### Challenge 2 - Chunk Rotator

In the `encrypt.rb` there's a lot of repetition and complexity around the actual encryption process.

Imagine you had a `ChunkRotator` machine which:

* Takes in a string-to-be-rotated of up to four characters in length (typically it is four, just the last one of the file might not be four)
* It also takes in a set of total offsets (from adding the key offsets to the date offsets)
* It returns the four characters after rotation

Build and test this component in isolation, then integrate it into the existing `encrypt.rb` replacing all the current rotation functionality.

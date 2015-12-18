---
title: Simulating Load
length: 90
tags: performance, benchmarking, apache bench
status: draft
---

## Learning Goals

* Understand the reasons for load testing rails applications
* Practice using some popular tools to simulating heavy load against an
  application
* Discuss some common pitfalls of testing performance in Dev vs.
  Production environments
* Understand the differences between elapsed time from the perspective
  of your app code and from the perspective of the client
* Understand the performance characteristics of a few different ruby
  webservers and how this affects their response time under load.

## Structure

* 5 - Warmup / Discussion
* 20 - Getting Started -- introduction to Apache Bench; begin tutorial
* 5 - Break
* 25 - Continue Tutorial
* 5 - Break
* 15 - Continue Tutorial
* 10 - Questions & Recap

## Warmup

Discuss some intro questions to get the brain juices flowing:

```
1. What does load testing mean?
2. Why should we bother load testing our applications?
3. What do we mean when we say something is a performance "bottleneck"?
4. Essential Napkin Math: if a page renders in 100ms how many can a single web worker serve in
   1 minute?
```

## Workshop:

http://tutorials.jumpstartlab.com/topics/performance/load_testing.html

## Corrections & Improvements for Next Time

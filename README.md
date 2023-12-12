<div align="center">

# Advent of Code 2023

</div>

## Writeups

## Day1

I have only had very minor exposure to programming in Zig, and was excited to
learn the language a lot better this year. Some immediate things that stood out
to me was how much was checked by the compiler. It feels like a mini-rust of
sorts. The optional and error types are also highly appreciated. Some slight
annoyances with the langauge include unsued variables being a compile error and
the slightly wacky loops.

In part b, I also discovered that the sentinel value of a pointer or slice is
also included in the type, which I found pretty neat. The saturating
subtracting operator is also some nice sugar.

## Day2

Day 2 involved a bit of parsing. My solution for this just involved string
splitting over and over again. I wonder how efficient this is? Perhaps a better
approach would be to make a single pass across the line using an iterator and
have a state machine to decide what we are parsing?

## Day3

Day 3 in all honesty gave me quite a hard time. This was perhaps due to lack of
understanding of the containers in the standard library, leading to perhaps
some really bad code. I also struggled quite a lot with writing nice code using
zig's loops, which behave slightly different to what you would expect from most
other languages. I would like to revisit this question when I get a bit better
at the language perhaps.

## Day4

Pretty clean solution using hashmap to check for winning numbers. Second part
of question was also a nice 1D DP solution. I did misunderstand the question
and thought you win a copy of the card of the number that you matched, leading
to an unnecessary topological sort implmenatation :P.

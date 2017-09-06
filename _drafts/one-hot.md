# One-hot Decoding and Binary Logarithms

One-hot encoding is a very common encoding scheme used to represent state in digital design and natural language processing. . .

Every once in a while I'll find myself needing to convert a one-hot representation into binary, and as usual the top search engine results don't provide enough math backing. Looking at the instructions/run-time for the specific architecture is fine, but the findings will not be very widely applicable due to differing branch costs, cache schemes, and instructions. In this post I will develope a few math based tools for handling one-hot encoding.

---
# Theory

While the name one-hot lends itself nicely to puns, it fails to convey a key property of the encoding. If only one bit in a number is set, it is a power of two. This gives us a very powerful mapping:

` (binary representation) n -> (one-hot representation) 2 ^ n + 1 `

So using pure math decoding a one-hot number is as simple as taking the logarithm with base 2:

` binary = log2(one-hot) `

The simplest way to encode a power of two is with bit shifting.

` 1 << n = 2 ^ n `

---
# Implementations

## Naive Solution

```C

    uint_t decode(uint_t hot) {
      uint_t result = 0;
      while (hot & 1 == 0) {
        result += 1;
        hot >>= 1;
      }
      return result;
    }

```

Calculating the complexity gives us (n is the number of bits):

Comparisons:

- Worst case: `n`

- Best case: `1`

- Average case (assuming uniform distribution):

` (1 / n) * SUM(1) for i = 1:n `

` (1 / n) *  (n * (n + 1)) / 2 `

` (n + 1) / 2`

The memory footprint is: 2 * n

## 

[]: https://www.researchgate.net/publication/284919835_Modular_Design_Of_Fast_Leading_Zeros_Counting_Circuit ()

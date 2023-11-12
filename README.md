# Freqalysis
Toy script to aid with basic frequency analysis tasks.
Given a file (supposedly containing intercepted ciphertext),
it will search for the most frequent:

* Single byte value
* Double repeats
* [Bigrams](https://en.wikipedia.org/wiki/Bigram)
* [Trigrams](https://en.wikipedia.org/wiki/Trigram)

## Character Sets
The character set can be tailored with the `-c` option. By default, all
possible Byte values (0 - 255) are used:

* `%a` (default): Entire numeric range of a Byte
* `%l`: lowercase letters (ASCII)
* `%u`: uppercase letters (ASCII)
* `%n`: alphanumeric characters (ASCII)
* `%h`: hex characters (0 - F)

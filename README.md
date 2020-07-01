# Freqalysis
Toy script to aid with basic frequency analysis tasks.
Given a file (supposedly containing intercepted ciphertext),
it will search for the most frequent:

* Single byte value
* Double repeats
* [Bigrams](https://en.wikipedia.org/wiki/Bigram)
* [Trigrams](https://en.wikipedia.org/wiki/Trigram)

## Character Sets
By default, the script will check the printable
ASCII range from 32 - 126 against the ciphertext. The character set
can be narrowed with the `-c` option:

* `%l`: lowercase letters
* `%u`: uppercase letters
* `%n`: alphanumeric characters
* `%h`: hex characters (0 - F)

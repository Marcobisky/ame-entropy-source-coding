## Description

* `markovC` intended to use `C` to do the second-order AMA (Adaptive markov approximation), but it cannot work due to minor issues.
* `markovcpp` cannot work either.
* `markovMatlab` works well.
* `lzss` intended to use lzss (not lz77) to encode `A-Game-of-Thrones.txt`, but it's not finished.
* `arithmeticOld` intends to use arithmetic coding to encode `markov_encoded.txt`, but it cannot work.
* `removeBackticks` intends to remove the backticks symbols from the second-order AMA encoded file because I initially decided to use backticks (``) to seperate the number of correct predictions from literal text. But since the original literal text do not have numbers, this step is ignored.
* `Requirements` contain the detailed requirements of this task.
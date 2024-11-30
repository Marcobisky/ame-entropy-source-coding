## Description

This folder tackles huffman coding on `original.txt` (without AME).

## Usage

Run `mainHuffman.m` will automatically perform the dictionary generation, encoding, decoding and performance analysis. 

It will generate the following 3 files:

* `binary_huffman.txt` -> binary-encoded text file
* `Huffman_dictionary.txt` -> dictionary: Huffman code for each character
* `received_huffman.txt` -> decoded text file

The performance evaluation information will be displayed on the matlab prompt.

Run

```zsh
diff original.txt received_huffman.txt
```

in zsh (not matlab!) to compare `original.txt` and `received_huffman.txt`. If no prompt, they are the same.
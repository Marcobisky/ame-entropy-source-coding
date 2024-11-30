## Description

This folder tackles fano coding on `original.txt` (without AME).

## Usage

Run `mainFano.m` will automatically perform the dictionary generation, encoding, decoding and performance analysis. 

It will generate the following 3 files:

* `binary_fano.txt` -> binary-encoded text file
* `Fano_dictionary.txt` -> dictionary: Fano code for each character
* `received_fano.txt` -> decoded text file

The performance evaluation information will be displayed on the matlab prompt.

Run

```zsh
diff original.txt received_fano.txt
```

in zsh (not matlab!) to compare `original.txt` and `received_fano.txt`. If no prompt, they are the same.
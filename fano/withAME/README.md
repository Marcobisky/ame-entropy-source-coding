## Description

This folder tackles fano coding on `processed.txt` (with AME).

## Usage

Run `mainFano.m` will automatically perform the dictionary generation, encoding, decoding and performance analysis. 

It will generate the following 3 files:

* `binary_fano_ame.txt` -> binary-encoded text file
* `Fano_dictionary_ame.txt` -> dictionary: Fano code for each character
* `received_fano_ame.txt` -> decoded text file

The performance evaluation information (though do not have reference value) will be displayed on the matlab prompt.

Run

```zsh
diff processed.txt received_fano_ame.txt
```

in zsh (not matlab!) to compare `processed.txt` and `received_fano_ame.txt`. If no prompt, they are the same.
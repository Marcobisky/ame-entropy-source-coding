## Usage

1. Activate environment.
2. Run `adaptive_markov_encode.py` to get AME encoded message (`processed.txt`).
3. Run `adaptive_markov_decode.py` to get the decoded message (`received.txt`).
4. Run

```zsh
diff original.txt received.txt
```

in zsh (not python!) to compare `original.txt` and `received.txt`. If no prompt, they are the same.
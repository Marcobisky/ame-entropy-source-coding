# adaptive_markov_decode.py
import json

def add_to_tree(tree, from_char, to_char):
    """Add a transition to the tree."""
    if from_char not in tree:
        tree[from_char] = {"transitions": {}, "highestFrequency": 0, "probableNextChar": ""}
    
    transitions = tree[from_char]["transitions"]
    if to_char in transitions:
        transitions[to_char] += 1
    else:
        transitions[to_char] = 1
    
    if transitions[to_char] >= tree[from_char]["highestFrequency"]:
        tree[from_char]["highestFrequency"] = transitions[to_char]
        tree[from_char]["probableNextChar"] = to_char

def predict_next(tree, current_char):
    """Predict the next character based on tree."""
    if current_char not in tree:
        return ""
    return tree[current_char]["probableNextChar"]

def decode(encoded_file, decoded_file):
    """Decodes a file using second-order Markov approximation."""
    with open(encoded_file, "rb") as f:
        encoded_text = f.read().decode()

    tree = {}
    decoded_output = []
    i = 0

    while i < len(encoded_text):
        current_char = encoded_text[i]
        
        if i == 0:
            # First character
            decoded_output.append(current_char)
            add_to_tree(tree, "", current_char)
        else:
            prev_char = decoded_output[-1]
            if current_char.isdigit():
                num_str = ""
                while i < len(encoded_text) and encoded_text[i].isdigit():
                    num_str += encoded_text[i]
                    i += 1
                i -= 1
                repeat_count = int(num_str)
                for _ in range(repeat_count):
                    prediction = predict_next(tree, prev_char)
                    if not prediction:
                        raise ValueError(f"Decoding error: No valid prediction for {prev_char}.")
                    add_to_tree(tree, prev_char, prediction)
                    decoded_output.append(prediction)
                    prev_char = prediction
            else:
                decoded_output.append(current_char)
                add_to_tree(tree, prev_char, current_char)

        i += 1

    with open(decoded_file, "wb") as f:
        f.write("".join(decoded_output).encode())

if __name__ == "__main__":
    decode("processed.txt", "received.txt")

# adaptive_markov_encode.py
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

def encode(source_file, output_file):
    """Encodes a file using second-order Markov approximation."""
    with open(source_file, "rb") as f:
        source_text = f.read().decode()

    tree = {}
    encoded_output = []
    correct_predictions = 0

    for i, current_char in enumerate(source_text):
        if i == 0:
            add_to_tree(tree, "", current_char)
            encoded_output.append(current_char)
        else:
            prev_char = source_text[i - 1]
            prediction = predict_next(tree, prev_char)

            if prediction == current_char:
                correct_predictions += 1
            else:
                if correct_predictions > 0:
                    encoded_output.append(str(correct_predictions))
                    correct_predictions = 0
                encoded_output.append(current_char)
            add_to_tree(tree, prev_char, current_char)

    if correct_predictions > 0:
        encoded_output.append(str(correct_predictions))

    with open(output_file, "wb") as f:
        f.write("".join(encoded_output).encode())

if __name__ == "__main__":
    encode("original.txt", "processed.txt")

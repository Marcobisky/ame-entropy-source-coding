# adaptive_markov_encode.py
import json

def add_to_tree(tree, from_char, to_char):
    """Add a transition to the tree."""
    if from_char not in tree:
        # Initialize the character in the tree with transition data
        tree[from_char] = {"transitions": {}, "highestFrequency": 0, "probableNextChar": ""}
    
    transitions = tree[from_char]["transitions"]
    if to_char in transitions:
        # Increment frequency for an existing transition
        transitions[to_char] += 1
    else:
        # Add a new transition to the tree
        transitions[to_char] = 1
    
    if transitions[to_char] >= tree[from_char]["highestFrequency"]:
        # Update the most probable next character if frequency increases
        tree[from_char]["highestFrequency"] = transitions[to_char]
        tree[from_char]["probableNextChar"] = to_char

def predict_next(tree, current_char):
    """Predict the next character based on tree."""
    if current_char not in tree:
        return ""  # Return empty if no prediction available
    return tree[current_char]["probableNextChar"]

def encode(source_file, output_file):
    """Encodes a file using second-order Markov approximation."""
    with open(source_file, "rb") as f:
        source_text = f.read().decode()  # Read and decode source file

    tree = {}  # Transition tree
    encoded_output = []  # Encoded text storage
    correct_predictions = 0  # Counter for consecutive correct predictions

    for i, current_char in enumerate(source_text):
        if i == 0:
            # Special case for the first character
            add_to_tree(tree, "", current_char)
            encoded_output.append(current_char)
        else:
            prev_char = source_text[i - 1]  # Previous character in sequence
            prediction = predict_next(tree, prev_char)

            if prediction == current_char:
                # Count correct predictions for consecutive matches
                correct_predictions += 1
            else:
                if correct_predictions > 0:
                    # Append count of correct predictions if any
                    encoded_output.append(str(correct_predictions))
                    correct_predictions = 0
                encoded_output.append(current_char)  # Append actual character
            add_to_tree(tree, prev_char, current_char)  # Update tree with transition

    if correct_predictions > 0:
        # Append remaining correct predictions at the end
        encoded_output.append(str(correct_predictions))

    with open(output_file, "wb") as f:
        f.write("".join(encoded_output).encode())  # Save encoded text

if __name__ == "__main__":
    encode("original.txt", "processed.txt")
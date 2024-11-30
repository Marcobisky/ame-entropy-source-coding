# adaptive_markov_decode.py
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

def decode(encoded_file, decoded_file):
    """Decodes a file using second-order Markov approximation."""
    with open(encoded_file, "rb") as f:
        encoded_text = f.read().decode()  # Read and decode the encoded file

    tree = {}  # Transition tree
    decoded_output = []  # Storage for decoded output
    i = 0  # Index for traversing encoded text

    while i < len(encoded_text):
        current_char = encoded_text[i]
        
        if i == 0:
            # First character, no previous context
            decoded_output.append(current_char)
            add_to_tree(tree, "", current_char)  # Add transition from initial state
        else:
            prev_char = decoded_output[-1]  # Previous character in the decoded output
            if current_char.isdigit():
                # Handle repetition encoded as numbers
                num_str = ""
                while i < len(encoded_text) and encoded_text[i].isdigit():
                    num_str += encoded_text[i]  # Build the number as a string
                    i += 1
                i -= 1  # Adjust index after loop
                repeat_count = int(num_str)
                for _ in range(repeat_count):
                    # Predict and decode repeated characters
                    prediction = predict_next(tree, prev_char)
                    if not prediction:
                        raise ValueError(f"Decoding error: No valid prediction for {prev_char}.")
                    add_to_tree(tree, prev_char, prediction)  # Update tree with prediction
                    decoded_output.append(prediction)
                    prev_char = prediction
            else:
                # Handle regular character encoding
                decoded_output.append(current_char)
                add_to_tree(tree, prev_char, current_char)  # Update tree with transition

        i += 1  # Move to the next character in the encoded text

    with open(decoded_file, "wb") as f:
        f.write("".join(decoded_output).encode())  # Save decoded text

if __name__ == "__main__":
    decode("processed.txt", "received.txt")
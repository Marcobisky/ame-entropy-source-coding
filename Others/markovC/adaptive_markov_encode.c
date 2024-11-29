// Filename: adaptive_markov_encode.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_CHAR 256

typedef struct Node {
    int count[MAX_CHAR];
    int total;
    char most_probable;
} Node;

Node tree[MAX_CHAR];

void initialize_tree() {
    for (int i = 0; i < MAX_CHAR; i++) {
        memset(tree[i].count, 0, sizeof(tree[i].count));
        tree[i].total = 0;
        tree[i].most_probable = 0;
    }
}

void add_to_tree(char from_char, char to_char) {
    int from_index = (unsigned char)from_char;
    int to_index = (unsigned char)to_char;

    tree[from_index].count[to_index]++;
    tree[from_index].total++;

    if (tree[from_index].count[to_index] > tree[from_index].count[(unsigned char)tree[from_index].most_probable]) {
        tree[from_index].most_probable = to_char;
    }
}

char predict_next(char from_char) {
    return tree[(unsigned char)from_char].most_probable;
}

int main() {
    const char *source_file = "source.txt";
    const char *encoded_file = "markov_encoded.txt";

    FILE *input = fopen(source_file, "rb");
    if (!input) {
        perror("Error opening source file");
        return 1;
    }

    FILE *output = fopen(encoded_file, "wb");
    if (!output) {
        perror("Error opening encoded file");
        fclose(input);
        return 1;
    }

    initialize_tree();
    char prev_char = '\0';
    char current_char;
    int correct_predictions = 0;

    while (fread(&current_char, 1, 1, input)) {
        if (prev_char) {
            char prediction = predict_next(prev_char);
            if (prediction == current_char) {
                correct_predictions++;
            } else {
                if (correct_predictions > 0) {
                    fprintf(output, "%d", correct_predictions);
                    correct_predictions = 0;
                }
                fputc(current_char, output);
            }
            add_to_tree(prev_char, current_char);
        } else {
            fputc(current_char, output);
        }
        prev_char = current_char;
    }

    if (correct_predictions > 0) {
        fprintf(output, "%d", correct_predictions);
    }

    fclose(input);
    fclose(output);

    return 0;
}
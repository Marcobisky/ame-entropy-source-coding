// Filename: adaptive_markov_decode.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

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
    const char *encoded_file = "markov_encoded.txt";
    const char *decoded_file = "markov_decoded.txt";

    FILE *input = fopen(encoded_file, "rb");
    if (!input) {
        perror("Error opening encoded file");
        return 1;
    }

    FILE *output = fopen(decoded_file, "wb");
    if (!output) {
        perror("Error opening decoded file");
        fclose(input);
        return 1;
    }

    initialize_tree();
    char *decoded_output = malloc(1);
    decoded_output[0] = '\0';
    char prev_char = '\0';
    char current_char;
    int repeat_count = 0;
    size_t decoded_len = 0;

    while (fread(&current_char, 1, 1, input)) {
        if (isdigit(current_char)) {
            repeat_count = repeat_count * 10 + (current_char - '0');
        } else {
            if (repeat_count > 0) {
                for (int i = 0; i < repeat_count; i++) {
                    char prediction = predict_next(prev_char);
                    if (!prediction) {
                        fprintf(stderr, "Decoding error: No valid prediction for '%c'\n", prev_char);
                        free(decoded_output);
                        fclose(input);
                        fclose(output);
                        return 1;
                    }
                    decoded_output = realloc(decoded_output, decoded_len + 2);
                    decoded_output[decoded_len++] = prediction;
                    decoded_output[decoded_len] = '\0';
                    add_to_tree(prev_char, prediction);
                    prev_char = prediction;
                }
                repeat_count = 0;
            }

            decoded_output = realloc(decoded_output, decoded_len + 2);
            decoded_output[decoded_len++] = current_char;
            decoded_output[decoded_len] = '\0';
            add_to_tree(prev_char, current_char);
            prev_char = current_char;
        }
    }

    fwrite(decoded_output, 1, decoded_len, output);
    free(decoded_output);
    fclose(input);
    fclose(output);

    return 0;
}
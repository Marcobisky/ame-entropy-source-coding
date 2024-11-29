#include <iostream>
#include <fstream>
#include <unordered_map>
#include <string>
#include <sstream>
#include <cctype>

using namespace std;

struct Transition {
    unordered_map<char, int> counts;
    char probableNextChar = '\0';
    int highestFrequency = 0;
};

void addToTree(unordered_map<char, Transition> &tree, char fromChar, char toChar) {
    if (tree.find(fromChar) == tree.end()) {
        tree[fromChar] = Transition();
    }

    auto &transitions = tree[fromChar];
    transitions.counts[toChar]++;
    if (transitions.counts[toChar] >= transitions.highestFrequency) {
        transitions.highestFrequency = transitions.counts[toChar];
        transitions.probableNextChar = toChar;
    }
}

char predictNext(unordered_map<char, Transition> &tree, char currentChar) {
    if (tree.find(currentChar) == tree.end()) {
        return '\0'; // No prediction possible
    }
    return tree[currentChar].probableNextChar;
}

int main() {
    string encodedFile = "markov_encoded.txt";
    string decodedFile = "markov_decoded.txt";

    ifstream inputFile(encodedFile, ios::binary);
    ofstream outputFile(decodedFile, ios::binary);

    if (!inputFile.is_open() || !outputFile.is_open()) {
        cerr << "Error opening file!" << endl;
        return 1;
    }

    string encodedText((istreambuf_iterator<char>(inputFile)), istreambuf_iterator<char>());
    inputFile.close();

    unordered_map<char, Transition> tree;
    string decodedOutput;

    size_t i = 0;
    while (i < encodedText.length()) {
        char currentChar = encodedText[i];

        if (i == 0) {
            decodedOutput += currentChar;
            addToTree(tree, '\0', currentChar);
        } else {
            char prevChar = decodedOutput.back();

            if (isdigit(currentChar)) {
                string numStr;
                while (i < encodedText.length() && isdigit(encodedText[i])) {
                    numStr += encodedText[i];
                    i++;
                }
                i--;

                int repeatCount = stoi(numStr);
                for (int j = 0; j < repeatCount; j++) {
                    char prediction = predictNext(tree, prevChar);
                    if (prediction == '\0') {
                        cerr << "Decoding error: No valid prediction found." << endl;
                        return 1;
                    }
                    decodedOutput += prediction;
                    addToTree(tree, prevChar, prediction);
                    prevChar = prediction;
                }
            } else {
                decodedOutput += currentChar;
                addToTree(tree, prevChar, currentChar);
            }
        }
        i++;
    }

    outputFile.write(decodedOutput.c_str(), decodedOutput.size());
    outputFile.close();

    return 0;
}
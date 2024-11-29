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
    string sourceFile = "source.txt";
    string outputFile = "markov_encoded.txt";

    ifstream inputFile(sourceFile, ios::binary);
    ofstream encodedFile(outputFile, ios::binary);

    if (!inputFile.is_open() || !encodedFile.is_open()) {
        cerr << "Error opening file!" << endl;
        return 1;
    }

    string sourceText((istreambuf_iterator<char>(inputFile)), istreambuf_iterator<char>());
    inputFile.close();

    unordered_map<char, Transition> tree;
    string encodedOutput;
    int correctPredictions = 0;

    for (size_t i = 0; i < sourceText.length(); i++) {
        char currentChar = sourceText[i];

        if (i == 0) {
            encodedOutput += currentChar;
            addToTree(tree, '\0', currentChar);
        } else {
            char prevChar = sourceText[i - 1];
            char prediction = predictNext(tree, prevChar);

            if (prediction == currentChar) {
                correctPredictions++;
            } else {
                if (correctPredictions > 0) {
                    encodedOutput += to_string(correctPredictions);
                    correctPredictions = 0;
                }
                encodedOutput += currentChar;
            }
            addToTree(tree, prevChar, currentChar);
        }
    }

    if (correctPredictions > 0) {
        encodedOutput += to_string(correctPredictions);
    }

    encodedFile.write(encodedOutput.c_str(), encodedOutput.size());
    encodedFile.close();

    return 0;
}


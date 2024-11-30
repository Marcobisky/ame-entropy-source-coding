clear;
% Performance analysis for the coding scheme when changing the length of the encoding content
inputFilePath = 'originalFull.txt'; % the original text

% Read input text
fileID = fopen(inputFilePath, 'r');
text = fscanf(fileID, '%c');
fclose(fileID);

% Initialize array for graphing
text_size = 2:10000:length(text);
huffman_binary_length = zeros(1, length(text_size));
fano_binary_length = zeros(1, length(text_size));
ame_huffman_binary_length = zeros(1, length(text_size));
ame_fano_binary_length = zeros(1, length(text_size));

% Encoding on partial content

for i = 1:length(text_size)
    partialText = text(1:text_size(i));

    % Directly perform huffman coding
    [huffman_partial_encoded, ~] = huffman_encode(partialText);
    huffman_binary_length(i) = length(huffman_partial_encoded);

    % Directly perform shannon-fano coding
    [fano_partial_encoded, ~] = fano_encode(partialText);
    fano_binary_length(i) = length(fano_partial_encoded);

    % Use AME first then perform huffman coding
    ame_partial_encoded = ame_encode(partialText);
    [huffman_ame_partial_encoded, ~] = huffman_encode(ame_partial_encoded);
    ame_huffman_binary_length(i) = length(huffman_ame_partial_encoded);

    % Use AME first then perform shannon-fano coding
    [fano_ame_partial_encoded, ~] = fano_encode(ame_partial_encoded);
    ame_fano_binary_length(i) = length(fano_ame_partial_encoded);
end

% Plot the results
figure;
plot(text_size, huffman_binary_length, 'r', 'LineWidth', 2);
hold on;
plot(text_size, fano_binary_length, 'b', 'LineWidth', 2);
plot(text_size, ame_huffman_binary_length, 'g', 'LineWidth', 2);
plot(text_size, ame_fano_binary_length, 'm', 'LineWidth', 2);
xlabel('Length of Text (characters)');
ylabel('Length of Encoded Message (bits)');
title('Performance Analysis of Different Coding Schemes');
legend('Huffman Encoding', 'Shannon-Fano Encoding', 'AME + Huffman Encoding', 'AME + Shannon-Fano Encoding');
grid on;
hold off;
% 1.initialise four different paths
inputFilePath = 'processed.txt'; % the original text
encodedFilePath = 'binary_ame.txt'; % binary-encoded text file
dictFilePath = 'ame_huffman_dictionary.txt'; % dictionary: Huffman code for each character
decodeFilePath = 'decoded_ame.txt'; % decoded text file

% 2.read input text
fileID = fopen(inputFilePath, 'r');
text = fscanf(fileID, '%c');
fclose(fileID);
   
% 3.encode that original text using Huffman decoding and put that in a .txt file
[encoded_text, dict] = huffman_encode(text);
fileID = fopen(encodedFilePath, 'w');
fprintf(fileID, '%d', encoded_text);
fclose(fileID);

% 4.put the dictionary in a .txt file and display that
fileID = fopen(dictFilePath, 'w');
for i = 1:length(dict)
    fprintf(fileID, '%s: %s\n', num2str(cell2mat(dict(i, 1))), num2str(cell2mat(dict(i, 2))));
end
fclose(fileID);

% 5.decode the encoded text and put that in a .txt file using Huffman decoding
decodedMessage = huffman_decode(encoded_text, dict);
fileID = fopen(decodeFilePath, 'w');
fprintf(fileID, '%s', decodedMessage);
fclose(fileID);

% 6.verify if decoding was successful
if isequal(text, decodedMessage)
    disp('Decoding is successful!');
else
    disp('Decoding failed.');
end

% 7.calculate some relevant parameters and display them
[avgCodeLength, rate, efficiency,zip_rate] = calculate_encoding_metrics(text,dict);
disp('average code length:');disp(avgCodeLength);
disp('code rate:');disp(rate);
disp('efficiency:');disp(efficiency);
disp('zip_rate:');disp(zip_rate);
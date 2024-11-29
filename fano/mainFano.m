% 1.initialise four different paths
inputFilePath = 'markov_encoded.txt';% the original text
encodedFilePath = 'Fano_encoded_output.txt';% binary-encoded text file
dictFilePath = 'Fano_dictionary.txt';% dictionary: Huffman code for each character
decodedFilePath = 'Fano_decode_message.txt';% decoded text file

% 2.read input text
fileID = fopen(inputFilePath, 'r');
text = fread(fileID, '*char')'; % Read all characters, preserving spaces and line endings
fclose(fileID);
% replace CRLF with a unique marker to ensure consistent handling
crlfMarker = '\r\n'; % Marker for CRLF during encoding/decoding
text = strrep(text, char([13 10]), crlfMarker); % Replace \r\n with marker

% 3.encode that original text using Fano decoding and put that in a .txt file
[encodedMessage, dict] = fano_encode(text);
% Ensure spaces are correctly encoded and stored in the dictionary
dict{strcmp(dict(:, 1), ' '), 1} = '_'; % Map space to underscore
fileID = fopen(encodedFilePath, 'w');
fprintf(fileID, '%s', encodedMessage); % Write as binary string
fclose(fileID);

% 4.put the Fano dictionary in a .txt file with CRLF format
fileID = fopen(dictFilePath, 'w');
for i = 1:size(dict, 1)
    line = sprintf('%s: %s\r\n', char(dict{i, 1}), dict{i, 2}); % Use \r\n for CRLF
    fwrite(fileID, line, 'char'); % Write each line explicitly with CRLF
end
fclose(fileID);

% 5.decode the encoded text and put that in a .txt file using Fano decoding
decodedMessage = fano_decode(encodedMessage, dict);
% ensure underscores are converted back to spaces
decodedMessage = strrep(decodedMessage, '_', ' ');
% restore original CRLF line endings (without markers in the output file)
decodedMessage = strrep(decodedMessage, crlfMarker, char([13 10])); % Replace marker with \r\n
% write the decoded message to a file
fileID = fopen(decodedFilePath, 'w');
fwrite(fileID, decodedMessage, 'char'); % Use fwrite to ensure exact output including spaces and line endings
fclose(fileID);

% 6.verify if decoding was successful
if isequal(strrep(text, crlfMarker, char([13 10])), decodedMessage)
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
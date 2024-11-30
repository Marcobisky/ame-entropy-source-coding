% 1. initialise four different paths
inputFilePath = 'processed.txt';% the original text
encodedFilePath = 'binary_fano_ame.txt';% binary-encoded text file
dictFilePath = 'Fano_dictionary_ame.txt';% dictionary: Huffman code for each character
decodedFilePath = 'received_fano_ame.txt';% decoded text file

% 2. read input text
fileID = fopen(inputFilePath, 'rb');
text = fread(fileID, '*char')'; % Read all characters, preserving spaces and line endings
fclose(fileID);

% 3. encode that original text using Fano decoding and put that in a .txt file
[encodedMessage, dict] = fano_encode(text);

fileID = fopen(encodedFilePath, 'wb');
fwrite(fileID, encodedMessage, 'char'); % Write the encoded message as is
fclose(fileID);

% 4. put the Fano dictionary in a .txt file with CRLF format
fileID = fopen(dictFilePath, 'wb');
for i = 1:size(dict, 1)
    line = sprintf('%s: %s\r\n', char(dict{i, 1}), dict{i, 2}); % Use \r\n for CRLF
    fwrite(fileID, line, 'char'); % Write each line explicitly with CRLF
end
fclose(fileID);

% 5. decode the encoded text and put that in a .txt file using Fano decoding
decodedMessage = fano_decode(encodedMessage, dict);

% write the decoded message to a file
fileID = fopen(decodedFilePath, 'wb');
fwrite(fileID, decodedMessage, 'char'); % Use fwrite to ensure exact output including spaces and line endings
fclose(fileID);

% 6. calculate some relevant parameters and display them
[avgCodeLength, rate, efficiency, zip_rate] = calculate_encoding_metrics(text,dict);
disp('average code length:');disp(avgCodeLength);
disp('code rate:');disp(rate);
disp('efficiency:');disp(efficiency);
disp('zip_rate:');disp(zip_rate);
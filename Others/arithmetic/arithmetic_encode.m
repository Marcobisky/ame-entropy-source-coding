clear;
input_file = 'source.txt';


% Read the input text
input_text = fileread(input_file);

% Build the frequency table and assign binary codes
[symbols, binary_codes] = build_binary_dictionary(input_text);

% Encode the text using the binary dictionary
binary_encoded = encode_to_binary(input_text, symbols, binary_codes);

% Save the dictionary and binary encoded message
save_binary_dictionary(symbols, binary_codes, 'dictionary.txt');
save_encoded_message(binary_encoded, 'encoded.txt');

disp('Encoding complete. Files saved: dictionary.txt, encoded.txt');



function [symbols, binary_codes] = build_binary_dictionary(text)
    % Calculate symbol frequencies
    symbols = unique(text);
    freq = histcounts(double(text), double([symbols, max(text) + 1]));
    freq = freq / sum(freq); % Normalize frequencies
    
    % Assign binary codes (using variable-length codes for compactness)
    num_symbols = length(symbols);
    binary_codes = cell(num_symbols, 1);
    for i = 1:num_symbols
        binary_codes{i} = dec2bin(i-1, ceil(log2(num_symbols))); % Binary representation
    end
end

function binary_encoded = encode_to_binary(text, symbols, binary_codes)
    % Convert text to binary using the dictionary
    binary_encoded = '';
    for char = text
        idx = find(symbols == char, 1);
        binary_encoded = strcat(binary_encoded, binary_codes{idx});
    end
end

function save_binary_dictionary(symbols, binary_codes, filename)
    % Save the dictionary (key: binary value)
    fileID = fopen(filename, 'w');
    for i = 1:length(symbols)
        fprintf(fileID, '%c: %s\n', symbols(i), binary_codes{i});
    end
    fclose(fileID);
end

function save_encoded_message(binary_encoded, filename)
    % Save the binary-encoded message
    fileID = fopen(filename, 'wb');
    fwrite(fileID, binary_encoded, 'char');
    fclose(fileID);
end
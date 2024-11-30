clear;
dictionary_file = 'dictionary.txt';
encoded_file = 'encoded.txt';
output_file = 'decoded.txt';


% Read the binary dictionary
[symbols, binary_codes] = load_binary_dictionary(dictionary_file);

% Read the binary encoded message
binary_encoded = load_encoded_message(encoded_file);

% Decode the binary sequence back to text
decoded_text = decode_from_binary(binary_encoded, symbols, binary_codes);

% Save the decoded text to the output file
save_decoded_text(decoded_text, output_file);

disp(['Decoding complete. Original text saved in: ', output_file]);


function [symbols, binary_codes] = load_binary_dictionary(filename)
    % Load the binary dictionary (key: binary value)
    fileID = fopen(filename, 'rb');
    data = textscan(fileID, '%c: %s', 'Delimiter', '\n');
    fclose(fileID);
    
    symbols = data{1};
    binary_codes = data{2};
end

function binary_encoded = load_encoded_message(filename)
    % Load the binary encoded message (concatenate chunks into a single sequence)
    fileID = fopen(filename, 'rb');
    binary_encoded = '';
    while ~feof(fileID)
        line = fgetl(fileID);
        binary_encoded = strcat(binary_encoded, line); % Concatenate each line
    end
    fclose(fileID);
end

function decoded_text = decode_from_binary(binary_encoded, symbols, binary_codes)
    % Decode the binary sequence into text
    decoded_text_parts = {}; % Use a cell array for robust concatenation
    temp = '';
    
    for bit = binary_encoded
        temp = [temp, bit]; % Accumulate the binary string bit by bit
        idx = find(strcmp(temp, binary_codes), 1);
        if ~isempty(idx)
            decoded_text_parts{end+1} = symbols(idx); % Append symbol to cell array
            temp = ''; % Reset temp
        end
    end
    
    % Combine the parts into the final decoded text
    decoded_text = strjoin(decoded_text_parts, '');
end

function save_decoded_text(data, filename)
    % Save the decoded text to a file
    fileID = fopen(filename, 'wb');
    fwrite(fileID, data, 'char');
    fclose(fileID);
end

% function binary_encoded = load_encoded_message(filename)
%     % Load the binary-encoded message from file
%     fileID = fopen(filename, 'r');
%     binary_encoded = '';
%     while ~feof(fileID)
%         line = fgetl(fileID);
%         if ischar(line)
%             binary_encoded = strcat(binary_encoded, line); % Concatenate lines
%         end
%     end
%     fclose(fileID);
% end


% function decoded_text = decode_from_binary(binary_encoded, symbols, binary_codes)
%     % Decode the binary sequence into text
%     decoded_text_parts = {}; % Use cell array for robust concatenation
%     temp = ''; % Temporary binary code accumulator
    
%     for bit = binary_encoded
%         temp = [temp, bit]; % Append the bit to the temporary code
%         idx = find(strcmp(temp, binary_codes), 1); % Check if the code matches any binary code
%         if ~isempty(idx)
%             decoded_text_parts{end+1} = symbols(idx); % Append symbol to parts
%             temp = ''; % Reset temp
%         end
%     end
    
%     % Combine all parts into the final decoded text
%     decoded_text = strjoin(decoded_text_parts, '');
% end

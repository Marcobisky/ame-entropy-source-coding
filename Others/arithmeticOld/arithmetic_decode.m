% File: arithmetic_decode.m
function arithmetic_decode(dictionary_file, encoded_file, output_file)
    % Read the dictionary file
    [symbols, ranges] = read_dictionary(dictionary_file);
    
    % Read the encoded binary sequence
    binary_encoded = fileread(encoded_file);
    
    % Convert binary sequence to decimal
    encoded_value = binary_to_decimal(binary_encoded);
    
    % Decode the encoded value back to text
    decoded_text = arithmetic_decoding(encoded_value, symbols, ranges);
    
    % Save the decoded text to the output file
    save_to_file(decoded_text, output_file);
    
    disp(['Decoding complete. Original text saved in: ', output_file]);
end

function [symbols, ranges] = read_dictionary(dictionary_file)
    % Read the dictionary file and extract symbols and their ranges
    fileID = fopen(dictionary_file, 'r');
    data = textscan(fileID, '%c%f%*[^\n]', 'HeaderLines', 1); % Symbol and frequency columns
    fclose(fileID);
    
    symbols = data{1};
    freq = data{2};
    
    % Calculate cumulative probabilities from frequencies
    cumulative_probs = [0; cumsum(freq)];
    ranges = [cumulative_probs(1:end-1), cumulative_probs(2:end)];
end

function value = binary_to_decimal(binary)
    % Convert binary string to decimal
    value = 0;
    for i = 1:length(binary)
        if binary(i) == '1'
            value = value + 2^(-i);
        end
    end
end

function decoded_text = arithmetic_decoding(encoded_value, symbols, ranges)
    % Decode the encoded value using the dictionary
    decoded_text = '';
    while true
        % Find the range containing the current encoded value
        idx = find(encoded_value >= ranges(:, 1) & encoded_value < ranges(:, 2), 1);
        if isempty(idx)
            break; % Stop decoding if no range matches
        end
        
        % Append the corresponding symbol to the output
        decoded_text = strcat(decoded_text, symbols(idx));
        
        % Narrow the range
        low = ranges(idx, 1);
        high = ranges(idx, 2);
        width = high - low;
        encoded_value = (encoded_value - low) / width;
    end
end

function save_to_file(data, filename)
    % Save the decoded text to a file
    fileID = fopen(filename, 'w');
    fprintf(fileID, '%s', data);
    fclose(fileID);
end
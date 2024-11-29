% File: arithmetic_encode.m
function arithmetic_encode(input_file)
    % Read the input file
    input_text = fileread(input_file);
    
    % Get unique characters and their frequencies
    [symbols, freq] = get_frequencies(input_text);
    
    % Calculate cumulative probabilities
    [ranges, cumulative_probs] = calculate_ranges(symbols, freq);
    
    % Encode the input text using arithmetic coding
    encoded_value = arithmetic(input_text, symbols, ranges);
    
    % Convert encoded value to binary
    binary_encoded = encode_to_binary(encoded_value);
    
    % Save the dictionary file
    save_dictionary(symbols, freq, cumulative_probs, 'dictionary.txt');
    
    % Save the binary encoded file
    save_to_file(binary_encoded, 'encoded.txt');
    
    disp('Encoding complete. Files saved: dictionary.txt, encoded.txt');
end

function [symbols, freq] = get_frequencies(text)
    % Count the frequency of each unique character
    symbols = unique(text);
    freq = zeros(size(symbols));
    for i = 1:length(symbols)
        freq(i) = sum(text == symbols(i));
    end
    % Normalize frequencies to probabilities
    freq = freq / sum(freq);
end

function [ranges, cumulative_probs] = calculate_ranges(symbols, freq)
    % Calculate ranges for each symbol
    cumulative_probs = [0; cumsum(freq(:))]; % Cumulative probabilities
    ranges = [cumulative_probs(1:end-1), cumulative_probs(2:end)]; % Start, End ranges
end

function encoded_value = arithmetic(text, symbols, ranges)
    % Perform arithmetic coding
    low = 0.0;
    high = 1.0;
    for char = text
        idx = find(symbols == char, 1);
        range = ranges(idx, :);
        width = high - low;
        high = low + width * range(2);
        low = low + width * range(1);
    end
    % Return a value in the final range
    encoded_value = (low + high) / 2;
end

function binary_encoded = encode_to_binary(value)
    % Convert the encoded value to binary representation
    binary_encoded = '';
    while value > 0
        value = value * 2;
        if value >= 1
            binary_encoded = strcat(binary_encoded, '1');
            value = value - 1;
        else
            binary_encoded = strcat(binary_encoded, '0');
        end
    end
end

function save_dictionary(symbols, freq, cumulative_probs, filename)
    % Save the dictionary (symbols, frequencies, ranges) to a file
    fileID = fopen(filename, 'w');
    fprintf(fileID, 'Symbol\tFrequency\tRange\n');
    for i = 1:length(symbols)
        fprintf(fileID, '%c\t%.4f\t[%.4f, %.4f]\n', symbols(i), freq(i), ...
                cumulative_probs(i), cumulative_probs(i+1));
    end
    fclose(fileID);
end

function save_to_file(data, filename)
    % Save the binary encoded data to a file
    fileID = fopen(filename, 'w');
    fprintf(fileID, '%s', data);
    fclose(fileID);
end
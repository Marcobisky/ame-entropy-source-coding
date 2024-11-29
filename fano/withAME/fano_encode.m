function [encodedMessage, dict] = fano_encode(text)
    % Compute symbol frequencies
    symbols = unique(text); % Unique characters, including spaces
    counts = histc(text, symbols); % Count occurrences

    % Convert symbols into cell format for compatibility
    symbols = num2cell(symbols);

    % Calculate probabilities
    probabilities = counts / sum(counts);

    % Sort symbols by probabilities in descending order
    [probabilities, idx] = sort(probabilities, 'descend');
    symbols = symbols(idx);

    % Generate Fano code dictionary
    dict = fano_create_dict(symbols, probabilities);

    % Encode the text
    encodedMessage = '';
    for i = 1:length(text)
        % Match each character to its code in the dictionary
        symbol = text(i);
        code = dict{ismember(dict(:,1), {symbol}), 2};
        encodedMessage = strcat(encodedMessage, code);
    end
end

function dict = fano_create_dict(symbols, probabilities)
    % Initialize dictionary
    dict = cell(length(symbols), 2);
    dict(:, 1) = symbols; % Add symbols to the dictionary

    % Recursive function to generate Fano codes
    function generate_code(subset, code)
        if numel(subset) == 1
            % Assign code to the only symbol left
            dict{ismember(dict(:,1), subset{1}), 2} = code;
            return;
        end

        % Find the partition point
        cumulative = cumsum(probabilities(ismember(symbols, subset)));
        total = cumulative(end);
        partition = find(cumulative >= total / 2, 1);

        % Split symbols into two groups and assign 0/1
        generate_code(subset(1:partition), [code, '0']);
        generate_code(subset(partition+1:end), [code, '1']);
    end

    % Start the recursive encoding
    generate_code(symbols, '');
end

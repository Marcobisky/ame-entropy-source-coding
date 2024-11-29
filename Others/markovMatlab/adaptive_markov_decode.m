function adaptive_markov_decode(encoded_file, decoded_file)
    % Read the encoded file in binary mode to capture all characters, including CRLF
    fid = fopen(encoded_file, 'rb'); % Open in binary mode
    encoded_text = fread(fid, '*char')'; % Read as a string
    fclose(fid);
    
    % Initialize tree structure (as a containers.Map) and decoded output
    tree = containers.Map(); % Each node points to a map of next characters and counts
    decoded_output = ""; % Use a string array for safe concatenation
    i = 1; % Pointer for the encoded text
    
    while i <= length(encoded_text)
        current_char = encoded_text(i);
        
        if i == 1
            % First character, no prediction, just add it
            decoded_output = decoded_output + current_char;
            add_to_tree(tree, '', current_char); % Add to the tree
        else
            prev_char = decoded_output(end); % Get the last decoded character
            
            if isstrprop(current_char, 'digit') % If current_char is a number
                % Read the full number
                num_str = "";
                while i <= length(encoded_text) && isstrprop(encoded_text(i), 'digit')
                    num_str = num_str + encoded_text(i);
                    i = i + 1;
                end
                i = i - 1; % Adjust index after reading digits
                
                % Convert number to integer
                repeat_count = str2double(num_str);
                
                % Predict the most likely next character
                prediction = predict_next(tree, prev_char);
                
                if prediction == ''
                    error('Decoding error: No valid prediction found for %s.', prev_char);
                end
                
                % Append the predicted character `repeat_count` times
                decoded_output = decoded_output + repmat(prediction, 1, repeat_count);
                
                % Update the tree with repeated transitions
                for j = 1:repeat_count
                    add_to_tree(tree, prev_char, prediction);
                    prev_char = prediction; % Update prev_char for next iteration
                end
            else
                % Current character is not a number, decode normally
                decoded_output = decoded_output + current_char;
                add_to_tree(tree, prev_char, current_char); % Update the tree
            end
        end
        
        % Move to the next character
        i = i + 1;
    end
    
    % Write the decoded text to the output file
    fid = fopen(decoded_file, 'wb'); % Open in binary mode
    fwrite(fid, decoded_output, 'char'); % Write preserving all characters
    fclose(fid);
end

function add_to_tree(tree, from_char, to_char)
    % Add a transition to the tree
    if ~isKey(tree, from_char)
        tree(from_char) = containers.Map(); % Create new node if not exists
    end
    
    % Get the transition map for the current node
    transitions = tree(from_char);
    
    if isKey(transitions, to_char)
        transitions(to_char) = transitions(to_char) + 1; % Increment count
    else
        transitions(to_char) = 1; % Initialize with count of 1
    end
    
    % Update the most recent arrow (tracked as 'last' in the map)
    transitions('last') = to_char;
    tree(from_char) = transitions;
end

function prediction = predict_next(tree, current_char)
    % Predict the next character based on tree
    if ~isKey(tree, current_char)
        prediction = ''; % No prediction possible
        return;
    end
    
    % Get transitions for the current node
    transitions = tree(current_char);
    
    % Find the most probable next character
    max_count = 0;
    prediction = '';
    
    keys = transitions.keys;
    for k = 1:length(keys)
        key = keys{k};
        if strcmp(key, 'last') % Skip the 'last' marker
            continue;
        end
        
        count = transitions(key);
        if count > max_count
            max_count = count;
            prediction = key;
        elseif count == max_count
            % Tie-breaking: choose the most recent one
            if strcmp(transitions('last'), key)
                prediction = key;
            end
        end
    end
end
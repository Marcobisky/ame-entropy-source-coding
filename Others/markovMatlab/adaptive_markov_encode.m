function adaptive_markov_encode(source_file, output_file)
    % Read the source file in binary mode to capture all characters, including CRLF
    fid = fopen(source_file, 'rb'); % Open in binary mode
    source_text = fread(fid, '*char')'; % Read as a string
    fclose(fid);
    
    % Initialize tree structure (as a containers.Map) and markovOut output
    tree = containers.Map(); % Each node points to a map of next characters and counts
    markovOut = ""; % Use a string array for safe concatenation
    correct_predictions = 0;
    
    % Process each character in the source text
    for i = 1:length(source_text)
        current_char = source_text(i);
        
        if i == 1
            % First character, no prediction, just add it
            add_to_tree(tree, '', current_char); % Root to current_char
            markovOut = markovOut + current_char;
        else
            % Previous character and current character
            prev_char = source_text(i-1);
            
            % Predict the next character
            prediction = predict_next(tree, prev_char);
            
            if prediction == current_char
                % Correct prediction
                correct_predictions = correct_predictions + 1;
            else
                % Add the count of correct predictions to markovOut.txt
                if correct_predictions > 0
                    % markovOut = markovOut + "`" + num2str(correct_predictions) + "`";
                    markovOut = markovOut + num2str(correct_predictions);
                    correct_predictions = 0;
                end
                % Add the actual character
                markovOut = markovOut + current_char;
            end
            
            % Update the tree with the transition
            add_to_tree(tree, prev_char, current_char);
        end
    end
    
    % Add any remaining correct predictions to markovOut.txt
    if correct_predictions > 0
        % markovOut = markovOut + "`" + num2str(correct_predictions) + "`";
        markovOut = markovOut + num2str(correct_predictions);
    end
    
    % Write markovOut.txt preserving spaces and newlines
    fid = fopen(output_file, 'wb'); % Open in binary mode
    fwrite(fid, markovOut, 'char'); % Write preserving all characters
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
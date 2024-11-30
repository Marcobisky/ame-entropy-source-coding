function encoded_output = ame_encode(source_text)
    % Initialize tree structure (as a containers.Map) and encoded_output
    tree = containers.Map(); % Each node points to a map of next characters and counts
    encoded_output = ""; % Use a string array for safe concatenation
    correct_predictions = 0;

    % Process each character in the source text
    for i = 1:length(source_text)
        current_char = source_text(i);
        
        if i == 1
            % First character, no prediction, just add it
            add_to_tree(tree, '', current_char); % Root to current_char
            encoded_output = encoded_output + current_char;
        else
            % Previous character and current character
            prev_char = source_text(i-1);
            
            % Predict the next character
            prediction = predict_next(tree, prev_char);
            
            if prediction == current_char
                % Correct prediction
                correct_predictions = correct_predictions + 1;
            else
                % Add the count of correct predictions to encoded_output.txt
                if correct_predictions > 0
                    % encoded_output = encoded_output + "`" + num2str(correct_predictions) + "`";
                    encoded_output = encoded_output + num2str(correct_predictions);
                    correct_predictions = 0;
                end
                % Add the actual character
                encoded_output = encoded_output + current_char;
            end
            
            % Update the tree with the transition
            add_to_tree(tree, prev_char, current_char);
        end
    end

    % Add any remaining correct predictions to encoded_output.txt
    if correct_predictions > 0
        % encoded_output = encoded_output + "`" + num2str(correct_predictions) + "`";
        encoded_output = encoded_output + num2str(correct_predictions);
    end

    % Convert encoded_output to char array
    encoded_output = char(encoded_output);
end


function add_to_tree(tree, from_char, to_char)
    % Add a transition to the tree
    if ~isKey(tree, from_char)
        tree(from_char) = containers.Map(); % Create new node if not exists
        transitions = tree(from_char);
        transitions('highestFrequency') = 0;
    end

    % Get the transition map for the current node
    transitions = tree(from_char);
    
    if isKey(transitions, to_char)
        transitions(to_char) = transitions(to_char) + 1; % Increment count
    else
        transitions(to_char) = 1; % Initialize with count of 1
    end
    
    % Record the highest count to now
    if transitions(to_char) >= transitions('highestFrequency')
        transitions('highestFrequency') = transitions(to_char);
        transitions('probableNextChar') = to_char;
    end
end

function prediction = predict_next(tree, current_char)
    % Predict the next character based on tree
    if ~isKey(tree, current_char)
        prediction = ''; % No prediction possible
        return;
    end
    
    % Get prediction for the next character
    transitions = tree(current_char);
    prediction = transitions('probableNextChar');
end
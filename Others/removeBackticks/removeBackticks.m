function removeBackticks(inputFilePath, outputFilePath)
    % Read the input file
    fileContent = fileread(inputFilePath);
    
    % Initialize processed content
    processedContent = '';
    
    % Loop through each character in the file content
    for i = 1:length(fileContent)
        if fileContent(i) == '`'
            % Check the characters before and after the backtick
            beforeChar = '';
            afterChar = '';
            if i > 1
                beforeChar = fileContent(i - 1);
            end
            if i < length(fileContent)
                afterChar = fileContent(i + 1);
            end
            
            % Determine if the backtick should be kept
            if ~isempty(beforeChar) && ~isempty(afterChar)
                if isdigit(beforeChar) || isdigit(afterChar)
                    % Keep the backtick if adjacent to a number
                    processedContent = [processedContent, '`'];
                else
                    % Otherwise, remove the backtick
                    continue;
                end
            else
                % Edge cases: keep standalone backticks
                processedContent = [processedContent, '`'];
            end
        else
            % Append all non-backtick characters
            processedContent = [processedContent, fileContent(i)];
        end
    end
    
    % Save the processed content to the output file with CRLF format
    processedContent = strrep(processedContent, sprintf('\n'), sprintf('\r\n'));
    fileID = fopen(outputFilePath, 'w');
    fwrite(fileID, processedContent);
    fclose(fileID);
end

% Helper function to check if a character is a digit
function result = isdigit(char)
    result = ~isempty(regexp(char, '\d', 'once'));
end
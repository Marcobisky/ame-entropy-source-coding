function decodedMessage = fano_decode(encodedMessage, dict)
    % Decode the encoded binary string using the Fano dictionary

    % Convert the dictionary into a map for fast lookup
    codeMap = containers.Map(dict(:,2), dict(:,1));

    % Initialize decoding variables
    decodedMessage = '';
    buffer = '';

    % Iterate through the encoded message to decode
    for i = 1:length(encodedMessage)
        buffer = [buffer, encodedMessage(i)]; % Append bit to buffer

        if isKey(codeMap, buffer)
            % If the buffer matches a code in the dictionary
            decodedChar = codeMap(buffer);
            decodedMessage = [decodedMessage, decodedChar];
            buffer = ''; % Reset the buffer
        end
    end

    % Ensure the decoded message matches the original text
    if ~isempty(buffer)
        error('Decoding error: incomplete or invalid encoding.');
    end
end
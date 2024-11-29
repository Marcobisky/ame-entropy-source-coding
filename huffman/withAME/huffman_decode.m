function decodedMessage = huffman_decode(encodedMessage, dict)
    % Decode encoded information using Huffman dictionary
    decodedMessage = huffmandeco(encodedMessage, dict);
    
    % Converts the decoded cell array back to a character array
    decodedMessage = cell2mat(decodedMessage);
end

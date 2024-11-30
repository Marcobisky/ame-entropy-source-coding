function [encodedMessage, dict] = huffman_encode(text)
    % compute frequency
    symbols = unique(text);
    counts = histc(text, symbols);
    
    %change symbols into cell 
    symbols = num2cell(symbols);
    
    % calculate probabiliyies
    probabilities = counts / sum(counts);
    
    dict = huffmandict(symbols, probabilities);
    
    % encode
    encodedMessage = huffmanenco(num2cell(text), dict);
end

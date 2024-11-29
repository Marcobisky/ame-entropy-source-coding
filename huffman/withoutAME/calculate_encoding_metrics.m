function [avgCodeLength, rate, efficiency, zip_rate] = calculate_encoding_metrics(text,dict)
    %calculates the character occurrence probability
    symbols = unique(text);
    counts = histc(text, symbols);
    probabilities = counts / sum(counts);
    
    %calculates the information source entropy
    entropy = -sum(probabilities .* log2(probabilities));
    
    %calculated the encoded average code length
    avgCodeLength = sum(cellfun(@length, dict(:,2)) .* probabilities');

    %calculated the code rate
    rate = entropy / avgCodeLength;

    %calculated the efficiency
    efficiency = rate / log2(2);

    %calculated the compressibility
    zip_rate=avgCodeLength/8;
   
end

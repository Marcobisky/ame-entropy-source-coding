% MATLAB Code to compute frequency and plot histogram of characters with labels
clear;
clc;

% File to analyze
% file_name = 'original.txt';
% output_file = 'originalStat.txt';

% file_name = 'processed.txt';
% output_file = 'processedStat.txt';

% Read file contents as characters
fid = fopen(file_name, 'r');
if fid == -1
    error('Could not open the file: %s', file_name);
end
text_data = fread(fid, '*char')';
fclose(fid);

% Total number of characters
total_chars = length(text_data);

% ASCII range (0 to 127)
ascii_range = 0:127;

% Initialize frequency array for each ASCII character
frequency = zeros(1, 128);

% Count occurrences of each ASCII character
for i = 1:total_chars
    char_code = double(text_data(i));
    if char_code >= 0 && char_code <= 127
        frequency(char_code + 1) = frequency(char_code + 1) + 1;
    end
end

% Convert counts to probabilities
probability = frequency / total_chars;

% Map ASCII values to readable labels
ascii_labels = cell(1, 128);
for i = ascii_range
    if i == 10
        ascii_labels{i + 1} = '\n'; % Label for newline
    elseif i == 13
        ascii_labels{i + 1} = '\r'; % Label for carriage return
    elseif i == 32
        ascii_labels{i + 1} = 'sp'; % Label for space
    else
        ascii_labels{i + 1} = char(i); % Regular character
    end
end

% Plot histogram
figure;
bar(ascii_range, probability, 'FaceColor', 'b', 'EdgeColor', 'k');
xlim([0, 127]);
xlabel('Character (in ASCII order)');
ylabel('Probability');
title('Character Statistic in original.txt');
grid on;

% Customize x-axis labels
set(gca, 'XTick', ascii_range, 'XTickLabel', ascii_labels, 'XTickLabelRotation', 0);

% Save the probability data for further analysis

fid = fopen(output_file, 'w');
fprintf(fid, 'ASCII Value\tCharacter\tProbability\n');
for i = ascii_range
    if probability(i + 1) > 0
        label = ascii_labels{i + 1};
        fprintf(fid, '%d\t\t%s\t\t%.6f\n', i, label, probability(i + 1));
    end
end
fclose(fid);
disp(['Character probabilities saved to ', output_file]);
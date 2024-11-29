% File: main.m
% This script acts as the entry point to compress a file using LZSS.

% Specify the input and output file names
input_file = 'testfile.txt'; % Input .txt file to compress
output_readable = 'testfile_readable.txt'; % Output human-readable file
output_file = 'testfile.bin'; % Output compressed file

% Check if the input file exists
if ~isfile(input_file)
    error('The input file %s does not exist.', input_file);
end

% Call the LZSS compression function
fprintf('Starting compression for %s...\n', input_file);
lzss_compression(input_file, output_file, output_readable);
fprintf('Compression finished. Compressed file saved as %s\n', output_file);

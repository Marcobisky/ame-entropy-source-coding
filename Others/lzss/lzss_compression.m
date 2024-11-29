function lzss_compression(input_file, binary_output_file, readable_output_file)
    % Read the input file
    fid = fopen(input_file, 'r');
    if fid == -1
        error('Error opening the input file.');
    end
    input_data = fread(fid, '*char')';
    fclose(fid);
    
    % Parameters for LZSS
    WINDOW_SIZE = 4096; % Sliding window size
    LOOKAHEAD_BUFFER_SIZE = 18; % Lookahead buffer size
    
    % Initialize variables
    input_length = length(input_data);
    compressed_data = []; % Array to store binary output
    readable_data = ""; % String to store human-readable output
    pos = 1; % Current position in the input data
    
    % Compression loop
    while pos <= input_length
        match_length = 0;
        match_distance = 0;
        
        % Define the sliding window and lookahead buffer
        window_start = max(1, pos - WINDOW_SIZE);
        window = input_data(window_start:pos - 1);
        lookahead_buffer = input_data(pos:min(pos + LOOKAHEAD_BUFFER_SIZE - 1, input_length));
        
        % Search for the longest match in the sliding window
        for dist = 1:length(window)
            match_candidate_start = max(1, length(window) - dist + 1);
            match_candidate = window(match_candidate_start:end);
            match_length_candidate = 0;
            
            while match_length_candidate < length(lookahead_buffer) && ...
                  match_length_candidate < length(match_candidate) && ...
                  match_candidate(match_length_candidate + 1) == lookahead_buffer(match_length_candidate + 1)
                match_length_candidate = match_length_candidate + 1;
            end
            
            if match_length_candidate > match_length
                match_length = match_length_candidate;
                match_distance = dist;
            end
        end
        
        % Encode the match or literal
        if match_length >= 3
            % Match found: encode as (1, distance, length)
            compressed_data = [compressed_data, 1, match_distance, match_length]; %#ok<AGROW>
            readable_data = readable_data + sprintf("(1, %d, %d)\n", match_distance, match_length);
            pos = pos + match_length;
        else
            % No match: encode as (0, literal character ASCII)
            compressed_data = [compressed_data, 0, uint8(input_data(pos))]; %#ok<AGROW>
            readable_data = readable_data + sprintf("(0, '%s')\n", input_data(pos));
            pos = pos + 1;
        end
    end
    
    % Write the compressed data to a binary file
    fid = fopen(binary_output_file, 'wb');
    if fid == -1
        error('Error opening the binary output file.');
    end
    fwrite(fid, compressed_data, 'uint8');
    fclose(fid);
    
    % Write the human-readable compressed format to a text file
    fid = fopen(readable_output_file, 'w');
    if fid == -1
        error('Error opening the readable output file.');
    end
    fprintf(fid, '%s', readable_data);
    fclose(fid);
    
    fprintf('Compression completed.\nCompressed binary file: %s\nReadable file: %s\n', binary_output_file, readable_output_file);
end
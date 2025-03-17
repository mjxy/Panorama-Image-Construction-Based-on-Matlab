function [num0, num1] = getTargetInit(imgs)
    % getOrderInit - Finds the initial pair of images with the highest matching score for stitching.
    %
    % Syntax: [num0, num1] = getOrderInit(imgs)
    %
    % Inputs:
    %    imgs - Cell array of images to be processed for feature extraction
    %
    % Outputs:
    %    num0 - Index of the first image in the best-matching pair
    %    num1 - Index of the second image in the best-matching pair
    %
    % Description:
    %    This function finds the initial pair of images with the highest feature match score,
    %    based on SIFT features. It uses bidirectional matching to determine the highest match
    %    to ensure robustness in avoiding mismatches.

    % Set SIFT threshold for feature detection
    siftThreshold = 5;
    
    % Number of images
    nImgs = numel(imgs); % Use numel to get the cell array size
    
    % Initialize cell arrays to store SIFT features and descriptors
    features  = cell(1, nImgs);
    descriptors = cell(1, nImgs);
    
    % Initialize match score matrix
    match_scores = zeros(nImgs);
    
    % Variables to store the indices of the images with the highest match score
    num0 = 0;
    num1 = 0;
    
    % Variable to store the highest match score
    highestScore= 0;
    
    % Extract SIFT features and descriptors for each image
    for i = 1:nImgs
        [f, d] = getSIFTFeatures(imgs{i}, siftThreshold); % Access each image with imgs{i}
        features {i} = f;
        descriptors{i} = d;
    end
    
    % Calculate match scores and store them
    for i = 1:nImgs-1
        for j = i+1:nImgs
            % Calculate the match score from image i to image j
            [matches, ~] = getMatches(features {i}, descriptors{i}, features {j}, descriptors{j});
            match_size1 = size(matches);
            match_scores(i, j) = match_size1(1);
            match0 = match_size1(1);
            
            % Calculate the match score from image j to image i
            [matches, ~] = getMatches(features {j}, descriptors{j}, features {i}, descriptors{i});
            match_size1 = size(matches);
            match_scores(j, i) = match_size1(1);
            match1 = match_size1(1);
            
            % Sum of bidirectional matches to avoid mismatches
            match = match0 + match1;
            
            % Update the best matching pair if a higher match score is found
            if match > highestScore
                highestScore= match;
                num0 = i;
                num1 = j;
            end
        end
    end
end

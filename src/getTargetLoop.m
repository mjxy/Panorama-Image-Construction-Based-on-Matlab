function num = getTargetLoop(img, imgs, sequence)
    % getOrderLoop - Finds the next image in sequence with the highest match score for stitching.
    %
    % Syntax: num = getOrderLoop(img, imgs, sequence)
    %
    % Inputs:
    %    img - Current main image to match against
    %    imgs - Cell array of target images
    %    sequence - Array of indices representing the remaining images to be matched
    %
    % Output:
    %    num - Index of the image in the sequence that has the highest match score with the main image
    %
    % Description:
    %    This function iterates through a sequence of images to find the one that has the highest
    %    matching score with the main image. SIFT features are used to calculate the match scores
    %    bidirectionally to ensure reliable matching.

    % Set SIFT threshold for feature detection
    Thresh = 5;
    
    % Get the number of unmatched images in the sequence
    nImgs = numel(sequence);
    
    % Initialize cell arrays for storing SIFT features and descriptors
    imgs_feat = cell(1, nImgs);
    imgs_dist = cell(1, nImgs);
    
    % Initialize match score matrix
    match_scores = zeros(2, nImgs);
    
    % Variables to store the best matching image index and maximum match score
    num = 0;
    match_max = 0;
    
    % Extract SIFT features and descriptors for the main image
    [f0, d0] = getSIFTFeatures(img, Thresh);
    
    % Extract SIFT features and descriptors for each target image in the sequence
    for i = 1:nImgs
        [f, d] = getSIFTFeatures(imgs{sequence(i)}, Thresh);
        imgs_feat{i} = f;
        imgs_dist{i} = d;
    end
    
    % Calculate bidirectional match scores between the main image and each target image
    for i = 1:nImgs
        % Match score from the main image to the target image
        [matches, ~] = getMatches(f0, d0, imgs_feat{i}, imgs_dist{i});
        match_size1 = size(matches);
        match_scores(1, i) = match_size1(1);
        
        % Match score from the target image to the main image
        [matches, ~] = getMatches(imgs_feat{i}, imgs_dist{i}, f0, d0);
        match_size1 = size(matches);
        match_scores(2, i) = match_size1(1);
        
        % Calculate the total bidirectional match score to avoid false matches
        match = match_scores(1, i) + match_scores(2, i);
    
        % Update the best matching image index if a higher match score is found
        if match > match_max
            match_max = match;
            num = sequence(i);
        end
    end
end

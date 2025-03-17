function [potential_matches, scores] = getMatches(f1, d1, f2, d2)
    % getMatches - Finds the matching feature points between two sets of descriptors using UBCMatch.
    %
    % Syntax: [potential_matches, scores] = getMatches(f1, d1, f2, d2)
    %
    % Inputs:
    %    f1 - Matrix of feature locations for the first image (3xN matrix: [x; y; scale])
    %    d1 - Matrix of descriptors for the first image (D x N matrix)
    %    f2 - Matrix of feature locations for the second image (3xM matrix: [x; y; scale])
    %    d2 - Matrix of descriptors for the second image (D x M matrix)
    %
    % Outputs:
    %    potential_matches - 3D matrix of matching points' locations for both images.
    %                         The size is [numMatches x 3 x 2] where each match contains the
    %                         coordinates (x, y) in both images along with an extra row for scaling.
    %    scores - A vector of matching scores for each pair of matching descriptors.
    %
    % Description:
    %    This function uses the VLFeat toolbox's `vl_ubcmatch` to find the matching descriptors 
    %    between two sets of descriptors (d1 and d2). It returns the coordinates of the matching 
    %    feature points and their matching scores.

    % Find matching descriptors between the two sets
    [matches, scores] = vl_ubcmatch(d1, d2);
    
    % Create an array to store matching points' locations with size [numMatches x 3 x 2]
    numMatches = size(matches, 2);
    pairs = nan(numMatches, 3, 2);
    
    % Store the matching points' coordinates and scale for both images
    pairs(:,:,1) = [f1(2, matches(1,:)); f1(1, matches(1,:)); ones(1, numMatches)]';
    pairs(:,:,2) = [f2(2, matches(2,:)); f2(1, matches(2,:)); ones(1, numMatches)]';
    
    % Return the matching points and their scores
    potential_matches = pairs;

end

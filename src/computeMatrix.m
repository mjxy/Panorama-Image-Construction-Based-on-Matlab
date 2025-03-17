function [ T ] = computeMatrix( img1, img2 )
    % computeMatrix - Computes the transformation matrix between two images using feature matching and RANSAC.
    %
    % Syntax: [T] = computeMatrix(img1, img2)
    %
    % Inputs:
    %    img1 - The first input image.
    %    img2 - The second input image.
    %
    % Outputs:
    %    T - A 3x3x2 matrix where T(:,:,1) is the identity matrix and T(:,:,2) 
    %        is the transformation matrix computed using RANSAC.
    %
    % Description:
    %    This function calculates a transformation matrix between two images by first extracting 
    %    SIFT features and descriptors using `getSIFTFeatures`. Then, it uses `getMatches` to find 
    %    the matching feature points between the images. Finally, it estimates the transformation matrix 
    %    using the RANSAC algorithm, considering inlier ratios and thresholds for accuracy.

    % Initialize parameters for RANSAC and transformation matrix
    Thresh = 5;                % Threshold for feature detection
    confidence = 0.999;        % Confidence level for RANSAC
    inlierRatio = 0.1;         % Minimum inlier ratio for RANSAC
    epsilon = 1.5;             % Tolerance for RANSAC

    % Initialize the transformation matrix T (3x3x2 matrix)
    T = zeros(3, 3, 2);
    T(:, :, 1) = eye(3);       % Set the first transformation matrix as the identity matrix

    % Extract SIFT features and descriptors for both images
    [f1, d1] = getSIFTFeatures(img1, Thresh);
    [f2, d2] = getSIFTFeatures(img2, Thresh);

    % Get the matching feature points between the two sets of features
    [matches, ~] = getMatches(f1, d1, f2, d2);

    % Compute the transformation matrix using RANSAC
    [T(:, :, 2), ~] = RANSAC(confidence, inlierRatio, 1, matches, epsilon);
end

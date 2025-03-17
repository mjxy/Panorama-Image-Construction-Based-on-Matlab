function [T, MaxInliers] = RANSAC(confidence, inliner_Ratio, Npairs, data, epsilon)
    % RANSAC - Implements the RANSAC algorithm to compute the best transformation matrix
    %         by finding inliers that fit a given transformation model.
    %
    % Syntax: [T, MaxInliers] = RANSAC(confidence, inliner_Ratio, Npairs, data, epsilon)
    %
    % Inputs:
    %    confidence    - The desired confidence level for the result.
    %    inliner_Ratio - The ratio of inliers in the dataset (probability of point being an inlier).
    %    Npairs        - The number of point pairs used to compute the transformation.
    %    data          - The data points to fit the model, where data(:,:,1) are source points 
    %                    and data(:,:,2) are destination points.
    %    epsilon       - The threshold for considering a point as an inlier based on the error.
    %
    % Outputs:
    %    T             - The best transformation matrix computed by RANSAC.
    %    MaxInliers    - The maximum number of inliers found during the iterations.
    %
    % Description:
    %    This function performs the RANSAC algorithm to compute the transformation matrix
    %    between two sets of points. The algorithm iteratively selects random subsets of point 
    %    pairs, computes the transformation, and evaluates the number of inliers that match the model.
    
    % Calculate the number of iterations required based on the confidence and inlier ratio
    m = ceil(log(1 - confidence) / log(1 - inliner_Ratio^Npairs)); % number of iterations
    
    NPoints = size(data, 1);  % number of data points
    MaxInliers = 0;           % variable to store maximum inliers count

    % Pre-allocate matrices for least squares computation
    A = zeros(2 * Npairs, 2); 
    b = zeros(2 * Npairs, 1);
    
    % Set up the A matrix (transformation model)
    for i = 1:Npairs
        A(2 * i - 1, 1) = 1;   % x coefficient
        A(2 * i, 2) = 1;       % y coefficient
    end

    % Iterate m times to compute the best transformation
    for i = 1:m
        % Randomly sample Npairs points from the dataset
        sampleIndicies = randperm(NPoints, Npairs);
        samples = data(sampleIndicies, :, :);
        
        % Extract corresponding point pairs
        pair0 = samples(:, :, 1);  % source points
        pair1 = samples(:, :, 2);  % destination points

        % Set up b matrix (point differences)
        for j = 1:Npairs
            b(2 * j - 1) = pair0(j, 1) - pair1(j, 1);
            b(2 * j) = pair0(j, 2) - pair1(j, 2);
        end
        
        % Solve for transformation using least squares
        t = A \ b;
        T = [1 0 t(1); 0 1 t(2); 0 0 1];  % transformation matrix
        
        % Apply the transformation to the destination points
        p_prime = T * data(:, :, 2)';  % transformed destination points
        error = data(:, :, 1)' - p_prime;  % compute error between source and transformed destination
        SE = error .^ 2;  % square the error
        SSE = sum(SE);  % sum of squared errors
        
        % Count the number of inliers (points with error less than epsilon)
        numInliers = sum(SSE < epsilon);
        
        % Update MaxInliers if the current set has more inliers
        if numInliers > MaxInliers
            bestSet = find(SSE < epsilon);  % set of inliers
            MaxInliers =    numInliers;        % update maximum inliers count
        end
    end
    
    % Recompute the transformation using inliers
    pair0 = data(bestSet, :, 1);  % source points of inliers
    pair1 = data(bestSet, :, 2);  % destination points of inliers

    % Set up b matrix again for inliers
    for j = 1:Npairs
        b(2 * j - 1) = pair0(j, 1) - pair1(j, 1);
        b(2 * j) = pair0(j, 2) - pair1(j, 2);
    end
    
    % Recompute the transformation matrix with inliers
    t = A \ b;
    T = [1 0 t(1); 0 1 t(2); 0 0 1];  % final transformation matrix
end

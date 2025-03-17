function [f, d] = getSIFTFeatures(image, edgeThresh)
    % getSIFTFeatures - Extracts SIFT features and descriptors from an image.
    %
    % Syntax: [f, d] = getSIFTFeatures(image, edgeThresh)
    %
    % Inputs:
    %    image - Input image, which can be a grayscale or RGB image
    %    edgeThresh - Threshold value for SIFT edge detection; helps control sensitivity
    %
    % Outputs:
    %    f - Matrix of SIFT feature frames; each column represents a feature with its location and scale
    %    d - Matrix of SIFT descriptors; each column represents a descriptor vector for a corresponding feature
    %
    % Description:
    %    This function converts an input image to grayscale if it is in RGB format, then extracts
    %    SIFT (Scale-Invariant Feature Transform) features and descriptors using the VLFeat library's
    %    vl_sift function, with an adjustable edge threshold for tuning feature sensitivity.

    % Convert image to grayscale if it is RGB
    if (size(image, 3) == 3)
        Im = single(rgb2gray(image)); % Convert RGB to grayscale and cast to single precision
    else
        Im = single(image); % Use grayscale image directly
    end

    % Extract SIFT features and descriptors with specified edge threshold
    [f, d] = vl_sift(Im, 'EdgeThresh', edgeThresh);
end

function outputImage = removeBlackBorder(inputImage, threshold)
    % removeBlackBorder - Removes black borders from an image based on a specified threshold.
    %
    % Syntax: outputImage = removeBlackBorder(inputImage, threshold)
    %
    % Inputs:
    %    inputImage - The input image, which can be a grayscale, RGB, uint8, or double image.
    %    threshold - A value that defines the black color threshold, typically between 0 and 255.
    %                A smaller value will consider more of the image as black.
    %
    % Outputs:
    %    outputImage - The cropped image with black borders removed.
    %
    % Description:
    %    This function processes the input image to remove black borders. It first converts the
    %    image to grayscale, then creates a binary image where the black regions (below the threshold)
    %    are marked as 1, and non-black regions are marked as 0. It identifies the boundary of the non-black
    %    regions and crops the image to exclude the black areas. If no non-black areas are found, the original
    %    image is returned.

    % Ensure the image is of type uint8 or double with appropriate value range
    if isfloat(inputImage)
        % If the image is of type double, scale it to uint8 range [0, 255]
        inputImage = im2uint8(inputImage);
    end

    % Convert the image to grayscale
    grayImage = rgb2gray(inputImage);
    
    % Create a binary image where black regions are 1 and others are 0
    binaryImage = grayImage < threshold;
    
    % Find the boundary of non-black regions
    [rows, cols] = find(binaryImage == 0);
    
    % If no non-black region is found, return the original image
    if isempty(rows) || isempty(cols)
        outputImage = inputImage;
        return;
    end
    
    % Determine the minimum and maximum row and column values for the non-black region
    minRow = min(rows);
    maxRow = max(rows);
    minCol = min(cols);
    maxCol = max(cols);
    
    % Crop the image based on the identified boundary
    outputImage = inputImage(minRow:maxRow, minCol:maxCol, :);
end

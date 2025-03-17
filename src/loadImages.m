function [imgSet, numImages] = loadImages(imageFiles)
    % loadImages - Loads image files specified in `imageFiles` and stores them in a cell array.
    %
    % Syntax:  [imgSet, numImages] = loadImages(imageFiles)
    %
    % Inputs:
    %    imageFiles - Array of structs containing information about the image files (e.g., file name and path).
    %
    % Outputs:
    %    imgSet      - Cell array containing the loaded images.
    %    numImages  - Integer count of total images processed.
    %
    % Description:
    %    This function reads image files from the specified `imageFiles` array. If the images are in PNG format,
    %    they are converted to JPG format before being loaded. The images are stored in the cell array `imgSet`.
    %    The function also returns the number of images loaded (`numImages`).
    
    % Get the number of image files
    numImages = length(imageFiles); 
    
    % Check if there are any images to load
    if numImages == 0
        error('No images selected.');
    end

    % Initialize cell array to hold the images
    imgSet = cell(1, numImages);
    
    % Load each image file
    for i = 1:numImages
        % Extract file extension
        [~, ~, ext] = fileparts(imageFiles(i).name);
        fullFilePath = fullfile(imageFiles(i).folder, imageFiles(i).name); % Full file path
        
        % Handle PNG files: convert to JPG format
        if strcmpi(ext, '.png')
            img = imread(fullFilePath);
            % Convert PNG to temporary JPG and load it
            tempFileName = [tempname, '.jpg']; % Temporary file path
            imwrite(img, tempFileName, 'jpg');
            imgSet{i} = imread(tempFileName);
            % Delete temporary JPG file
            delete(tempFileName);  
        elseif strcmpi(ext, '.jpg') || strcmpi(ext, '.jpeg')
            % Directly load JPG files
            imgSet{i} = imread(fullFilePath);
        end
    end

end

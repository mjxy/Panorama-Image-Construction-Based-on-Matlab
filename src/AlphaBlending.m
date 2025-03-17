function [newImg] = AlphaBlending(img1, img2, transforms, newHeight, newWidth) 
% Merge two images using alpha blending to create a panoramic image.
% The function computes the appropriate transformation for each image based on 
% the given transformation matrix, and blends them together using alpha blending.
%
% Inputs:
%   - img1: The first input image (can be RGB or grayscale).
%   - img2: The second input image (can be RGB or grayscale).
%   - transforms: A 3x3xN matrix where each 3x3 matrix represents the transformation
%     for the corresponding image.
%   - newHeight: The height of the new panorama image.
%   - newWidth: The width of the new panorama image.

% Outputs:
%   - newImg: The resulting panoramic image after merging the input images.

% Convert images to double precision for accurate calculations
img1 = im2double(img1);
img2 = im2double(img2);

% Get the dimensions of the first image
height1 = size(img1, 1);
width1 = size(img1, 2);
nChannels1 = size(img1, 3);
nImgs = 2;  % Number of images being merged (2 in this case)

% Create a mask for the first image (used for alpha blending)
mask1 = ones(height1, width1);

% Create a 3D mask for each color channel in the first image
m1 = ones([height1, width1, nChannels1], 'like', img1);
for i = 1:nChannels1
    m1(:,:,i) = mask1;
end
mask1 = m1;

% Get the dimensions of the second image
height2 = size(img2, 1);
width2 = size(img2, 2);
nChannels2 = size(img2, 3);

% Create a mask for the second image
mask2 = ones(height2, width2);

% Create a 3D mask for each color channel in the second image
m2 = ones([height2, width2, nChannels2], 'like', img2);
for i = 1:nChannels2
    m2(:,:,i) = mask2;
end
mask2 = m2;

% Initialize the boundaries for the panorama image
max_h = 0;
min_h = 0;
max_w = 0;
min_w = 0;

% Loop through the images and calculate the positions based on the transformations
for i = 1:nImgs
    p_prime = transforms(:,:,i) * [1; 1; 1];
    p_prime = p_prime / p_prime(3);  % Normalize the coordinates
    base_h = floor(p_prime(1));
    base_w = floor(p_prime(2));
    
    % Update the boundaries of the panorama image
    if base_h > max_h
        max_h = base_h;
    end
    if base_h < min_h
        min_h = base_h;
    end
    if base_w > max_w
        max_w = base_w;
    end
    if base_w < min_w
        min_w = base_w;
    end
end

% Initialize the panorama image and the denominator for blending
newImg = zeros([newHeight+10, newWidth+10, nChannels1], 'like', img1);
denominator = zeros([newHeight+10, newWidth+10, nChannels1], 'like', img1);

% Loop through the images and place them into the panorama image
for i = 1:nImgs
    min_w = 0;
    min_h = 0;
    
    % Apply the transformation for the current image
    p_prime = transforms(:,:,i) * [min_h + 10; min_w + 10; 1];
    p_prime = p_prime / p_prime(3);  % Normalize the coordinates
    base_h = floor(p_prime(1));
    base_w = floor(p_prime(2));
    
    % Ensure that the base coordinates are not zero
    if base_h == 0
        base_h = 1;
    end
    if base_w == 0
        base_w = 1;
    end
    
    % If it's the first image, add it to the panorama with its mask
    if i == 1
        newImg(base_h:base_h+height1-1, base_w:base_w+width1-1, :) = ...
            newImg(base_h:base_h+height1-1, base_w:base_w+width1-1, :) + ...
            img1 .* mask1;
        
        denominator(base_h:base_h+height1-1, base_w:base_w+width1-1, :) = ...
            denominator(base_h:base_h+height1-1, base_w:base_w+width1-1, :) + ...
            mask1;
        
        denominator(newImg == 0) = 0;  % Avoid division by zero
        
        imshow(newImg ./ denominator);  % Show intermediate result
        
    else
        % If it's the second image, add it to the panorama with its mask
        newImg(base_h:base_h+height2-1, base_w:base_w+width2-1, :) = ...
            newImg(base_h:base_h+height2-1, base_w:base_w+width2-1, :) + ...
            img2 .* mask2;
        
        denominator(base_h:base_h+height2-1, base_w:base_w+width2-1, :) = ...
            denominator(base_h:base_h+height2-1, base_w:base_w+width2-1, :) + ...
            mask2;
    end
end

% Normalize the result to avoid excessive pixel intensity
newImg = newImg ./ denominator;

end

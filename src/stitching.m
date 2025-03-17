function [newImage] = stitching(img1, img2)
    % stitching - Combines two images into one stitched panorama using cylindrical projection.

    % Calculate the transformation matrix for aligning the two images
    translations = computeMatrix(img1, img2);

    % Multiply the transformation matrices to obtain the cumulative transformation
    absoluteTrans = zeros(size(translations));
    absoluteTrans(:, :, 1) = translations(:, :, 1);
    absoluteTrans(:, :, 2) = absoluteTrans(:, :, 1) * translations(:, :, 2);

    % Compute bounding box for the stitched image
    [minX, minY, maxX, maxY] = computeBoundingBox(absoluteTrans, img1, img2);
    panorama_h = ceil(maxY) - floor(minY) + 1;
    panorama_w = ceil(maxX) - floor(minX) + 1;

    % Adjust translation matrices for alignment
    absoluteTrans = adjustTranslation(absoluteTrans, minX, minY);

    % Merge the images using the calculated transformations
    newImage = AlphaBlending(img1, img2, absoluteTrans, panorama_h, panorama_w);
end

function [minX, minY, maxX, maxY] = computeBoundingBox(absoluteTrans, img1, img2)
    width1 = size(img1, 2);
    height1 = size(img1, 1);
    width2 = size(img2, 2);
    height2 = size(img2, 1);
    
    maxX = max(width1, absoluteTrans(2, 3, 2) + width2);
    maxY = max(height1, absoluteTrans(1, 3, 2) + height2);
    minX = min(1, absoluteTrans(2, 3, 2));
    minY = min(1, absoluteTrans(1, 3, 2));
end

function adjustedTrans = adjustTranslation(trans, minX, minY)
    adjustedTrans = trans;
    adjustedTrans(2, 3, :) = trans(2, 3, :) - floor(minX);
    adjustedTrans(1, 3, :) = trans(1, 3, :) - floor(minY);
end

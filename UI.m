% Panorama Image Construction
% Author: Junyou Chen
% ID: 202200171208
% Date: November 10 2024
% Class：Robot Class 22.1
% Version: 7.0

% Project Defect
% 1. Suboptimal Stitching Order: The greedy strategy does not account for global relationships, leading to cumulative errors as the number of images increases, resulting in unnatural stitching.
% 2. Poor Handling of Rotation and Translation: Ineffective handling of rotational and translational transformations can lead to stitching errors or gaps.
% 3. Insufficient Image Blending: Simple alpha blending can cause visible seams in areas with differences in brightness or color.
% 4. Low Computational Efficiency: Selecting the image with the highest match score at each step leads to redundant calculations, making the method inefficient for large-scale stitching.
function UI()
    % Add code path
    addpath("src");
    % Create UI interface
    fig = figure('Name', 'Panoramic Image Building System', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600],'Resize','off');
    uicontrol('Style', 'text', 'String', 'Panorama Mosaic system', 'Position', [225, 550, 400, 30], 'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

    % create button and progress bar
    buttonWidth = 150;
    buttonHeight = 40;
    selectFilesButton = uicontrol('Style', 'pushbutton', 'String', 'Select Images', 'Position', [40, 480, buttonWidth, buttonHeight], 'FontSize', 14, 'Callback', @selectFiles); 
    startButton = uicontrol('Style', 'pushbutton', 'String', 'Start', 'Position', [190, 480, buttonWidth, buttonHeight], 'FontSize', 14, 'Callback', @main);
    saveButton = uicontrol('Style', 'pushbutton', 'String', 'Save', 'Position', [340, 480, buttonWidth, buttonHeight], 'FontSize', 14, 'Callback', @saveImage, 'Enable', 'off');
    resetButton = uicontrol('Style', 'pushbutton', 'String', 'Reset', 'Position', [490, 480, buttonWidth, buttonHeight], 'FontSize', 14, 'Callback', @resetSystem);  
    exitButton = uicontrol('Style', 'pushbutton', 'String', 'Exit', 'Position', [640, 480, buttonWidth, buttonHeight], 'FontSize', 14, 'Callback', @exitSystem);
    progressBar = uicontrol('Style', 'text', 'String', '---To be started---', 'Position', [100, 430, 600, 40], 'FontSize', 14, 'BackgroundColor', 'white', 'HorizontalAlignment', 'center');

    % Create display area
    imgAxes = axes('Parent', fig, 'Position', [0.1, 0.1, 0.8, 0.6]);
    axis(imgAxes, 'off');
    set(imgAxes, 'XTick', [], 'YTick', [], 'XLim', [0 800], 'YLim', [0 600]);

    % UI interface related variables
    isStitching = false;
    finalImage = [];
    imageFiles = []; 
    
    % Main function - concatenation function
    function main(~, ~)
        if isStitching
            return;
        end
        if isempty(imageFiles)
            msgbox('Please select a image file!');
            return;
        end
        
        isStitching = true;
        
        % Enable button
        set(selectFilesButton, 'Enable', 'off');
        set(startButton, 'Enable', 'off');
        set(progressBar, 'String', 'progress：0%');
        set(saveButton, 'Enable', 'off');
        set(resetButton, 'Enable', 'off');
        
        % Run splicing procedure
        % Startup toolbox
        run('vlfeat-0.9.21/toolbox/vl_setup');
        % % Load the image set with theimgs0 cell array
        [imgSet, number] = loadImages(imageFiles);
        fprintf("Loading Completed:%d \n", number);
        
        % Set sequential list
        processedSet = []; 
        unprocessedSet = 1:number; 
        
        
        % Get the two images with the highest matching degree as the initial images
        [num0, num1] = getTargetInit(imgSet);
        % Initial stitching
        image = stitching(imgSet{num0}, imgSet{num1});
        % The value of pixel nan is changed to 0 to prevent subsequent errors
        image(isnan(image)) = 0;
        % Show image
        imshow(image, 'Parent', imgAxes);
        % Reordering list
        processedSet = [processedSet, num0, num1];
        unprocessedSet(unprocessedSet == num0) = [];
        unprocessedSet(unprocessedSet == num1) = [];
        
        % Update progress bar
        updateProgress(2, number);

        % Circular stitching process - minimum two images
        if number > 2
            for i = 1:number-2
                num = getTargetLoop(image, imgSet, unprocessedSet);
                image = stitching(image, imgSet{num});
                image(isnan(image)) = 0;
                processedSet = [processedSet, num];
                unprocessedSet(unprocessedSet == num) = [];
                
                % Update progress
                updateProgress(i + 2, number);
                
                % Display image
                imshow(image, 'Parent', imgAxes);
            end
        end
        
        % Remove image black border
        threshold = 5; % Black threshold. The value can be adjusted based on the actual effect
        finalImage = removeBlackBorder(image, threshold);
        
        % Displays the final Mosaic
        imshow(finalImage, 'Parent', imgAxes);
        fprintf("Task accomplished\n");
        
        % Button design
        set(saveButton, 'Enable', 'on');
        set(startButton, 'Enable', 'on');
        set(resetButton, 'Enable', 'on');
        
        % Displays the splicing order
        set(progressBar, 'String', sprintf('Final order: %s', num2str(processedSet)));
        fprintf("Picture Mosaic complete!\n");
        fprintf('Final order: %s', num2str(processedSet));
    end

    % Select images function
    function selectFiles(~, ~)
        [fileNames, path] = uigetfile('*.*', 'Select picture file', 'MultiSelect', 'on');
        if isequal(fileNames, 0)
            msgbox('No file is selected');
            return;
        end
        if ischar(fileNames)
            fileNames = {fileNames}; % If there is only one file, convert it to a cell array
        end
        % Build the imageFiles structure
        imageFiles = [];
        for i = 1:length(fileNames)
            imageFiles(i).name = fileNames{i};
            imageFiles(i).folder = path;
        end
        msgbox('The image file is selected successfully！');
    end

    % Update the progress bar function
    function updateProgress(current, total)
        progress = round((current / total) * 100);
        set(progressBar, 'String', sprintf('Process：%d%%', progress));
        drawnow; % Ensure that the UI interface is updated in real time
    end
    
    % Save image function
    function saveImage(~, ~)
        if isempty(finalImage)
            msgbox('Not finished splicing, cannot save!');
            return;
        end
        % Select the save path and file name
        [fileName, filePath] = uiputfile({'*.jpg'; '*.png'; '*.tif'}, 'Save Mosaic picture');
        if isequal(fileName, 0)
            msgbox('The save path and file name are not selected');
            return;
        end
        saveFullPath = fullfile(filePath, fileName);
        
        % Save the image to the specified location
        imwrite(finalImage, saveFullPath);
        msgbox('Image saved successfully!');
    end
    
    % Reset system function - Select another image set
    function resetSystem(~, ~)
        % Empty images and imageFiles
        imageFiles = [];
        finalImage = [];
        isStitching = false;
        % Disable Save and concatenate buttons
        set(selectFilesButton, 'Enable', 'on');
        set(saveButton, 'Enable', 'off');
        set(startButton, 'Enable', 'on');
        % Clears the display area
        imshow([], 'Parent', imgAxes);
        % Updates the progress bar
        set(progressBar, 'String', '-- To be started --');
        msgbox('The system has been reset, please re-select the picture');
    end

    % Exit system function
    function exitSystem(~, ~)
        close(fig);
    end
end

# Panorama-Image-Construction-Based-on-Matlab
Abstract This project aims to develop a Matlab-based panorama stitching program that can automatically determine the optimal stitching order for a set of 20 images and seamlessly merge them into a single panoramic image.
## basic information

Panorama Image Construction

Author: Junyou Chen

ID: 202200171208

Date: November 10 2024

Class：Robot Class 22.1

Version: 7.0

## PS

- The main function is inside the UI.m function
- There are two image sets in the folder: "images" (project image set) and "imagestest" (self-built image set). In order to quickly test the project effect respectively, you can first try to operate the "imagestest" (self-built image set), and then "images" (project image set). 
- The pre-tried result has been saved in "Result", you can modify it according to the UI interface.
- Ensure that the vlfeat-0.9.21 toolkit is complete. Otherwise, decompress it by yourself
- The project dataset (" images ") has too many images, resulting in imperfect image stitching due to cumulative errors, and the result in "result" is only the best case of multiple attempts

## System Usage



**UI Interface**  
The interface includes five buttons:

- **Select Images**: Open a file explorer to select images (.jpg or .png) for stitching.
- **Start**: Begin the image stitching process.
- **Save**: Save the final panorama image after stitching.
- **Reset**: Reset the system to select a new image set after stitching.
- **Exit**: Exit the system.

**Enter System**

Open the "UI.m" file in MATLAB, then type: UI in the command line window and send the instruction

**Select Images**  

Click "Select Images" to choose the target image set. The file explorer will open, allowing you to select multiple images. Successful selection will show a confirmation message. If no file is selected, an error message will appear.

**Start Stitching**  

Click "Start" to begin stitching the selected images. A progress bar will show the status, and other buttons (except "Exit") will be disabled during stitching.

**Stitching Complete**  

After stitching, the progress bar will show the final order, and the panorama image will appear in the window below.

**Save Image**  

Once stitching is complete, click "Save" to save the panorama. Choose the save path and file name in the file explorer. A confirmation message will pop up if the save is successful. If the save path or filename is missing, an error message will appear.

**Reset System**  

After stitching is complete, click "Reset" to start a new stitching session. A confirmation message will pop up indicating the system has been reset.

## File architecture

```
file:
    images- The given set of images
    imagestest- Self-built image set
    results-Final panoramic Mosaic results
    vlfeat-0.9.21 Tool library
    src-Code folder
Images
    Final.jpg - The final image of the given image set
    test_final.jpg- Self-built image set final image
CODE
    AlphaBlending.m- Image blending function
    computeMatrix.m- transform matrix calculation function
    Getmates.m - Gets the matching feature function
    getSIFTFeatures.m- Gets the SIFI feature function
    getTargetlnit.m- The function that gets the two figures with the highest matching degree of the target image set
    getTargetLoop.m- Gets the function that best matches the set of unprocessed images to the existing panorama
    loadlmages.m- image set loading function
    Ransac. m-RANSAC algorithm function
    removeBlackBorder.m- Remove blackborder function
    stitching.m- Image stitching function
    Ul.m-UI Interface functions & main functions
Text file
    Junyou Chen 202200171208 Report .... - Project report
    README.md
```

## Reference：

l https://github.com/joyeecheung/panoramic-image-stitching

l https://github.com/yrlu/image_mosaic_stitching

l https://github.com/BrandonHanx/AutoPanorama

l https://github.com/khushhallchandra/Automatic-Panoramic-Stitching

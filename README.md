# ARDE
This is the source code of paper named "Attraction-Repulsion Mechanism Inspired Single Image Detail
Enhancement Method".

# Project Introduction
This project provides an image detail enhancement tool based on the ARDE (Attraction-Repulsion Inspired Detail Enhancement) algorithm. To overcome the limitations of traditional residual learning methods that rely on greedy search strategies and fall into local optima, ARDE models the search for optimal matching blocks as a dynamic population evolutionary proce.It simulates the natural physical forces of "attraction" and "repulsion" to drive intelligent agents toward the global optim. 

The algorithm dynamically adjusts its search direction across the entire domain, precisely locating target blocks that best match the texture features of the original image blocks.The optimization is guided by a multi-feature loss function that focuses on pixel differences, edge differences, and texture feature differences.

# File Structure
```
├── ARDE_main.p       # [Core Algorithm] Compiled MATLAB P-code for the main ARDE optimization
├── ARDE.p            # [Core Algorithm] Compiled MATLAB P-code for ARDE components
├── grad.p            # [Helper] Compiled gradient calculation function
├── texture.p         # [Helper] Compiled texture processing function
├── DE_demo.m         # [Main Program] The primary execution script
├── Requirements.txt  # Environment and hardware dependency instructions
├── data/             # [Input Folder] Stores the .png images to be processed
└── results/          # [Output Folder] Automatically generated, stores enhanced images and metrics
```
# Quick Start
Step 1: Prepare the Environment
Ensure your MATLAB (R2023b recommended) has the "Image Processing Toolbox" and "Parallel Computing Toolbox" installed.

Step 2: Prepare the Files
Keep 'DE_demo.m' and all .p compiled files in the same directory. Ensure the input directory '.\data' exists.

Save the contents of the second script as 'DE_demo.m'.

In the directory where the code is located, create a new folder named data.
(If this folder does not exist, the program will not be able to find the images).

Step 3: Place Images
Place the .png images you want to enhance into the '.\data' folder.
Note: The code defaults to reading .png format images for detail extraction.

Step 4: Run the Program
Open MATLAB and set the Current Folder to the directory containing the files above. Type DE_demo in the Command Window and press Enter, or simply click the "Run" button in the Editor.

# Parameter Description (can be modified in DE_demo.m)
factor (Default: 4):
Enhancement intensity coefficient.

A higher value makes details more prominent but may introduce noise.

Recommended range: 2.0 - 5.0.

Pathr: Input image path (Default is '.\data').

Pathw: Output result save path (Default is '.\results').

# Notes
First-Run Speed: The program starts a parallel pool (parpool), so the first run might take a few dozen seconds to start the compute workers, which is normal. Subsequent image processing speeds will be much faster.

Memory Usage: For extremely high-resolution images (e.g., 4K and above), the Padding and population calculations in the ARDE algorithm may consume a significant amount of memory.

Parallel Computing: ARDE internally uses parfor to process image rows in parallel. If your computer has a high number of CPU cores, the processing speed will significantly improve.

# Output Results
The enhanced images will be saved in the results folder, with the filename format:
[Original Filename]_X[Enhancement Intensity]_ARDE.png.

For example: pattern_ARDE_X4.png



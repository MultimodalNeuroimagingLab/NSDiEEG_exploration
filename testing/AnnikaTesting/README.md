# NSDiEEG_exploration
Summer 2025.
This is Annika's code folder to test differences in neural responses to action stimuli.

Contained in this project is code to normalize data, compare groups of images,
compare specific images, and many other functions.


- beforeAnalysis/             
    - Code to run before analyzing data (normalization, SNR)

- analysis/                   
    - Code to analyze the normalized broadband data (mean, d', plots, etc)

- external/                   
    - Code used in many functions, but not written by me

- old/                        
    - Older versions of code existing in another one of these folders

- README.md                  
    - This file




### Important Note

Almost all the code needs the program `setLocalDataPath.m` and `ieeg_nsdParseEvents.m`
which are in the "external" folder.




### Before Analysis

#### Normalizing the Data
First, pre-processed data must be normalized. For this project, a per-run normalization
method was used (`normalization_perRun.m`). There is code for per-trial normalization,
but that is not the recommended method (`newBBNormalization.m` and `newBBNormalization_parFor.m`).
There is also an option to normalize the data of a single image (`NormalizationByImage.m`).
These are the steps for per-run:
1. Take log base 10
2. Across all trials in a run, mean from -0.1 to 0 
3. Subtract the mean from the entire time period


#### Calculating SNR
It is also recommended to calculate the Signal to Noise Ratio (SNR) of each of
the electrodes. This project used Zeeshan's code (`SNR.m`, which is in the External
folder) to calculate the SNR and then orders the electrodes into a file using 
the a separate code (`loadSNR.m`)




### Analysis

#### Category Comparisons: Creating Groups
There are two options to compare groups of images: creating folders containing
different categories of images (such as 'food' or 'buildings') or creating an
excel file with a list of all the Shared1000 images, each column representing 
a category, and a 1 or 0 whether the image is contained in the category. The 
former is easier to quickly create groups by scrolling through images; the latter
is easier when automatically filtering different HED labels (for example, a 
'human' column and an 'animal' column).

Whenever the following mentions finding indexes of images, it uses the function
`folder_idxs.m` when a folder of images is being used or `annotatedImages_idx.m`
when an excel file is being used.


#### Category Comparison: Calculating Means, Medians, and d'

With the normalized data, the main code used id either `ImageFolderAnalysis` 
(for one subject) or `ImageFolderAnalysis_SubjectLoop` (for multiple subjects).

The code first finds the mean across images:
1. Loads the current subject's normalized data
2. Finds the indexes of the images in the current group being tested (all images 
in an individual folder or all the 1's in the column of an excel file)
3. Finds the BB values of each of the images in the group at the current electrode
4. Takes the mean across all the broadband values for the images (so there 
is one value for each time point)
Steps 3 and 4 use `BBAverageImageFolder.m`

Depending on the input, the code completes these steps:
- Plots the mean across images on a graph over time using `plotBB.m` and `shadedErrorBars.m`
- Calculates the mean, peak, and median of the image average across a specified 
time frame using `BBMeanAndPeak.m`
- Given two folders, calculates the d' between these folders using `DprimeFunction.m,
explained below.
 

#### Category Comparison: Calculating d'

There is a separate option to calculate d' between two folders (using `findDprime.m`
and the function `dPrimeFunction.m`)
1. Finds the indexes of the images in the current folder of images that we are testing
2. Finds the normalized data of each of the images in the folder at the given electrode
3. Takes the mean of each image across a given time frame, so that each image 
has one value
4. Takes the mean and variance of all of the image means (`dPrimeAverageBB`)
5. Uses the d’ equation to calculate d’


#### Category Comparison: Calculating Image Contrast

Using a list of images with a Gabor Filter applied, the code `contrastMean.m` 
will use Morgan's code to find the contrast, then take the mean contrast of 
each image and save it in a 1x1000 array. Then, using `folderContrast.m`, the 
mean contrast of images within a folder will be calculated (listing the average 
contrast of each image in the folder and the mean across these images).


#### Single Image: Comparing Broadband Traces

`SinglePhotoBBGraph.m` will take normalized broadband data of a subject, find 
a single image at a single electrode, and plot the trace of that image over 
time (using `plotBB_SinglePhoto.m). Similarly, `SinglePhotoBBGraphFolder plots 
the broadband data of every image within a folder.


#### Single Image: Finding Images

The functions `displayImageNSDidx.m` and `displayImageSharedidx.m` both take 
an index of an image and create a figuring displaying the requested image.


#### Other functions

The functions `NSD2shared.m` and `shared2NSD.m` are inverses of each other. They
take one type of index (for example, the NSD index) and convert it to the other
type of index (in this case, the Shared index).

The script `normBB_withFigures` is an edited version of Morgan's code.


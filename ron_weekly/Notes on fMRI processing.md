# Notes on fMRI processing

github.com/neurodata/ndmg
on eric dev merge branch

Takes in our inputs (an fRMI files and a strucutal data file) to derive for us a time series with a particular subject

fMRI:
4d matrix - first 3 dimensions are x, y, z (brain position)
4th dimension is time
Measures the Bolt signal response in a particular voxel

Goal of processing pipeline:

Every person's brain is different shape, different anatomical landmarks, need to get over because we want to measure activity in some particular region of interest (ie all voxels considered "motor cortex")

Want those individual regions/ brain spaces to be standardized.

Scans have artifacts and Gaussian noise. Many factors that can corrupt images themselves

Want to eliminate subject specific interference. 

MC_flirt - motion correction flirt. 
Align images linearly to 0th slice of that persons brain
Quality control metric of how well head aligns before and after aligning to the brain.

Registration procedure: I have however many subjects, I need them to be ina standard space. Brain atlas - millions of dollars to take high res anatomical scans, usually at 5/10th mm resolution, really high precision.
Non linear registration - finds maximal length of brain and central axis and uses easy to find coordinates and areas of the brain to determine which regions to be aligned. 

Nuisance correction - remove artifacts from scans. May pick up low frequency signal for weird reasons (ie 5 degrees warmer than it should be). FFT selective bandpass

Extract time series for individual voxel in image, then downsample to some region of interest. Brain mask (characteristic function for set E where E is set of points we want to keep)

After time series, downsample individual time series to an individual atlas.

Give us for 2000 voxels, take average of activity for that point in time. Gives us time series in more realistic to use scale. Before 1million by timesteps dimension, make 70 by timesteps. 

Signal to noise ratio - bullshit statistic that some people like

We'll need to look at smoothing

Discriminability:
 - each subject represents some random variable. correlation estimates to a single subject should be closer within subjects at times 1 and 2 than other subjects at any time. 
 - tells us
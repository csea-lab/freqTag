# freqTag
FreqTag Toolbox
This toolbox contains a suite of matlab functions used to process ssVEP data in frequency tagging experiments. A companion paper can be found here as a preprint: 

Example data needed for following along with the examples in the companion paper can be downloaded here: 

The goal of the toolbox is to illustrate some principles of frequency-domain analyses of EEG data. The focus is on frequency tagging ssVEP studies, in which EEG is recorded as observers view streams of periodically modulated (e.g. flickering) visual stimuli. 

To install, download this folder and add to the matlab path using the add path button or the addpath command. 

Overview of the contents: 
1) Example pipelines: The toolbox comes with two example pipelines that combine several of the functions supplied here to accomplish typical tasks. The example pipelines are provided in two formats: a) as Matlab Live scripts (to be opened using the matlab livescript editor), which contain background information and explanation along with the code, in a formatted document, where individual cells can be successively executed by clicking on the side bar on the left; b) as matlab scripts, with comments supplied as part of the code, to be executed cell by cell, for example by right clicking and selecting "execute cell".

Two example pipelines are provided: freqtag_pipeline_example1, and freqtag_pipeline_example2 

freqtag_pipeline_example1.m: 
This script demonstrates how users calculate basic parameters that are needed for setting inputs and interpreting outputs.   
It illustrates the use of specific functions for use in frequency tagging analysis: freqtag_FFT.m , freqtag_3DFFT.m , freqtag_HILB.m
Example data set exampledata_1 is the dataset provided to run through this script. I may be downloaded here: 
	
freqtag_pipeline_example2.m: 
This script demonstrates an example pipeline for analysis of single trials or studies with few trials, using sliding window analysis. 
It calls several other functions such as: freqtag_FFT.m , freqtag_3DFFT.m , freqtag_slidewin.m , freqtag_simpleSNR
exampledata_2 is the infant dataset provided to run through this script
freqtag_slidewin.m requires the function bslcorr.m, which is also provided in this folder. 

2) Two data sets are used for demonstration as mentioned above 
exampledata_1 is an EEG (129 electrodes) epoched data, containing 39 trials. It comprises -400 ms pre- and 7400 ms post-stimulus onset. 500Hz sample rate. During the last 5-s two stimuli flickered at 5Hz and 6Hz.

exampledata_2 is an EEG epoched data, containing 15 trials. It comprises of 5-s in which two stimuli flickered at 5Hz and 6Hz.

summary of the functions, by function. 
systematic inout and output

Dependency: bslcorr.m and MATLAB functions such as, but not limited to:  mean, plot, fft, angle, abs, hilbert, butter, line, floor, round, repeat, find, round, squeeze, double, resample, zeros.   

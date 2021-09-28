# freqTag
##The FreqTag Toolbox
This toolbox contains a suite of matlab functions used to process ssVEP data in frequency tagging experiments. A companion paper can be found here as a preprint: 

Example data needed for following along with the examples in the companion paper can be downloaded here: 

The goal of the toolbox is to illustrate some principles of frequency-domain analyses of EEG data. The focus is on frequency tagging ssVEP studies, in which EEG is recorded as observers view streams of periodically modulated (e.g. flickering) visual stimuli. 

To install, download this folder and add to the matlab path using the add path button or the addpath command. 

##Overview of the contents: 
###1) Example pipelines: 
The toolbox comes with two example pipelines that combine several of the functions supplied here to accomplish typical tasks. The example pipelines are provided in two formats: 


a) as Matlab Live scripts (to be opened using the matlab livescript editor), which contain background information and explanation along with the code, in a formatted document, where individual cells can be successively executed by clicking on the side bar on the left; 

b) as matlab scripts, with comments supplied as part of the code, to be executed cell by cell, for example by right clicking and selecting "execute cell".

Two example pipelines are provided: "**freqtag\_pipeline\_example1**", and "**freqtag\_pipeline\_example2**" 

**freqtag\_pipeline\_example1.m:** 
This script demonstrates how users calculate basic parameters that are needed for setting inputs and interpreting outputs.   
It illustrates the use of specific functions for use in frequency tagging analysis: freqtag\_FFT.m , freqtag\_3DFFT.m , freqtag\_HILB.m

The example data set exampledata_1 is required to run through this script. It may be downloaded here: 
	
**freqtag\_pipeline\_example2.m:** 
This script demonstrates an example pipeline for analysis of single trials or studies with few trials, using sliding window analysis. 
It calls several other functions such as: freqtag\_FFT.m , freqtag\_3DFFT.m , freqtag\_slidewin.m , freqtag\_simpleSNR 

freqtag\_slidewin.m requires the function bslcorr.m, which is also provided in this folder. 

exampledata\_2 is the dataset required to run through this script


###2) Example data sets: 
Two data sets are used for demonstration as mentioned above: 

exampledata_1 is an EEG (129 electrodes) epoched data, containing 39 trials. It comprises -400 ms pre- and 7400 ms post-stimulus onset. 500Hz sample rate. During the final 5 seconds, two stimuli flickered at 5Hz and 6Hz.

exampledata_2 also is EEG epoched data, containing 15 trials. It comprises 5 seconds in which two stimuli flickered at 5Hz and 6Hz. More information is given in the companion paper.

###3) Function description




###4 Dependency: 
The toolbox requires bslcorr.m and MATLAB functions:  mean, plot, fft, angle, abs, hilbert, butter, line, floor, round, repeat, find, round, squeeze, double, resample, zeros.   

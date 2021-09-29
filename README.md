# freqTag

The FreqTag Toolbox

This toolbox contains a suite of matlab functions used to process ssVEP data in frequency tagging experiments. A companion paper can be found here as a preprint: https://osf.io/7syw8/

Example data needed for following along with the examples in the companion paper can be downloaded here: https://osf.io/pmge9/

The goal of the toolbox is to illustrate some principles of frequency-domain analyses of EEG data. The focus is on frequency tagging ssVEP studies, in which EEG is recorded as observers view streams of periodically modulated (e.g. flickering) visual stimuli. 

To install, download this folder and add to the matlab path using the add path button or the addpath command. 

## Requirements:
Matlab installation. This code is tested under Matlab 9.3 (2017b) and later. It may work under older versions of Matlab. For older versions it is recommended to use the the m-file versions of the pipeline examples/tutorials instead of the live scripts (.mlx) files.

## Overview of the contents: 

### 1) Example pipelines: 
The toolbox comes with two example pipelines that combine several of the functions supplied here to accomplish typical tasks. The example pipelines are provided in two formats: 

a) as Matlab Live scripts (to be opened using the matlab livescript editor), which contain background information and explanation along with the code, in a formatted document, where individual cells can be successively executed by clicking on the side bar on the left; 

b) as matlab scripts, with comments supplied as part of the code, to be executed cell by cell, for example by right clicking and selecting "execute cell".

Two example pipelines are provided: "**freqtag\_pipeline\_example1**", and "**freqtag\_pipeline\_example2**" 

#### freqtag_pipeline_example1.m and freqtag_pipeline_example1.mlx (liveScript version)

-This script demonstrates how users calculate basic parameters that are needed for setting inputs and interpreting outputs.   
-It illustrates the use of specific functions for use in frequency tagging analysis: freqtag_FFT.m , freqtag_3DFFT.m , freqtag_HILB.m
-Example data set exampledata_1 is the dataset provided to run through this script. It may be downloaded here: https://osf.io/pmge9/
	
#### freqtag_pipeline_example2.m and freqtag_pipeline_example2.mlx (liveScript version)

-This script demonstrates an example pipeline for analysis of single trials or studies with few trials, using sliding window analysis. 
-It calls several other functions such as: freqtag_FFT.m , freqtag_3DFFT.m , freqtag_slidewin.m , freqtag_simpleSNR
-exampledata_2 is the dataset provided to run through this script. It may be downloaded here: https://osf.io/pmge9/


### 2) Example data sets: 
Two data sets are used for demonstration as mentioned above. They may be retrived from the OSF site for this toolbox: https://osf.io/pmge9/

exampledata_1 is an EEG (129 electrodes) epoched data, containing 39 trials. It comprises -400 ms pre- and 7400 ms post-stimulus onset, collected at 500Hz sample rate. During the final 5 seconds, two stimuli flickered at 5Hz and 6Hz. It is used in the example1 pipeline above. 

exampledata_2 also is EEG epoched data, containing 15 trials. It comprises 5 seconds in which two stimuli flickered at 5Hz and 6Hz. More information is given in the companion paper. It is used in the example2 pipeline above. 

### 3) Functions contained in this toolbox:

#### function [amp, phase, freqs, fftcomp] = freqtag_FFT(data, fsamp)

% This function applies the Discrete Fourier Transform on a 2-D (M-by-N) data array in matlab workspace.\
% Inputs:\
% data = sensors by time points 2-D matrix\
% fsamp = sampling rate in Hz\
% Outputs:\ 
% amplitude spectrum (amp)\
% phase spectrum\
% frequencies available in the spectrum (freqs)\
% complex Fourier components (fftcomp)

#### function [amp, freqs, fftcomp] = freqtag_FFT3D(data, fsamp)

% This function applies the Discrete Fourier Transform on a 3-D data array, sensors by time points by trials, in matlab workspace.\
% It transforms each trial into the spectral domain and averages the single-trial amplitude spectra to yield one output spectrum.\
% Inputs:\
% data = sensors by time points by trials 3-D matrix\
% fsamp = sampling rate in Hz\
% Outputs:\
% mean amplitude spectrum (amp)\
% frequencies available in the spectrum (freqs)\
% complex Fourier components (fftcomp)

#### function [hilbamp, phase, complex] = freqtag_HILB(data, taggingfreq, filterorder, sensor2plot, plotflag, fsamp)

% this function implements a simple filter-Hilbert analysis of a 2-D data array (sensors by tim points) in the matlab workspace. It outputs the time-varying ssVEP amplitude, the time-varying phase, and the complex components of the time-varying spectrum, at the tagging frequency (real and imaginary) for each time point.\
% Inputs:\
% data = sensors by time points 2-D matrix (if data has trials as 3rd\
% dimension, use mean to average across trials)\
% taggingfreq = is the tagging frequency\
% filterorder = is the order of the filter to be aplied on the data\
% sensor2plot = is the sensor to be plotted with the phase shifted time series,\
% the absolute value of the data and the analytical hilbert transformed time series\
% plotfag = is the option to plot or not to plot the above information\
% fsamp = is the sampling rate 

#### function [trialamp,winmat3d,phasestabmat,trialSNR] = freqtag_slidewin(data, plotflag, bslvec, ssvepvec, foi, fsampnew, fsamp, outname)

% this function performs a sliding window averaging analysis as described for example in Morgan et al. 1996; Wieser 
% et al., 2016\
% Inputs:\
% data = sensors by time points 2-D matrix\
% bslvec = sample points to be used for baseline subtraction\
% ssvepvec = a vector containing the sample points to be used in sliding window analysis\
% foi = driving frequency of interest in Hz\
% fsampnew = new sample rate (if needed)\
% fsamp = sampling rate in Hz\
% Outputs:\
% ssVEP amplitude at the frequency of interest for each trial (trialamp)\
% three dimensional array of sliding window averages for each trial, in the time domain (winmat3d)\
% the phase stability average of complex coefficients across moving windows\
% ssVEP signal-to-noise ratio in decibels at the frequency of interest for each trial (trialamp)
 
### 4) Dependencies: 
The toolbox requires helper functions bslcorr.m (baseline correction in th etime domain) and freqtag_regressionMat (detrending based on linear regression). A simple function for calculating signal-to-noise ratios is also used (freqtag_simpleSNR.m). These functions are provided in this folder. The users is directed to the helpfiles and example scripts for documentation. The toolbox uses a number of built-in MATLAB functions:  mean, plot, fft, angle, abs, hilbert, butter, line, floor, round, repeat, find, round, squeeze, double, resample, zeros.   

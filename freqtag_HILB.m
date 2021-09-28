function [hilbamp, phase, complex] = freqtag_HILB(data, taggingfreq, filterorder, sensor2plot, plotflag, fsamp)
% this function implements a simple filter-Hilbert analysis of a 2-D data array (sensors by tim points) in the matlab workspace. 
% It outputs the time-varying ssVEP amplitude (hilbamp), the time-varying phase, and the complex (real and imaginary) components of 
% the time-varying response, at the tagging frequency for each time point.

% Inputs:
% data = sensors by time points 2-D matrix (if data has trials as 3rd
% dimension, use mean to average across trials)
% taggingfreq = is the tagging frequency
% filterorder = is the order of the filter to be aplied on the data
% sensor2plot = is the sensor to be plotted with the phase shifted time series,
% the absolute value of the data and the analytical hilbert transformed time series
% plotfag = is the option to plot or not to plot the above information
% fsamp = is the sampling rate

    taxis = 0:1000/fsamp:size(data,2)*1000/fsamp - 1000/fsamp;   % Calculate the time axis
    taxis = taxis/1000; 
   
    uppercutoffHz = taggingfreq + .5;                            % Design the LOW pass filter around the taggingfreq   
    [Blow,Alow] = butter(filterorder, uppercutoffHz/(fsamp/2));  
    
    lowercutoffHz = taggingfreq - .5;                            % Design the HIGH pass filter around the taggingfreq
    [Bhigh,Ahigh] = butter(filterorder, lowercutoffHz/(fsamp/2), 'high'); 
	
	
     data = data';             % The filtfilt function takes the time-point as rows and sensors as columns
    
  
     lowpassdata = filtfilt(Blow,Alow, data);               % Filter the data using the low-pass filter 
     lowhighpassdata = filtfilt(Bhigh, Ahigh, lowpassdata);    % Filter the low-pass data using the high-pass filter
     
   
     tempmat = hilbert(lowhighpassdata);                    % Calculate Hilbert Transform on the filtered data
     
    
     tempmat = tempmat';                                    % Sensors as rows again
     
         
     if plotflag                                            % Plot shows filtered data in blue, imaginary (hilbert) part in red, absolute value (envelope) in black 
      figure(10)
      plot(taxis, lowhighpassdata(:,sensor2plot)), hold on, plot(taxis, imag(tempmat(sensor2plot,:)), 'r'), plot(taxis, abs(tempmat(sensor2plot,:)), 'k')
      pause(.5)
     end
     
     hold off
    
 hilbamp = abs(tempmat);                               % Amplitude over time (real part)
 phase = angle(tempmat);                               % Phase over time 
 complex = tempmat;                                    % Imaginary part
 
function [amp, freqs, fftcomp] = freqtag_FFT3D(dataset, fsamp)
% This function applies the Discrete Fourier Transform on a 3-D data array, sensors by time points by trials, in matlab workspace.
% It transforms each trial into the spectral domain and averages the single-trial amplitude spectra to yield one output spectrum.

% Inputs:
% data = sensors by time points by trials 3-D matrix
% fsamp = sampling rate in Hz

% Outputs:
% mean amplitude spectrum (amp)
% frequencies available in the spectrum (freqs)
% complex Fourier components (fftcomp), a 3-D array which has electrodes, by frequencies, by trials

for trial = 1: size(dataset,3)       % Start of the trial loop

        Data = squeeze(dataset(:, :, trial));
        
        NFFT = size(Data,2);                % Extracts the number of data points in the dataset
        complex = fft(Data', NFFT);         % Here, the data becomes time points by sensors using the transpose to feed the fft function
                                            % and the complex spectrum is computed
        Mag = abs(complex);                 % Calculates the amplitude                                        
          
       
        Mag(1,:) = Mag(1,:)/2;                                             % DC Frequency not twice
        if ~rem(NFFT,2)                                                    % Nyquist Frequency not twice
                Mag(NFFT/2+1, :) = Mag(NFFT/2+1, :)./2;
        end

        Mag=Mag/NFFT;                      % After computing the fft, the coefficients are scaled by the length of the segment

        Mag = Mag';                        % Sensors as rowls again

        meanpower = Mag(:,1:round(NFFT./2));    % only the portion below Nyquist is saved
    
             if  trial == 1
                 specsum = meanpower; 
             else
                 specsum = specsum + meanpower;
             end
             
        fftcomp(:, :, trial) = complex(1:round(NFFT./2),:)';

end                                         % End of the trial loop

    amp = specsum ./ size(dataset,3);       % Scaling the spectrum by the number of trials
    
    select = 1:(NFFT+1)/2;                      % Scaling the frequencies
    freqs = (select - 1)'*fsamp/NFFT;
    
    
    	

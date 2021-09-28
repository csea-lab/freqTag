function [amp, phase, freqs, fftcomp] = freqtag_FFT(data, fsamp)
% This function applies the Discrete Fourier Transform on a 2-D (M-by-N) data array (data), which is loaded in matlab workspace.

% Inputs:
% data = sensors by time points 2-D matrix
% fsamp = sampling rate in Hz

% Outputs:
% amplitude spectrum (amp)
% phase spectrum
% frequencies available in the spectrum (freqs)
% complex Fourier components (fftcomp)



    NFFT = size(data,2);         % Extract the number of data points in the dataset
	fftcomp = fft(data', NFFT);  % Here, the data becomes time points by sensors using the transpose to use the matlab fft function
	phase = angle(fftcomp);      % Calculate the phase
    Mag = abs(fftcomp);          % Calculate the amplitude
               
	
	Mag(1,:) = Mag(1,:)/2;                                             % DC Frequency not twice
	if ~rem(NFFT,2)                                                    % Nyquist Frequency not twice
			Mag(NFFT/2+1, :)=Mag(NFFT/2+1, :)./2;
	end
	
	Mag=Mag/NFFT;               % After computing the fft, the coefficients will be 
                                % scaled in terms of frequency (in Hz) 
    
    Mag = Mag';                 % Sensors as rows again
    phase = phase';
    
    amp = Mag(:,1:round(NFFT./2));              % Scaling the power
    phase  = phase(:,1:round(NFFT./2));         % Scaling the phase
    select = 1:(NFFT+1)/2;                      % Scaling the frequencies
    freqs = (select - 1)'*fsamp/NFFT;
    
    
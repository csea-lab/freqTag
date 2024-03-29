function [trialamp,winmat3d,phasestabmat,trialSNR] = freqtag_slidewinTemp(data, plotflag, bslvec, ssvepvec, foi, sampnew, fsamp, outname)
% This function performs a sliding window averaging analysis as described for example in Morgan et al. 1996; Wieser % et al., 2016

% Inputs:
% data = sensors by time points 2-D matrix
% bslvec = sample points to be used for baseline subtraction
% ssvepvec = a vector containing the sample points to be used in sliding
% window analysis, in OLD sample points
% foi = driving frequency of interest in Hz
% fsampnew = new sample rate (if needed)
% fsamp = sampling rate in Hz

% Outputs:
% ssVEP amplitude at the frequency of interest for each trial (trialamp)
% three dimensional array of sliding window averages for each trial, in the time domain (winmat3d)
% the phase stability average of complex coefficients across moving windows
% ssVEP signal-to-noise ratio in decibels at the frequency of interest for each trial (trialamp) 
  
 % this to be done outside the loop to save time, needed for winshift proc
 sampcycle=1000/sampnew; % sampling interval of the new samplerate
 tempvec = round((1000/foi)/sampcycle); % this makes sure that average window duration is exactly the duration in sp of one cyle at foi
 longvec = repmat(tempvec,1,200); % repeat this many times, at least for duration of entire epoch, subsegments are created later 
 winshiftvec_long = [1 cumsum(longvec)+1]; % use cumsum function to create growing vector of indices for start of the winshift
 tempindexvec = find(winshiftvec_long > (length(ssvepvec).*sampnew./fsamp)); % find the last possible window onset insed the ssvepvec window
 endindex = tempindexvec(1);  % this is the first index for which the winshiftvector exceeds the data segment 
 winshiftvec = winshiftvec_long(1:endindex-4);

 % need this stuff for the spectrum
 shiftcycle=round(tempvec*4); % 4 cycles of the ssVEP are used here, hardcoded for this toolbox to avoid confusion
 samp=1000/sampnew;
        freqres = 1000/(shiftcycle*samp); % 6 lines of code to find the appropriate bin for the frequency of interest for each segment
        freqbins = 0:freqres:(sampnew/2); 
        min_diff_vec = freqbins-foi;  
        min_diff_vec = abs(min_diff_vec); 
        targetbin=find(min_diff_vec==min(min_diff_vec));
   
    trialamp = []; 
    trialSNR = []; 
    phasestabmat = [];  
    
    NTrials = size(data,3); 
    
    disp('Trial index:')

  for trial = 1:NTrials
        
        Data = squeeze(data(:, ssvepvec, trial)); 
       
        fouriersum = []; 
        
        disp(trial)
  
%===========================================================
    % 1. resample data
%===========================================================   
    
        Data=double(Data'); % make sure data are double precision in case they come from eeglab
            
        resampled=resample(Data,sampnew,fsamp);           
            
        Data = resampled';  
    
%===========================================================
	% 2. Baseline correction
%===========================================================
	
     datamat = bslcorr(Data, bslvec);

%==========================================================
	% 3. moving window procedure with 4 cycles
%===========================================================
	
	 winmatsum = zeros(size(datamat,1),shiftcycle); %4 cycles
	
	 if plotflag, h = figure; end

     length(winshiftvec)
   
     for winshiftstep = 1:length(winshiftvec)
		
        winmatsum = (winmatsum + freqtag_regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))); % time domain averaging for win file
        
        %for within-trial phase locking
        fouriermat = fft(freqtag_regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))');
        fouriercomp = fouriermat(targetbin,:)'; 
        
        if winshiftstep ==1
            fouriersum = fouriercomp./abs(fouriercomp);
        else
            fouriersum = fouriersum + fouriercomp./abs(fouriercomp);
        end
        
       if plotflag
           subplot(2,1,1), plot(1:sampcycle:shiftcycle*sampcycle, freqtag_regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))'), title(['sliding window starting at ' num2str((winshiftvec(winshiftstep))*sampcycle)  ' ms ']), xlabel('time in milliseconds')
           subplot(2,1,2), plot(1:sampcycle:shiftcycle*sampcycle, winmatsum'), title(['sum of sliding windows; number of shifts:' num2str(winshiftstep) ]), ylabel('microvolts')
           pause
       end        

    end
    
    winmat = winmatsum./length(winshiftvec);

	%===========================================================
	% 4. determine amplitude and Phase using fft of 
    % averaged sliding windows (variable winmat)
	%=========================================================== 
	
	NFFT = shiftcycle-1; % one cycle in sp of the desired frequency times 4 oscillations (-1)
	NumUniquePts = ceil((NFFT+1)/2); 
	fftMat = fft (winmat', (shiftcycle-1));  % transpose: channels as columns (fft columnwise)
	Mag = abs(fftMat);                                                   % Amplitude berechnen
	Mag = Mag*2;   
	
	Mag(1) = Mag(1)/2;                                                    % DC only once in the full spectrum, no need to correct as above. 
	if ~rem(NFFT,2)                                                       % same with Nyquist
        Mag(length(Mag))=Mag(length(Mag))/2;
	end
	
	Mag=Mag/NFFT;                                                        
    
    trialamp = [trialamp Mag((targetbin),:)'];
    
    trialSNR = [trialSNR log10(Mag((targetbin),:)'./ mean(Mag(([targetbin-2 targetbin+2]),:))').*10]; % a very crude SNR estimate if someone needs it
    
    % phase stability

    phasestabmat = [phasestabmat abs(fouriersum./winshiftstep)]; 
    
    winmat3d(:, :, trial) = winmat; 
        
   end % trials
   
   outmat.fftamp = trialamp; 
   outmat.phasestabmat = phasestabmat; 
   outmat.winmat = winmat3d; 
   
   eval(['save ' outname '.slidwin.mat outmat -mat']);

   fclose('all');

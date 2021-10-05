 % simulsidebands
% A simple simulation that examines the impact of power in nearby bands on the sliding window procedure
% implemented in this toolbox, using freqtag_slidewin
% evrything is hard coded, and white noise is used, to facilitate running
% on any system, regardless of matlab version and install 

clear
% define the outputs 
trialmagf1 =[]; 
trialmagf2 =[]; 

% define the frequencies
freq1 = 6;
freq2 = 5;

 % define time scale and sampling
 time = 0:0.002:6; % 6 second trials, sampled at 500 Hz

% allow for variable noise and signal magnitude

noiselevel = 20;

for run = 1:50
  for siglevel1 = 1:20
    for siglevel2 = 1:15

        % first, create a simulated trial with freq1 Hz ssVEP, plus noise

        sinef1 = sin(2*pi*time*freq1) .* siglevel1./3; 

        sigf1 = sinef1 + rand(1, length(sinef1)).*noiselevel; % white noise is used here, but can be supplied with other noise

        % same for freq2 Hz ssVEP, plus noise
        
        sinef2 = sin(2*pi*time*freq2) .* siglevel2./2; 

        sigf2 = sinef2 + rand(1, length(sinef2)).*noiselevel; 

        %plot(time, sigf2), pause(1)

        % add up and plot their sum 

        sigsum = sigf1+sigf2;

        %plot(time, sigsum), pause(1)

        [trialmagf1(siglevel1, siglevel2, run),~,~,trialSNRf1(siglevel1, siglevel2, run)] = freqtag_slidewin(sigsum, 0, 1:3000, 1:3000, freq1, 600, 500, 'test');
        [trialmagf2(siglevel1, siglevel2, run),~,~,trialSNRf2(siglevel1, siglevel2, run)] = freqtag_slidewin(sigsum, 0, 1:3000, 1:3000, freq2, 600, 500, 'test');
        
    end
  end
end

origSNR1 = ((1:20)./3)./noiselevel;
origSNR2 = ((1:15)./2)./noiselevel;

figure
subplot(1,2,1), plot(origSNR2, squeeze(mean(trialmagf1,3))), legend(num2str(origSNR1')),
xlabel(['SNR at tag 2 (' num2str(freq2) 'Hz)']), ylabel(['SNR for tag 1 (' num2str(freq1) 'Hz)']),
title('Tag 1 SNR by Tag 2 SNR') 
subplot(1,2,2), plot(origSNR1, squeeze(mean(trialmagf2,3))), legend(num2str(origSNR2'))
xlabel(['SNR at tag 1 (' num2str(freq1) 'Hz)']), ylabel(['SNR for tag 2 (' num2str(freq2) 'Hz)'])
title('Tag 2 SNR by Tag 1 SNR') 

figure
subplot(1,2,1), plot(origSNR2, squeeze(mean(trialSNRf1,3))), legend(num2str(origSNR1'))
subplot(1,2,2), plot(origSNR1, squeeze(mean(trialSNRf2,3))), legend(num2str(origSNR2'))




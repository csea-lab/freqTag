% simulsidebands
% A simple simulation that examines the impact of power in nearby bands on the sliding window procedure
% implemented in this toolbox, using freqtag_slidewin
% evrything is hard coded, and white noise is used, to facilitate running
% on any system, regardless of matlab version and install 


% clear the outputs 
trialmagf1 =[]; 
trialmagf2 =[]; 
% define the frequencies
freq1 = 5;
freq2 = 6;

 % define time scale and sampling
 time = 0:0.002:6; % 6 second trials, sampled at 500 Hz

% allow for variable noise and signal magnitude

noiselevel = 20;

for run = 1:50
  for siglevel1 = 1:30
    for siglevel2 = 1:20

        % first, create a simulated trial with freq1 Hz ssVEP, plus noise

        sinef1 = sin(2*pi*time*freq1) .* siglevel1./6; 

        sigf1 = sinef1 + rand(1, length(sinef1)).*noiselevel; % white noise is used here, but can be supplied with other noise

        % same for freq2 Hz ssVEP, plus noise
        
        sinef2 = sin(2*pi*time*freq2) .* siglevel2./5; 

        sigf2 = sinef2 + rand(1, length(sinef2)).*noiselevel; 

        %plot(time, sigf2), pause(1)

        % add up and plot their sum 

        sigsum = sigf1+sigf2;

        % plot(time, sigsum), pause(1)

        [trialmagf1(siglevel1, siglevel2, run),winmat3d,phasestabmat,trialSNRf1(siglevel1, siglevel2, run)] = freqtag_slidewin(sigsum, 0, 1:3000, 1:3000, freq1, 600, 500, 'test');
        [trialmagf2(siglevel1, siglevel2, run),winmat3d,phasestabmat,trialSNRf2(siglevel1, siglevel2, run)] = freqtag_slidewin(sigsum, 0, 1:3000, 1:3000, freq2, 600, 500, 'test');
        
    end
  end
end

figure
subplot(1,2,1), contourf((1:30)./6, (1:20)./5, squeeze(mean(trialmagf1,3))'), colorbar
subplot(1,2,2), contourf((1:30)./6, (1:20)./5, squeeze(mean(trialmagf2,3))'), colorbar



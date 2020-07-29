%%Visual Microphone: this is the function that extracts sound from video
%%Based on "The Visual Microphone: Passive Recovery of Sound from Video"
%%by Abe Davis, Michael Rubinstein, Neal Wadhwa, Gautham J. Mysore,
%%Fredo Durand, and William T. Freeman
%%from SIGGRAPH 2014

%%This code written by Abe Davis

%%(c) Myers Abraham Davis (Abe Davis), MIT 
%%Note from Abe: It's probably worth mentioning that MIT has a patent
%%pending on this work.

%%
function [S] = vmModesFromVideo(vHandle, nscalesin, norientationsin, varargin)
%   Extracts audio from tiny vibrations in video.
%   Optional argument DownsampleFactor lets you specify some factor to
%   downsample by to make processing faster. For example, 0.5 will
%   downsample to half size, and run the algorithm.

tic;
startTime = toc;
% Parameters
defaultnframes = 0;
defaultDownsampleFactor = 1;
defaultsamplingrate = -1;
p = inputParser();
% addOptional(p, 'DownsampleFactor', defaultDownsampleFactor, @isnumeric);     
% addOptional(p, 'SamplingRate', defaultsamplingrate, @isnumeric);
% addOptional(p, 'NFrames', defaultnframes, @isnumeric);
p.addParameter('DownsampleFactor', defaultDownsampleFactor, @isnumeric);     
p.addParameter('SamplingRate', defaultsamplingrate, @isnumeric);
p.addParameter('NFrames', defaultnframes, @isnumeric);

nScales = nscalesin;
nOrients = norientationsin;
parse(p, varargin{:});
dSampleFactor = p.Results.DownsampleFactor;
samplingrate = round(p.Results.SamplingRate);
numFramesIn = p.Results.NFrames;
info=aviinfo(vHandle);

if(samplingrate<0)
    %samplingrate = info.FramesPerSecond;
	samplingrate = round(info.FramesPerSecond*2);
end


'Reading first frame of video'
'Successfully read first frame of video'
colorframe = aviread(vHandle,1);

if(dSampleFactor~=1)
    colorframe = imresize(colorframe,dSampleFactor);
end

fullFrame = im2single(squeeze(mean(colorframe,3)));
refFrame = fullFrame;

[h,w] = size(refFrame);%height and width of video in pixels

nF = numFramesIn;
if(nF==0)
    %depending on matlab and type of video you are using, may need to read
    %the last frame
    %lastFrame = read(vHandle, inf); 
    nF = info.NumFrames;%number of frames
end


%params.nScales = nScales;
%params.nOrientations = nOrients;
%params.dSampleFactor = dSampleFactor;
%params.nFrames = nF;

%%

[pyrRef, pind] = buildSCFpyr(refFrame, nScales, nOrients-1);

%%%%%%%%%%%%%%%		Why do we need?????????		%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%		a loop below???????????		%%%%%%%%%%%%%%%%%%%%%% 
for j = 1:nScales
    for k = 1:nOrients
        bandIdx = 1+nOrients*(j-1)+k;    
    end
end

%

totalsigs = nScales*nOrients;
%signalffs = zeros(nScales,nOrients,nF);
%ampsigs = zeros(nScales,nOrients,nF);

%

prog = waitbar (0, '0.00%');      %Waitbar Initialization

% Process
phasew=zeros(h,w,nF);	% Time slices of the weighted local motion signal
sumamp=0;				% For normalization

nF=nF*9/10;				% Octave not able to read last two frames
power_spec=zeros(nF);

for q = 1:1000
    %if(mod(q,floor(nF/100))==1)
    %    progress = q/nF;
    %    currentTime = toc;
    %    ['Progress:' num2str(round(progress*100)) '% done after ' num2str(currentTime-startTime) ' seconds.']
    %end
    vframein = aviread(vHandle,q);
    if(dSampleFactor == 1)
        fullFrame = im2single(squeeze(mean(vframein,3)));
    else
        fullFrame = im2single(squeeze(mean(imresize(vframein,dSampleFactor),3)));
    end
    
    im = fullFrame;
    
    pyr = buildSCFpyr(im, nScales, nOrients-1);
    pyrAmp = abs(pyr);
    pyrDeltaPhase = mod(pi+angle(pyr)-angle(pyrRef), 2*pi) - pi;   
    
    
    for j = 1:nScales
        bandIdx = 1 + (j-1)*nOrients + 1;
        curH = pind(bandIdx,1);
        curW = pind(bandIdx,2);        
        for k = 1:nOrients
            bandIdx = 1 + (j-1)*nOrients + k;
            amp = pyrBand(pyrAmp, pind, bandIdx);
            phase = pyrBand(pyrDeltaPhase, pind, bandIdx);
            
            %weighted signals with amplitude square weights.
            phasew(:,:,q) += phase.*(abs(amp).^2);   %%%%%%%%%%%%%%%%%%%%%%check whether orientations should be added.***********************************************************
            
            sumamp = sum(abs(amp(:)));
            ampsigs(j,k,q)= sumamp;					%%%%%%%%%%%%%%%%%%%%%%%%%%%% how to add amp for each orientation in a frame. Are they orthogonal?****************************
        end
    end
    waitbar (q/nF, prog, sprintf ('%.2f%%  Frame %d', 100*q/nF, q));
end

waitbar (0, prog, sprintf ('Starting Fourier Transform'));

phase_fft = fft(phasew,[],3);
waitbar (1, prog, sprintf ('Finishing Fourier Transform'));
power_spec = squeeze(sum(sum(abs(phase_fft))));

S.power=power_spec(1:(nF+1)/2);
S.freq=[0:(nF-1)/2]'*samplingrate/nF;
S.frames=nF;

waitbar (0, prog, sprintf ('Smoothing Image'));
stdev=0.5;
for i=1:nF
	phasew(:,:,i)=imsmooth(phasew(:,:,i),'Gaussian',stdev);
end
waitbar (1, prog, sprintf ('Finished Smoothing'));

%phasew=phasew/sumamp;          %%%%%%%%%%%%%%% No Normalization for now. Need to define sumamp also.************************************************************************
waitbar (0, prog, sprintf ('Saving Data'));
save data.mat phase_fft;
waitbar (1, prog, sprintf ('Data Saved'));
%S.rgb=vmPlotRGB(phasew,h,w,nF);

waitbar (0, prog, sprintf ('FFT of smoothed phase data'));
S.smooth_fft=fft(phasew,[],3);
waitbar (1, prog, sprintf ('FFT of smoothed phase data'));

%S.rgb=vmPlotShape(S.smooth_fft,h,w,nF,prog);

end

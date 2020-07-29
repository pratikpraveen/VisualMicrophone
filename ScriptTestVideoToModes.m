%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%By Abe Davis:
%This code runs a very basic version of the Visual Microphone on high speed
%video of a bag of chips being hit by a linear ramp of frequencies. 
%
%The provided default video (crabchipsRamp.avi) has a very strong signal, 
%so you can still get results if you downsample by a significant factor. 
%The default below is to downsample to 0.1 times the original size, which 
%is enough to make things runable on my laptop in a reasonable amount of 
%time.

%This code does not leverage rolling shutter.
%note that the recovered sound is sampled at 2200Hz, which may not play by
%default in some media players. It will play in MATLAB though.

%this code also uses matlabPyrTools by Eero P. Simoncelli
%parts of it also use the signal processing toolbox

%A lot of the functions pass around objects that represent sounds. They
%have fields:
%'x' - the time signal
%'samplingRate' - the sampling rate.

%This work is based on:
%"The Visual Microphone: Passive Recovery of Sound from Video"
%by Abe Davis, Michael Rubinstein, Neal Wadhwa, Gautham J. Mysore,
%Fredo Durand, and William T. Freeman
%from SIGGRAPH 2014
%
%MIT has a patent pending on this work.
%
%(c) Myers Abraham Davis (Abe Davis), MIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%

%change the below path to wherever you put the VisualMicCode Directory
%cd C:\Users\pponnar\Desktop\Resources\Code\Modal;

clear
setPath
currentDirectory = pwd;
%dataDir = fullfile('', 'data');%dataDir should be directory to data
dataDir = uigetdir();
filename=uigetfile();
%vidName = 'Book';
%vidExtension = '.avi';
testcasename = filename(1:(index(filename,'.')-1));
nscales = 1;
norientations = 1;
dsamplefactor = 0.2; %downsample to 0.1 full size
%filename = [vidName vidExtension];
warning('off', 'Octave:possible-matlab-short-circuit-operator');
pkg load video;
pkg load image;
pkg load signal;
%vr = VideoReader(fullfile(dataDir, filename));   %only for Matlab

%if the video is saved with the actual framerate, you can set as follows. 
%samplingrate = vr.FrameRate;

%otherwise, specify the framerate manually
samplingrate = 240;

wndw = 80;
olap = 40;
vr = fullfile(dataDir, filename);
%%
more off;
S = vmModesFromVideo(vr, nscales, norientations,'DownsampleFactor', dsamplefactor,'SamplingRate',  samplingrate);
figure(1);
plot(S.freq,S.power);


fflush(stdout);
g=input('Enter index of frequency of mode shapes required: ');

%%%%%%%% Add provision for black background. Create your own colormap. Range is 0-1 for rgb not 0-255*****************
%%%%%%%% What is the unit of phase???? Is it just a value or is it in radians?****************************************
somewhat_cool=[repmat(0,3,3);cool(16)];
colormap(hsv);
for i=1:length(g)
	figure(i+1);
	contourf(S.smooth_fft(:,:,g(i)));
end
colormap(somewhat_cool);
for i=1:length(g)
	figure(length(g)+i+1);
	contourf(S.smooth_fft(:,:,g(i)));
end
	
	
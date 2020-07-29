function [ S ] = vmSoundFromWAV(fileName, fileDirectory)
%   vmSoundFromWAV
%   Loads sound from wav file

if(nargin == 2)
    S.fileName = fileName;
    S.fileDirectory = fileDirectory;
else
    [S.fileName, S.fileDirectory] = uigetfile;
end

[S.x, S.samplingRate] = wavread(fullfile(S.fileDirectory, S.fileName));

if(size(S.x,2)>1)
    S.channels = S.x;
    S.x = mean(S.x, 2);
    'WARNING: loaded stereo sound, the visual mic code will treat as mono.'
end
S.type = {'fromWAV'};

end
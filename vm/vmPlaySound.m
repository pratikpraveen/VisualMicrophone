function [ output_args ] = vmPlaySound( S, gain )
%VMPLAYSOUND Plays the sound S, multiplied by gain
%   S should have field x, the time signal, and samplingRate, the sampling
%   rate. This is purely a convenience function.

%if(nargin == 1)
%    sound(S.x, S.samplingRate);
%else
%    sound(S.x*gain, S.samplingRate);
%end

if(nargin == 1)
    player = audioplayer(S.x, S.samplingRate);
else
    player = audioplayer(S.x, S.samplingRate);
play (player);

end
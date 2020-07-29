function [ Smod ] = vmGetSoundSpecSub( S , qtl1, qtl2)
%vmGetSoundSpecSub Recover sound from the stft of S
%this assumes that S has the fields commonly used in visual mic (vm) code
%(c) Myers Abraham Davis (Abe Davis), MIT

st = vmComputeSTFT(S);

if(nargin == 3)
    newst = vmComputeSpecSub(st,qtl1,qtl2);
else
    newst = vmComputeSpecSub(st);
end

Smod = S;
Smod.x = double(real(vmSTFTResynth(newst.s,st.windowSize,st.hopSize, 0, 'hann')));

%edge cases can slightly change length of filtered signal so I crop to
%original length. This isn't a problem if spectral subtraction is a final
%filtering step, but if you are doing super high precision work you should
%be aware of it.
Smod.x = Smod.x(1:length(S.x));

%scale to -1,1 so we can listen to it.
Smod = vmGetSoundScaledToOne(Smod);

end


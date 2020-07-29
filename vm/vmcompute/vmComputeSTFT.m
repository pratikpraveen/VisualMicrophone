function [ stft_out ] = vmComputeSTFT( S, windowsize, hopsize )
%vmComputeSTFT getter for the stft of a sound. Used in cases where a sound may
%or may not have an already computed and usable stft. If stft already
%computed, can return it without recomputing.
%Abe Davis, 2014

%(c) Myers Abraham Davis (Abe Davis), MIT

if(nargin<2)
    if(isfield(S,'stft') && isfield(S.stft,'s'))
        stft_out = S.stft; % if it exists, return it
        return;
    else
        stft_out.windowSize = S.samplingRate;
        stft_out.hopSize = floor(S.samplingRate*0.02);
        stft_out.s = vmSTFTForward(S.x, stft_out.windowSize, stft_out.hopSize, 0, 'hann'); % if it doesn't, compute and return
        return
    end
else
    if(nargin<3)
        hopsize = floor(S.samplingRate*0.02);%default for hopsize
    end
    
    stft_out.windowSize = windowsize;
    stft_out.hopSize = hopsize;
    
    if(isfield(S,'stft'))
        if(isfield(S.stft, 'windowSize') && isfield(S.stft,'hopSize') && (S.stft.hopSize ==hopsize) && (S.stft.windowSize == windowsize))
            stft_out = S.stft;
            return;
        else
            stft_out.s = vmSTFTForward(S.x, stft_out.windowSize, stft_out.hopSize, 0, 'hann');% params don't match, compute new stft
            return;
        end
    else
        stft_out.s = vmSTFTForward(S.x, stft_out.windowSize, stft_out.hopSize, 0, 'hann'); % don't have stft, compute
    end
end

end


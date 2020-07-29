function [ output_args ] = vmWriteWAV(S, fn)
%vmWriteWAV takes a sound and writes it out as a WAV file
% with the file name fn
%wavwrite(S.x, S.samplingRate, fn);
audiowrite(fn, S.x, S.samplingRate);

end


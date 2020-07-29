function [ stnew ] = vmComputeSpecSub(  Sstft, qtl1, qtl2 )
%Function to do spectral subtraction on stft. Without manually selecting
%silent region of signal, noise floor is chosen as some quantile of the
%observed energies at each frequency. By default, this means that the
%median power at a given frequency is assumed to be the noise floor. If you
%want to mess with the input parameters, you can change this to a different
%quantile (e.q. set the noise floor the the 80th percentile at each
%frequency). 

%(c) Myers Abraham Davis (Abe Davis), MIT

%A note from Abe: 
%Anecdotally, I remember that the median ends up being a fairly
%unaggressive noise floor. You can often get away with something like the
%90th percentile and it will still do well. This may seem surprising at
%first, but the important thing to realize is that even in a signal that is
%never silent (e.g someone talking), *individual frequencies* will still be
%silent most of the time. Ok, so this may not be the case for a wicked drum
%solo, but it applies to speech.




st = Sstft.s;

%st = Sr.stft;
stmags = abs(st).^2;
stangles = angle(st);

if(nargin<3)
    qtl1 = 0.5;
    qtl2 = 1;
end

holdCol = quantile(stmags,qtl1,2);
holdCol = holdCol(:,qtl2);

for(q=1:size(stmags,2))
    stmags(:,q) = stmags(:,q)-holdCol;
    stmags(:,q) = max(stmags(:,q),0);
end


stmags = sqrt(stmags);
newst = stmags.*exp(complex(0,1)*stangles);

stnew = Sstft;
stnew.s = newst;

end


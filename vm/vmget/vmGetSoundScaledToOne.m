function [ S ] = vmGetSoundScaledToOne(A)
%vmGetSoundScaledToOne Scales to -1,1 so that we can play as audio file
%   make it audible
%   (c) Myers Abraham Davis (Abe Davis), MIT
S = A;

maxsx = max(S.x);
minsx = min(S.x);
if(maxsx~=1.0 || minsx ~= -1.0)
    range = maxsx-minsx;
    S.x = 2*S.x/range;
    newmx = max(S.x);
    offset = newmx-1.0;
    S.x = S.x-offset;
end

if(size(S.x,2)>size(S.x,1))
    S.x = S.x.';
end

end


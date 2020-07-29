function f = vmSTFTResynth( x, sz, hp, pd, w, ll)
% Transform short-time Fourier transform into time signal
% Based on (with permission):
% function f = stft( x, sz, hp, pd, w, ll)
% by Paris Smaragdis
% Inputs:
%  x   input time series (must be row vector), or input complex spectrogram (DC to Nyquist)
%  sz  size of the FFT
%  hp  hop size in samples
%  pd  pad size in samples
%  w   window to use (function name of data vector)
%  ll  highest frequency index to return
%
% Output:
% time series resynthesis

% 
% Paris Smaragdis 2006-2008, paris@media.mit.edu
% Abe Davis, abedavis@mit.edu


% Defaults
if nargin < 5
    w = 1;
end
if nargin < 4
    pd = 0;
end
if nargin < 3
    hp = sz/2;
end

% Specified window is a string
if isstr( w)
    w = feval( w, sz);
end

% Ignore padded part
if length( w) == sz
    w = [w; zeros( pd, 1)];
end

% Overlap add/window/replace conjugate part
if isa( x, 'single')
    f = zeros( 1, (size(x,2)-1)*hp+sz+pd, 'single');
else
    f = zeros( 1, (size(x,2)-1)*hp+sz+pd);
end
v = 1:sz+pd;
for i = 1:size( x,2)
    f((i-1)*hp+v) = f((i-1)*hp+v) + ...
        (w .* real( ifft( [x(:,i); conj( x(end-1:-1:2,i))])))';
end

% Norm for overlap
f = f / (sz/hp);
%	f = f(sz+pd+1:end-sz-2*pd);
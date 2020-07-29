function f = vmSTFTForward( x, sz, hp, pd, w, ll)
% Short-time Fourier transform, from signal to stft
% based on the function by Paris Smaragdis (with permission)
% function f = stft( x, sz, hp, pd, w, ll)
%
% Inputs: 
%  x   input time series (must be row vector), or input complex spectrogram (DC to Nyquist)
%  sz  size of the FFT
%  hp  hop size in samples
%  pd  pad size in samples
%  w   window to use (function name of data vector)
%  ll  highest frequency index to return
%
% Output:
%  f   complex STFT output (only DC to Nyquist components)

% Paris Smaragdis 2006-2008, paris@media.mit.edu
% Abe Davis, abedavis@mit.edu

% Forward transform
%if isreal( x)

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

% Orient and zero pad input
if size( x, 1) > 1
    x = x';
end
%x = [x zeros( 1, ceil( length(x)/sz)*sz-length(x))];
x = [x zeros( 1, ceil((length(x)-sz)/hp)*hp+sz-length(x))];

%	x = [zeros( 1, sz+pd) x zeros( 1, sz+pd)];

% Pack frames into matrix
if isa( x, 'single')
    s = zeros( sz, (length(x)-sz)/hp, 'single');
else
    %sz
    %(length(x)-sz)/hp
    %s = zeros( sz, (length(x)-sz)/hp);
    s = zeros( sz, floor((length(x)-sz)/hp));
end
j = 1;
for i = sz:hp:length( x)
    s(:,j) = w .* x((i-sz+1):i).';
    j = j + 1;
end

% FFT it
f = fft( s, sz+pd);

% Chop redundant part
%f = f(1:end/2+1,:);
%f = f(1:floor(end/2+1),:);
f = f(1:ceil((end+1)/2),:);

% Chop again to given limits
if nargin == 6
    f = f(1:ll,:);
end

% Just plot
if nargout == 0
    imagesc( log( abs(f))), axis xy
    %		xlabel( 'Time (sec)')
    %		ylabel( 'Frequency (Rad)')
    %		set( gca, 'xtick
end


%end

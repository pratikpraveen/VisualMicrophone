function out = corrDnClr(im, filt)

%------------------------------------------------------------
%% OPTIONAL ARGS:

if (exist('nlevs') ~= 1) 
  nlevs = 1;
end

if (exist('filt') ~= 1) 
  filt = 'binom5';
end

%------------------------------------------------------------

tmp = corrDn(im(:,:,1), filt);
out = zeros(size(tmp,1), size(tmp,2), size(im,3));
out(:,:,1) = tmp;
for clr = 2:size(im,3)
  out(:,:,clr) = corrDn(im(:,:,clr), filt, );
end

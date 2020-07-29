function [ AXout, shiftam ] = vmAlignAToB( Ax, Bx )
%Aligns A to B, optionally returns offset

acorb = conv(Ax, Bx(end:-1:1));
[maxval, maxind] = max(acorb);
shiftam = size(Bx,1)-maxind;
AXout = circshift(Ax, shiftam);
end


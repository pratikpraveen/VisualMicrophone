function shape vmModeShapes(a,h,w,b)
    shape=zeros(h,w,b);
    shape=fft(a,[],3);
end 
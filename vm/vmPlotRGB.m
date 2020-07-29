
function imRGB= vmPlotRGB(a,h,w,b)
	
	MAX=max(max(a));
	MIN=min(min(a));
	imRGB=zeros(h,w,3,b);
	i=j=k=1;
	temp=1;
	for val=a(:)
		temp=floor((val-MIN(k))/(MAX(k)-MIN(k))*4);
		temp
		if temp==0
			imRGB(i,j,1,k)=imRGB(i,j,2,k)=imRGB(i,j,3,k)=0;
		else
			if temp==4
				imRGB(i,j,1,k)=imRGB(i,j,2,k)=imRGB(i,j,3,k)=255;
			else
				imRGB(i,j,temp,k)=255;
			end
		end
		if (i==w && j==h)
			k=k+1;
			i=j=1;
		elseif i==w
			j=j+1;
			i=1;
		else			
			i=i+1;
		end
	end
end

function imShape = vmPlotShape(a,h,w,b,prog)

imShape=zeros(h,w,3,b);
for c1=1:b
	for c2=1:w
		for c3=1:h
			if abs(a(c3,c2,c1))>1e-3
				if sign(real(a(c3,c2,c1)))>0
					[imShape(c3,c2,:,c1)]=[255 105 180];
				else
					[imShape(c3,c2,:,c1)]=[34 139 34];
				end
			end
		end
	end
	waitbar (c1/b, prog, sprintf ('Calculating RGB...   %.2f%%', 100*c1/b));
end
close(prog);
end
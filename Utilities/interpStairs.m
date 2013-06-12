function xi = interpStairs(t,x,ti)
%interpolate using closes previous sample... thereby producing a 
%stair step function.

last = 1;
xi = zeros(size(ti));
for ndx = 1:length(ti)
    last = find(ti(ndx)>t(last:end-1),1,'last') + (last-1);
    if(isempty(last))
        last = 1;
        xi(ndx) = 0;
    else
        xi(ndx) = x(last);
    end
end
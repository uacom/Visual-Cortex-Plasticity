% DRAW_CIRCLE(x0,y0,r,linestyle,color,slices) draw a circle

function DRAW_CIRCLE(x0,y0,r,linestyle,color,slices)

if nargin < 6
    num_slices = 20;
else
    num_slices = slices;
end

c_step = 2*pi/num_slices;

i=0:c_step:2*pi;
x = r*cos(i) + x0;
y = r*sin(i) + y0;

plot(x,y,'LineStyle',linestyle,'Color',color);

return
% LINEBOX   draw a rectangle
%
% function linebox(x_ori,y_ori,color,angle,x_dim,y_dim,line_width);
%
%     INPUTS
%     x_ori      -  x of center
%     y_ori      -  y of center
%     color      -  fill color
%     angle      -  angle in +x direction
%     x_dim      -  size along x axis
%     y_dim      -  size along y axis
%     line_width -  line width
%  


function linebox(x_ori,y_ori,color,angle,x_dim,y_dim,line_width)

if nargin < 7
   linewidth = 1;
else
   linewidth = line_width;
end

if nargin < 6
   y_size = 1;
else
   y_size = y_dim;
end

if nargin < 5
   x_size = 1;
else
   x_size = x_dim;
end

if nargin < 4
   direction = 0;
else
   direction = angle;
end

if nargin < 3
   line_color = [0.0 0.0 0.0];
else
   line_color = color;
end

if nargin < 2
   fprintf('ERROR: too few arguements.\n');
   return;
end

xs_o_2 = x_size*0.5;
ys_o_2 = y_size*0.5;
rad_direction = direction*pi/180;
sin_xs2 = xs_o_2*sin(rad_direction);
cos_xs2 = xs_o_2*cos(rad_direction);
sin_ys2 = ys_o_2*sin(rad_direction);
cos_ys2 = ys_o_2*cos(rad_direction);

% patch box
x = zeros(1,5);
y = zeros(1,5);

x(1) =  cos_xs2 - sin_ys2;
y(1) =  sin_xs2 + cos_ys2;

x(2) = -cos_xs2 - sin_ys2;
y(2) = -sin_xs2 + cos_ys2;

x(3) = -cos_xs2 + sin_ys2;
y(3) = -sin_xs2 - cos_ys2;

x(4) =  cos_xs2 + sin_ys2;
y(4) =  sin_xs2 - cos_ys2;

x(5) =  cos_xs2 - sin_ys2;
y(5) =  sin_xs2 + cos_ys2;

line('XData',x+x_ori,'YData',y+y_ori,'Color',line_color,'LineWidth',linewidth);

return;

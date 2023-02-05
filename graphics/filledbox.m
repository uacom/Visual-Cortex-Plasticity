% FILLEDBOX   draw a filled rectangle
%
% function filledbox(x_ori,y_ori,color,angle,x_dim,y_dim);
%
%     INPUTS
%     x_ori   -  x of center
%     y_ori   -  y of center
%     color   -  fill color
%     angle   -  angle in +x direction
%     x_dim   -  size along x axis
%     y_dim   -  size along y axis
% 

function filledbox(x_ori,y_ori,color,angle,x_dim,y_dim)

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
   fill_color = [0.0 0.0 0.0];
else
   fill_color = color;
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
x = zeros(1,4);
y = zeros(1,4);

x(1) =  cos_xs2 - sin_ys2;
y(1) =  sin_xs2 + cos_ys2;

x(2) = -cos_xs2 - sin_ys2;
y(2) = -sin_xs2 + cos_ys2;

x(3) = -cos_xs2 + sin_ys2;
y(3) = -sin_xs2 - cos_ys2;

x(4) =  cos_xs2 + sin_ys2;
y(4) =  sin_xs2 - cos_ys2;

patch('XData',x+x_ori,'YData',y+y_ori,'FaceColor',fill_color,'EdgeColor',fill_color,'LineWidth',1);

return;

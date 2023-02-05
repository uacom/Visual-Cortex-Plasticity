% ARROW   draw a line with an arrow
%
% function arrow(x1,y1,x2,y2,arrow_size,color,arrow_angle,line_width);
%
%     INPUTS
%     x1,y1       -  start
%     x2,y2       -  end
%     arrow_size  -  arrow arm size
%     color       -  fill color
%     arrow_angle -  arrow full angle
%     line_width  -  line width
%  
%   

function arrow(x1,y1,x2,y2,arrow_size,color,arrow_angle,line_width);

if nargin < 8
   l_width = 1;
else
   l_width = line_width;
end

if nargin < 7
   a_angle = 90;
else
   a_angle = arrow_angle;
end

if nargin < 6
   l_color = [0.0 0.0 0.0];
else
   l_color = color;
end

if nargin < 5
   a_size = 0.1;
else
   a_size = arrow_size;
end

if nargin < 4
   fprintf('ERROR: too few arguements.\n');
   return;
end

if x1 == x2
   if y1 <= y2
      line_angle = pi/2;
   else
      line_angle = pi*3/2;
   end
elseif y1 == y2
   if x1 <= x2
      line_angle = 0;
   else
      line_angle = pi;
   end
else
   tan_angle = (y2-y1)/(x2-x1);
   line_angle = atan(tan_angle);
   if x1 > x2
      line_angle = line_angle + pi;
   end
end

x = zeros(1,5);
y = zeros(1,5);

x(1) = x1;
y(1) = y1;

x(2) = x2;
y(2) = y2;

x(3) = x2 + a_size*cos( (180-a_angle/2)/180*pi + line_angle );
y(3) = y2 + a_size*sin( (180-a_angle/2)/180*pi + line_angle );

x(4) = x2;
y(4) = y2;

x(5) = x2 + a_size*cos( (180+a_angle/2)/180*pi + line_angle );
y(5) = y2 + a_size*sin( (180+a_angle/2)/180*pi + line_angle );

plot(x,y,'Color',l_color,'LineWidth',l_width);

return;

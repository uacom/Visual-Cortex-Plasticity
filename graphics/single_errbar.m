% single_errbar(x0,y0,upper_err,lower_err,line_width,line_color,stem_gap,cap_size)
% x0, y0, origin of the error bar 
% upper_err, lower_err, upper and lower errors
% line_width, line_color
% step_gap, size of gap between upper and lower error lines, should be 0-100 percent
% cap_size, how large the cap line is
%


function  single_errbar(x0,y0,upper_err,lower_err,line_width,line_color,stem_gap,cap_size)

hold on

% upper bar
% stem
stem_start_x = x0;
stem_start_y = y0 + upper_err*stem_gap;
stem_end_x = x0;
stem_end_y = y0 + upper_err;
plot([stem_start_x stem_end_x],[stem_start_y stem_end_y],'LineWidth',line_width,'Color',line_color);
% cap
cap_left_x  = stem_end_x - cap_size*0.5;
cap_left_y  = stem_end_y;
cap_right_x = stem_end_x + cap_size*0.5;
cap_right_y = stem_end_y;
plot([cap_left_x cap_right_x],[cap_left_y cap_right_y],'LineWidth',line_width,'Color',line_color);

% lower bar
% stem
stem_start_x = x0;
stem_start_y = y0 - lower_err*stem_gap;
stem_end_x = x0;
stem_end_y = y0 - lower_err;
plot([stem_start_x stem_end_x],[stem_start_y stem_end_y],'LineWidth',line_width,'Color',line_color);
% cap
cap_left_x  = stem_end_x - cap_size*0.5;
cap_left_y  = stem_end_y;
cap_right_x = stem_end_x + cap_size*0.5;
cap_right_y = stem_end_y;
plot([cap_left_x cap_right_x],[cap_left_y cap_right_y],'LineWidth',line_width,'Color',line_color);

return

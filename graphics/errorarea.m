function [hl,ha] = yerrorarea(X,Y,E,lc,ac);
% function [hl,ha] = yerrorarea(X,Y,E,lc,ac);
%
% INPUTS    X  -
%           Y  -
%           E  -
%           lc - color for data line
%           ac - color for error area
%
% OUTPUTS   h1   - handle for line
%           ha   - handle for error area
%
% 

hold on

% error area
stderr_x = [X(:)' fliplr(X(:)')];
stderr_yl = Y-E;
stderr_yh = Y+E;
stderr_y = [stderr_yl(:)' fliplr(stderr_yh(:)')];
ha = patch(stderr_x,stderr_y,ac);
set(ha,'LineStyle','none');

% data
hl = plot(X,Y,'Color',lc);

return;



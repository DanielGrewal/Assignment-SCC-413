function xdata = reverse_normal(x, xmin, xmax) 
% need original min and max values for it to work
% x = xi * (xmax - xmin) + xmin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x = normalised data
% xmax = original max value & xmin = original min value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xdata = x * (xmax - xmin) + xmin; 
end
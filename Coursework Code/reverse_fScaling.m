function xdata = reverse_fScaling(x,m,s)
% standardization = (x - mean) / sd
% reverse standardization = (x * sd) + xmin
% x must be n x 1 vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x = standardized data
% s = original standard deviation
% m = mean of original data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xdata = (x * s) + m;
end
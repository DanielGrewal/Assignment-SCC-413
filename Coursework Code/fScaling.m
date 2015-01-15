function [xdata] = fScaling(x)
 % function for feature scaling 
 
 mean = sum(x) / length(x); % first find the mean of the data
 s = std(x);
 
 xdata = (x - mean) / s;


end
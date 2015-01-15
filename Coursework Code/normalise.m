function [ xnorm ] = normalise(x)

    % Find the minimum and maximum values
    xmin = min(x(:));
    xmax = max(x(:));
    
    if(abs(xmax) >= abs(xmin))
        
        maxa = abs(xmax);
        
    else
        
        maxa = abs(xmin);
        
    end
        
        xnorm = x / maxa;

end
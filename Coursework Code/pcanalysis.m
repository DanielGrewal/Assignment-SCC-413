function [ xdata ] = pcanalysis(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author = Daniel Grewal
% contact email - d.grewal187@icloud.com
% PCA Algorithm which works with 2-d data sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if data are of different scales, must perform feature scaling function
% define rows and columns
rows = @(x) size(x,1);
cols = @(x) size(x,2);

% principal component analysis for 2-d vector
if cols(x) == 2
    % perform mean normalisation
    mean1 = sum(x(:,1)) / length(x(:,1));
    mean2 = sum(x(:,2)) / length(x(:,2));
    mean_norm1 = x(:,1) - mean1;
    mean_norm2 = x(:,2) - mean2;
    % store mean values in vector
    mean_norm_x = [mean_norm1, mean_norm2];
    % get covariance matrix
    sigma = cov(mean_norm_x);
    % use eigenvalues from U matrix
    [U,S,V] = svd(sigma);
    % take first k values and form new matrix, perform z = u' * x
    p1a = U(1,1);
    p1b = U(1,2);
    p_p1a = p1a * x(:,1);
    p_p1b = p1b * x(:,2);
    pca_1 = p_p1a + p_p1b;
    p2a = U(2,1);
    p2b = U(2,2);
    p_p2a = p2a * x(:,1);
    p_p2b = p2b * x(:,2);
    pca_2 = p_p2a + p_p2b;
    % principal componenets stored in new variable
    xdata = [pca_1,pca_2];

end

    a = 20;
    c = linspace(1,30,length(x));
    scatter(xdata(:,1),xdata(:,2),a,c, 'filled');

end
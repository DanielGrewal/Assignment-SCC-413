% relationship between caller and receiver and duration
x = calls_dataset(:,{'Caller', 'Receiver','DurationMins','ToD','Days','Sex','Age','Ethnic','Country','Occupation','Lat','Long','Distance'}); % create subset of data with important variables
statarray2 = grpstats(x,{'Caller'},{'mean','sum'});
% plot statarray2
figure();
hold on;
scatter(statarray2.Caller, statarray2.sum_DurationMins,[],statarray2.mean_Sex,'+');
hold off;

%-------------------------------------------------------------------------------------------------
% perform pca on data 
%-------------------------------------------------------------------------------------------------
% create new arrays for receiver and caller and their sum of duration in
% mins
statarray2_2 = [statarray2.Caller,statarray2.mean_Sex,statarray2.sum_DurationMins,statarray2.min_DurationMins,statarray2.max_DurationMins,statarray2.mean_DurationMins];

% create boxplots for each variable
figure();
statvbls2 = {'Caller', 'Sex','Sum Duration in mins', 'Min Dur', 'Max Dur', 'Mean Dur'};
boxplot(statarray2_2,'orientation','horizontal','labels',statvbls2);

% perform pairwise correlation
pairwise_cor = corr(statarray2_2,statarray2_2);

% perform feature scaling as variables measured in different units
scaled_caller = fScaling(statarray2_2(:,1));
scaled_receiver = fScaling(statarray2_2(:,2));
scaled_sex = fScaling(statarray2_2(:,3));
scaled_duration = fScaling(statarray2_2(:,4));
scaled_tod = fScaling(statarray2_2(:,5));

% create new arrays for scaled data
statarray2_3 = [scaled_caller,scaled_receiver,scaled_sex,scaled_duration,scaled_tod];

% plot scaled features statarray2
figure();
hold on;
scatter3(statarray2_3(:,1),statarray2_3(:,2),statarray2_3(:,3),[],statarray2.mean_Sex,'+');
hold off;

w = 1./var(statarray2_2);

[wcoeff,score,~,latent,explained] = pca(statarray2_2, 'VariableWeights',w);
coefforth = diag(sqrt(w))*wcoeff;
I = coefforth' * coefforth;

figure();
hold on;
title('PCA');
scatter(score(:,1),score(:,2),'+');
xlabel('1st Principal Component');
ylabel('2nd Principal Component');
grid on;
hold off;
figure();
hold on;
xlabel('Principal Component');
ylabel('Variance Explained');
pareto(explained);
hold off;
figure();
biplot(wcoeff(:,1:3), 'scores', score(:,1:3), 'VarLabels', {'Caller','Sex','Duration'});
statarray2_4 = [score(:,1), score(:,2),score(:,3)];

%-------------------------------------------------------------------------------------------------
% perform clustering analysis
%-------------------------------------------------------------------------------------------------
% k-means on data
k_means_(statarray2_4,5);
k_means_(statarray2_2,5);


% perform agglomerative clustering
%statarray2_5 = [normalise(statarray2_2(:,1)), normalise(statarray2_2(:,2)), normalise(statarray2_2(:,3)), normalise(statarray2_2(:,4)), normalise(statarray2_2(:,5))]; % normalise the data
statdist = pdist(statarray2_4); % compute similiarity 
statsquare = squareform(statdist);
statlink = linkage(statsquare); % uses proximity measures to determine how data is to be clustered
figure();
hold on;
title('Dendrogram of Clusters computed using Euclidean Distance');
[h,t] = dendrogram(statlink); % produce dendrogram
xlabel('Clusters');
ylabel('Distance');
hold off;
statc = cophenet(statlink, statdist); % correlation is high

statdist_2 = pdist(statarray2_4, 'mahalanobis');
statsquare_2 = squareform(statdist_2);
statlink_2 = linkage(statdist_2, 'average');
figure();
hold on;
title('Dendrogram of Clusters computed using Mahalanobis Distance');
[h2,t2] = dendrogram(statlink_2);
xlabel('Clusters');
ylabel('Distance');
hold off;
statc_2 = cophenet(statlink_2, statdist_2); % correlation is high

agg1 = clusterdata(statarray2_4,'maxclust',2);
agg2 = clusterdata(statarray2_4,'maxclust',3,'distance','mahalanobis');
agg3 = clusterdata(statarray2_4,'maxclust',2,'distance','mahalanobis');

figure();
hold on;
title('Agglomerative Clustering - Euclidean');
scatter3(statarray2_4(:,1),statarray2_4(:,2),statarray2_4(:,3), 100, agg1, 'filled');
xlabel('Time of Day');
ylabel('Duration in Mins');
hold off;

figure();
hold on;
title('Agglomerative Clustering - Mahalanobis - 3 Clusters');
scatter3(statarray2_4(:,1), statarray2_4(:,2),statarray2_4(:,3), 100, agg2, 'filled');
xlabel('Time of Day');
ylabel('Duration in Mins');
hold off;

figure();
hold on;
title('Agglomerative Clustering - Mahalanobis - 2 Clusters');
scatter3(statarray2_4(:,1), statarray2_4(:,2),statarray2_4(:,3), 100, agg3, 'filled');
xlabel('Time of Day');
ylabel('Duration in Mins');
hold off;

% perform gaussian mixed model clustering
options = statset('Display','final');
gm1 = fitgmdist(statarray2_4,2,'Options',options);
idx1 = cluster(gm1,statarray2_4);
cluster1 = (idx1 == 1);
cluster2 = (idx1 == 2);

figure();
hold on;
title('Gaussian Mixture Model');
scatter(statarray2_4(cluster1,1),statarray2_4(cluster1,2),30,'r+');
scatter(statarray2_4(cluster2,1),statarray2_4(cluster2,2),30,'bo');
xlabel('Time of Day');
ylabel('Duration in Mins');
legend('Cluster 1','Cluster 2','Location','NW')
hold off;

gm2 = fitgmdist(statarray2_4,3,'Options',options);
idx2 = cluster(gm2,statarray2_4);
cluster1 = (idx2 == 1);
cluster2 = (idx2 == 2);
cluster3 = (idx2 == 3);

figure();
hold on;
title('Gaussian Mixture Model');
scatter(statarray2_4(cluster1,1),statarray2_4(cluster1,2),30,'r+');
scatter(statarray2_4(cluster2,1),statarray2_4(cluster2,2),30,'bo');
scatter(statarray2_4(cluster3,1),statarray2_4(cluster3,2),30,'gd');
xlabel('Time of Day');
ylabel('Duration in Mins');
legend('Cluster 1','Cluster 2', 'Cluster 3','Location','NW')
hold off;

p1 = posterior(gm2, statarray2_4); % posterior prob for gm1

scatter(statarray2_4(cluster1,1),statarray2_4(cluster1,2),30,p1(cluster1,1),'+')
hold on
title('Posterior Probability');
xlabel('Time of Day');
ylabel('Duration in Mins');
scatter(statarray2_4(cluster2,1),statarray2_4(cluster2,2),30,p1(cluster2,1),'o')
scatter(statarray2_4(cluster3,1),statarray2_4(cluster3,2),30,p1(cluster3,1),'d')
hold off
legend('Cluster 1','Cluster 2', 'Cluster 3','Location','NW')
clrmap = jet(80); colormap(clrmap(9:72,:))
ylabel(colorbar,'Component 1 Posterior Probability')



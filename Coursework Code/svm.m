% svm classifier

%data_PF
%popular_f
A = data_PF;

% get size of data o = observations, f = features
[o f] = size(A);

% to summarise data, calculate mean and sd
PF_mean = mean(A);
PF_std = std(A);

% standardize the data
B = zscore(A);

% calculate pc
[coeff score latent] = princomp(B);

var_score = var(score);
cum_var_score = cumsum(var(score)) / sum(var(score));

% sort data into test and train
xtrain = score(1:143,1:7); % pca data -- also scaled retains 90% var
train_label = popular_f(:,1:143);
train_label = train_label';
train_label_int = grp2idx(train_label);
xtest = score(144:end,1:7);
test_label = popular_f(:,144:end);
test_label = test_label';
test_label_int = grp2idx(test_label);


fullData = score(:,1:7); 
labels = [train_label_int;test_label_int];
trainIndex = zeros(204,1); trainIndex(1:143) = 1;
testIndex = zeros(204,1); testIndex(144:end) = 1;
trainData = fullData(trainIndex == 1,:);
testData = fullData(testIndex == 1,:);
trainLabel = labels(trainIndex == 1,:);
testLabel = labels(testIndex == 1,:);


model = svmtrain(trainLabel, [(1:143)' trainData*trainData'], '-c 500 -g 0.06 -t 4 -b 1');
[predict_label, accuracy, prob_values] = svmpredict(testLabel, [(1:61)' testData*testData'], model, '-b 1');

trueClassIndex = zeros(204,1);
trueClassIndex(labels == 1) = 1;
trueClassIndex(labels == 2) = 2;

resultClassIndex = zeros(length(test_label_int),1);
resultClassIndex(test_label_int == 1) = 1;
resultClassIndex(test_label_int == 2) = 2;

% Reduce the dimension from 7D to 2D
distanceMatrix = pdist(fullData(:,1:7),'euclidean');
newCoor = mdscale(distanceMatrix,2);

% Plot the whole data set
x = newCoor(:,1);
y = newCoor(:,2);
patchSize = 30; %max(prob_values,[],2);
figure; scatter(x,y,patchSize, trueClassIndex,'filled');
title('whole data set');

% Plot the test data
x = newCoor(testIndex == 1,1);
y = newCoor(testIndex ==1,2);
patchSize = 80*max(prob_values,[],2);
figure; hold on;
colorTrueClass = trueClassIndex(testIndex == 1,:);
scatter(x,y,2*patchSize,colorTrueClass,'filled'); 
scatter(x,y,patchSize,resultClassIndex,'filled');
% Plot the training set
x = newCoor(trainIndex==1,1);
y = newCoor(trainIndex==1,2);
patchSize = 30;
colorTrueClass = trueClassIndex(trainIndex==1,:);
scatter(x,y,patchSize,colorTrueClass,'o');
title('classification results');

%% Importing Data
scoreddataCCFilteredtrainSetPositive = readtable('Data\scored_data_CC_Filtered_trainSet_Positive.csv');
scoreddataCCFilteredtrainSetNegative = readtable('Data\scored_data_CC_Filtered_trainSet_Negative.csv');
compositeatlas3Dbasedffalff = readtable('Data\composite_atlas3D_based_ffalff.csv');
connectivityData = readtable('Data\Greicius2D_FC_4Aaron.txt', 'Delimiter', '\t', 'ReadVariableNames', true);

%% Pre joining for maintaining order
combineDataJoined = innerjoin(compositeatlas3Dbasedffalff, scoreddataCCFilteredtrainSetNegative);
combineDataJoinedMatrix = table2array(combineDataJoined);

%% Dimension Reduction and combining back with ratings
numOfRedFeatures = 20;
featureMatrix = table2array(compositeatlas3Dbasedffalff);
[~,scores,latent,~,explained,~] = pca(combineDataJoinedMatrix(:, 2:235));
reducedFeatureMatrix=scores(:, 1:numOfRedFeatures);
%%
reducedFeatureMatrix = [combineDataJoinedMatrix(:, 1) reducedFeatureMatrix];
reducedFeatureMatrix = [reducedFeatureMatrix combineDataJoinedMatrix(:, end-1)];
ratings = reducedFeatureMatrix(:, end);

% plot(ratings, reducedFeatureMatrix, 'r^');
% xlabel('Observed Response');
% ylabel('Fitted Response');

%% model creation and prediction
tempData = reducedFeatureMatrix;
trainPartition = 0.8;
nTree = 50;
[m, n] = size(reducedFeatureMatrix);
trainSet = int32(m*trainPartition);
trainData = tempData(1:trainSet, :);
testData = tempData(trainSet+1:end, :);
testLabels = ratings(trainSet+1:end);
mdlTB = TreeBagger(nTree, trainData(:, 2:numOfRedFeatures+1),ratings(1:trainSet, :),'Method', 'regression');
YFit = mdlTB.predict(testData(:, 2:numOfRedFeatures+1));

%% Plotting data to check for model
figure('name','ffalff Negative Prediciton');
plot(ratings(trainSet+1:end),YFit,'r^');
%axis([-1.5 1.5 -1.5 1.5]);     %Uncomment for symmentric graph %comment out for actual one
xlabel('Observed Response');
ylabel('Fitted Response');

%% MSE calculation
MSE = immse(ratings(trainSet+1:end, :), YFit);

%%Correlation
predictedCorrelation = corrcoef(ratings(trainSet+1:end, :), YFit);

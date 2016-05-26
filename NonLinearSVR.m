%% Importing Data
scoreddataCCFilteredtrainSetPositive = readtable('Data\scored_data_CC_Filtered_trainSet_Positive.csv');
scoreddataCCFilteredtrainSetNegative = readtable('Data\scored_data_CC_Filtered_trainSet_Negative.csv');
compositeatlas3Dbasedffalff = readtable('Data\composite_atlas3D_based_ffalff.csv');
connectivityData = readtable('Data\Greicius2D_FC_4Aaron.txt', 'Delimiter', '\t', 'ReadVariableNames', true);

%% Pre joining for maintaining order
combineDataJoined = innerjoin(connectivityData, scoreddataCCFilteredtrainSetNegative);
combineDataJoinedMatrix = table2array(combineDataJoined);

%% Dimension Reduction and combining back with ratings
numOfRedFeatures = 20;
featureMatrix = table2array(connectivityData);
[~,scores,latent,~,explained,~] = pca(combineDataJoinedMatrix(:, 2:2927));
reducedFeatureMatrix=scores(:, 1:numOfRedFeatures);
reducedFeatureMatrix = [combineDataJoinedMatrix(:, 1) reducedFeatureMatrix];
reducedFeatureMatrix = [reducedFeatureMatrix combineDataJoinedMatrix(:, end-1)];
ratings = reducedFeatureMatrix(:, end);

%% Model Fitting and prediction
mdl = fitrsvm(reducedFeatureMatrix(:, 2:numOfRedFeatures+1),ratings,'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
YFit = predict(mdl, reducedFeatureMatrix(:, 2:numOfRedFeatures+1));

%% Plotting data to check for model
plot(ratings,YFit,'r^');
axis([-1.5 1.5 -1.5 1.5]);     %Uncomment for symmentric graph %comment out for actual one
xlabel('Observed Response');
ylabel('Fitted Response');

%% Predicting values {Testing phase}
YFit = predict(mdl, reducedFeatureMatrix(:, 2:numOfRedFeatures+1));
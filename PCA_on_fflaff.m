%% Get roi_data matrix
iFile = fopen ('composite_atlas3D_based_ffalff.csv');
%paramIds = textscan (iFile, '%s', 1, 'Headers', 0);
inputMatrix = csvread ('composite_atlas3D_based_ffalff.csv', 1);
%% Get mood ratings
moodRatings = csvread ('scored_data_CC_Filtered_trainSet_Positive.csv');
%%
pcaMatrix = pca(inputMatrix);
%%
disp(pcaMatrix);
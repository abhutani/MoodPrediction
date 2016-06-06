%%PCA and selection done

combinedDataMatrix = table2array(combinedDataJoined);
[loadings, scores, var]=pca(combinedDataMatrix(:, 2:235));
chosenCompSignal = scores(:,1:10);

[n,p] = size(combinedDataMatrix(:, 2:235));

%%Ratings variable defined
ratings = combinedDataMatrix(:,236);

%% Working on selected signals
%[trainInd,valInd] = dividerand(,0.99,0.01);
betaPCR = regress(ratings-mean(ratings), chosenCompSignal);
% betaPCR = loadings(:,1:17)*betaPCR;
% betaPCR = [mean(ratings) - mean(combinedDataMatrix(:, 2:235))*betaPCR; betaPCR];
% yfitPCR = [ones(n,1) combinedDataMatrix(:, 2:235)]*betaPCR;

plot(ratings,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
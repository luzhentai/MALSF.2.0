clear, clc, close all
addpath('NIfTI')
data = [1002 1003 1004 1005 1006 1012 1013,...
    1017 1023 1025 1101 1104 1116 1119 1128];

SelectNum = 50;
lambda1 = 1*10^(-4);
lambda2 = 1*lambda1;
nu = 0.01;        % coefficient of the length term
gama = 0.1;       % atlas weight
mu = 0.1;         % coefficient of distance regularization term P(\phi)
epsilon = 0.1;      % papramater of smoothed Dirac function
timestep = 1;
sigma = 1;
r = 10; % ROI: 5 -> 15
numIter = 10;

Result_dir = 'results/';
LabelDir = 'data/';
Result_Name = 'AMR_LW_SkullStripped';

str = {'RightAccumbens',  'LeftAccumbens',...
    'RightAmygdala',   'LeftAmygdala',...
    'RightCaudate',    'LeftCaudate',...
    'RightHippocampus','LeftHippocampus',...
    'RightPallidum',   'LeftPallidum', ...
    'RightPutamen',    'LeftPutamen',...
    'RightThalamus',   'LeftThalamus'};

% str = {'RightCaudate'};

% % % % % % 1. level set segmentation  % % % % % %

for j = 1 : length(data)
    fnames = data(j);
    
    for i = 1:length(str)
        ROI = str{i};
        
        main(ROI, fnames, SelectNum, lambda1, lambda2,...
            nu, gama, mu, sigma,epsilon, timestep, r, numIter)
    end
    
end

% % % % % 2 Dice % % % % % %
for i = 1:length(str)
    ROI = str{i};
    Comput_Dice(Result_dir,LabelDir,Result_Name, ROI, SelectNum);
end

% % % % % 3 Hausdorff % % % % % %
for i = 1:length(str)
    ROI = str{i};
    Comput_Hausdorff(Result_dir,LabelDir,Result_Name, ROI, SelectNum)
end

% % % % % 4 Boxplot % % % % % 
showreDice
showreHausdorff

% % % % % 5 Compare five other method % % % % % 
for i = 1:length(str)
    ROI = str{i};
    Compare_Dice(ROI)
end

for i = 1:length(str)
    ROI = str{i};
    Compare_Hausdorff(ROI)
end


% function Compare_Dice(ROI)
% ROI = 'LeftThalamus';
DiceDir = 'K:\LevelSetFusion.1.0\results\';

% 1. STAPLE
DiceName = 'STAPLE';
prior_flag = 1;
cf = 1;
load( strcat(DiceDir,DiceName,'_prior',num2str(prior_flag),'_cf',num2str(cf),'_', ROI));    

% 2. SpatialSTAPLE
DiceName = 'SpatialSTAPLE';
flag = 1;
interp = 1;
cf = 1;
load( strcat(DiceDir,DiceName,'_cf',num2str(cf),'_interp',num2str(interp), '_', ROI));

% 3. SIMPL
DiceName = 'SIMPL';
Metric = 0;
load( strcat(DiceDir,DiceName,'_Metric',num2str(Metric),'_', ROI))

% 4. MajorVoting
DiceName = 'Dice_MajorVoting';
load( strcat(DiceDir,DiceName, '_', ROI))

% 5. WeightVoting
DiceName = 'Dice_GWV';
load( strcat(DiceDir,DiceName, '_', ROI))


% 6. LBF
DiceName = 'AMR';
SN = 50;
load( strcat(DiceDir,'Dice_', DiceName, '_LW_SkullStripped_', ROI, '_SN_', num2str(SN) ) );

data = [STAPLE_SI', SpatialSTAPLE_SI', MV_SI', GWV_SI', SIMPL_SI', LBF'];
 
 
    
hc = figure, 
h = boxplot(data); 

grid on;
set(h, 'LineWidth', 2);
set(gcf,'color','w');

ylim([0.5 0.948])

set(findall(gca, 'type', 'text'), 'visible', 'off')

s = 14;
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'FontSize',s)

set(findall(gcf, 'Type', 'axes'),'FontSize',s)
Y = 0.52;

name = {'STAPLE', 'SpatialSTAPLE','MajorVoting',...
        'WeightVoting', 'SIMPL', 'Our'};

t = 30;
for i = 1 : length(name)
    text(i-0.4,  Y,  name(i) ,'FontSize',s, 'rotation', t);
end

title(ROI)

function Compare_Hausdorff(ROI)

% 1. STAPLE
Hausdorff_Name = 'Hausdorff_STAPLE';
prior_flag = 1;
cf = 1;
load( strcat( Hausdorff_Name,'_prior',num2str(prior_flag),'_cf',num2str(cf),'_', ROI));    

% 2. SpatialSTAPLE
Hausdorff_Name = 'Hausdorff_SpatialSTAPLE';
flag = 1;
interp = 1;
cf = 0;
load( strcat( Hausdorff_Name,'_cf',num2str(cf),'_interp',num2str(interp), '_', ROI));

% 3. SIMPL
Hausdorff_Name = 'Hausdorff_SIMPL';
Metric = 0;
load( strcat(Hausdorff_Name,'_Metric',num2str(Metric),'_', ROI))

% % 4. MajorVoting
Hausdorff_Name = 'Hausdorff_MajorVoting';
load( strcat(Hausdorff_Name, '_', ROI))

% % 5. WeightVoting
Hausdorff_Name = 'Hausdorff_GWV';
load( strcat('Hausdorff_GWV_', ROI))


% 6. LBF
Hausdorff_Name = 'AMR';
SN = 50;
load( strcat( 'Hausdorff_', Hausdorff_Name, '_LW_SkullStripped_', ROI, '_SN_', num2str(SN) ) );

data = [STAPLE_HD', SpatialSTAPLE_HD', MV_HD', GWV_HD', SIMPL_HD', LBF'];
 
hc = figure, h = boxplot(data); 

grid on;
set(h, 'LineWidth', 2);
set(gcf,'color','w');

ylim([0.2 12])
Y = 0.4;

set(findall(gca, 'type', 'text'), 'visible', 'off')


s = 14;
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'FontSize',s)


set(findall(gcf, 'Type', 'axes'),'FontSize',s)

name = {'STAPLE', 'SpatialSTAPLE', 'MajorVoting',...
        'WeightVoting', 'SIMPL', 'Our'};

t = 30;
for i = 1 : length(name)
    text(i-0.3,  Y,  name(i) ,'FontSize',s, 'rotation', t);
end
title(ROI)
    

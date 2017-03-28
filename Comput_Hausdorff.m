function Comput_Hausdorff(Result_dir,LabelDir,Result_Name, ROI, SelectNum)

LV = LabelValue(ROI);

data = [1002 1003 1004 1005 1006 1012 1013,...
    1017 1023 1025 1101 1104 1116 1119 1128];


for ii = 1 : length(data)
    fnames = data(ii);
    %  'u', 'BrainIm', 
    % ROI region: 'Tx', 'Ty', 'Tz', 
    % Brain region: 'Bx', 'By', 'Bz'
    load(strcat( Result_dir, Result_Name, '_', ROI, '_SN_', num2str(SelectNum), '_', num2str(fnames) ))
    % 2ANTS_6DRAMMS_LW_SkullStripped
    L = load_untouch_nii_gz( strcat(LabelDir,num2str(fnames), '_3_glm.nii.gz') );
    
    L = L.img;
    L = L(Bx, By, Bz);
    L = L(Tx, Ty, Tz);
    ground = (L == LV);
    levelset = u<= 0;
    LBF(ii) = Hausdorff(ground, levelset);
end

% All Multi Regist Global Weight
save( strcat('Hausdorff_', Result_Name, '_', ROI, '_SN_',  num2str(SelectNum)) ,  'LBF')
% figure, boxplot(LBF'); grid on

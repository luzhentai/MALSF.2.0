clear, clc
str = {'RightAccumbens',  'LeftAccumbens',...
    'RightAmygdala',   'LeftAmygdala',...
    'RightCaudate',    'LeftCaudate',...
    'RightHippocampus','LeftHippocampus',...
    'RightPallidum',   'LeftPallidum', ...
    'RightPutamen',    'LeftPutamen',...
    'RightThalamus',   'LeftThalamus'};

HausdorffName = 'AMR';

for SN = 50
    for i = 1:length(str)
        HausdorffI = str{i};
        
        load( strcat('Hausdorff_', HausdorffName, '_LW_SkullStripped_', HausdorffI, '_SN_', num2str(SN) ) );
        
        data(:, i) = LBF';
        
        Med(i) = median(LBF);
        
    end
    
    
    figure, boxplot(data); grid on;
    
    
    Ave = mean(mean( data ));
    AllMed = median(data(:));
    
    ylim([0 11])
    Y = 0.12;
    name = {'L-Accumbens', 'R-Accumbens', 'L-Amygdala',   'R-Amygdala',...
        'L-Caudate',   'R-Caudate',   'L-Hippocampus','R-Hippocampus',...
        'L-Pallidum',  'R-Pallidum',  'L-Putamen',    'R-Putamen',...
        'L-Thalamus',  'R-Thalamus'};
    s = 16;
    t = 50;
    for i = 1 : length(name)
        text(i-0.6,  Y,  name(i) ,'FontSize',s, 'rotation', t);
        text(i-0.3,   Med(i)+0.004,   num2str( Med(i) ) );
    end
    
    title(['Hausdorff SN=', num2str(SN), ' Ave = ', num2str(Ave), ...
        ' Median = ', num2str(AllMed)])
end


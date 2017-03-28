function main(ROI, fnames, SelectNum, lambda1, lambda2,...
    nu, gama, mu, sigma,epsilon, timestep, r, numIter)

LV = LabelValue(ROI);
load( strcat('data/', ROI, 'Atlas', num2str(fnames)) )
load( strcat('data/DRAMMS_2012_cbp_N4_SkullStripped_',  num2str(fnames)) )
load( strcat('data/ANTS_2012_cbp_N4_SkullStripped_', num2str(fnames)) )
%  ANTS BrainIm Bx By Bz
load( strcat('data/LNCC_2012_f7', '_', ROI, '_', num2str(fnames)) )

[Ix, Iy, Iz] = size(BrainIm);

Tx = max(1,Tx(1)-r) : min(Ix, Tx(end)+r);
Ty = max(1,Ty(1)-r) : min(Iy, Ty(end)+r);
Tz = max(1,Tz(1)-r) : min(Iz, Tz(end)+r);

Img = BrainIm(Tx, Ty, Tz); % ROI image will be  segmented 
[Ax, Ay, Az] = size(Img);
% figure, imshow(uint8( Img(:,:,10)' ))

AtlasPhi = zeros(Ax, Ay, Az, length(ANTS)+length(DRAMMS) );
for i = 1 : length(ANTS)
    A = ANTS{i};
    A = A(Tx, Ty, Tz);
    A0 = (A==LV);
    AtlasPhi(:, :, :, i) = initialPhi(A0);
end

for i = 1 : length(DRAMMS)
    B = DRAMMS{i};
    B = B(Tx, Ty, Tz);
    B0 = (B==LV); 
    AtlasPhi(:, :, :, i+length(ANTS)) = initialPhi(B0);
end
% contourshowROI(Img, B0)

phi = AtlasPhi(:, :, :, 1);
% figure, surf(phi(:, :, 20))
% reconstruction3D(phi, 'r')

LocalWeight =  zeros(Ax, Ay, Az, length(ANTS)+length(DRAMMS));
for i = 1 : size(LocalWeight,4)
    LocalWeight(:, :, :, i) = LNCC{i};
end

LocalWeightAtlasPhi = LocalWeightFun_Rank(AtlasPhi, LocalWeight, SelectNum);

MeanPhi = sum(LocalWeightAtlasPhi, 4) ;
% reconstruction3D(MeanPhi, 'r')
% for i = 1: size(MeanPhi, 3)
%     figure, surf( MeanPhi(:, :, 20) )
%     view([90 0])
% end
% close all

Ksigma = gaussMask(sigma, 3);
ONE = ones(size(Img));
KONE = convn(ONE, Ksigma, 'same');
KI = convn(Img, Ksigma, 'same');

for n =1:20
    phi = EVOL_LBF3D(phi, MeanPhi, gama, Img, Ksigma,KI, KONE, nu, timestep, mu, lambda1, lambda2, epsilon, numIter);
end
u = phi;
% [max(u(:)), min(u(:))]

save(strcat('results/AMR_LW_SkullStripped_', ROI, '_SN_', num2str(SelectNum), '_', num2str(fnames) ), 'u', 'Tx', 'Ty', 'Tz')

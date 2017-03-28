function u = EVOL_LBF3D(initFunc,Aphi,w,Img,Ksigma,KI,KONE,nu,timestep,mu,lambda1,lambda2,epsilon,numIter)
%  EVOL_LBF(initFunc,Img,Ksigma,KI,KONE,nu,timestep,mu,lambda1,lambda2,epsilon,numIter)
% Copyright (c) 2004--2007 by Chunming Li
% Author: Chunming Li
% Revision by Chunming Li 8/24/2005

u = initFunc;
for k1=1:numIter
    u = NeumannBound3D(u);
    K = curvature_central_3d(u);    % div()  
    HeavU = Heaviside(u,epsilon);
    DiracU = Dirac(u,epsilon);
    
    [f1, f2] = LBF_LocalBinaryFit(Ksigma,Img,KI,KONE,HeavU);
    LBF = LBF_dataForce(Img,Ksigma,KONE,f1,f2,lambda1,lambda2);
    
    areaTerm = -DiracU.*LBF;
    penalizeTerm = mu*(4*del2(u)-K);
    lengthTerm = nu.*DiracU.*K;
    
    Atlas = u - Aphi;
    T = w*Atlas;      % Atlas

    u = u + timestep*(lengthTerm + penalizeTerm + areaTerm - 2*T);
end

% Make a function satisfy Neumann boundary condition
% function B = NeumannBound3D(A)
% [m,n,k] = size(A);
% if (m<3 | n<3| k<3) 
%     error('either the number of rows or columns is smaller than 3');
% end
% xi = 2:m-1;
% yi = 2:n-1;
% zi = 2:k-1;
% B = A;
% B([1 m],[1 n],[1 k]) = B([3 m-2],[3 n-2],[3 k-2]);  % mirror corners
% B([1 m],[1 n],zi) = B([3 m-2],[3 n-2],zi);          % mirror edges
% B([1 m],yi,[1 k]) = B([3 m-2],yi,[3 k-2]);          % mirror edges
% B([1 m],[1 n],zi) = B([3 m-2],[3 n-2],zi);          % mirror edges
% B([1 m],yi,zi) = B([3 m-2],yi,zi);          % mirror surfaces
% B(xi,[1 n],zi) = B(xi,[3 n-2],zi);          % mirror surfaces
% B(xi,yi,[1 k]) = B(xi,yi,[3 k-2]);          % mirror surfaces

function g = NeumannBound3D(f)
% Make a function satisfy Neumann boundary condition
[nnx,nny,nnz] = size(f);
g = f;
g([1 nnx],[1 nny],[1 nnz]) = g([3 nnx-2],[3 nny-2],[3 nnz-2]);
g([1 nnx],2:end-1,[1 nnz]) = g([3 nnx-2],2:end-1,[1 nnz]);
g(2:end-1,[1 nny],[1 nnz]) = g(2:end-1,[3 nny-2],[1 nnz]);
g([1 nnx],[1 nny],2:end-1) = g([1 nnx],[3 nny-2],2:end-1);


g(2:end-1,2:end-1,[1 nnz]) = g(2:end-1,2:end-1,[3 nnz-2]);
% % x==1 & x==nnx;
g([1 nnx],2:end-1,2:end-1) = g([3,end-2],2:end-1,2:end-1);
% % y==a & y==nny;
g(2:end-1,[1 nny],2:end-1) = g(2:end-1,[3 nny-2],2:end-1); 

function K = curvature_central_3d(u);

[bdx,bdy,bdz]=gradient(u);
mag_bg=sqrt(bdx.^2+bdy.^2+bdz.^2)+1e-10;

nx=bdx./mag_bg;
ny=bdy./mag_bg;
nz=bdz./mag_bg;

[nxx,nxy,nxz]=gradient(nx);
[nyx,nyy,nyz]=gradient(ny);
[nzx,nzy,nzz]=gradient(nz);

K=nxx+nyy+nzz;


function [f1,f2] = LBF_LocalBinaryFit(K,Img,KI,KONE,H)
% fast algorithm
I=Img.*H;
c1=convn(H,K,'same');
c2=convn(I,K,'same');
f1=c2./(c1);
f2=(KI-c2)./(KONE-c1);

function h = Heaviside(x,epsilon)     % function (11)
h=0.5*(1+(2/pi)*atan(x./epsilon));

function f = Dirac(x, epsilon)    % function (12)
f=(epsilon/pi)./(epsilon^2.+x.^2);

function f = LBF_dataForce(Img,K,KONE,f1,f2,lamda1,lamda2)
s1=lamda1.*f1.^2-lamda2.*f2.^2;
s2=lamda1.*f1-lamda2.*f2;
f=(lamda1-lamda2)*KONE.*Img.*Img+convn(s1,K,'same')-2.*Img.*convn(s2,K,'same');


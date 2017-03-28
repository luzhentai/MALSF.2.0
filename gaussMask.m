function g = gaussMask(sig, dim)  
% Generate 2D or 3D Gaussian mask as convolution kernel
% input: 
%       p = [p1 p2 p3] specify the size of the mask
%       sig is the std of Gaussian kernel
% Copyright (c) 2004--2007 by Chunming Li
% Author: Chunming Li, 10/15/2004

r=2*ceil(2*sig)+1;
p=r*ones(1,dim);

siz   = (p-1)/2;
std   = sig;

if length(p)==3    
    [x,y,z] = meshgrid(-siz(2):siz(2),-siz(1):siz(1),-siz(3):siz(3));
    arg   = -(x.*x + y.*y+z.*z)/(2*std*std);
    h     = exp(arg);
    h(h<eps*max(h(:))) = 0;    
    sumh = sum(h(:));
    if sumh ~= 0,
        g  = h/sumh;
    end
elseif length(p)==2    
    [x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
    arg   = -(x.*x + y.*y)/(2*std*std);    
    h     = exp(arg);
    h(h<eps*max(h(:))) = 0;    
    sumh = sum(h(:));
    if sumh ~= 0,
        g  = h/sumh;
    end    
end
function S = si(x, y)

a = sum(sum(sum(x)));
b = sum(sum(sum(y)));
S = 2*sum(sum(sum(x.*y)))/(a+b);
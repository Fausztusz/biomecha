function [M, x, y] = Max(I)
[M,Ind] = max(I(:));
[x, y] = ind2sub(size(I),Ind);
end
function Neighbours = GenerateNeighbours(mx, my, p)
global I;
global BasePoints;
global n;
global k;
    neighs = NeighbourKoords(mx, my);
    nsize = size(neighs);
    if nsize(2) > 0
        for i = 1:nsize(2)
            if I(neighs(1,i), neighs(2,i))>0
               BasePoints(n) = struct('ID', n, 'koords', [neighs(1,i) neighs(2,i)], 'neighbours', p, 'Line', k);
               BasePoints(p).neighbours = [BasePoints(p).neighbours, n];
               n = n+1;
               GenerateNeighbours(neighs(1,i), neighs(2,i), n-1);
            end
        end
    end
end
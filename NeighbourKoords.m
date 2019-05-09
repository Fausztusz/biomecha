function NK = NeighbourKoords(x, y)
global A;
global I;
nx = [];
ny = [];
h = I(x, y);
if h > 0
    for i = 1-h:h-1
        for j = 1-h:h-1
            I(x+i,y+j)=0;
        end
    end
    v = zeros(1, 8*h+2);
    dx = [-h:h, h+zeros(1, 2*h-1), h:-1:-h, -h+zeros(1, 2*h-1)];
    dy = [h+zeros(1, 2*h+1), h-1:-1:1-h, -h+zeros(1, 2*h+1), 1-h:h-1];
    for i = 1:8*h
       v(i+1)=I(x+dx(i), y+dy(i));
    end
    v(1)=v(8*h+1);
    v(8*h+2)=v(2);
    [pks, ind] = findpeaks(v);
    sortrows([pks; ind].',1).';
    for i=1:length(pks)
        if v(ind(i)-1)>0 && v(ind(i)+1)>0 && v(ind(i))>A*h
            nx = [nx, x+dx(ind(i)-1)];
            ny = [ny, y+dy(ind(i)-1)];
        end
    end
end
NK = [nx; ny];
end
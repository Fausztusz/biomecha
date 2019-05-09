clear all;
%% ----------Paraméterek----------
global A;
A = 0.6;
global B;
B = 0.2;
%% ----------Kép importálása----------
I0 = imread('input.png');
figure(2);
imshow(I0);
%imfinfo('input.png');
global I;
I = double(I0(:,:,1));
I(1,:)=0;
I(end,:)=0;
I(:,1)=0;
I(:,end)=0;
[sx, sy]=size(I);
M = max(max(I));
figure(1);
clf;
hold on;
%% ----------Domborzat kialakítáa----------
i=1;
while M == 255
    for ix=2:sx-1
        for iy=2:sy-1
            if (I(ix,iy) == 255 && ( I(ix-1,iy) == i-1 || I(ix+1,iy) == i-1 || I(ix,iy-1) == i-1 || I(ix,iy+1) == i-1 ))
                I(ix,iy)=i;
            end
        end
    end
    M = max(max(I));
    i=i+1;
    %pause(0.1);
    imshow(10.*uint8(I));
end
%----------Bázispontok generálása----------
[M, mx, my]= Max(I);
m = B*M;
global BasePoints;
BasePoints = struct('ID',{},'koords',{}, 'neighbours',{}, 'Line', {});
global n; %number of points
n = 1;
global k; % number of lines
k = 1;
while M >= m
    BasePoints(n) = struct('ID', n, 'koords', [mx my], 'neighbours', [], 'Line', k );
    n = n+1;
    GenerateNeighbours(mx, my, n-1);
    [M, mx, my]= Max(I);
    k = k+1;
    for i = 1:length(BasePoints)
        hold on;
        plot(BasePoints(i).koords(2), BasePoints(i).koords(1), '+r');
    end
    %pause(0.1);
end
%% ----------Görbék illesztése----------


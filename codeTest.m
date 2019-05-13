im = imread('input.png');
imsum = sum(im, 3); % sum all channels
h = fspecial('gaussian', 3);
im2 = imclose(imsum, ones(3)); % close
im2 = imfilter(im2, h); % smooth
% for each column, find regional max
mx = zeros(size(im2));
for c = 1:size(im2, 2)
    mx(:, c) = imregionalmax(im2(:, c));
end
% find connected components
ccomp = bwlabel(mx);
%imshow(ccomp);
%plot(ccomp);

p = vertcat(BasePoints.koords);

curves=cell(max(vertcat(BasePoints.Line)),1);

for point=BasePoints
    curves(point.Line, 1)= {[cell2mat(curves(point.Line, 1)) ;  [point.koords(1) point.koords(2)]]};
end

figure(5);
hold on;

 %%
 for i=1:length(curves)
      %curves{i,1}(length(curves(i)) ,1)= curves{i,1}(1,1);
      %curves{i,1}(length(curves(i)) ,2)= curves{i,1}(1,2);
      %a=fnplt(cscvn(cell2mat(curve)'),'r',1);
      %plot(a(1 , 1:end ),a(2 ,1:end));
      plt=getplot(curves(i));
      plot(plt(1 , 1:end ),plt(2 ,1:end))
 end

%yi=interp1(x,y,xi,'spline');plot(xi,yi)

function pltt=getplot(curve)
    pltt=fnplt(cscvn(cell2mat(curve)'));
end

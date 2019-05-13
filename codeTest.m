% im = imread('input.png');
% imsum = sum(im, 3); % sum all channels
% h = fspecial('gaussian', 3);
% im2 = imclose(imsum, ones(3)); % close
% im2 = imfilter(im2, h); % smooth
% % for each column, find regional max
% mx = zeros(size(im2));
% for c = 1:size(im2, 2)
%     mx(:, c) = imregionalmax(im2(:, c));
% end
% % find connected components
% ccomp = bwlabel(mx);
% %imshow(ccomp);
% %plot(ccomp);

curves=cell(max(vertcat(BasePoints.Line)),1);

for point=BasePoints
    curves(point.Line, 1)= {[cell2mat(curves(point.Line, 1)) ;  [point.koords(1) point.koords(2)]]};
end

figure(5);
hold on;
=======
 curves=cell(max(vertcat(BasePoints.Line)),1);
 
 i=1;
 lastinserted=1;    %The ID of the last inserted point
 lastline=1;        %The ID of the previous pont
 distThres=50;

 for point=BasePoints
        if lastline ~= point.Line && ~isempty(curves{lastline})
            lastinserted = i+1;
            lastline=BasePoints(i).Line;
        end
        
        if(ismember(lastinserted,BasePoints(i).neighbours))
            curves(point.Line, 1)= {[cell2mat(curves(point.Line, 1)) ;  [point.koords(1) point.koords(2)]]};
            lastinserted=i;
         end

     i=i+1;
 end
 
 for i=1:length(curves)
     if ~isempty(curves{i})
     if pdist( [ curves{i}(1,1:2) ; curves{i}(end,1:2)]) < distThres
         curves{i}=[cell2mat(curves(i)) ; curves{i}(1,1:2)];
     end
     end
 end
 
 hold on;
>>>>>>> ec460aa6c2b93501a3c305b3c82cae6db4f1ef8c

 for i=1:length(curves)
     if length(curves{i}) > 3
        plt=getplot(curves(i));
        plot(plt(1 , 1:end ),-plt(2 ,1:end))
     end
    
 end
 
function plt=getplot(curve)
    plt=fnplt(cscvn(cell2mat(curve)'));
end

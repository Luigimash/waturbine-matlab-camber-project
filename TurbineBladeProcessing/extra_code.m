% i=16;
% x = airfoilPoints{i}.x;
% y = airfoilPoints{i}.y;
% z = airfoilPoints{i}.z;
% figure(1);
% tempPara = (1:399).'; % generate values 0 to 399, just for adding some color
% scatter(x,y,[],tempPara,'fill');
% title('Original points plot');
% xlabel('meters'); 
% ylabel('meters');
% axis equal;
% axis square;

% maxDist = -10;
% for i = 1:length(x_dense)
%     distances = sqrt((x_dense - x_dense(i)).^2 + (y_dense - y_dense(i)).^2);
%     getBigDist = max(distances);
%     if getBigDist > maxDist
%         maxDist = getBigDist
%     end
% end
% maxDist
% 
% 
% number 11 doesn't have any point clouds for example

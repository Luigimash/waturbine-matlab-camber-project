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

% I got these alpha values by trial and error generating cross sections,
% plotting the alphaShape, seeing if it's good enough, adjusting if not,
% and then saving the alpha values here 
%SHAPE_ALPHAS = [0.1 0.1 0.02 0.02 0.02 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01];



% ----------
% The below code is used to export `offsetPointsDatabase` to txt files 
% newOffsetPointsDatabase = cell(1,20);
% NUM_OF_POINTS = 250;
% 
% for i=1:20
%     tempCell = zeros(NUM_OF_POINTS,3);
%     len = size(offsetPointsDatabase{1,i});
%     len=len(1);
%     stepSize = len/NUM_OF_POINTS;
%     for d=1:NUM_OF_POINTS
%         step = floor(d*stepSize);
%         tempCell(d,:) = offsetPointsDatabase{1,i}(step,:);
%         if d==NUM_OF_POINTS
%             tempCell(d,:) = offsetPointsDatabase{1,i}(1,:);
%         end
%     end
%     newOffsetPointsDatabase{1,i} = tempCell();
% end
% 
% for i=1:20 
% %     writematrix(offsetPointsDatabase{1,i}, sprintf('outputs/section_%d.txt',i));
%       writematrix(newOffsetPointsDatabase{1,i}, sprintf('smallerOutputs/section_%d.txt',i));
% end
% -----------------

% ----------
%The below code is used to export Camber_Out to txt files 

for i=1:20 
%     writematrix(offsetPointsDatabase{1,i}, sprintf('outputs/section_%d.txt',i));
      writematrix(Camber_Lines_Matrix{1,i}, sprintf('camberOut/section_%d.txt',i));
end
% ----------


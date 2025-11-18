% I'm pretty sure this is not fully functional and was mostly just a prototype. Feel free to disregard.

clear;
close all;
ingestVariables;
% I got these alpha values by trial and error generating cross sections,
% plotting the alphaShape, seeing if it's good enough, adjusting if not,
% and then saving the alpha values here
SHAPE_ALPHAS = [0.1 0.1 0.02 0.02 0.02 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01];
offsetPointsDatabase = cell(1,20);
%for i = 1:20
i=7;
    % First plot the original set of points to see what we're working with
    x = airfoilPoints{i}.x;
    y = airfoilPoints{i}.y;
    z = airfoilPoints{i}.z(1);
    
%     figure(2);
%     tempPara = (1:399).'; % generate values 0 to 399, just for adding some color
%     scatter(x,y,[],tempPara,'fill');
%     title(sprintf('Original points plot: cross section #%d',i));
%     xlabel('meters'); 
%     ylabel('meters');
%     daspect([1 1 1])


    % Interpolate border, making it have 2x as many points by interpolating
    t = 1:length(x);  % Original parameter
    t_fine = 1:0.5:length(x);  % Finer spacing
    x_dense = spline(t, x, t_fine);
    y_dense = spline(t, y, t_fine);
    
    OFFSET_DIST = 1.2*(10^-3) % Offset distance in millimeters, converted to m

    %offsetPoints = {};
    xOffset = zeros(length(x_dense),1);
    yOffset = zeros(length(y_dense),1);
    for f=1:length(x_dense)
        if f == length(x_dense) %last iteration
            normVector =10000 * [y_dense(f)-y_dense(1), x_dense(1)-x_dense(f)];
        else 
            normVector =10000 * [y_dense(f+1)-y_dense(f), x_dense(f+1)-x_dense(f)];
        end
        unitVector = normVector / sqrt((normVector(1)^2)+(normVector(2)^2)); %normalize to unit vector size
        offsetPoint = (unitVector * OFFSET_DIST) + [x_dense(f),y_dense(f)];
        xOffset(f) = offsetPoint(1);
        yOffset(f) = offsetPoint(2);
    end
    close all
    figure(1)
    hold on
    plot(x,y)
    plot(xOffset,yOffset)


    figure(2);
    plot(xOffset,yOffset);
    hold on
    plot(x,y)
    title(sprintf('Original points plot: cross section #%d',i));
    xlabel('meters'); 
    ylabel('meters');
    daspect([1 1 1])
%end
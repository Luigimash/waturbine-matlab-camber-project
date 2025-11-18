close all;
ingestVariables;
% I got these alpha values by trial and error generating cross sections,
% plotting the alphaShape, seeing if it's good enough, adjusting if not,
% and then saving the alpha values here
SHAPE_ALPHAS = [0.1 0.1 0.02 0.02 0.02 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01];
offsetPointsDatabase = cell(1,20);
%for i = 1:20
i=16;
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


    % Generate a point cloud inside the shape 
    shape = alphaShape(x,y);

    shape.Alpha = SHAPE_ALPHAS(i); 
    %plot(shape)

    % Define the point cloud
    [xmin, xmax] = bounds(x);
    [ymin, ymax] = bounds(y);
    spacing = 0.025*(10^-3); % 0.025mm spacing atm, can adjust lower for more accuracy
    [xmesh, ymesh] = meshgrid(xmin:spacing:xmax, ymin:spacing:ymax);
    clear xmin xmax ymin ymax;
    
    %Prune point cloud to only get values inside the shape
    in = inShape(shape, xmesh, ymesh);
    % Plot to verify point cloud is inside shape
%     figure (4);
%     title(sprintf('Point Cloud inside of Shape: cross section #%d',i'));
%     hold on;
%     scatter(xmesh(in),ymesh(in));
%     scatter(x,y,[],tempPara,'fill');
%     daspect([1 1 1])

    xmesh = xmesh(in); %simplify the variables
    ymesh = ymesh(in);
    
    clear in;


    % Interpolate border, making it have 5x as many points by interpolating
    t = 1:length(x);  % Original parameter
    t_fine = 1:0.1:length(x);  % Finer spacing
    x_dense = spline(t, x, t_fine);
    y_dense = spline(t, y, t_fine);

    radius = 1.2*(10^-3); % 5mm radius
    % Create a logical mask the same size as xmesh
    keep_mask = true(size(xmesh));
    
    for f = 1:length(x_dense)
        distances = sqrt((xmesh - x_dense(f)).^2 + (ymesh - y_dense(f)).^2);
        keep_mask = keep_mask & (distances > radius);
    end
    
    % After the loop, get the remaining points
    remaining_x = xmesh(keep_mask);
    remaining_y = ymesh(keep_mask);

    %Make new alphaShape with post-offset points
    offsetShape = alphaShape(remaining_x,remaining_y);
    
%     figure(6);
%     title(sprintf('Point cloud after offset: cross section #%d',i'));
%     xlabel('meters'); 
%     ylabel('meters');
%     hold on;
%     plot(x_dense,y_dense);
%     plot(offsetShape);
%     daspect([1 1 1])

    % Preserve only the boundary
    [~,offsetPoints] = boundaryFacets(offsetShape);

%     figure(7);
%     title(sprintf('Final boundary: cross section #%d',i));
%     xlabel('meters'); 
%     ylabel('meters');
%     hold on;
%     plot(offsetPoints(:,1),offsetPoints(:,2));
%     plot(x,y);
%     daspect([1 1 1]) 
    offsetPoints(:,3) = z; %add Z dimension for solidworks
    offsetPointsDatabase{1,i} = offsetPoints;

    %plotting for sanity
    figure(i);
    title(sprintf('Final boundary: cross section #%d',i));
    xlabel('meters'); 
    ylabel('meters');
    hold on;
    plot(offsetPoints(:,1),offsetPoints(:,2));
    plot(x,y);
    daspect([1 1 1]) 

    clear bf distances f keep_mask offsetPoints offsetShape remaining_x
    clear remaining_y shape t t_fine x y z x_dense y_dense xmesh ymesh
%end


% -------------------
% After running `main.m`, you might watn to run the code in `extra_code.m`
% that is used to export the data in `offsetPointsDatabase` to text files
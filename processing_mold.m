close all;
ingestVariables;

colorMatrix = zeros(1,399);
sizeMatrix=zeros(1,399);
Camber_Lines_Matrix = cell(1,20);

%airfoil data is given as an array of 1:399 points, meaning the 
%midpoint is at 200 (200+199 = 399, 200-199 = 1)
FIRSTP = 1; % first point of the curve
MIDP = 200; %middle point of the curve 
LASTP = 399; %last point of the curve
%PTS_COUNTER_STATIC = 39; % at 399 points per curve, pts_counter at the end of running this program once will always be 39, putting it in this constant for reference

a_exportPoints = cell(1,20);
b_exportPoints = cell(1,20);
for i= 1:399
    colorMatrix(1,i) = 1;
    sizeMatrix(i) = 2;
end
% colorMatrix(1:3,1) = [0 0 1];
% colorMatrix(1:3,200) = [0 0 1];
colorMatrix(1,FIRSTP) = 5;
colorMatrix(1,100) = 10;
colorMatrix(1,300) = 10;
colorMatrix(1,MIDP) = 5;
sizeMatrix(FIRSTP) = 108;
sizeMatrix(MIDP) = 108;
for i = 1:20
%i=12;
    x = airfoilPoints{i}.x;
    y = airfoilPoints{i}.y;
    z = airfoilPoints{i}.z(1);
%     figure(i)
%     title(sprintf('Original points plot: cross section #%d',i));
%     scatter(x,y,sizeMatrix, colorMatrix);
%     daspect([1 1 1])
%     hold on
%     xPlot = [airfoilPoints{i}.x(FIRSTP), airfoilPoints{i}.x(MIDP)];
%     yPlot = [airfoilPoints{i}.y(FIRSTP), airfoilPoints{i}.y(MIDP)];
%     plot(xPlot,yPlot)
    
    airfoilInterpX = zeros(1,MIDP);
    airfoilInterpY = zeros(1,MIDP);
    for s=1:MIDP 
        MAXINDEX = LASTP+1;
        airfoilInterpX(1,s) = (airfoilPoints{i}.x(MAXINDEX-s) + airfoilPoints{i}.x(s))/2;
        airfoilInterpY(1,s) = (airfoilPoints{i}.y(MAXINDEX-s) + airfoilPoints{i}.y(s))/2;
    end
%      plot(airfoilInterpX, airfoilInterpY);

    % Convert the interpolated points into halves of the wing for export

    halfA = zeros(LASTP, 3);
    halfB = zeros(LASTP, 3);
    
    halfA(:,3) = z;
    halfB(:,3) = z;
    
%     % Setting first and last points to be the same 
%     halfA(1,1) = x(1);
%     halfA(1,2) = y(1);
%     halfA(LASTP,1) = x(1);
%     halfA(LASTP,2) = y(1);
% 
%     halfB(1,1) = x(1);
%     halfB(1,2) = y(1);
%     halfB(LASTP,1) = x(1);
%     halfB(LASTP,2) = y(1);
    step_counter = 1;
    RES_STEPS = 6;
    pts_counter = 0;
    b_insertLastPoint=1;
    for s=1:LASTP
        MAXINDEX = LASTP+1;
        if s > MIDP
            if step_counter >= RES_STEPS
                pts_counter = pts_counter + 1;
                L = MIDP + pts_counter;
                halfA(L,1) = airfoilInterpX(1,MAXINDEX-s);
                halfB(L,1) = airfoilInterpX(1,MAXINDEX-s);
    
                halfA(L,2) = airfoilInterpY(1,MAXINDEX-s);
                halfB(L,2) = airfoilInterpY(1,MAXINDEX-s);
                step_counter = 0;
                if (MAXINDEX-s)==1
                    b_insertLastPoint=0;
                end
            end 
            step_counter = step_counter + 1;
        else
            halfA(s,1) = x(s);
            halfB(s,1) = x(MAXINDEX-s);

            halfA(s,2) = y(s);
            halfB(s,2) = y(MAXINDEX-s);
        end
    end
    if b_insertLastPoint==1
        pts_counter = pts_counter + 1;
        halfA((MIDP+pts_counter), 1) = x(1);
        halfB((MIDP+pts_counter), 1) = x(1);

        halfA((MIDP+pts_counter), 2) = y(1);
        halfA((MIDP+pts_counter), 2) = y(1);
    end

    % I know this isn't the most organized code, but this is grandfathered
    % in from the way I originally programmed it, so this is just how the
    % script is. Don't kill me. 
    % The above code generates halfA and halfB, which are point arrays that
    % splits the original airfoil cross section down its camber line, where
    % the camber line is generated using some point averages between
    % opposing points from the original air foil.
    % We're not actually going to use halfA or halfB for anything, but
    % since I already wrote the code to generate them, we're gonna leave
    % them there as grandfathered code. The camber line starts after point
    % MIDP and is pts_counter points long, despite halfA and halfB being
    % size LASTP (399). 

    % The below code extracts only the Camber line from halfA and halfB,
    % then extends along the slope of the end so that when imported into
    % solidworks we can have a smooth and ovrsized plane with which we
    % can split the airfoil blade mold. Use Solidwork's `Split` feature
    % to split the turbine blade model down the middle.

    % The final output will be the x,y,z point array Camber_Out. 
    % The points defining the cross section itself will be the x,y,z points
    % we imported at the beginnning of this script.

    arrayLen = 4+pts_counter;
    Camber_Out = zeros(arrayLen,3);
    % Set z values, which are constant
    Camber_Out(:,3) = z;
    L = pts_counter; %convenience for saving space in the code

    % Get the slope at both ends of the camber line
    % Note that the 200th point is the midpoint, and the MIDP+pts_counter
    % (234) point is a repeat of the very first x(1), y(1) point
    EXTRA_DIST = 15*(10^-3); % Extra point distance in mm

    slope_1 = [x(1)-Camber_Out((L-2),1), y(1)-Camber_Out((L-2),2)];
    slope_2 = [x(MIDP)-halfA((MIDP+2),1), y(MIDP)-halfA((MIDP+2),2)];
    %normalize the vectors to length 1
    lenSlope_1 = sqrt( (slope_1(1)^2)+(slope_1(2)^2) );
    lenSlope_2 = sqrt( (slope_2(1)^2)+(slope_2(2)^2) );
    slope_1 = slope_1 / lenSlope_1;
    slope_2 = slope_2 / lenSlope_2;
    %multiply them by length
    offset_1 = slope_1 * EXTRA_DIST;
    offset_2 = slope_1 * 2*EXTRA_DIST;
    offset_3 = slope_2 * 2*EXTRA_DIST;
    offset_4 = slope_2 * EXTRA_DIST;
    
    % Generating new points
    newpt_1 = [x(1)+offset_1(1),y(1)+offset_1(2)];
    newpt_2 = [x(1)+offset_2(1),y(1)+offset_2(2)];
    newpt_3 = [x(MIDP)+offset_3(1),y(MIDP)+offset_3(2)];
    newpt_4 = [x(MIDP)+offset_4(1),y(MIDP)+offset_4(2)];

    % Get final points list 
    Camber_Out(arrayLen-1,1) = newpt_1(1);
    Camber_Out(arrayLen-1,2) = newpt_1(2);
    Camber_Out(arrayLen,1)  = newpt_2(1);
    Camber_Out(arrayLen,2)  = newpt_2(2);

    Camber_Out(1,1)  = newpt_3(1);
    Camber_Out(1,2) = newpt_3(2);
    Camber_Out(2,1) = newpt_4(1);
    Camber_Out(2,2) = newpt_4(2);

    for s=3:(arrayLen-2)
        IND = (s-2) + MIDP; %current index
%        MAXIND = (arrayLen-4) + 1; %maximum array index

        Camber_Out(s,1) = halfA(IND,1);
        Camber_Out(s,2) = halfA(IND,2);
    end

    % PLOTTING
    figure(i)
    title(sprintf('Original points plot: cross section #%d',i));
    hold on

    % Plotting halfA and halfB
    %tempPara = (1:399).'; % generate values 0 to 399, just for adding some color
    %scatter(halfA(:,1),halfA(:,2), 3,tempPara);
    %scatter(halfB(:,1),halfB(:,2), 3,tempPara);

    plot(x,y,"r");

    tempPara = (1:arrayLen);
    %scatter(Camber_Out(:,1),Camber_Out(:,2), 3,tempPara);
    plot(Camber_Out(:,1),Camber_Out(:,2), "b");
    daspect([1 1 1])

    % Save Camber_Out in each iteration to a cell array,
    % Camber_Lines_Matrix
    Camber_Lines_Matrix{1,i} = Camber_Out;
end

    
% PLAN
% Smooth the Camber line bisecting the blade by reducing resolution until
% the anomaly disappears
% Extend the Camber line naturally by following the slope at its
% extremities, and adding another point like 1cm away or some shit
% Export ONLY the camber line data, and import it as additional curves into
% the solidworks part
% Use a boundary surface to connect the camber line splits to form a
% surface that follows the camber lines, effectively bisecting the blade
% Make a big block and have it cover the entirety of the blade, then use
% "cavity" in solidworks to get the negative of the entire blade inside
% the block
% Then, split the block in half by using the Boundary Surfaced camber line
% plane, which should get you a split in the correct way to ensure that the
% blocks have (no) overhangs (?)
% you can always use 3D sketches to edit the curves and add extra
% width/depth to the camber line plane, or just manually add points in
% matlab software 
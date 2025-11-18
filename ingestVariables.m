%AF1=readtable('Airfoil sections/airfoil1.txt');
%AF2=readtable('Airfoil sections/airfoil2.txt');
%AF3=readtable('Airfoil sections/airfoil3.txt');
%AF4=readtable('Airfoil sections/airfoil4.txt');
clear
airfoilPoints = cell(1,20);
for i = 1:20
    filename = fullfile('Airfoil sections', ['airfoil' num2str(i) '.txt']);
    tempReadTable = readtable(filename, ReadVariableNames=false);
    tempReadTable.Properties.VariableNames = ["x","y","z"];
    airfoilPoints{i} = tempReadTable;
end
clear tempReadTable varName i filename ans;

% Access the data from cross section "i" by using, for example,
% airfoilPoints{i}.x(5)
% or if you just want the entire array of x values,
% airfoilPoints{i}.x

% Run this file once to ingest all the data into matlab
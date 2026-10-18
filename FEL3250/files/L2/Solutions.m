%% Clear workspace
clear all
close all
clc

%% Figure properties
screenInfo = get(0, 'ScreenSize');
screenSize = screenInfo(3:4);
figureSize = [800, 600; 1400, 600]; % [normal, wide]'
figurePos = [([screenSize; screenSize] - figureSize)/2, figureSize];
figurePosW = figurePos(2, :);

set(0, 'DefaultFigurePos', figurePos(1, :));    % default: normal

%% Question #1
disp('Question #1')

A = [
     0    2     2  inf  inf;
    inf   0   inf   4    3;
    inf  inf   0   inf   1;
    inf  inf  inf   0   -3;
    inf  inf  inf  inf   0
    ];

[d, P] = fcn_SPA(A, 'Bellman', 'On');

fprintf('\n')

%% Question #2
disp('Question #2')

A = [
     0     2      8     inf   inf   inf;
    inf    0      5      3    inf   inf;
    inf    6      0     inf    0    inf;
    inf   inf     1      0     7     6;
    inf   inf    inf     4     0     2;
    inf   inf    inf    inf   inf    0
    ];

[d, P] = fcn_SPA(A, 'Dijsktra', 'On');

fprintf('\n')

%% Question #3
disp('Question #3')

A = [
     0    4    2   inf  inf;
    inf   0   inf   3   inf;
    inf   1    0   inf   1;
    inf  inf   3    0    6;
    inf  inf   2   inf   0
    ];

[d, P] = fcn_SPA(A, 'Bellman', 'On');

fprintf('\n')

%% Question #4
disp('Question #4')

A = [
     0     3     10    inf   inf   inf   inf;
    inf    0      4     7     1    inf   inf;
    inf   inf     0    -2    inf    7    inf;
    inf   inf    inf    0     2    -6    inf;
    inf   inf    inf   inf    0    inf   15;
    inf   inf    inf   inf    9     0     6;
    inf   inf    inf   inf   inf   inf    0
    ]

[d, P] = fcn_SPA(A, 'Bellman', 'On');

deltaVec = [0, 0, 3, 0, 0, -7, -2];

A_m = A;
for row = 1:length(A_m)
    for col = 1:length(A_m)
        if row ~= col
            A_m(row, col) = A(row, col) + deltaVec(row) - deltaVec(col);
        end
    end
end

A_m

[d, P] = fcn_SPA(A_m, 'Dijsktra', 'On');

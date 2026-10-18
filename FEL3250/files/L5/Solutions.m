%% Clear workspace
clear all
close all
clc

%% Figure properties
screenInfo = get(0, 'ScreenSize');
screenSize = screenInfo(3:4);
figureSize = [800, 600; 1400, 600]; % [normal, wide]'
figurePos = [([screenSize; screenSize]-figureSize)/2, figureSize];

figurePosW = figurePos(2, :);
set(0, 'DefaultFigurePos', figurePos(1,:));

%% Question #1
% (a)
A = [
    25, 86, 13, 12;
    43, 30, 74, 25;
    97, 26, 85, 22;
    26, 26, 26, 26
    ];

p = [24, 19, 39, 50];

N = length(A);
y = zeros(N);

for obj = 1:N
    curBen = A(:, obj);
    
    for per = 1:N
        ben = A(per, :) - p;
        maxBen = max([ben(1:obj-1), ben(obj+1:end)]);
        
        y(per, obj) = p(obj) + (ben(obj) - maxBen);
    end
end

y2 = y(:, 2)'

% (b)
z = sort(y2, 'ascend')

pNew = repmat(p, N+1, 1);
pNew(1:end-1, 2) = (z - 1)';
pNew(end, 2) = z(end) + 1;

noOfPref = zeros(1, N+1);

for k = 1:N+1
    prefCount = 0;
    for per = 1:N
        ben = A(per, :) - pNew(k, :);
        if max(ben) <= ben(2)
            prefCount = prefCount + 1;
        end
    end
    noOfPref(k) = prefCount;
end

noOfPref

% (c)
p2 = linspace(1.2*z(1), 1.2*z(end), 100);
d = zeros(1, length(p2));

for k = 1:length(d)
    if p2(k) <= z(1)
        d(k) = 1 - noOfPref(1);
    elseif p2(k) <= z(2)
        d(k) = 1 - noOfPref(2);
    elseif p2(k) <= z(3)
        d(k) = 1 - noOfPref(3);
    elseif p2(k) <= z(4)
        d(k) = 1 - noOfPref(4);
    else
        d(k) = 1 - noOfPref(5);
    end
end

figure
plot(p2, d)
xlabel('p_2 [-]')
ylabel('d(p_2) [-]')

% (d,e)
qBar = zeros(1, length(p2));

pBar = p;
pBar(2) = p2(1);

qBar(1) = sum(max(A - repmat(pBar, N, 1), [], 2)) + sum(pBar);
qBar(2:end) = d(2:end).*diff(p2);
qBar = cumsum(qBar);

figure
plot(p2, qBar)
xlabel('p_2 [-]')
ylabel('qBar(p_2) [-]')

% (f)
% a_12 - p_2 = 67, max(a_ik - p_k) = 67
% a_23 - p_3 = 35, max(a_ik - p_k) = 35
% a_31 - p_1 = 73, max(a_ik - p_k) = 73
%
% As can be seen, for all eps >= 0, the above equations are satisfied.

% (g)
epsilon = 10;
pMod = p;

matchings = [
    0 1 0 0;
    0 0 1 0;
    1 0 0 0;
    0 0 0 0
    ];

while sum(sum(matchings)) < N
    for per = 1:N
        if sum(matchings(per, :)) > 0
            
        else
            ben = A(per, :) - pMod;
            [benSorted, benInd] = sort(ben, 'descend');
            obj = benInd(1);
            
            pMod(obj) = pMod(obj) + benSorted(1) - benSorted(2) + epsilon;
            
            if isempty(find(matchings(:, obj) > 0, 1, 'first'))
                matchings(per, obj) = 1;
            else
                matchings(:, obj) = 0;
                matchings(per, obj) = 1;
            end
        end
    end
end

fAuction = sum(sum(A.*matchings))

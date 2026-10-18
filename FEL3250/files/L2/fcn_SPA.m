function [ d, P ] = fcn_SPA( A, method, verbose )
%FCN_SPA Shortest Path Algorithm
% A: Square matrix. It is the representation of a given graph, where A(i,j)
% corresponts to the arc length/cost leaving node i and arriving at node j.
% If there is no arc from node i to node j, simply set A(i,j) = inf.
%
% method: "Dijsktra" for label setting, or, "Bellman" for label correcting.
%
% verbose: "On" for printing out information, or, "Off" for suppressing it.
%
% d: Node labels obtained after successful termination.
%
% P: (One of) the shortest path(s) from node 1 to node N.

% Check for negative arc lengths/costs for "Dijkstra" method
if strcmp(method, 'Dijsktra') && sum(sum(A < 0)) > 0
    error(['Matrix ''A'' cannot have negative elements when using ', ...
        'Dijkstra''s method. Please modify your network accordingly.'])
end

if size(A, 1) ~= size(A, 2)
    error('Please define a square matrix, A, for the graph.')
end

% Initialize the algorithm
N = length(A);
d = inf*ones(1, N);
isInV = zeros(1, N);

V = 1;
d(1) = 0;
isInV(1) = 1;

iterCount = 1;

if strcmp(verbose, 'On')
    disp('Algorithm started...')
end

while ~isempty(V)
    %The Bellman-Ford Method: First-In-First-Out order
    curNode = V(1);
    curInd = 1;
    
    %Dijkstra Method: Taking out the minimum label
    if strcmp(method, 'Dijsktra')
        for k = 2:length(V)
            if d(V(k)) < d(curNode)
                curNode = V(k);
                curInd = k;
            end
        end
    end
    
    if strcmp(verbose, 'On')
        disp(['Iteration Count: ', num2str(iterCount)])
        disp(['--- Candidate List (V)   : ', num2str(V)])
        disp(['--- Node Labels (d)      : ', num2str(d)])
        disp(['--- Node out of V        : ', num2str(curNode)])
    end
    
    isInV(curNode) = 0;
    V = [V(1:curInd-1), V(curInd+1:end)];
    
    for k = 1:N
        if A(curNode, k) < inf && curNode ~= k
            if d(k) > d(curNode) + A(curNode, k)
                d(k) = d(curNode) + A(curNode, k);
                if isInV(k) == 0
                    V = cat(2, V, k);
                    isInV(k) = 1;
                end
            end
        end
    end
    
    iterCount = iterCount + 1;
end

P = N;
curNode = N;
while curNode > 1
    for prevNode = 1:N
        if prevNode ~= curNode && ...
                (A(prevNode, curNode) + d(prevNode) == d(curNode))
            curNode = prevNode;
            P = cat(2, curNode, P);
            break
        end
    end
end

if strcmp(verbose, 'On')
    disp(['Shortest Path: ', num2str(P)])
    disp('Algorithm finished!')
end

end

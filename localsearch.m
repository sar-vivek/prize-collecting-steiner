%% Performs first-improvement local search 
%%Neighborhood definition : X and nX are neighbors if they differ exactly in one node. 
%%G is edge-weight matrix 
%%Prize is an array denoting penalties (if we skip) or prize (if we visit) of nodes
%%Requires : compute_cost function : which constructs a tree spanning nodes in X and returns the cost of tree + penalties of not visited nodes.
%%Author: Vivek Sardeshmukh
function X = localsearch(G, Prize, X)

local_improvement = 1;
%_c_ is the cost of current solution 
c=compute_cost(G, Prize, X);
while(local_improvement)
    local_improvement=0 ;
    for i=1:length(G(1,:))
        %_i_ is not in X then _nX_ will consider _i_
        if (any(X==i))
            nX= setdiff(X, i);
        else
            nX= union(X, i);
        end
        nc=compute_cost(G,Prize, nX);
        if (nc < c)
            X = nX;
            c = nc;
            local_improvement=1;
            break;
            % first improvement found so stop and exit
        end
    end
end


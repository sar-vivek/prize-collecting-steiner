%% Performs first-improvement local search 
% Neighborhood definition : X and nX are neighbors if they differ exactly in one node. 
% G is edge-weight matrix 
% Prize is an array denoting penalties (if we skip) or prize (if we visit) of nodes
% Requires : ComputeScore function : which constructs a tree spanning nodes in X and returns the prizes of nodes visited - cost of t.
% stops on local maximum 
% Author: Vivek Sardeshmukh

function [X,c] = LocalSearch(X, c)
    global G r count lf;
    
    local_improvement = 1;
    %_c_ is the cost of current solution 
    while(local_improvement)
        local_improvement = 0 ;
        for i = 1:length(G)
            if(i == r)
                continue;
            elseif (any(X == i)) %_i_ is in X then _nX_ will not consider _i_
                nX = setdiff(X, i);
            else 
                nX = union(X, i);
            end
            nc = ComputeScore(nX);
            if (nc > c)
                X = nX;
                c = nc;
                local_improvement = 1;
                count = count + 1;
                fprintf(lf, 'Count is %d\n', count); 
                break;
                % first improvement found so stop and exit
            end
        end
    end
end

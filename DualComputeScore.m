%% Constructs a minimum weight tree which spans all the nodes in _X_ 
% if such tree doesnt exists (i.e. G[X] is not connected) then return -INF
% Returns the prizes of nodes that are in X - cost of the tree 
% Author : Vivek Sardeshmukh

function c = DualComputeScore(X)
    global G Prize;

    %g1 = G[X] graph induced by X

    G1 = zeros(length(G), length(G));

    %{
    % http://stackoverflow.com/questions/7685291/construct-a-minimum-spanning-tree-covering-a-specific-subset-of-the-vertices
    % I see many problems with this approach as well. It is same as asking is shortest path problem and MST are the same?
    % which are basically not
    % UPDATE : Bingo! This problem is NP-complete. I have a proof.
    % what next? - I am forcing X to be feasible only if induces a connected graph.
    % To see the implementation (of course which doesnt give optimal ans) of above idea see revision : b540f1082390 
    %}  

    %graph induced by X
    for i = 1 : length(G)
	for j = 1 : length(G)
	    if(any(X==i) && any(X==j) && G(i,j)~=-1)
		G1(i,j) = G(i,j);
	    end
	end
    end

    G1 = sparse(G1);
    [noC, comp] = graphconncomp(G1);
    %check all nodes in X belong to same component 
    xcomp = comp(X(1));
    noC = 1;
    for i = 2 : length(X)
        if (xcomp ~= comp(X(i)))
            noC = 2;
            break;
        else
            noC = 1;
        end
    end
    if (noC == 1) 
	[tree, pred] = graphminspantree(G1);
	cost_tree = sum(nonzeros(tree));
	penalti = 0;
	for i = 1:length(Prize)
	    if(any(X == i))
            continue;
        else
            penalti = penalti + Prize(i);
	    end
	end
	c = penalti + cost_tree;
    else 
	%if G1 is not connected X is not feasible!
	c = inf;
    end
end

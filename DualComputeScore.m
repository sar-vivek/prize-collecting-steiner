%% Constructs a minimum weight tree which spans all the nodes in _X_ 
% Returns the penalties of nodes that are not in X + cost of the tree 
% Author : Vivek Sardeshmukh

function dc = DualComputeScore(X)
 %calculate ST on X with root as root
    %graph induced by X
    global G Prize;
    for i = 1:length(G)
       for j = 1:length(G)
           if(any(X == i) && any(X == j))
               if(G(i,j) == -1)
                   G1(i,j) = 0;
               else
                   G1(i,j) = G(i,j);
               end
           else
               G1(i,j) = 0;
           end
       end
    end
    G1 = sparse(G1);
   %calculate mst on G1
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
   dc = penalti + cost_tree;
end

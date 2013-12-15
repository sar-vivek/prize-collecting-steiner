%% Constructs a minimum weight tree which spans all the nodes in _X_ 
% Returns the prizes of nodes that are in X - cost of the tree 
% Author : Vivek Sardeshmukh

function c = ComputeScore(X)
    %calculate ST on X with root as root
    %graph induced by X
    global G Prize;
    % this is wrong need to fix how G1 is constructed
    % http://stackoverflow.com/questions/7685291/construct-a-minimum-spanning-tree-covering-a-specific-subset-of-the-vertices

    Gc = G;
    G1 = zeros(length(G), length(G));
   
    for i = 1:length(Gc)
	for j = 1:length(Gc)
	    if(Gc(i,j) == -1)
		G1(i,j) = 0;
	    end
	end
    end

    for i = 1:length(Gc)
	for j = 1:length(Gc)
	    if(Gc(i,j) == -1)
		continue;
	    elseif ( any(X == i) && any(X == j) )
		G1(i, j) = Gc(i, j);	    
	    elseif ( any(X == i) )
		%remove j and updates its neigbhors weights
		for k = 1 : length(Gc)
		    if ( Gc(j, k) == -1 )
			continue;
		    else
			for l= 1 : length(Gc)
			    if ( l == k || Gc(l,j) == -1 )
				continue;
			    else
				if (Gc(l, k) == -1)
				    Gc(l, k) = Gc(l, j) + Gc(j, k);
				    Gc(k, l) = Gc(k, j) + Gc(j, l);
				elseif (Gc(l, k) > Gc(l, j) + Gc(j, k))
				    Gc(l, k) = Gc(l, j) + Gc(j, k);
				    Gc(k, l) = Gc(k, j) + Gc(j, l);
				end	    
				Gc(l, j) = -1;
				Gc(j, l) = -1;
			    end
			end
		    end
		    Gc(k, j) = -1;
		    Gc(j, k) = -1;
		end
	    elseif (any(X == j))
		for k = 1 : length(Gc)
		    if ( Gc(i, k) == -1 )
			continue;
		    else
			for l= 1 : length(Gc)
			    if ( l == k || Gc(l,i) == -1 )
				continue;
			    else
				if (Gc(l,k) == -1)
				    Gc(l, k) = Gc(l, i) + Gc(i, k);
				    Gc(k, l) = Gc(k, i) + Gc(i, l);

				elseif (Gc(l, k) > Gc(l, i) + Gc(i, k))
				    Gc(l, k) = Gc(l, i) + Gc(i, k);
				    Gc(k, l) = Gc(k, i) + Gc(i, l);
				end
				Gc(l, i) = -1;
				Gc(i, l) = -1;
			    end
			end
		    end
		    Gc(k, i) = -1;
		    Gc(i, k) = -1;
		end
	    end
	end
    end
    for i = 1:length(Gc)
	for j = 1:length(Gc)
	    if (Gc(i, j) == -1)
		continue;
	    else
		G1(i,j) = Gc(i,j);
	    end
	end
    end


    G1 = sparse(G1);
    %calculate mst on G1
    [tree, pred] = graphminspantree(G1);
    cost_tree = sum(nonzeros(tree));
    profit = 0;
    for i = 1:length(Prize)
	if(any(X == i))
	    profit = profit + Prize(i);
	end
    end
    if (cost_tree == 0)
	c = -1;
    else
	c = profit - cost_tree;
    end
end


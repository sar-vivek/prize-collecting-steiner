%% generate a random neighbor of X
% Author : Vivek B Sardeshmukh

function  nX  = GenerateNeighbor( X )
    global GenProb;
    global G;
    global r;
    global Prize;
    permutedG =  randperm(length(G));
    for j = 1 : length(G)
	i = permutedG(j);
	p = rand(1 ,1);
       	if (i == r)
		continue;
	end
	if (any(X == i))
	    nX = setdiff(X, i);
	else  
	    nX = union(X, i);
	end
	if ( p > GenProb )
	    break;
	end
    end
    nx = union(nX, r);
end

%% generate a random neighbor of X
% Author : Vivek B Sardeshmukh

function  nX  = GenerateNeighbor( X )
    global GenProb;
    global G;
    global r;
    for i = 1 : length(G)
	p = rand(1 ,1);
	if (i == r)
	    continue;
	elseif (any(X == i))
	    nX = setdiff(X, i);
	else  
	    nX = union(X, i);
	end
	if ( p > GenProb )
	    break;
	end
    end
end


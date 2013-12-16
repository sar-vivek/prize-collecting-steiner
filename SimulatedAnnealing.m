%% Simulated Annealing 
% takes a solution s and its score e
% returns a solution which maximizes e 
% Author: Vivek B Sardeshmukh and Preethi Issac

function [ sbest, ebest ] = SimulatedAnnealing(s, e)
    global EMin;
    global KMax;
    global TMax;
    global TMin;
    global Alpha;

    sbest = s;
    ebest = e;
    k = 0;
    t = TMax;

    while ( t > TMin && e <= EMin) 
        t = Alpha * t; 
        snew = GenerateNeighbor( s );
	display(snew);
        enew = ComputeScore( snew );
	display(enew);
        if ( e < enew )
            s = snew;
            e = enew;
	elseif ( exp( (enew - e) / t) > rand(1,1) )
	    s = snew;
	    e = enew;
        end
        if ( enew > ebest )
            sbest = snew;
            ebest = enew;
        end
	k = k +1;
    end
    display(k);
end

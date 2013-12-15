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

    while ( t > TMin && e < EMin) 
        t = Alpha * t; 
        snew = GenerateNeighbor( s );
        enew = ComputeScore( snew );
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
    end
end

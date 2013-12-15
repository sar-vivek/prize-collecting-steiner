%%calculates acceptance probability of newly generated solution
% takes score e of old solution, enew of new, and current temp t
% returns a real between [0,1]
% Author : Vivek B Sardeshmukh

function p = AcceptanceProb(e, enew, t)
    if ( e < enew )
	p = 1;
    else
	p = exp( (enew - e) / t )'
    end
end

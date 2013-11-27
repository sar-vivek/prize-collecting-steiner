function [X, s] = simann(X0)
    objfunc = @compute_cost;
    [X, s, exitfalg, outp] = simulannealbnd(objfunc, X0);
 end

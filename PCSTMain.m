%% G is matrix representing a undirected graph (V,E) have none negtive weighted edges, where the G(i,j) is the cost of edge(i,j)
%% Each vertex in V is denoted by the index 1,2,3,... size(V)
%% Prize is vertex penalites, a list of int
%% Author : Preethi Issac and Vivek B Sardeshmukh
function [scoreX, scoreY, scoreZ] = PCSTMain(inputfile, outputfile)
    global G;
    global Prize;
    global r;
    global GenProb;
    global TMax TMin Alpha; 
    global EMin;    %minimum value of maximization obj fun we want.. set to 2*opt (init sol)

    % Setting up parameters
    r	    = 292;  % root node
    GenProb = 0.8;  % probability with a neighbor is genereted in GenerateNeighbor function
    TMax    = 1000;  % cooling schedule initial temp
    TMin    = 0.001; % final temp
    Alpha   = 0.8;   % t = Alpha * t 


    % debug variables
    global lf; %file for debugging in localsearch
    global count;
    count = 0;


     %SMALL INSTANCE
     r=6;
     G = [ -1  4 -1 -1 -1 -1 -1;
	    4 -1  7 -1 -1  3 -1;
	   -1  7 -1  3 -1 -1 -1;
	   -1 -1  3 -1  5 -1 -1;
	   -1 -1 -1  5 -1  2 -1;
	   -1  3 -1 -1  2 -1  1;
	   -1 -1 -1 -1 -1  1 -1;];  

     Prize = [100 0 200 4 300 400 0];
    
    %[G,Prize] = InputData(inputfile);
    %initial sol
    tic;
    [T, X, scoreX] = InitSol();
    initTime = toc;
    dualX = DualComputeScore(X);
    display(X);
    display(scoreX);
    display(T);
 
    %local search 
    localfile = strcat(inputfile, 'local.txt');
    lf = fopen(localfile, 'w');
    tic;
    [Y, scoreY] = LocalSearch(X, scoreX);
    localTime = toc;
    dualY = DualComputeScore(Y);
    fclose(lf);
    display(Y);
    display(scoreY);

    %Simulated Annealing starting with 0.5-approx 
    EMin = 1.8 * scoreX;    %and hoping for a 0.9-approx 
    tic;
    [Z, scoreZ] = SimulatedAnnealing(X, scoreX); 
    simTime = toc;
    dualZ = DualComputeScore(Z);
    display(Z);
    display(scoreZ);

    fileid = fopen(outputfile, 'a+');
    fprintf(fileid, '%s %d (%d)  %d--%d (%d) %d (%d)  %g %g %g\n', inputfile, scoreX, dualX, scoreY, count, dualY, scoreZ, dualZ,  initTime, localTime, simTime);
    fclose(fileid);
    exit;
end

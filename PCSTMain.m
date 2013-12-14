%% G is matrix representing a undirected graph (V,E) have none negtive weighted edges, where the G(i,j) is the cost of edge(i,j)
%% Each vertex in V is denoted by the index 1,2,3,... size(V)
%% Prize is vertex penalites, a list of int
%% Author : Preethi

function T = PCSTMain(Prize)
    global G;
    global Prize;
    global r;
    r = 292; % root node
    [G,Prize] = inputdata('C02-A.stp');
    % SMALL INSTANCE
    %r=5;
    % G = [-1 1 10 -1 -1 -1 -1 -1 -1 -1; 
    %      1 -1 -1 -1 -1 10 -1 -1 -1 -1; 
    %     10 -1 -1 10 1 -1 -1 -1 -1 -1; 
    %     -1 -1 1 -1 -1 -1 -1 -1 10 -1; 
    %     -1 -1 1 -1 -1 1 10 10 1 -1; 
    %     -1 10 -1 -1 1 -1 10 -1 -1 -1; 
    %     -1 -1 -1 -1 10 10 -1 -1 -1 -1; 
    %     -1 -1 -1 -1 10 -1 -1 -1 -1 100; 
    %     -1 -1 -1 10 1 -1 -1 -1 -1 100; 
    %     -1 -1 -1 -1 -1 -1 -1 100 100 -1;]

    % Prize = [10 0 0 150 200 0 100 0 0 20];
    
    %initial sol
    [T, X, score] = PCSTsubprogram();
    display(X);
    display(score);
    fileid=fopen('output.txt', 'w');
    fprintf(fileid, '%d  ', score);
    %local opt
    [Y, score1] = localsearch(X, score);
    display(Y);
    display(score1);
    fprintf(fileid, ' %d\n', score1);
end


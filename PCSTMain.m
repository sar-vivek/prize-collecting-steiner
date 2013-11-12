%% G is matrix representing a undirected graph (V,E) have none negtive weighted edges, where the G(i,j) is the cost of edge(i,j)
%% Each vertex in V is denoted by the index 1,2,3,... size(V)
%% Prize is vertex penalites, a list of int

function T = PCSTMain(G, Prize)
    r = 292; % root node
    % inputing instances
    G = inputdata('C02-A.stp');


    % Close file

    % Create adjacency matrix in sparse format with zeros instead of -1
    % (memory efficient if there are lots of zeros)
    AdjMatrixSparseWithZeros = ...
        sparse(ArrayOfInitialNodes, ArrayOfFinalNodes, ArrayOfEdgeWeights, ...
        NumberOfNodes, NumberOfNodes);
    AdjMatrixSparseWithZeros = ...
        AdjMatrixSparseWithZeros + AdjMatrixSparseWithZeros'
    % Transform it to full format (no compact storage in memory)
    % and replace zeros with -1
    G = full(AdjMatrixSparseWithZeros);
    for i = 1:NumberOfNodes
        for j = 1:NumberOfNodes
            G(i,j) = G(j,i);
        end
    end
    G = full(AdjMatrixSparseWithZeros);
    G(G==0) = -1
    score = -inf;

    % Finding Tree
    T = [];
    for i = 1:length(Prize)
        Temp = PCSTsubprogram(G, Prize, i);
        TempScore = Temp.score;        
        %{ 
        Debug information
        str = sprintf('The edge(s) in tree with root %d and total score is %d', i, TempScore);
        disp(str);
        disp(' Vertex      Vertex       Cost');

        for i = 1: length(Temp.E)
            str = sprintf('   %d(%d)         %d(%d)         %d', Temp.E(i).id.i, Prize(Temp.E(i).id.i), Temp.E(i).id.j, Prize(Temp.E(i).id.j), Temp.E(i).cost);
            disp(str);
        end
        %}
        %% disp('---------------------------------------------------------');
        if TempScore >= score            
            score = TempScore;          
            T = Temp;

        end
    end

    disp('The edge(s) in the tree is(are)');
    disp('     Vertex           Vertex          Cost');
    for i = 1: length(T.E)
        str = sprintf('%4d(%6d)      %4d(%6d)       %4d', T.E(i).id.i, Prize(T.E(i).id.i), T.E(i).id.j, Prize(T.E(i).id.j), T.E(i).cost);
        disp(str);
    end
    str = sprintf('total score is %d', T.score);
    disp(str);





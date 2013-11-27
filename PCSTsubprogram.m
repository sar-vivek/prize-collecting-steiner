%% G is matrix representing a undirected graph (V,E) have none negtive weighted edges, where the G(i,j) is the cost of edge(i,j)
%% Each vertex in V is denoted by the index 1,2,3,... size(V)
%% Prize is vertex penalites, a list of int
%% r is the root vertex, the output tree will contain the root
function T = PCSTsubprogram(G, Prize, r)
r = 292; % root node
% inputing instances
       [G,Prize] = inputdata('C02-A.stp');

% end
%     % Read number of nodes and edges
%     H = textscan(fileID, '%s %f', 2, 'HeaderLines', 1);
%     disp(['Number of ' H{1}{1} ':'])
%     NumberOfNodes = H{2}(1)
%     disp(['Number of ' H{1}{2} ':'])
%     NumberOfEdges = H{2}(2)
%     % Read all remaining lines ("E x x x" lines)
%     C = textscan(fileID, '%c %f %f %f');
%    
%     ArrayOfInitialNodes = C{2}'
%     ArrayOfFinalNodes   = C{3}'
%     ArrayOfEdgeWeights  = C{4}'
%     line1 = fgetl(fileID);
% res={line1};
% while ischar(line1)
%   line1 = fgetl(fileID);
%   res{end+1} =line1
% end
% fclose(fileID);
% res(end)=[]
% s2 = regexp(res, ' ', 'split')
% s3 = size(s2);
% numPRIZEnodes1 = s2{1,4}{1,2};
% numPRIZEnodes2=str2num(numPRIZEnodes1);
% nodes1P=s2{1,5}{1,2};
% nodes2P = str2num(nodes1P);
% Prize(NumberOfNodes) = 0;
% for i = 5: numPRIZEnodes2 + 4
%     nodenumber = s2{1,i}{1,2};
%     nodenumber1 =  str2num( nodenumber);
%     Prize1 = s2{1,i}{1,3};
%     Prize2 = str2num( Prize1);
%    Prize(nodenumber1) = Prize2;
% 
% end
% 
% 
%     % Close file
% 
%     % Create adjacency matrix in sparse format with zeros instead of -1
%     % (memory efficient if there are lots of zeros)
%     AdjMatrixSparseWithZeros = ...
%         sparse(ArrayOfInitialNodes, ArrayOfFinalNodes, ArrayOfEdgeWeights, ...
%         NumberOfNodes, NumberOfNodes);
%     AdjMatrixSparseWithZeros = ...
%         AdjMatrixSparseWithZeros + AdjMatrixSparseWithZeros'
%     % Transform it to full format (no compact storage in memory)
%     % and replace zeros with -1
%     G = full(AdjMatrixSparseWithZeros);
%     G(G==0) = -1
     F = []; %% A tree
     Comp(length(Prize)).C = []; %% set of components
     Comp(length(Prize)).w = 0;
     Comp(length(Prize)).lambda = 1;
     Comp(length(Prize)).Id = 0;
     RootComp = r; %% the id of root components
     d = zeros(length(Prize));
     
     nComp = length(Prize);  %% number of components
     
     VertexBelong = zeros(1, length(Prize)); %% this array is used to denote which component a vertex belongs to. This array is used for 
     %% eg, VertexBelong(3) = 5 means that the Vertex is in the componet5
     %% VertexMark = zeros(1, length(Prize));  %% each vertex is labelled with certain component
     
     for i=1: length(Prize)
         Comp(i).w = 0;
         Comp(i).C = [i];
         Comp(i).Id = i;
         if( i == r )
            Comp(i).lambda = 0;
         else
            Comp(i).lambda = 1;
         end
         VertexBelong(i) = i; %% initially, each vertex is in its own component
     end
        
     next_id = length(Prize)+1;  %% next availiable id to assign a component
     
     
         
     while (1)
        %% while there exists a component in Comp such that its lambda = 1, the while loop continues..
        flag = 0;
        %% print all comp
        %{
        for i=1: length(Comp)
            fprintf('The comp id is %d with lambda %d.', Comp(i).Id, Comp(i).lambda);
            disp(Comp(i).C);
        end
        %}    
            
            
        for i=1: length(Comp)
            if Comp(i).lambda == 1;
                flag = 1;                
                break;
            end
        end
        
        if (flag==0)
            break;
        end
        
        %% Find an edge minimize e1
        e1 = Inf;
        Edge_chosn.i = 0;
        Edge_chosn.j = 0;
        for i=1:length(G(1,:))
            
            for j=(i+1):length(G(1,:))
                %% filter off the entries not representing valid edge cost
                if not(G(i,j) >= 0) || VertexBelong(i) == VertexBelong(j)
                    continue;
                end
                
                etmp = (G(i,j) - d(i) - d(j))/( Comp( VertexBelong(i) ).lambda + Comp( VertexBelong(j) ).lambda );
                if etmp < e1
                    e1 = etmp;
                    Edge_chosn.i = i;
                    Edge_chosn.j = j;
                end
                               
            end
        end
        
        %% Find an edge minimize e2
        e2 = Inf;
        Ct_idx = 1;
        for i=1:length(Comp)
            
            if (Comp(i).lambda == 1)
                etmp = sum( Prize( Comp(i).C(1:length(Comp(i).C)) ) );
                %{
                for k = 1: length(Comp(i).C)
                    etmp = etmp + Prize( Comp(i).C(k) );
                end
                %}
                etmp = etmp - Comp(i).w;
                
                if (etmp < e2)
                    e2 = etmp;
                    Ct_idx = i;
                end
            
            else
                continue;
            end
        end
        
        e = min(e1,e2);
        
        %% update the w(C) for all component  --- implicitly set yc = yc + lambda(C) for all C
       for i=1:length(Comp)
          Comp(i).w = Comp(i).w + e*Comp(i).lambda;         
       end   
       
                
        %% implicitly set ys = 0 for all S belongs to V
     
        for i=1:length(Comp(RootComp).C)
            d(  Comp(RootComp).C(i) ) =  d( Comp(RootComp).C(i) ) + e*Comp(RootComp).lambda;
        end
        
        if (e == e2)
            Comp(Ct_idx).lambda = 0;
           %%mark the unlabelled vertices of Ct with label Ct
           %{
            for i=1:length(Comp(Ct_idx).C)            
               VertexMark( Comp(Ct_idx).C(i) ) = Comp(Ct_idx).Id;
            end
           %} 
           %% disp('not add edge this round');
        else             
            F = [F, Edge_chosn];
            Comp(nComp+1).C = [Comp( (VertexBelong(Edge_chosn.i))).C  Comp( (VertexBelong(Edge_chosn.j))).C ];
            Comp(nComp+1).w = Comp( (VertexBelong(Edge_chosn.i))).w + Comp( (VertexBelong(Edge_chosn.j))).w;
            Comp(nComp+1).Id = next_id;
            next_id = next_id + 1;
         
            %%disp(VertexBelong(r));
            if( (VertexBelong(r) == (VertexBelong(Edge_chosn.i))) ||  (VertexBelong(r) == (VertexBelong(Edge_chosn.j))) )
               Comp(nComp+1).lambda = 0;
            else 
               Comp(nComp+1).lambda = 1;
            end
            
            Comp([(VertexBelong(Edge_chosn.i)) (VertexBelong(Edge_chosn.j))]) = [];
            nComp = length(Comp);
            
            %% fprintf('add new edge %d %d with lambda = %d', Edge_chosn.i, Edge_chosn.j, Comp(nComp).lambda); 
            for i=1:length(Comp(nComp).C)
                %{
                %% update the marks 
                if VertexMark(Comp(nComp).C(i)) > 0
                    VertexMark(Comp(nComp).C(i)) = Comp(nComp).Id;
                end
                %}
                VertexBelong(Comp(nComp).C(i)) = nComp;  %% the new added component is at the end of the list
            end
            
            %% update the vertex belong
            for i=1:length(Comp)
                for j=1:length(Comp(i).C)
                    VertexBelong(Comp(i).C(j)) = i;
                    if ( Comp(i).C(j) ) == r
                        RootComp = i;
                    end
                end
            end
            
                       
        end
        
     end
     
     % remove the edges!
     rm = [];
     for i = 1:length(F)
         if ( VertexBelong(F(i).i) ~= RootComp && VertexBelong(F(i).j) ~= RootComp )
             rm = [rm i];
         end
     end
     F(rm) = [];
     
     
     %% Generate a structure for the tree!
     %% The tree contains two components: 1st is the sets like F; 2nd is the set of vertex objects    

     vt = [];
     T.E = [];
     for i = 1:length(F)
        vt = union(vt, [F(i).i,F(i).j]);
        edge_tmp.id = F(i);
        edge_tmp.cost = G(F(i).i, F(i).j);
        T.E = [T.E, edge_tmp];
     end
     
      %% The vertex objects contain 1. vertex id; 2.vertex neighbours; 3.the revenue of the vertex; 4.whether the vertex is done
     T.V = [];
     
     for idx = 1:length(vt)
        v_tmp.id = vt(idx);
        v_tmp.neighbour = [];
        v_tmp.r = Prize(v_tmp.id);
        v_tmp.done = 0;  %% done is used for pruning the output tree. But currently we do not need it.
        %%find the neighbour
        for k = 1:length(F)
           
           if(F(k).i == v_tmp.id)
               v_tmp.neighbour = union(v_tmp.neighbour, F(k).j);
           elseif (F(k).j == v_tmp.id)
               v_tmp.neighbour = union(v_tmp.neighbour, F(k).i);
           end
           
            
        end
        T.V = [T.V, v_tmp];
        
     end
     
     
     MapV = zeros(1,length(Prize)); %% Map(i) is the index of Vertex i in the tree T.V;  MapV( T.V(i).id ) = i;
     for i = 1:length(T.V)
        MapV(T.V(i).id) = i; 
     end
     
     
   
    
         for i = 1:length(T.V)
         T.V(i).r = Prize(T.V(i).id);
         score = score + Prize(T.V(i).id);
     end
 
     for i = 1:length(T.E)         
         score = score - T.E(i).cost;
         
     end
  
%      Prize(T.E(i).id.i), T.E(i).id.j, Prize(T.E(i).id.j), T.E(i).cost
T.score = score;
     
     

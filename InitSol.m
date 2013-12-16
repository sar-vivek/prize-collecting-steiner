%%Intial Solution
% Derived from : M. X. Goemans and D. P. Williamson, The primal dual method for approximation algorithms
% and its application to network design problems, Approximation algorithms for NP-hard problems 
% (D. Hochbaum, ed.), PWS Publishing Co., 1996, pp. 144–191.
%
% G is matrix representing a undirected graph (V,E) have none negtive weighted edges, where the G(i,j) is the cost of edge(i,j)
% Each vertex in V is denoted by the index 1,2,3,... size(V)
% Prize is vertex penalites, a list of int
% r is the root vertex, the output tree will contain the root
% Author : Preethi Issac 

function [T,X,score] = InitSol()
    global G;
    global Prize;
    global r;
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
                %% Get rid of invalid edge cost
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
     
     
     
     
     score = 0;
     for i = 1:length(T.V)
         T.V(i).r = Prize(T.V(i).id);
         score = score + Prize(T.V(i).id);
     end
          
     for i = 1:length(T.E)         
         score = score - T.E(i).cost;
     end
     
     T.score = score;
     X= vt';
     display(X);
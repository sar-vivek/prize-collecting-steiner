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
     Store(length(Prize)).C = []; %% set of components
     Store(length(Prize)).w = 0;
     Store(length(Prize)).lambda = 1;
     Store(length(Prize)).Id = 0;
     RootStore = r; %% the id of root components
     d = zeros(length(Prize));
     
     nStore = length(Prize);  %% number of components
     
     B = zeros(1, length(Prize)); %% this array is used to denote which component a vertex belongs to. This array is used for 
     %% eg, B(3) = 5 means that the Vertex is in the component 5
     %% VertexMark = zeros(1, length(Prize));  %% each vertex is labelled with certain component
     
     for i=1: length(Prize)
         Store(i).w = 0;
         Store(i).C = [i];
         Store(i).Id = i;
         if( i == r )
            Store(i).lambda = 0;
         else
            Store(i).lambda = 1;
         end
         B(i) = i; %% initially, each vertex is in its own component
     end
        
     next_id = length(Prize)+1;  %% next availiable id to assign a component
     
     
         
     while (1)
        %% while there exists a component in Store such that its lambda = 1, the while loop continues..
        flag = 0;
           
            
            
        for i=1: length(Store)
            if Store(i).lambda == 1;
                flag = 1;                
                break;
            end
        end
        
        if (flag==0)
            break;
        end
        
        %% Find an edge minimize ED {Objective}
        ED = Inf;
        New_Edge.i = 0;
        New_Edge.j = 0;
        for i=1:length(G(1,:))
            
            for j=(i+1):length(G(1,:))
                %% Get rid of  invalid edge cost!
                if not(G(i,j) >= 0) || B(i) == B(j)
                    continue;
                end
                
                etmp = (G(i,j) - d(i) - d(j))/( Store( B(i) ).lambda + Store( B(j) ).lambda );
                if etmp < ED
                    ED = etmp;
                    New_Edge.i = i;
                    New_Edge.j = j;
                end
                               
            end
        end
        
        %% Find an edge minimize e2
        e2 = Inf;
        Ct_idx = 1;
        for i=1:length(Store)
            
            if (Store(i).lambda == 1)
                etmp = sum( Prize( Store(i).C(1:length(Store(i).C)) ) );
                %{
                for k = 1: length(Store(i).C)
                    etmp = etmp + Prize( Store(i).C(k) );
                end
                %}
                etmp = etmp - Store(i).w;
                
                if (etmp < e2)
                    e2 = etmp;
                    Ct_idx = i;
                end
            
            else
                continue;
            end
        end
        
        e = min(ED,e2);
        
        %% update the w(C) for all component  --- implicitly set yc = yc + lambda(C) for all C
       for i=1:length(Store)
          Store(i).w = Store(i).w + e*Store(i).lambda;         
       end   
       
                
        %% implicitly set ys = 0 for all S belongs to V
     
        for i=1:length(Store(RootStore).C)
            d(  Store(RootStore).C(i) ) =  d( Store(RootStore).C(i) ) + e*Store(RootStore).lambda;
        end
        
        if (e == e2)
            Store(Ct_idx).lambda = 0;
        else             
            F = [F, New_Edge];
            Store(nStore+1).C = [Store( (B(New_Edge.i))).C  Store( (B(New_Edge.j))).C ];
            Store(nStore+1).w = Store( (B(New_Edge.i))).w + Store( (B(New_Edge.j))).w;
            Store(nStore+1).Id = next_id;
            next_id = next_id + 1;
         
          
            if( (B(r) == (B(New_Edge.i))) ||  (B(r) == (B(New_Edge.j))) )
               Store(nStore+1).lambda = 0;
            else 
               Store(nStore+1).lambda = 1;
            end
            
            Store([(B(New_Edge.i)) (B(New_Edge.j))]) = [];
            nStore = length(Store);
            
           
            for i=1:length(Store(nStore).C)
           
                B(Store(nStore).C(i)) = nStore;  %% the new added component is at the end of the list
            end
            
            %% update the vertex belong
            for i=1:length(Store)
                for j=1:length(Store(i).C)
                    B(Store(i).C(j)) = i;
                    if ( Store(i).C(j) ) == r
                        RootStore = i;
                    end
                end
            end
            
                       
        end
        
     end
     
     % remove the edges!
     rm = [];
     for i = 1:length(F)
         if ( B(F(i).i) ~= RootStore && B(F(i).j) ~= RootStore )
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
     
     
     MapV = zeros(1,length(Prize)); %% Map(i) is the index of Vertex i in the tree T.V; 
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
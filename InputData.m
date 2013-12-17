%reads the input file
%author : Preethi Issac
function [G,Prize] = InputData(inputfile)
content = fileread( inputfile ) ;
 % - Extract graph information.
 pattern    = 'Nodes\s+(?<nodes>\d+)\s+Edges\s+(?<edges>\d+)\s+(?<data>.*)SEC' ;
 graph      = regexp( content, pattern, 'names' ) ;
 graph.data = textscan( graph.data, '%*s %f %f %f' ) ;
 % - Extract terminals information.
 pattern     = 'Terminals\s+(?<terminals>\d+)\s+(?<data>.*)END' ;
 terminals   = regexp( content, pattern, 'names' ) ;
 terminals.data = textscan( terminals.data, '%*s %f %f' ) ;
E = str2num(graph.edges);
N = str2num(graph.nodes);
T = str2num (terminals.terminals);
graph.data{1}(E+1) = [];
graph.data{2}(E+1) = [];
graph.data{3}(E+1) = [];
Prize = zeros(1,N);
for k = 1 : T
    Prize(1,terminals.data{1}(k)) = terminals.data{2}(k);
 end
% node1 = graph.data{1};

% mode2 = graph.data{2};
% cost = graph.data{3};

 
 G_sp = sparse( graph.data{1}, graph.data{2}, graph.data{3},N, N ) ;
 G_sp = G_sp + G_sp.' ;
 G = full(G_sp);
 for i = 1:N
     for j = 1:N
         
     if G(i,j)== 0
         G(i,j) = -1;
     end 
     end
 end
 

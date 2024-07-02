
load("digraph_obtained_Hito3.mat");


V=find(G.Edges.name=="Calle Elisa Cendreros");
W=find(G.Edges.name=="Calle de la Paloma");
Z=rmedge(G, V); 
Z=rmedge(Z,W);
      

H=G;
Q=find(startsWith(H.Edges.name,'Ronda'));
for i=1:length(Q)
    H.Edges.maxspeed(Q(i))=30;
end


J=G;
P=find(G.Edges.name=="Calle Toledo");
for i=1:length(P)
   J = flipedge(J,P(i));
end


j=1;
for i=1:height(G.Edges) 
G.Edges.Weight(i,j)=((G.Edges.Flow(i)) * (G.Edges.length(i)*60/(0.9*G.Edges.maxspeed(i)*1000))); 
end

for i=1:height(Z.Edges) 
Z.Edges.Weight(i,j)=((Z.Edges.Flow(i)) * (Z.Edges.length(i)*60/(0.9*Z.Edges.maxspeed(i)*1000))); 
end

for i=1:height(H.Edges) 
H.Edges.Weight(i,j)=((H.Edges.Flow(i)) * (H.Edges.length(i)*60/(0.9*H.Edges.maxspeed(i)*1000))); 
end

for i=1:height(J.Edges)
J.Edges.Weight(i,j)=((J.Edges.Flow(i)) * (J.Edges.length(i)*60/(0.9*J.Edges.maxspeed(i)*1000))); 
end

T0=0; T1=0; T2=0; T3=0;
for i=1:height(G.Edges)
    T0=T0+G.Edges.Weight(i);
end
for i=1:height(Z.Edges)
    T1=T1+Z.Edges.Weight(i);
end
for i=1:height(H.Edges)
    T2=T2+H.Edges.Weight(i);
end
for i=1:height(J.Edges)
    T3=T3+J.Edges.Weight(i);
end

Scenario=["Initial Case"; "Scenario 1"; "Scenario 2"; "Scenario 3"];
T=[T0;T1;T2;T3];
Table=table(Scenario,T);
disp(Table);

fprintf('Then, Scenario 1 is the one that has least detrimental impact on the network.\n');
fprintf('Because the total travel time is the lowest one, which means that the cars "stay" less time on the road.');
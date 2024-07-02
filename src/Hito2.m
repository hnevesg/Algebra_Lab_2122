data_dir = 'data/'; 
map_filename='CiudadReal';

switch map_filename
    case 'ESI'
        bounds = [-3.9272, -3.9140; 38.9871, 38.9940];
    case 'RondaCiudadReal'
        bounds = [-3.9388, -3.9136; 38.9795, 38.9965];
    case 'CiudadReal'
        bounds = [-3.9568, -3.8964; 38.9670, 39.0038];
    otherwise
        error("Wrong value for variable `map_filename`");
end

[n_nodes,nodes,n_edges,edges]=load_pycgr(data_dir, map_filename);

source_nodes = [edges.source];
target_nodes = [edges.target];  

G_visual=graph(source_nodes,target_nodes);

j=1;
for i=1:length(edges.source) % for adding column 'travel time'
edges.travel_time(i,j)=(edges.length(i)*60/(0.9*edges.maxspeed(i)*1000)); % m/min
end

j=length(edges.source)+1;
for i=1:length(edges.source) % for adding bidirectional edges to digraph
    if(edges.bidirectional(i)==1)
       edges.source(j)=edges.target(i);
       edges.target(j)=edges.source(i);
       edges.length(j)=edges.length(i);
       edges.bidirectional(j)=edges.bidirectional(i);
       edges.type(j)=edges.type(i);
       edges.maxspeed(j)=edges.maxspeed(i);
       edges.name(j)=edges.name(i);
       edges.travel_time(j)=edges.travel_time(i);
       j=j+1;
    end
end

source_nodes_dig = [edges.source];
target_nodes_dig = [edges.target];  
edge_weights_dig = [edges.travel_time];

G=digraph(source_nodes_dig,target_nodes_dig,edge_weights_dig);

for i=1:length(edges.source) % for adding each attribute at right position
   if findedge(G,edges.source(i),edges.target(i))~=0
        index=findedge(G,edges.source(i),edges.target(i));
        G.Edges.length(index)=edges.length(i);
        G.Edges.maxspeed(index)=edges.maxspeed(i);
        G.Edges.name(index)=edges.name(i);
   end
end

map_label='Map from hospital to ESI';

fig = figure(); 
ax = axes('Parent', fig);
show_map(ax,bounds,map_label,data_dir,map_filename);

figure(1)
p1 = plot(G_visual, 'b', 'LineWidth', 1); 

p1.XData = [nodes.lon];  
p1.YData = [nodes.lat];
p1.MarkerSize = 0.7; 
[path1, t, edgepath] = shortestpath(G,4034,3350); 
highlight(p1,4034,'NodeColor','g','MarkerSize',5);
highlight(p1,3350,'NodeColor','r','MarkerSize',5);
highlight(p1,path1,'EdgeColor','r','LineWidth',3);

d=0;
for i=1:length(edgepath)
    d=d+G.Edges.length(edgepath(i));
end

disp("Route 1: ");
fprintf('The distance of the shortest path is %.1f meters. \n', d);
fprintf('And the estimated time is %.2f minutes. \n', t);

map_label='Map from ITSI to la granja';
fig = figure(); 
ax = axes('Parent', fig);
show_map(ax,bounds,map_label,data_dir,map_filename);

figure(2)
p2 = plot(G_visual, 'b', 'LineWidth', 1);

p2.XData = [nodes.lon];  
p2.YData = [nodes.lat];
p2.MarkerSize = 0.7; 
[path2, time, edgep] = shortestpath(G,4785,4082,'Method','positive'); %4082 or 5683
highlight(p2,4785,'NodeColor','g','MarkerSize',5);
highlight(p2,4082,'NodeColor','r','MarkerSize',5);
highlight(p2,path2,'EdgeColor','r','LineWidth',3);

distance=0;
for i=1:length(edgep)
    distance=distance+G.Edges.length(edgep(i));
end

disp("Route 2: ");
fprintf('The distance of the shortest path is %.1f meters.\n', distance);
fprintf('And the estimated time is %.2f minutes.\n', time);

map_label='Map from la granja to ITSI';
fig = figure(); 
ax = axes('Parent', fig);
show_map(ax,bounds,map_label,data_dir,map_filename);

figure(3)
p3 = plot(G_visual, 'b', 'LineWidth', 1);

p3.XData = [nodes.lon];  
p3.YData = [nodes.lat];
p3.MarkerSize = 0.7; 
[path3, ti, epath] = shortestpath(G,4082,4785,'Method','positive');
highlight(p3,4785,'NodeColor','r','MarkerSize',5);
highlight(p3,4082,'NodeColor','g','MarkerSize',5);
highlight(p3,path3,'EdgeColor','r','LineWidth',3);

dist=0;
for i=1:length(epath)
    dist=dist+G.Edges.length(epath(i));
end

disp('Route 3: ');
fprintf('The distance of the shortest path is %.1f meters. \n', dist);
fprintf('And the estimated time is %.2f minutes. \n', ti);

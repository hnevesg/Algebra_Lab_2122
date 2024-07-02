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

load("digraph_obtained_Hito3.mat");

map_label='Map from Hospital to ESI';
fig = figure(); 
ax = axes('Parent', fig);
show_map(ax,bounds,map_label,data_dir,map_filename);


for i=1:6692 % for changing column 'travel time' 
G.Edges.Weight(i)=((G.Edges.Flow(i)/500).^4 *0.2 +1) * (G.Edges.length(i)*60/(0.9*G.Edges.maxspeed(i)*1000)); 
end 

figure(1)
p1 = plot(G_visual, 'b', 'LineWidth', 1); 

p1.XData = [nodes.lon];  
p1.YData = [nodes.lat];
p1.MarkerSize = 0.7; 
[path1, t, edgepath] = shortestpath(G,4034,3350,'Method','positive'); 
highlight(p1,4034,'NodeColor','g','MarkerSize',5);
highlight(p1,3350,'NodeColor','r','MarkerSize',5);
highlight(p1,path1,'EdgeColor','r', 'LineWidth',3);

distance=0;
for i=1:length(edgepath)
    distance=distance+G.Edges.length(edgepath(i));
end

disp("Route 1: ");
fprintf('The distance of the shortest path is %.1f meters. \n', distance);
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

distance=0;
for i=1:length(epath)
    distance=distance+G.Edges.length(epath(i));
end

disp('Route 3: ');
fprintf('The distance of the shortest path is %.1f meters. \n', distance);
fprintf('And the estimated time is %.2f minutes. \n', ti);
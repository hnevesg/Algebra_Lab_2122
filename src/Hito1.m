%% Variable definition
data_dir = 'data/'; % Relative path to the data
map_filename='ESI';

% Set the bounds for the map (do not change)
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

%% Load graph data
[n_nodes,nodes,n_edges,edges]=load_pycgr(data_dir, map_filename);

%% Construct the graph
source_nodes = [edges.source];
target_nodes = [edges.target];  

% Undirected graph for visualization
G_visual=graph(source_nodes,target_nodes);

% Actual digraph
% Add reverse direction to bidirectional roads (from target to source)

j=length(edges.source)+1;
for i=1:length(edges.source)
    if(edges.bidirectional(i)==1)
       edges.source(j)=edges.target(i);
       edges.target(j)=edges.source(i);
       edges.length(j)=edges.length(i);
       edges.bidirectional(j)=edges.bidirectional(i);
       edges.type(j)=edges.type(i);
       edges.maxspeed(j)=edges.maxspeed(i);
       edges.name(j)=edges.name(i);
       j=j+1;
    end
end

source_nodes_dig = [edges.source];
target_nodes_dig = [edges.target];  
edge_weights_dig = [edges.length];

G=digraph(source_nodes_dig,target_nodes_dig,edge_weights_dig);

% Plot the graph
map_label='ESI Map';
fig = figure(); 
ax = axes('Parent', fig);
show_map(ax,bounds,map_label,data_dir,map_filename);

p1 = plot(G_visual, 'b', 'LineWidth', 2); 

p1.XData=[nodes.lon]; % coordinates 
p1.YData=[nodes.lat];
p1.MarkerSize= 1; % vertices size




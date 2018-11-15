%% define planes
addpath D:\Git\codeBase\skeletonClassWithAdj_v8\
[in_collected, nodes] = define_planes();
%% plot planes
plot_planes(in_collected);
%% analyze cells
analyze_cells(nodes, in_collected)
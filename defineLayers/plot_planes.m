function plot_planes(in_collected)
figure;
hold on
styles = {'b*', 'r+'};
for side_it = 1 : 2
    scatter3(in_collected{side_it}(:, 1) * 0.012, ...
        in_collected{side_it}(:, 2) * 0.012, ...
        in_collected{side_it}(:, 3) * 0.025, ...
        styles{side_it})
end
axis equal
xlabel('um')

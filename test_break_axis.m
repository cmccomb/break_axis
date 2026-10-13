fig = figure('Visible', 'off');
ax = axes('Parent', fig);
plot(ax, 1:3, [1 2 3]);
set(ax, 'YTick', [1 2 3], 'YTickLabel', {'1', '2', '3'});

% The break is a visual annotation; it does not change plotted data.
line_before = findobj(ax, 'Type', 'line');
y_before = get(line_before, 'YData');
break_axis('handle', ax, 'axis', 'y', 'bottom_reset', 'start');
labels = cellstr(get(ax, 'YTickLabel'));
assert(strcmp(labels{1}, 'start'));
assert(isequal(get(line_before, 'YData'), y_before));
close(fig);

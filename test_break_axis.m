fig = figure('Visible', 'off');
ax = axes('Parent', fig);
plot(ax, 1:3, [1 2 3]);
legendHandle = legend(ax, 'line');
set(ax, 'YTick', [1 2 3], 'YTickLabel', {'1', '2', '3'});

% The break is a visual annotation; it does not change plotted data.
line_before = findobj(ax, 'Type', 'line');
y_before = get(line_before, 'YData');
break_axis('handle', ax, 'axis', 'y', 'bottom_reset', 'start');
labels = cellstr(get(ax, 'YTickLabel'));
assert(strcmp(labels{1}, 'start'));
assert(isequal(get(line_before, 'YData'), y_before));
assert(isvalid(legendHandle));
assert(strcmp(legendHandle.Visible, 'on'));
close(fig);

%% Scatter data and its legend survive the visual annotation
fig = figure('Visible', 'off');
ax = axes('Parent', fig);
points = scatter(ax, 1:3, [1 2 3]);
legendHandle = legend(ax, 'points');
set(ax, 'YTick', [1 2 3]);
break_axis('handle', ax, 'axis', 'y', 'position', 2);
assert(isvalid(points));
assert(isvalid(legendHandle));
assert(strcmp(legendHandle.Visible, 'on'));
assert(isequal(points.YData, [1 2 3]));
close(fig);

%% The default x break is placed relative to the x position of the axes
fig = figure('Visible', 'off');
ax = axes('Parent', fig, 'Position', [0.15 0.6 0.5 0.3]);
plot(ax, 1:3, [1 2 3]);
set(ax, 'XTick', [1 2 3]);
break_axis('handle', ax, 'axis', 'x');
rectangles = findall(fig, 'Type', 'rectangleshape');
assert(numel(rectangles) == 1);
rect_position = get(rectangles, 'Position');
ax_position = getpixelposition(ax, true);
fig_position = getpixelposition(fig);
expected_center = (ax_position(1) + ax_position(3)/4)/fig_position(3);
assert(abs(rect_position(1) + rect_position(3)/2 - expected_center) < 1e-6);
close(fig);

%% An explicit position respects reversed axis direction
fig = figure('Visible', 'off');
ax = axes('Parent', fig, 'Position', [0.15 0.6 0.5 0.3]);
plot(ax, 1:3, [1 2 3]);
set(ax, 'XLim', [1 3], 'XDir', 'reverse', 'XTick', [1 2 3]);
break_axis('handle', ax, 'axis', 'x', 'position', 1.5);
rectangles = findall(fig, 'Type', 'rectangleshape');
rect_position = get(rectangles, 'Position');
ax_position = getpixelposition(ax, true);
fig_position = getpixelposition(fig);
expected_center = (ax_position(1) + 0.75*ax_position(3))/fig_position(3);
assert(abs(rect_position(1) + rect_position(3)/2 - expected_center) < 1e-6);
close(fig);

%% A selected axes inside a panel still receives figure-relative marks
fig = figure('Visible', 'off');
panel = uipanel('Parent', fig, 'Position', [0.2 0.2 0.6 0.6]);
ax = axes('Parent', panel);
plot(ax, 1:3, [1 2 3]);
set(ax, 'YTick', [1 2 3]);
break_axis('handle', ax, 'axis', 'y', 'position', 2);
rectangles = findall(fig, 'Type', 'rectangleshape');
assert(numel(rectangles) == 1);
rect_position = get(rectangles, 'Position');
assert(all(rect_position >= 0) && all(rect_position <= 1));
close(fig);

%% Reject unsupported option values before creating annotations
fig = figure('Visible', 'off');
try
    break_axis('axis', 'z');
    error('Expected an error for an unsupported axis.');
catch err
    assert(contains(err.message, 'x') && contains(err.message, 'y'));
end
close(fig);

function break_axis(varargin)
%BREAK_AXIS Inserts a break on the selected axis.
%   BREAK_AXIS() applies a break to the y-axis of the current axis with 
%       default height and location.
%   BREAK_AXIS('handle', ax) applies a break to the axis ax.
%   BREAK_AXIS('length', L) applies a break with length L (L is a fraction
%       between ticks).
%   BREAK_AXIS('axis', 'x') applies a break to the x-axis.
%   BREAK_AXIS('bottom_reset', X) resets the bottom tick label to X (X 
%      must be a string).
%   BREAK_AXIS('position', P) breaks the axes at position P.

%% Parse the inputs
% Default values
ax = gca;
extent = 0.5;
bottom_reset = '';
xy = 'y';
position = Inf;

% Overwrite with what was fed in
if mod(nargin, 2) ~= 0
    error('Options must be supplied as name/value pairs.');
end
if nargin > 0
    for i=1:2:length(varargin)
        if strcmp(varargin{i}, 'handle')
            ax = cell2mat(varargin(i+1));
        elseif strcmp(varargin{i}, 'length')
            extent = cell2mat(varargin(i+1));
        elseif strcmp(varargin{i}, 'axis')
            xy = cell2mat(varargin(i+1));
        elseif strcmp(varargin{i}, 'bottom_reset')
            bottom_reset = cell2mat(varargin(i+1));
        elseif strcmp(varargin{i}, 'position')
            position = cell2mat(varargin(i+1));
        else
            error('Unrecognized option: %s', char(varargin{i}));
        end
    end
end

if ~ishandle(ax) || ~strcmp(get(ax, 'Type'), 'axes')
    error('The handle option must identify an axes.');
end
if ~strcmp(xy, 'x') && ~strcmp(xy, 'y')
    error('The axis option must be ''x'' or ''y''.');
end
if ~isnumeric(extent) || ~isscalar(extent) || ~isfinite(extent) || extent <= 0 || extent > 1
    error('The length option must be a number between 0 and 1.');
end
if ~isnumeric(position) || ~isscalar(position) || ~(isfinite(position) || position == Inf)
    error('The position option must be a finite number.');
end
if ~strcmp(get(ax, [xy 'Scale']), 'linear')
    error('Axis breaks currently require a linear axis scale.');
end
width = get(ax, 'TickLength');
width = width(1)*2;
       
%% Do the things

% Get figure handle
f = ancestor(ax, 'figure');

% Annotation coordinates are normalized to the figure, including when the
% axes live inside a panel or tiled layout.
ax_pixels = getpixelposition(ax, true);
figure_pixels = getpixelposition(f);
pos = [ax_pixels(1:2)./figure_pixels(3:4), ...
       ax_pixels(3:4)./figure_pixels(3:4)];

% Get number of tick intervals
n = numel(get(ax, [xy 'Tick'])) - 1;
if n < 1
    error('The selected axis must have at least two ticks.');
end

if strcmp(xy, 'x')
    
    % Get the spacing between ticks
    spacing = pos(3)/n;
    
    % Find the center along the axis
    cent = pos(1) + 0.5*spacing;
    
    % Reset if a position was given
    if position < Inf
        lims = get(ax, 'xlim');
        fraction = (position - lims(1))/diff(lims);
        if strcmp(get(ax, 'XDir'), 'reverse')
            fraction = 1 - fraction;
        end
        cent = pos(1) + pos(3) * fraction;
    end
    
    % define the extents of the bar
    X = [cent - extent*spacing/2; 
         cent + extent*spacing/2];
    Y1 = [pos(2) - 0.005; 
          pos(2) + 0.005];
    Y2 = [pos(2) - width/2; 
          pos(2) + width/2];
    
    % Make the bar and ticks
    h1 = annotation(f, 'rectangle', [X(1), Y1(1), diff(X), diff(Y1)]);
    annotation(f, 'line', [X(1) X(1)], [Y2(1) Y2(2)]);
    annotation(f, 'line', [X(2) X(2)], [Y2(1) Y2(2)]);
    
elseif strcmp(xy, 'y')
    % Get the spacing between ticks
    spacing = pos(4)/n;
    
    % Find the center along the axis
    cent = pos(2) + 0.5*spacing;
    
    % Reset if a position was given
    if position < Inf
        lims = get(ax, 'ylim');
        fraction = (position - lims(1))/diff(lims);
        if strcmp(get(ax, 'YDir'), 'reverse')
            fraction = 1 - fraction;
        end
        cent = pos(2) + pos(4) * fraction;
    end
    
    % define the extents of the bar
    X1 = [pos(1) - 0.005; 
          pos(1) + 0.005];
    X2 = [pos(1) - width/2; 
          pos(1) + width/2];
    Y = [cent - extent*spacing/2; 
         cent + extent*spacing/2];
     
    % Make the bar and ticks
    h1 = annotation(f, 'rectangle', [X1(1), Y(1), diff(X1), diff(Y)]);
    annotation(f, 'line', [X2(1) X2(2)], [Y(1) Y(1)]);
    annotation(f, 'line', [X2(1) X2(2)], [Y(2) Y(2)]);
    
end

% Reset the color
h1.FaceColor = 'w';
h1.Color = 'w';

% Reset the bottom value
if ~isempty(bottom_reset)
    list = cellstr(get(ax, [xy 'ticklabel']));
    list(1) = {bottom_reset};
    set(ax, [xy 'ticklabel'], list);
end


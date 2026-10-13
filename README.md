# break_axis: a visual axis break for MATLAB plots

[![MATLAB tests](https://github.com/cmccomb/break_axis/actions/workflows/tests.yml/badge.svg)](https://github.com/cmccomb/break_axis/actions/workflows/tests.yml)

`break_axis` draws a white gap and break marks over an existing x or y axis.
**It is visual only:** it does not change the axis scale, plotted data, or
coordinates. Do not use it to imply that values were rescaled.

```matlab
plot(1:5, [1 2 3 4 5]);
break_axis('axis', 'y', 'position', 2.5);
```

Place `break_axis.m` on your MATLAB path. Options are name/value pairs:

- `'handle'`: target axes handle (default: current axes)
- `'axis'`: `'x'` or `'y'` (default: `'y'`)
- `'position'`: data coordinate where the mark appears
- `'length'`: mark length as a fraction of tick spacing (default: `0.5`)
- `'bottom_reset'`: optional replacement for the first displayed tick label

The annotation is placed using the current figure layout. If you resize the
figure or change the axes limits after calling the function, redraw the break.

Run `test_break_axis` from this folder for a basic behavior check. The GitHub
Actions workflow runs it on pushes and pull requests.

Also available on [MATLAB File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/51249-aesethetic-axis-breaks).
Licensed under BSD 3-Clause; see [LICENSE](LICENSE).

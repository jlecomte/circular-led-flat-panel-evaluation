# Clear all variables. Very important!
clear all;

# Clear the current figure window
clf;

# Clear the command window
clc;

# Set high accuracy on output for debugging
format long;

################################################################################
# FUNCTIONS

# n = number of LEDs
# xLED = position of each LED along the x-axis
# yLED = position of each LED along the y-axis
# r = radius of LED strip circle in mm
# h = height of the strip over reflective background sheet in mm
# x = position of the point for which we want to know the intensity along the x-axis
# y = position of the point for which we want to know the intensity along the y-axis
function I = intensity(n, xLED, yLED, r, h, x, y)
  if norm([x y] - [0 0]) > r
    I = 0;
    return;
  endif

  intensities = [];

  for i = 1:n
    intensities(i) = 1 / norm([x y 0] - [xLED(i) yLED(i) h]);
  endfor

  I = sum(intensities);
endfunction

################################################################################
# PARAMETERS

# Radius of LED strip circle in mm
R = 87;

# Radius of the actual light surface in mm
# This must be < R to avoid issues with 0-distance and infinite brightness...
# It must also be an integer!
r = 80;

# Distance between two LEDs on the strip in mm
l = 20;

# Height of the strip over reflective background sheet in mm
h = 5;

################################################################################
# COMPUTE EACH LED POSITION IN X,Y COORDINATES

xLED = [];
yLED = [];

# How many LEDs fit on the circle?
n = floor(2 * pi  * R / l);

for i = 1:n
  xLED(i) = R * cos(i * l / R);
  yLED(i) = R * sin(i * l / R);
endfor

# plot (xLED, yLED, "linestyle", "none", "marker", ".");

################################################################################
# COMPUTE BRIGHTNESS OF EACH POINT
# (we use a grid where each cell measures 1mm x 1mm)

tz = [];

tx = ty = -r:1:r;

minval = Inf;
maxval = 0;

for x = tx
  for y = ty
     val = intensity(n, xLED, yLED, r, h, x, y);
     tz(x + r + 1, y + r + 1) = val;
     if val > 0 && val < minval
       minval = val;
     endif
     if val > maxval
       maxval = val;
     endif
  endfor
endfor

mesh(tx, ty, tz);

printf("Maximum intensity difference is %.1f%%\n", 100 * (maxval - minval) / maxval);

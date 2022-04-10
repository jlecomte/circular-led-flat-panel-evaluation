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
    # Vector between x, y point and LED i
    v1 = [x y 0] - [xLED(i) yLED(i) h];
    # The distance between the x, y point and LED i
    d = norm(v1);
    # The vector normal (orthogonal) to the face of the LED
    v2 = [xLED(i) yLED(i) 0];
    # The apex angle LED i is seen by the x, y point
    # See https://www.mathworks.com/matlabcentral/answers/328240-calculate-the-3d-angle-between-two-vectors
    a = atan2(norm(cross(v1, v2)), dot(v1, v2));
    # Compute the intensity caused by LED i using the inverse square law, and by
    # taking into account the apex angle since LEDs emit a directional beam of light
    # See https://www.ledwatcher.com/light-measurements-explained/
    intensities(i) = (1 / norm([x y 0] - [xLED(i) yLED(i) h])) * (1 - cos(a/2));
  endfor

  I = sum(intensities);
endfunction

################################################################################
# PARAMETERS

# Radius of LED strip circle in mm
R = 90;

# Radius of the actual light surface in mm
# This value is the inside dimension of the AT130EDT dew shield...
r = 78.5;

# Distance between two LEDs on the strip in mm
l = 16.5;

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

xindex = 1;
yindex = 1;

for x = tx
  yindex = 1;
  for y = ty
     val = intensity(n, xLED, yLED, r, h, x, y);
     tz(xindex, yindex) = val;
     if val > 0 && val < minval
       minval = val;
     endif
     if val > maxval
       maxval = val;
     endif
     yindex++;
  endfor
  xindex++;
endfor

mesh(tx, ty, tz);

printf("Maximum intensity difference is %.1f%%\n", 100 * (maxval - minval) / maxval);

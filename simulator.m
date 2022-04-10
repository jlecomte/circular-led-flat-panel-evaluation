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
# theta = viewing angle when intensity of light beam is half of the value at 0°
# x = position of the point for which we want to know the intensity along the x-axis
# y = position of the point for which we want to know the intensity along the y-axis
function I = intensity(n, xLED, yLED, r, h, theta, x, y)
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
    # The viewing angle LED i is seen by the x, y point
    # See https://www.mathworks.com/matlabcentral/answers/328240-calculate-the-3d-angle-between-two-vectors
    alpha = atan2(norm(cross(v1, v2)), dot(v1, v2));
    # Compute the intensity caused by LED i using the inverse square law, and by
    # taking into account the viewing angle since LEDs emit a directional beam of light.
    intensities(i) = (1 / norm([x y 0] - [xLED(i) yLED(i) h])) * exp(-(alpha^2/(2*theta^2)));
  endfor

  I = sum(intensities);
endfunction

################################################################################
# PARAMETERS

# Radius of LED strip circle in mm
R = 85;

# Radius of the actual light surface in mm
# This value is the inside dimension of the AT130EDT dew shield...
r = 78.5;

# Distance between two LEDs on the strip in mm
# Standard values seem to be:
#   - 16.5 mm for "standard" LED strips
#   - 4.2mm for "high density" LED strips
l = 16.5;

# Height of the strip over reflective background sheet in mm
h = 5;

# Most manufacturers use θ1/2 (the viewing angle when intensity is half of the value at 0°)
# to characterize the angular distribution of LED light beams. In our application, we will
# consider a gaussian distribution, valid for viewing angles comprised in [-90°, +90°]
# It's only a model, an approximation, but it should give us an idea of what would happen,
# and empirically, based on experience, it seems like it might work...
# The following value is completely empirical, and was not measured.
theta = 60;

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

tx = ty = -r:2:r;

minval = Inf;
maxval = 0;

xindex = 1;
yindex = 1;

for x = tx
  yindex = 1;
  for y = ty
     val = intensity(n, xLED, yLED, r, h, theta, x, y);
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

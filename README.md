# Circular LED Strip Flat Panel Uniformity Evaluation

I am planning to build a flat field light panel using an LED strip placed against a wall encircling a diffusing sheet located a few mm below the LED strip. The LED strip itself would not be directly visible as it would be tucked under a small lip around the top perimeter of the wall. The diffusing sheet would be lit up by the LED strip and would reflect the light back towards to the telescope, possibly with one or two layers of a strongly diffusing material.

I was wondering how uniform the light intensity put out by such a panel would be. My expectation is that we should see obvious differences in brightness, especially around the LEDs themselves, even though they would not be directly visible thanks to that small lip.

To find out whether this would even work, I built this GNU Octave simulation. The calculation is pretty complicated. It uses the inverse square law, and also attempts to take into account the directionality of the light beam emitted by a single LED (using a simple Gaussian model). Here is the result using the default values, which match my telescope:

```bash
$ octave simulator.m
Maximum intensity difference is 32.5%
```

![Rendering of light intensity map](result.png)

This result shows that, indeed, a strong diffuser (for example, in the form of an opaque acrylic sheet) placed on top of the light panel, is required to provide good enough uniformity to get good flats.

As always, you can play with the parameters involved. They are documented in the source file (`simulator.m`)

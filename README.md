# Circular LED Strip Flat Panel Uniformity Evaluation

## Modeling

I am planning to build a flat field light panel using an LED strip placed against a wall encircling a diffusing sheet located a few mm below the LED strip. The LED strip itself would not be directly visible as it would be tucked under a small lip around the top perimeter of the wall. The diffusing sheet would be lit up by the LED strip and would reflect the light back towards to the telescope, possibly with one or two layers of a strongly diffusing material.

I was wondering how uniform the light intensity put out by such a panel would be. My expectation is that we should see obvious differences in brightness, especially around the LEDs themselves, even though they would not be directly visible thanks to that small lip.

To find out whether this would even work, I built this GNU Octave simulation. The calculation is pretty complicated. It involves:

* the viewing angle, since LEDs emit a directional beam of light (I use a Gaussian model here, which is just an approximation)
* the inverse square law, since light flux decreases inversely to the square of the distance from the light source
* the angle between the light ray and the background surface — the steeper the angle, the dimmer the point, which is why we have seasons on Earth...

Here is the result using the default values, which match my telescope:

```bash
$ octave simulator.m
Maximum intensity difference is 81.5%
```

![Rendering of light intensity map](images/result.png)

This result shows that this is not a workable solution as-is. And indeed, I built a prototype of this flat panel system, and what you see is a very bright ring that cannot be made into a uniform surface, no matter how many diffusing sheets you place in front of it.

In order to obtain a more uniform result, we need to look at what the manufacturers of flat panel LED TVs do. What we need is to use a Light Guide Panel (LGP), which is usually a sheet of acrylic mixed with reflecting particles, or processed with a laser engraver to create reflecting cavities. It is lit along its edges by the LED strip.

I found a reasonably affordable sheet of this kind of material [here](https://www.inventables.com/technologies/light-guide-acrylic-sheet). You may also purchase a light panel, and tear it down to get that component. Then, you can cut a circle out of it (using a router and a guide) to fit it into your flat panel.

You can play with the parameters involved. They are documented in the source file (`simulator.m`)

## Prototyping

Here is a photograph of the design I simulated, with a diffusing sheet on top of it. It clearly shows a lack of uniformity, and corresponds to the results I obtained in the simulation:

![The Light Guiding Plate(LGP)](images/no-lgp.png)

I wanted to try out an LGP so I ordered the [Taloya LED Flush Mount Ceiling Light](https://www.amazon.com/dp/B08GX81JB1) ($20) on Amazon, opened it up, and recovered the LGP as well as the white background. I did not use anything else from it. Then, I cut the LGP and a piece of 3mm thick white translucent acrylic I had from a previous project using a scroll saw, and I cleaned those up at the router table with a circular template, for a perfect fit and finish. I also cut the white background using a pair of scissors. I did not reuse the diffuser from the light fixture because I thought it was not diffusing enough. Finally, I 3D printed a mount for it that could eventually be integrated with my robotic lens cap. Here are a few photos of the project. The LED strip is a $14 "high density" LED strip I bought on Amazon [[link](https://www.amazon.com/dp/B07X53HXY1)].

The LGP nicely distributing the light emitted by the LED strip across the entire surface:

![The Light Guiding Plate(LGP)](images/lgp.png)

With the acrylic diffusing sheet (itself sitting a few mm above the LGP):

![The Light Guiding Plate(LGP)](images/lgp+diffuser.png)

The completed unit:

![The Light Guiding Plate(LGP)](images/flat-panel.png)

Test fitting the unit to my telescope (AT130EDT):

![The Light Guiding Plate(LGP)](images/flat-panel-fitted.png)

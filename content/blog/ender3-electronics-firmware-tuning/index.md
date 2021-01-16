+++
fragment = "content"
weight = "100"
date = "2021-01-15"
display_date = true
title = "Ender3 Upgrade Pt.3 (Electronics, Firmware, and Tuning)"

categories = ["Ender 3", "Projects"]

[asset]
  image = "blog/ender3-electronics-firmware-tuning/done.jpg"
  text = "Assembled and modified Ender 3 3D printer."
+++

Having completed the [mechanical assembly](https://blog.ryangeyer.me/blog/ender3-hero-me-gen5-upgrade/) on my Ender 3, it was time to move on to getting all of the electronics dialed in, and tuned.

# Marlin Firmware

The first step was to get the latest-and-greatest version of Marlin 2.0 and add my configuration. Since I intended to run the inductive/PINDA type bed leveling probe, that meant some changes to my configuration. As fate would have it, I'd go back to my BLTouch (more on that later).

I maintain my own branch of Marlin for this printer, to keep track of my changes, which you can find on [github](https://github.com/rgeyer/Marlin/tree/Ender3Pro).

I won't bore you with the details of getting PlatformIO setup since there are very thorough [directions](https://platformio.org/install) available directly from them. Suffice to say, you'll need it installed in order to compile a custom firmware.

I have been using the CLI of PlatformIO for some time for various Arduino projects, and I have it installed in a non-standard location. So for me, it's as simple as running `~/.platformio/penv/bin/pio run`.

That will build my firmware bin file. Now, how to upload it to the printer? It had been so long since I'd worked on this machine that I'd completely forgotten how it works. I tried connecting over USB, and using OctoPrint firmware updating plugins, all without success.

Before too long, I realized that all I had to do was drop my firmware binary onto an SD card, and make sure that SD card was inserted into my SKR 1.3 when it booted up.

That meant `cp.pio/build/LPC1768/firmware.bin` at `/path/to/sdcard/`, then unmounting the SD card, and putting it in the control board.

# Auto Bed Leveling

Ultimately, the step took A LOT of time, and I ended up reverting to my previous BLTouch configuration. I'll elaborate on this, but first, let's talk about my attempts to get the inductive sensor to work.

## What didn't work

I had bought a generic inductive proximity sensor. This [LJ18A3-8-Z/BX](https://www.amazon.com/gp/product/B01M1777XK/) to be precise. It's a NPN NO sensor, which is meant to operate at between 6 and 36V, with an approximate sensing distance of 8mm.

Given that the Ender 3 runs a 24v power supply, and my SKR 1.3 controller board is only able to tolerate 5v on it's z-min GPIO pin, some wiring needed to be done in order to make everything operate at it's appropriate voltages.

I'll spare you all the technical details, but basically what I needed was to power the sensor directly off of the 24v power supply, and use a voltage divider on the sensor pin to drop it down to a safe voltage for the controller board. I more-or-less followed the excellent guidance found in [this blog post](https://mertarauh.com/2017/01/18/dont-trust-the-internet-and-how-to-add-an-inductive-proximity-sensor-to-your-3d-printer-the-proper-and-easiest-way/).

The result was this simple circuit, which I threw together onto a piece of perfboard.

<div id="voltage-divider-carousel" class="carousel slide w-50 mx-auto" data-wrap="false">
  <ol class="carousel-indicators">
    <li data-target=#voltage-divider-carousel" data-slide-to="0" class="active"></li>
    <li data-target=#voltage-divider-carousel" data-slide-to="1"></li>
    <li data-target=#voltage-divider-carousel" data-slide-to="2"></li>    
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img class="d-block w-auto" src="/images/blog/ender3-electronics-firmware-tuning/voltage-divider-schematic.png" alt="Schematic of a voltage divider and power supply for an NPN NO transistor"/>
    </div>
    <div class="carousel-item">
      <img class="d-block w-auto" src="/images/blog/ender3-electronics-firmware-tuning/voltage-divider-front.jpg" alt="Voltage divider assembled on perfboard, front side."/>
    </div>
    <div class="carousel-item">
      <img class="d-block w-auto" src="/images/blog/ender3-electronics-firmware-tuning/voltage-divider-back.jpg" alt="Voltage divider assembled on perfboard, back side."/>
    </div>
  </div>
  <a class="carousel-control-prev" href="#voltage-divider-carousel" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#voltage-divider-carousel" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>

Proud of myself for wiring this up, and quickly bench-testing to see that it *did* properly trigger the sensor when it came into proximity with metal, I buttoned up the whole machine, ready to move on to tuning.

Unfortunately, when I finally dialed in my z offset, and tried my first test print, I found that the bed leveling seemed WAY off. It was digging into the build plate on the left and right sides, and was not anywhere NEAR the bed in the center.

I'd be lying if I told you I didn't spend several hours trying to troubleshoot this, but ultimately, I simply installed [Bed Visualizer](https://plugins.octoprint.org/plugins/bedlevelvisualizer/) on my OctoPrint server, and pretty quickly saw the issue.

With the inductive sensor, the firmware thought my bed looked like this.

<img class="w-50 mx-auto" src="/images/blog/ender3-electronics-firmware-tuning/e3-oem-mesh.png" alt="Mesh bed leveling showing VERY low corners, and a high center."/>

When in reality, it looked like this.

<img class="w-50 mx-auto" src="/images/blog/ender3-electronics-firmware-tuning/bedshape.jpg" alt="Actual photo of the bed, showing it low in the center, and high on the sides."/>

Something was clearly wrong. Rather than spend another eternity trying to figure out *why* it's mis-reading the shape of the bed, I made the decision to go back to my BLTouch. I had opted-out of using it because the pin had gotten bent and a little mangled in the past, and I thought this meant I had to replace the whole sensor. Imagine my surprise when I discovered that I could just [order a new pin](https://www.amazon.com/gp/product/B07L5T2LNW/)!

Once I printed a new part, tweaked the firmware, and got the BLTouch mounted, this was the resulting mesh.

<img class="w-50 mx-auto" src="/images/blog/ender3-electronics-firmware-tuning/e3-bltouch-mesh.png" alt="Mesh bed leveling showing VERY low corners, and a high center."/>

Okay! That's out of the way, tuning time!

# Tuning

There's not a *TON* of interesting stuff here, but it *is* necessary after all of these changes, to make sure things are dialed in and working.

## PID

I enabled PID autotuning via the LCD in my Marlin firmware, so I could very easily do this right away using [these](https://support.th3dstudio.com/hc/en-us/articles/360043728451-P-I-D-Hotend-Calibration-Guide) instructions.

That said, there are a couple factors which were important.

1. I cranked the cooling fan(s) up to 100%
2. I tuned for 225C since I do lots of PETG, so this is roughly between my PLA and PETG printing temps.

## Slicer

The HMG5 has DRAMATICALLY increased cooling capabilities, so I needed to adjust my slicer to allow lower fan speeds. It *was* set at min and max of 100% fan speed due to my old cooling setup. I set the minimum to 20%.

Also of note, is that I PID tuned with the cooling fans fully on. Even though the fan ducts aren't directed to the heater block, when the fans are at full speed, it impacts the ability for the heater block to warm up. When I did my first test prints, I kept getting thermal runaway errors!

## E-Steps

I followed [these](https://www.matterhackers.com/articles/how-to-calibrate-your-extruder) steps to dial in my e-steps.

That said, I had the right value set in my firmware config from the last time I had tuned, and the value remained the same. Namely 99.00.

## Z-Offset

I also enabled the z-offset wizard in my firmware. This is a great feature, and I followed the excellent video instructions from [TeachingTech](https://www.youtube.com/watch?v=fN_ndWvXGBQ) to use it (tho the steps are super easy).

After using the wizard, with the BLTouch, I found that no baby z stepping was required to further tune my z-offset, a huge bonus!

Take a look at this first layer!

<img class="w-100 mx-auto" src="/images/blog/ender3-electronics-firmware-tuning/flp.jpg" alt="Excellent, flat first layer of extrusion."/>

## Linear Acceleration

After getting a good first layer print, I *did* print a benchy. While the corners could use a little tuning, I was happy enough with them that I decided to forego linear acceleration tuning for the time being.

I did still have my old value in my firmware config and it seems adequate for now. I'll save fine tuning it for another day.

# Victory Print

With everything dialed in, it was time to print something useful as a victory lap.

A friend asked me to print [this](https://www.thingiverse.com/thing:2845739) model of a Google Android meant to hold a Google Home or Nest Mini, and it seemed like a perfectly appropriate choice for a victory print.

<div id="firstprint" class="carousel slide w-50 mx-auto" data-wrap="false">
  <ol class="carousel-indicators">
    <li data-target=#firstprint" data-slide-to="0" class="active"></li>
    <li data-target=#firstprint" data-slide-to="1"></li>
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img class="mx-auto" src="/images/blog/ender3-electronics-firmware-tuning/firstprint1.jpg" alt="Google Android model being printed."/>
    </div>
    <div class="carousel-item">
      <img class="mx-auto" src="/images/blog/ender3-electronics-firmware-tuning/firstprint2.jpg" alt="Finished Google Android Model."/>
    </div>
  </div>
  <a class="carousel-control-prev" href="#firstprint" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#firstprint" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>

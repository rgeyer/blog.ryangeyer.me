+++
fragment = "content"
weight = "100"
date = "2021-02-11"
display_date = true
title = "Ender 3 Thermal Runaway Troubleshooting"

categories = ["Ender 3"]

[asset]
 image = "blog/ender3-thermalrunaway-troubleshooting/gfdash.png"
 text = "Picture of the assembled hero me gen5 hotend and cooling system."
+++

After the recent upgrades to my Ender 3, I've been happily printing PLA on my new spring steel bed for some time. Now tho, I wanted to switch back to my glass bed and print some PETG.

In attempting to print, I've had the same model fail twice!

Both times, it was a "THERMAL RUNAWAY PROTECTION" error. This is where the firmware of the machine monitors the amount of power it's sending to the heaters, and measures the current temperature (relative to the desired temp), and if it thinks something is wrong, it'll shut the machine off rather than burn down your house. Pretty handy, really.

On the first failure, I assumed it was because I hadn't tweaked the filament profile to reduce my fan speed as I discussed [here](https://blog.ryangeyer.me/blog/ender3-electronics-firmware-tuning/#slicer) in my previous post.

Another print test, with the fans actually off, showed that this wasn't the case.

So, it was time to PID tune both the bed, and extruder heaters. However, this also didn't seem to help.

# Forensics

Okay, now I figure it's time to track the actual value(s) of these things before I start making more changes to my thermal runaway heuristics.

I found a plugin for exposing desired vs. actual temps and fan speeds to Prometheus - [Prometheus-Exporter](https://github.com/tg44/OctoPrint-Prometheus-Exporter), but it lacks the ability to report on the current PWM power used for either heater.

What I want to see is if when a fan kicks on, the temp drops, and the power used to power a heater goes up.

Naturally, my only choice was to modify the code in my own [fork](https://github.com/rgeyer/OctoPrint-Prometheus-Exporter/tree/temp_pwr).

Now I have my Grafana dashboard ready, and I can watch it in realtime, and see what's happening.

I still haven't resolved the issue, but this should give me the tools I need to track it down.

+++
fragment = "content"
weight = "100"
date = "2020-12-22"
display_date = true

categories = ["Ender 3","Projects"]

title = "Ender 3 Upgrades Pt. 1"
# summary = "Adding a PEI removable bed, a Hero Me Gen5, and an 18mm inductive ABL sensor to the Ender 3"

[asset]
  image = "blog/Screen Shot 2020-12-21 at 8.34.35 PM.png"
  text = "PrusaSlicer preview of Hero Me Gen 5 Parts"
+++

# Humble beginnings

If I'm honest, it's been so long since I printed with my Ender 3 that I don't really remember what sort of issues or failures it was suffering from.

I *think* that I was having some bed adhesion issues, and I've always had lackluster cooling on this machine. So after it has been sitting idle for over 6mo while my Prusa MK3s has been busy being a workhorse, it's time to work out the bugs and get the Ender 3 printing again.

When I first got it on the bench, I had a clear idea of what I wanted to accomplish. I wanted to replace my bed leveling springs with solid mounts, add a magnetic removable PEI sheet bed, and swap out my BLTouch for an 18mm inductive (PINDA style) probe for auto bed leveling (ABL).

I had begun to suspect the BLTouch's accuracy ever since I had a particularly messy failed print, that actually bent the probe! I did manage to clean it up, and bend it back, and things seemed to be working just fine. I was just never as confident that it was doing it's job.

# Feature creep

In order to mount the new probe, I needed to print a new mount for it. "No big deal!" I said to myself. Except, that's never how it turns out.

You see, my Ender 3 already has a few modifications on it. Namely, I have a genuine E3D V6 HotEnd, and an early Basaraba direct drive gantry plate. I hold the whole thing together with some [3D printed mounts](https://www.thingiverse.com/thing:3393889) from the designer of the [Hero Me](https://www.thingiverse.com/thing:4460970) modular hot end cooling system. This particular combination has worked very well for me, but as I was about to find out, it's become completely outdated by new designs and options.

If I wanted to switch to the new probe, it wouldn't fit "under" the direct drive extruder anymore since it's quite a tall sensor. All of the available options for 3D printable mounts and cooling options no longer supported my directdrive gantry plate anymore either!

So I decided I'd go ahead with printing the full Hero Me Gen5, with dual 5015 cooling fans. This meant also upgrading my gantry plate to something which would be compatible. In looking over all my parts to make sure I had a complete BOM, I realized that this entire time I've *ALSO* been running a 12v 5015 part cooling fan on my 24v powersupply, and that the Hero Me Gen5 requires a 4020 fan for the hotend rather than the 30mm fan that the E3D V6 already uses!

# Final task list

With all of that sorted, here's everything that will be included in this project.

In this post I'll be upgrading the following;
* Install a PEI magnetic removable print surface
* Hero Me Gen5 HotEnd cooling system w/ dual 5015 parts cooling fans.
* 18mm Industrial Inductive ABL sensor
* [PrinterMods (Basaraba's new "official" store) Modular DirectDrive (MDD) v1.3 gantry plate](https://printermods.com/products/direct-drive-mod-for-creality-ender-3-cr-10)
* PrinterMods Aluminum Extruder parts
* Update Marlin firmware
* (Re)Calibrate
  * HotEnd PID
  * Linear acceleration
  * E steps

# The work begins

After encountering all of the feature creep, I ordered parts, and started printing the Hero Me Gen5 parts, which means I have a few days to wait until I can dive in and really get my hands dirty. Stay tuned here for updates and I'll break down each of these tasks.

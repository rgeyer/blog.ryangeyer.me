+++
title = "Tasmota for Topgreener TGWF115PQM"
date = "2020-12-21"
categories = ["Home Automation"]
draft = true

fragment = "content"
weight = 100
display_date = true
comments = true

[asset]
  image = "blog/tasmota-for-topgreener-tgwf115pqm/PXL_20201221_221010894.jpg"
+++

In an ongoing effort to provide automation, and generally gain insights over what's happening in my home, I've acquired several of these TopGreener smartplugs.

In this blog post I'll show you how to;
* Flash them with custom firmware for tasmota
* Connect them to an MQTT broker using TLS and username/password authentication
* Calibrate tasmota against them to get accurate(ish) wattage/power readings from them
* Monitor power utilization with Grafana

Template: `{"NAME":"TGWF115PQM","GPIO":[0,56,0,17,134,132,0,0,131,57,21,0,0],"FLAG":0,"BASE":18}` - https://templates.blakadder.com/topgreener_TGWF115APM.html

Tuya Convert - https://github.com/ct-Open-Source/tuya-convert

Power Calibration - https://tasmota.github.io/docs/Power-Monitoring-Calibration/

Home Assistant Auto Discovery - SetOption19 1

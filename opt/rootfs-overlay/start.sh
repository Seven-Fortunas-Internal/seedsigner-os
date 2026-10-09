#!/bin/sh

cd /opt/src/

#/usr/bin/python3 main.py >> /dev/kmsg 2>&1 &  # version that writes output to dmesg
# Production: the app's output goes nowhere (nothing on the HDMI console).
/usr/bin/python3 main.py </dev/null >/dev/null 2>&1 &

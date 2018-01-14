#!/bin/bash

# Disable DPMS / Screen blanking
xset -dpms
xset s off

# Reset the framebuffer's colour-depth
fbset -depth $( cat /sys/module/*fb*/parameters/fbdepth );

# Hide the cursor (move it to the bottom-right, comment out if you want mouse interaction)
xwit -root -warp $( cat /sys/module/*fb*/parameters/fbwidth ) $( cat /sys/module/*fb*/parameters/fbheight )

# Start the window manager (remove "-use_cursor no" if you actually want mouse interaction)
#matchbox-window-manager -use_titlebar no -use_cursor no &

# Launch window manager without title bar.
exec matchbox-window-manager -use_titlebar no -use_cursor no &

# Run unclutter
unclutter &

chromium --incognito --kiosk --noerrdialogs --disable-translate-new-ux --disable-cache --disk-cache-dir=/dev/null --disk-cache-size=1 --app=$( cat /home/pi/.url )
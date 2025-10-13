#!/bin/bash

# Check if any audio sinks are in a "RUNNING" state.
if pactl list sinks | grep -q "State: RUNNING"; then
    # If audio is playing, reset the X idle timer to prevent locking and sleeping.
    xset s reset
else
    # If no audio is playing, proceed with locking the screen using i3lock.
    # The --nofork flag is crucial for xss-lock to manage the process correctly.
    i3lock -i /usr/share/backgrounds/default.png -t --nofork
fi

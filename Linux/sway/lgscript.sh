#!/bin/bash

waylogout \
	--hide-cancel \
	--screenshots \
	--font="Baloo 2" \
	--effect-blur=7x5 \
	--indicator-thickness=20 \
	--ring-color=4c566aaa \
	--inside-color=4c566a66 \
	--text-color=#2e3440aa \
	--line-color=00000000 \
	--ring-selection-color=8fbcbbaa \
	--inside-selection-color=8fbcbb66 \
	--text-selection-color=eaeaeaaa \
	--line-selection-color=00000000 \
	--logout-command="swaymsg exit" \
	--poweroff-command="loginctl poweroff" \
	--reboot-command="loginctl reboot" \
	--selection-label

#!/bin/bash

## Mind-Mapping of device auto-rotate implementation from sls_tablet_mode_daemon
### General Remark:
### - don't do thing if goto lid closed mode
### On Wayland/non-GNOME: Not supported
### On Wayland/GNOME
### - Laptop>>Slate: do nothing
### - Laptop>>Closed: do nothing
### - Laptop>>Tablet: handled by v1
### - Slate>>Laptop: do nothing
### - Slate>>Tablet: handled by v1
### - Slate>>Closed: do nothing
### - Closed>>Laptop: handled by v2
###   - GNOME-shell trigger auto-rotation even option is turned off, so let v2 handle (v1 not handle this)
### - Closed>>Slate: handled by v2
###   - GNOME-shell trigger auto-rotation even option is turned off, so let v2 handle (v1 not handle this)
### - Closed>>Tablet: handled by v1 (v1, because closed>>tablet make tabletsw module enter to SW_TABLET_MODE, v1 is triggered the auto-rotate)
### - Tablet>>Slate: handled by v1
### - Tablet>>Laptop: handled by v1
### - Tablet>>Closed: do nothing
### On X11/Not-GNOME
### - Laptop>>Slate: do nothing
### - Laptop>>Closed: do nothing
### - Laptop>>Tablet: do nothing
### - Slate>>Laptop: do nothing
### - Slate>>Tablet: do nothing
### - Slate>>Closed: do nothing
### - Closed>>Laptop: do nothing
### - Closed>>Slate: do nothing
### - Closed>>Tablet: do nothing
### - Tablet>>Slate: handled by v2
###   - let v2 handle this (v1 not handle this), rotate to normal, when switching back to laptop/slate
### - Tablet>>Laptop: handled by v2
###   - let v2 handle this (v1 not handle this), rotate to normal, when switching back to laptop/slate
### - Tablet>>Closed: do nothing
### On X11/GNOME
### - Laptop>>Slate: do nothing
### - Laptop>>Closed: do nothing
### - Laptop>>Tablet: do nothing
### - Slate>>Laptop: do nothing
### - Slate>>Tablet: do nothing
### - Slate>>Closed: do nothing
### - Closed>>Laptop: handled by v2
###   - GNOME-shell trigger auto-rotation even option is turned off, so let v2 handle (v1 not handle this)
### - Closed>>Slate: handled by v2
###   - GNOME-shell trigger auto-rotation even option is turned off, so let v2 handle (v1 not handle this)
### - Closed>>Tablet: handled by v2
###   - GNOME-shell trigger auto-rotation even option is turned off, so let v2 handle (v1 not handle this)
### - Tablet>>Slate: handled by v2
###   - let v2 handle this (v1 not handle this), rotate to normal, when switching back to laptop/slate 
### - Tablet>>Laptop: handled by v2
###   - let v2 handle this (v1 not handle this), rotate to normal, when switching back to laptop/slate
### - Tablet>>Closed: do nothing
##

IS_PREPARE=1
echo "[NOTICE:sls_tablet_mode_userdaemon_v2] From now on, The script should output only with the header of the script name, if any line output to screen/stdout without it, it mean something wrong (such as mis-configured or incompatible thing occured)"

# location of file that place indicating value for device tablet state, must same as sysdaemon (v2)
RUNDIR=/run/sls_tablet_mode_daemon
DEV_STATE_FILE=/sys/devices/platform/MSHW0123\:00/01\:26\:01\:00\:01/state
determine_and_set() {
	NEW_VALUE=`cat $DEV_STATE_FILE`
	if (($IS_PREPARE)); then true
	else
		if [[ "$NEW_VALUE" == "laptop" ]]; then tolaptop
		elif [[ "$NEW_VALUE" == "slate" ]]; then toslate
		elif [[ "$NEW_VALUE" == "closed" ]]; then tolid
		elif [[ "$NEW_VALUE" == "tablet" ]]; then totablet
		else to_laptop; fi
	fi
	OLD_VALUE=$NEW_VALUE
}
tolaptop() {
	if [[ "$OLD_VALUE" == "tablet" ]]; then autorotate_tonormal_x11_conditioncheck
	elif [[ "$OLD_VALUE" == "closed" && "`echo $XDG_CURRENT_DESKTOP | grep -i -o -m1 "GNOME"`" == "GNOME" ]]; then
		is_on_wayland
		if [[ "$?"=="0" ]]; then autorotate_tonormal_x11
		else autorotate_tonormal_gnome_wl; fi
	fi
	## for PulseEffects integration, configure your preset below
	is_pulseeffects_run
	if (($?)); then pulseeffects -l SLS_laptop_dev; fi
	##
}
toslate() {
	if [[ "$OLD_VALUE" == "tablet" ]]; then autorotate_tonormal_x11_conditioncheck
	elif [[ "$OLD_VALUE" == "closed" && "`echo $XDG_CURRENT_DESKTOP | grep -i -o -m1 "GNOME"`" == "GNOME" ]]; then
		is_on_wayland
		if [[ "$?"=="0" ]]; then autorotate_tonormal_x11
		else autorotate_tonormal_gnome_wl; fi
	fi
	## for PulseEffects integration, configure your preset below
	is_pulseeffects_run
	if (($?)); then pulseeffects -l SLS_slate_dev; fi
	##
}
totablet() {
	if [[ "$OLD_VALUE" == "closed" && "`echo $XDG_CURRENT_DESKTOP | grep -i -o -m1 "GNOME"`" == "GNOME" ]]; then
		is_on_wayland
		if [[ "$?"=="0" ]]; then autorotate_tonormal_x11; fi
	fi
	## for PulseEffects integration, configure your preset below
	is_pulseeffects_run
	if (($?)); then pulseeffects -l SLS_tablet_dev; fi
	##
}
tolid() {
	## for PulseEffects integration, configure your preset below
	is_pulseeffects_run
	if (($?)); then pulseeffects -l SLS_lid_dev; fi
	##
}
is_on_wayland() {
	if [[ "$XDG_SESSION_TYPE" != "wayland" ]]; then ISON_WAYLAND=0
	else ISON_WAYLAND=1; fi
	return $ISON_WAYLAND
}
autorotate_tonormal_x11_conditioncheck() {
	is_on_wayland
	if [[ "$?"=="0" ]]; then autorotate_tonormal_x11; fi
}
autorotate_tonormal_x11() { xrandr --output eDP-1 --rotate normal >/dev/null; }
autorotate_tonormal_gnome_wl() {
	# set to location of file gnome-randr.py (for use on Wayland)	
	~/Applications/Scripts/FromOthers/gnome-randr.py --output eDP-1 --rotate normal >/dev/null;
}
is_pulseeffects_run() {
	PE_PID=`pidof pulseeffects`
	if [[ "$PE_PID" != "" ]]; then return 1
	else return 0; fi
}

OLD_VALUE=
determine_and_set
IS_PREPARE=0
echo "[NOTICE:sls_tablet_mode_userdaemon_v2] preparing done, monitoring..."

while (true); do
	cat $RUNDIR/state_monitor
	determine_and_set	
done
exit 0;

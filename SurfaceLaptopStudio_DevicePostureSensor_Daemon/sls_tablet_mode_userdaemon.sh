#!/bin/bash

IS_PREPARE=1
echo "[NOTICE:sls_tablet_mode_userdaemon] From now on, The script should output only with the header of the script name, if any line output to screen/stdout without it, it mean something wrong (such as mis-configured or incompatible thing occured)"

# location of file that place indicating value for device tablet state, must same as sysdaemon (v1)
RUNDIR=/run/sls_tablet_mode_daemon
determine_and_set() {
	if ((`cat $RUNDIR/is_sw_tablet_mode`)); then NEW_VALUE=1
	else NEW_VALUE=0; fi
	if (($IS_PREPARE)); then true
	else
		if ((NEW_VALUE)); then enable_tablet_mode_onuser
		else disable_tablet_mode_onuser; fi
	fi
}
enable_tablet_mode_onuser() {
	# reuse code below because in GNOME-shell Wayland, after put in Linux input event's tablet mode, the screen will be rotated automatically according to sensor for one time, even last settings is set to off.
	if [[ "`cat /sys/devices/platform/MSHW0123\:00/01\:26\:01\:00\:01/state`" != "closed" && "$XDG_SESSION_TYPE" == "wayland" && "`echo $XDG_CURRENT_DESKTOP | grep -i -o -m1 "GNOME"`" == "GNOME" ]]; then
		# different from below code: adding delay
		sleep 1
		# set to location of file gnome-randr.py (for use on Wayland)
		~/Applications/Scripts/FromOthers/gnome-randr.py --output eDP-1 --rotate normal >/dev/null
	fi
}
disable_tablet_mode_onuser() {
	# this code below doesn't run on any except GNOME-Shell Wayland, my script detect it for you
	# this auto rotate screen to normal when tablet mode is off (On GNOME Wayland, if it off, then screen rotation will be disabled, so if current state of screen rotation is not in normal, then set it.)
	# also prevent this from running on closed lid state, it wont works
	# for X11 / and some auto-rotate features for GNOME-Wayland, we use another version of script
	if [[ "`cat /sys/devices/platform/MSHW0123\:00/01\:26\:01\:00\:01/state`" != "closed" && "$XDG_SESSION_TYPE" == "wayland" && "`echo $XDG_CURRENT_DESKTOP | grep -i -o -m1 "GNOME"`" == "GNOME" ]]; then
		# set to location of file gnome-randr.py (for use on Wayland)
		~/Applications/Scripts/FromOthers/gnome-randr.py --output eDP-1 --rotate normal >/dev/null
	fi
}

determine_and_set
IS_PREPARE=0
echo "[NOTICE:sls_tablet_mode_userdaemon] preparing done, monitoring..."

while (true); do
	cat $RUNDIR/sw_tablet_mode_monitor
	determine_and_set	
done
exit 0;

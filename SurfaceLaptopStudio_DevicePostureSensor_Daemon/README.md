# The Surface Laptop Studio Tablet Mode State Sensor Integration Daemon

**_Warning: This is not well tested, and have not tested on Non-GNOME DE. So it is buggy and not stable, but open contribution is welcomed in either issues/PR._**

This zip consists of
- sls_table_mode_sysdaemon_withdriver.sh: (Implementation v1) Daemon to run as root, for communicate with userdaemon of same implementation
- sls_table_mode_userdaemon_withdriver.sh: (Implementation v1) Daemon to run as individual user
- sls_table_mode_sysdaemon_withdriver_v2.sh: same as above but using another implementation
- sls_table_mode_userdaemon_withdriver_v2.sh: same as above but using another implementation

## What it can do
- sysdaemon (v1):
	- report SW_TABLET_MODE to folder that set in $RUNDIR variable that set in file of sysdaemon/userdaemon of implementation v1
	- alert of changed SW_TABLET_MODE state through pipe file at $RUNDIR/sw_tablet_mode_monitor
- userdaemon (v1):
	- this depends and gets data from sysdaemon (v1)
	- do action on user's session-side, based on Linux input event's tablet mode
		- Auto-Rotate based on mentioned state, for enhancing UX
			- This implementation (v1) only works on GNOME Wayland
			- some features listed below, requires implementation v2:
				- GNOME-Wayland: Auto-Rotate to normal orientation if posture comes back from lid closed to either laptop/slate
				- GNOME-X11: Same as above but also appiled when comes back from lid to tablet state
- sysdaemon (v2):
	- alert of changed device posture event through pipe file at $RUNDIR/state_monitor
- userdaemon (v2):
	- this depends and gets data from sysdaemon (v2)
	- do action on user's session-side, based on SLS device posture state
		- Auto-Rotate based on mentioned state, for enhancing UX
			- This implementation (v2) works on:
				- GNOME on X11
				- GNOME on Wayland (for some features that implementation (v1) do not handle for them)
				- Non-GNOME on X11
		- PulseEffects preset changing based on mentioned state

## Requirement
- Linux kernel from GitHub_Repo:linux-surface/linux-surface >=5.18.4-surface
- Please see in these 4 script files

## Installation
1) Setup 4 scripts: see on code comment in the file

## Usage
1) Run and no-wait (leave it run) "sls_table_mode_sysdaemon.sh" as root
2) Run and no-wait (leave it run) "sls_table_mode_sysdaemon_v2.sh" as root (must run after 1.)
3) Run and no-wait (leave it run) "sls_table_mode_userdaemon.sh" on independent user must run after 1.
4) Run and no-wait (leave it run) "sls_table_mode_userdaemon_v2.sh" on independent user must run after 2.

## After Usage
1) can delete folder that ref by $RUNDIR variable of each script safely 

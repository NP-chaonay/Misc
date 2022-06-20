#!/bin/bash

IS_PREPARE=1
echo "[NOTICE:sls_tablet_mode_sysdaemon_v2] From now on, The script should output only with the header of the script name, if any line output to screen/stdout without it, it mean something wrong (such as mis-configured or incompatible thing occured)"

# set state update interval
UPDATE_INTERVAL=1
# location of file that place indicating value for device tablet state, must be the same as user-daemon (v2)
RUNDIR=/run/sls_tablet_mode_daemon
DEV_STATE_FILE=/sys/devices/platform/MSHW0123\:00/01\:26\:01\:00\:01/state
determine_and_set() {
	NEW_VALUE=`cat $DEV_STATE_FILE`
	if [[ "$OLD_VALUE" != "$NEW_VALUE" ]]; then
		if (($IS_PREPARE)); then true
		else echo -n > $RUNDIR/state_monitor; fi
		OLD_VALUE=$NEW_VALUE
	fi
}

OLD_VALUE=
if [[ -d $RUNDIR ]]; then true
else
	echo "[ERROR:sls_tablet_mode_sysdaemon_v2] require sls_tablet_mode_sysdaemon (v1) to be executing first"
	exit 1
fi
mknod $RUNDIR/state_monitor p
determine_and_set
IS_PREPARE=0
echo "[NOTICE:sls_tablet_mode_sysdaemon] preparing done, monitoring..."

while (true); do
	sleep $UPDATE_INTERVAL
	determine_and_set
done
exit 0;

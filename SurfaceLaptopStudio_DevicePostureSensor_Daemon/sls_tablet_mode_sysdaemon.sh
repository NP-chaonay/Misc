#!/bin/bash

IS_PREPARE=1
echo "[NOTICE:sls_tablet_mode_sysdaemon] From now on, The script should output only with the header of the script name, if any line output to screen/stdout without it, it mean something wrong (such as mis-configured or incompatible thing occured)"

# location of file that place indicating value for device tablet state, must be the same as user-daemon (v1)
RUNDIR=/run/sls_tablet_mode_daemon
DEV_FILE=/dev/input/`find /sys/module/surface_aggregator_tabletsw/drivers/surface_aggregator\:surface_aggregator_tablet_mode_switch/01\:26\:01\:00\:01/input/ | egrep -o -m1 "event[0-9]+"`
determine_and_set() {
	# SW_TABLET_MODE=0 >> exit 0; if =1 then exit 10;
	if (evtest --query $DEV_FILE EV_SW SW_TABLET_MODE); then
		echo -n "0" > $RUNDIR/is_sw_tablet_mode
	else
		echo -n "1" > $RUNDIR/is_sw_tablet_mode
	fi
	if (($IS_PREPARE)); then true;
	else echo -n > $RUNDIR/sw_tablet_mode_monitor; fi
}

rm -rf "$RUNDIR" &>/dev/null
mkdir -p $RUNDIR
mknod $RUNDIR/sw_tablet_mode_monitor p
touch $RUNDIR/is_sw_tablet_mode
determine_and_set
IS_PREPARE=0
echo "[NOTICE:sls_tablet_mode_sysdaemon] preparing done, monitoring..."

while (true); do
	cat $DEV_FILE | head -z -c0
	determine_and_set
done
exit 0;

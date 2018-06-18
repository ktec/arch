#!/bin/sh

# Set brightness when redshift status changes

case $1 in
	period-changed)
		case $3 in
			night)
				brightness -set 300
				;;
			transition)
				brightness -set 600
				;;
			daytime)
				brightness -set 1000
				;;
		esac
		;;
esac

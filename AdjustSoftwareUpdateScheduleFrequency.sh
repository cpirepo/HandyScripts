#!/bin/bash
#
#
#
if [[ $# != 1 ]];then
printf "We need a amount of days between checks \n"
exit
fi

sudo defaults write com.apple.SoftwareUpdate ScheduleFrequency -int $1

NEWDAYS=`sudo defaults read com.apple.SoftwareUpdate ScheduleFrequency`

printf "We are now checking every $NEWDAYS days. \n"

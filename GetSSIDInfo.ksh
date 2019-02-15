#!/bin/ksh
#
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 

print "`date`"
networksetup -getairportnetwork en1

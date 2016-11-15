#!/bin/bash

# Create SSMTP config
CFGFILE=/etc/ssmtp/ssmtp.conf

cat >$CFGFILE <<CONFIG
root=root
mailhub=${MAILHUB}
FromLineOverride=YES
CONFIG

chmod 640 $CFGFILE
chown root:mail $CFGFILE


# Start check_mk
omd start && tail -f /var/log/nagios.log


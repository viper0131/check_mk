#!/bin/bash

# Init check_mk instance
if [ ! -d "/opt/omd/sites/${CMK_SITE}" ] ; then
    omd create ${CMK_SITE}
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0
    htpasswd -b -m /omd/sites/${CMK_SITE}/etc/htpasswd cmkadmin ${CMK_PASSWORD}
    ln -s "/omd/sites/${CMK_SITE}/var/log/nagios.log" /var/log/nagios.log
    /opt/redirector.sh ${CMK_SITE} > /omd/sites/${CMK_SITE}/var/www/index.html
fi


# Create SSMTP config
CFGFILE=/etc/ssmtp/ssmtp.conf

cat >$CFGFILE <<CONFIG
root=root
mailhub=${MAILHUB}
FromLineOverride=YES
CONFIG

chmod 640 $CFGFILE
chown root:mail $CFGFILE


# Start cron daemon
/usr/sbin/crond

# Start check_mk
omd start && tail -f /var/log/nagios.log


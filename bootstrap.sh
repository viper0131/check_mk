#!/bin/bash


# Dir for store system files
STORETC="/opt/omd/etc"

# Init check_mk instance
if [ ! -d "/opt/omd/sites/${CMK_SITE}" ] ; then
    omd create ${CMK_SITE}
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0
    htpasswd -b -m /omd/sites/${CMK_SITE}/etc/htpasswd cmkadmin ${CMK_PASSWORD}
    /opt/redirector.sh ${CMK_SITE} > /omd/sites/${CMK_SITE}/var/www/index.html
    
    # Check dir and save omd tmpfs for repeated use
    [ ! -d ${STORETC} ] && \
	mkdir -p ${STORETC} && \
	grep omd /etc/fstab > ${STORETC}/fstab
else
    # Restore and create settings omd for using with new container
    useradd -M -c "OMD site ${CMK_SITE}" -b "/omd/sites" -U -G apache
    cat ${STORETC}/fstab >> /etc/fstab
    mount tmpfs
    omd enable ${CMK_SITE}
fi


# This link needs always
ln -s "/omd/sites/${CMK_SITE}/var/log/nagios.log" /var/log/nagios.log


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

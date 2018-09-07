#!/bin/bash

BASE_OMD="/opt/omd/sites"

# Init check_mk instance
if [ ! -d "${BASE_OMD}/${CMK_SITE}" ] ; then
    omd create ${CMK_SITE}
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0
    htpasswd -b -m /omd/sites/${CMK_SITE}/etc/htpasswd cmkadmin ${CMK_PASSWORD}
    /opt/redirector.sh ${CMK_SITE} > /omd/sites/${CMK_SITE}/var/www/index.html
    
    # Save omd record about tmpfs for second use
    grep omd /etc/fstab > ${BASE_OMD}/${CMK_SITE}/.fstab.tmpfs
else
    # Create user and group for using existing site with new container
    useradd -M -c "OMD site ${CMK_SITE}" -b "/omd/sites" -U -G omd ${CMK_SITE}
    usermod -aG ${CMK_SITE} apache
    chown -R ${CMK_SITE}:${CMK_SITE} ${BASE_OMD}/${CMK_SITE}
    # Restore tmpfs
    cat ${BASE_OMD}/${CMK_SITE}/.fstab.tmpfs >> /etc/fstab
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

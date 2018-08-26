#!/bin/bash

# Check_mk update script 

VERSION=$1
DOWNLOADNR=$2
URL=https://mathias-kettner.de/support/${VERSION}/check-mk-raw-${VERSION}-el7-${DOWNLOADNR}.x86_64.rpm

echo "===START UPDATE==="
echo "=DOWNLOAD AND INSTALL NEW CHECK_MK VERSION="
yum install -y $URL
if [ $? -eq 1 ]; then
	echo "=ERROR: cannot install the new version of check_mk (Version ${VERSION})="
	echo "Check if this URL exist: $URL"
	exit 1
fi
echo "=NEW CHECK_MK VERSION ($VERSION) INSTALLED="
echo "=STOP SITE $CMK_SITE="
omd stop $CMK_SITE
if [ $? -eq 1 ]; then
	echo "=ERROR: cannot stop site [$CMK_SITE]="
	exit 1
fi
echo "=SITE $CMK_SITE STOPPED="
echo "=STARTING UPDATE SITE $CMK_SITE="
omd update $CMK_SITE
if [ $? -eq 1 ]; then
	echo "=ERROR: cannot update site [$CMK_SITE] to $VERSION="
	exit 1
fi
echo "=SITE $CMK_SITE UPDATED="
echo "=STARTING SITE $CMK_SITE="
omd start $CMK_SITE
if [ $? -eq 1 ]; then
	echo "=ERROR: cannot start site [$CMK_SITE]="
	exit 1
fi
echo "=SITE $CMK_SITE STARTED="
echo "===SITE $CMK_SITE SUCCESSFULLY UPDATED TO VERSION $VERSION==="
exit 0

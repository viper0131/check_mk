FROM centos:7.3.1611

ENV CMK_VERSION="1.2.8p25"
ENV CMK_DOWNLOADNR="48"
ENV CMK_SITE="mva"
ENV MAILHUB="undefined"

RUN \
    yum -y install epel-release && \
    yum install -y --nogpgcheck time \
        traceroute \
        dialog \
        fping \
        graphviz \
        graphviz-gd \
        httpd \
        libevent \
        libdbi \
        libmcrypt \
        libtool-ltdl \
        mod_fcgid \
        mariadb-server \
        net-snmp \
        net-snmp-utils \
        pango \
        patch \
        perl-Net-SNMP \
        perl-Locale-Maketext-Simple \
        perl-IO-Zlib \
        php \
        php-mbstring \
        php-pdo \
        php-gd \
        rsync \
        uuid \
        xinetd \
        cronie \
        python-ldap \
        freeradius-utils \
        libpcap \
        python-reportlab \
        bind-utils \
        python-imaging \
        poppler-utils \
        libgsf \
        rpm-build \
        pyOpenSSL \
        fping \
        libmcrypt \
        perl-Net-SNMP \
        which \
        ssmtp \
        mailx \
        openssh-clients \
        samba-client \
        rpcbind

ADD    bootstrap.sh /opt/
ADD    redirector.sh /opt/
EXPOSE 5000/tcp

#VOLUME /opt/omd

# retrieve and install the check mk binaries
RUN rpm -ivh https://mathias-kettner.de/support/${CMK_VERSION}/check-mk-raw-${CMK_VERSION}-el7-${CMK_DOWNLOADNR}.x86_64.rpm

# Creation of the site fails on creating tempfs, ignore it.
# Now turn tempfs off after creating the site
RUN omd create ${CMK_SITE} || \
    omd config ${CMK_SITE} set DEFAULT_GUI check_mk && \
    omd config ${CMK_SITE} set TMPFS off && \
    omd config ${CMK_SITE} set CRONTAB on && \
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0 && \
    omd config ${CMK_SITE} set APACHE_TCP_PORT 5000 && \
    ln -s "/omd/sites/${CMK_SITE}/var/log/nagios.log" /var/log/nagios.log && \
    /opt/redirector.sh ${CMK_SITE} > /omd/sites/${CMK_SITE}/var/www/index.html
    

WORKDIR /omd
ENTRYPOINT ["/opt/bootstrap.sh"]


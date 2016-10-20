FROM centos:7

ENV CMK_VERSION="1.2.8p12"
ENV CMK_SITE="mva"

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
        which

ADD    bootstrap.sh /opt/
EXPOSE 5000/tcp

#VOLUME /opt/omd

# retrieve and install the check mk binaries
RUN rpm -ivh https://mathias-kettner.de/support/${CMK_VERSION}/check-mk-raw-${CMK_VERSION}-el7-36.x86_64.rpm

# Creation of the site fails on creating tempfs, ignore it.
# Now turn tempfs off after creating the site
RUN omd create ${CMK_SITE} || \
    omd config ${CMK_SITE} set DEFAULT_GUI check_mk && \
    omd config ${CMK_SITE} set TMPFS off && \
    omd config ${CMK_SITE} set CRONTAB off && \
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0 && \
    omd config ${CMK_SITE} set APACHE_TCP_PORT 5000 && \
    su - ${CMK_SITE} -c "htpasswd -b ~/etc/htpasswd admin system" && \
    echo su - ${CMK_SITE} -c "htpasswd -D ~/etc/htpasswd omdadmin"
    

WORKDIR /omd
ENTRYPOINT ["/opt/bootstrap.sh","${CMK_SITE}"]

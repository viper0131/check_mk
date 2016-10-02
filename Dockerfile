FROM centos:7

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
        perl-Net-SNMP

RUN rpm -ivh https://mathias-kettner.de/support/1.2.8p11/check-mk-raw-1.2.8p11-el7-36.x86_64.rpm

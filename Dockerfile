FROM centos:7.5.1804

# ARG can be overwritten on build time using "docker build --build-arg name=value"
ARG CMK_VERSION_ARG="1.5.0p2"
ARG CMK_DOWNLOADNR_ARG="38"
ARG CMK_SITE_ARG="mva"
ARG MAILHUB="undefined"
ARG TIMEZONE="UTC"

# After Build the ENV vars are initialized with the value of there build argument.
ENV CMK_VERSION=${CMK_VERSION_ARG}
ENV CMK_DOWNLOADNR=${CMK_DOWNLOADNR_ARG}
ENV CMK_SITE=${CMK_SITE_ARG}
ENV MAILHUB=${MAILHUB}
ENV TIMEZONE=${TIMEZONE}

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
        php-xml \
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

# set timezone
RUN rm -f /etc/localtime
RUN ln -s "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime

# retrieve and install the check mk binaries
RUN rpm -ivh https://mathias-kettner.de/support/${CMK_VERSION}/check-mk-raw-${CMK_VERSION}-el7-${CMK_DOWNLOADNR}.x86_64.rpm

# fake fstab
RUN echo "# /etc/fstab" > /etc/fstab

# new site is now created on first startup (needs SYS_ADMIN capability!)
WORKDIR /omd
ENTRYPOINT ["/opt/bootstrap.sh"]


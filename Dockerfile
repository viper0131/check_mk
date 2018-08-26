FROM centos:7

# ARG can be overwritten on build time using "docker build --build-arg name=value"
ARG CMK_VERSION_ARG="1.5.0p2"   # https://mathias-kettner.com/download.php
ARG CMK_DOWNLOADNR_ARG="38"
ARG CMK_SITE_ARG="mva"
ARG MAILHUB="undefined"

# After Build the ENV vars are initialized with the value of there build argument.
ENV CMK_VERSION=${CMK_VERSION_ARG}
ENV CMK_DOWNLOADNR=${CMK_DOWNLOADNR_ARG}
ENV CMK_SITE=${CMK_SITE_ARG}
ENV MAILHUB=${MAILHUB}

RUN yum -y install epel-release

ADD    bootstrap.sh /opt/
ADD    redirector.sh /opt/
EXPOSE 5000/tcp

# retrieve and install the check mk binaries and its dependencies
RUN yum install --nogpgcheck -y ssmtp https://mathias-kettner.de/support/${CMK_VERSION}/check-mk-raw-${CMK_VERSION}-el7-${CMK_DOWNLOADNR}.x86_64.rpm

# fake fstab
RUN echo "# /etc/fstab" > /etc/fstab

# new site is now created on first startup (needs SYS_ADMIN capability!)
WORKDIR /omd
ENTRYPOINT ["/opt/bootstrap.sh"]


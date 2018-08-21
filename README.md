# nlmacamp/check_mk:1.4.0p35

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
- [Updates](#updates)


# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Check_MK](https://mathias-kettner.de/check_mk.html).

Check_MK is comprehensive IT monitoring solution in the tradition of [Nagios](https://www.nagios.org/).

This docker images is based on the Check_MK [Raw Edition](http://mathias-kettner.com/check_mk_introduction.html) - a free and 100% open-source version.

The Check_MK Raw Edition is a full-blown IT monitoring solution.

## Contributing

If you find this image useful you can help. - Send a pull request with your awesome features and bug fixes


## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

----------

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/nlmacamp/check_mk) and is the recommended method of installation.

```bash
docker pull nlmacamp/check_mk:1.4.0p35    (or nlmacamp/check_mk:latest)
```

Alternatively you can build the image yourself.

```bash
docker build -t nlmacamp/check_mk github.com/viper0131/check_mk
```

*OPTIONAL:* If you want to change the timezone in the docker container (default is `UTC`), use `--build-arg TIMEZONE=Europe/Berlin`

## Quickstart

Start Check_MK using:

```bash
    docker run -itd --name check_mk \
           --publish 80:5000 \
           --restart always \
           nlmacamp/check_mk
```

*OPTIONAL:* Specify outgoing mail server with `-e "MAILHUB=<IP:PORT>"`

If your want to map a local directory (e.g. for backup or check scripts):

```
  --volume <localdir>:/opt/backup
```

## Test installation

Check the status of check_mk using:

```bash
docker exec -it check_mk omd status
```

the result should look like:

```bash
Doing 'status' on site mva:
mkeventd:       running
rrdcached:      running
npcd:           running
nagios:         running
apache:         running
-----------------------
Overall state:  running
```


Fireup the Check_MK GUI:

Browse to http://localhost/mva

login with the default user **cmkadmin** with password **omd**

----------

# Updates

1. Log into your current container (`docker exec -it check_mk /bin/bash`)
2. Stop check_mk (`omd stop mva`)
3. Install new check_mk rpm (get link for CentOS 7 version from [here](http://mathias-kettner.com/check_mk_download.php?HTML=yes)): `rpm -ivh https://mathias-kettner.de/support/1.4.0p1/check-mk-raw-1.4.0p1-el7-48.x86_64.rpm`
4. Update check_mk (`omd update mva`)
5. Start check_mk (`omd start mva`)


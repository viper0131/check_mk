# nlmacamp/check_mk:1.5.0p5

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
    - [Use another version](#use-another-version)
  - [Quickstart](#quickstart)
    - [Volumes](#volumes)
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
docker pull nlmacamp/check_mk:1.5.0p5    (or nlmacamp/check_mk:latest)
```

Alternatively you can build the image yourself.

```bash
docker build -t nlmacamp/check_mk github.com/viper0131/check_mk
```

### Use another version

If you want to change the version of check_mk, use `--build-arg CMK_VERSION_ARG=1.5.0p5 --build-arg CMK_DOWNLOADNR_ARG=38`.

To get the version and downloadnr, go to https://mathias-kettner.com/download.php and select your version (CRE). Select Red Hat / CentOS 7.x and right click on "Download" link and select "Copy link" (or similar).

On clipboard you should have something like this:

https://<span></span>mathias-kettner.de\/support\/**1.5.0p5**\/check-mk-raw-**1.5.0p5**-el7-**38**.x86_64.rpm

Generally:

https://<span></span>mathias-kettner.de\/support\/**<CMK_VERSION_ARG>**\/check-mk-raw-**<CMK_VERSION_ARG>**-el7-**<CMK_DOWNLOADNR_ARG>**.x86_64.rpm

```bash
docker build -t nlmacamp/check_mk github.com/viper0131/check_mk --build-arg CMK_VERSION_ARG=1.5.0p5 --build-arg CMK_DOWNLOADNR_ARG=38
```

## Quickstart

**IMPORTANT - the container needs SYS_ADMIN capability or privileged mode (depends on os / docker version)**

Start Check_MK using:

```bash
    docker run -itd --name check_mk \
           --publish 80:5000 \
           --cap-add=SYS_ADMIN \
           --restart always \
           nlmacamp/check_mk
```

If you get errors like

```
mount: tmpfs is write-protected, mounting read-only
mount: cannot mount tmpfs read-only
```

try start your container with `--privileged` instead of `--cap-add=SYS_ADMIN`

*OPTIONAL:* Specify outgoing mail server with `-e "MAILHUB=<IP:PORT>"`
*OPTIONAL:* Specify outgoing mail server encryption with `-e "MAILHUBSTARTTLS=YES"`
*OPTIONAL:* Specify outgoing mail server login with `-e "MAILHUBAUTHUSER=<USERNAME>"` and `-e "MAILHUBAUTHPASS=<PASSWORD>"`

*OPTIONAL:* If you want to change the timezone in the docker container, use `-e TZ=Europe/Berlin`

*OPTIONAL:* If you want to change the password for administrative user 'cmkadmin', use `-e CMK_PASSWORD=p4ssw0rd`. This work only on first run of docker container. You can also change it on Wato (web GUI).  

*OPTIONAL:* If you want to change the name of your site (default: *mva*), use `-e CMK_SITE=mysite`. 

### Volumes

You should map site directory (configuration, graphs, custom checks):
```
--volume <localdir>:/opt/omd/sites
```

If you want to map another local directory (e.g. for backup or check scripts):

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

Browse to `http://<server-ip>`

login with the default user **cmkadmin** with password **omd** (or the pesonalized one, if specified in [Quickstart](#quickstart)).

----------

# Updates

1. Get your container name (`docker ps`).
2. Get your desired check_mk version and his downloadnr as described in [Use another version](#use-another-version)
3. Run this command (with correct container name and cmk version and downloadnr): `docker exec -it <container> /opt/update.sh <CMK_VERSION_ARG> <CMK_DOWNLOADNR_ARG>` (Ex. `docker exec -it check_mk /opt/update.sh 1.5.0p5 38`)

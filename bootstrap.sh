#!/bin/bash

omd start && tail -f /omd/sites/$1/var/log/nagios.log

#!/bin/bash
# The cron.allow file was added through the kickstarter file
chmod --recursive 600 `find /etc/cron* | grep -v '0anacron'`
chmod 700 `find /etc/cron* | grep '0anacron'`

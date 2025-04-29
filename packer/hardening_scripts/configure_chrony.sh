#!/bin/bash

# Disable chrony temporarily
systemctl stop chronyd

# Modify daemon and config file
sed -i 's/OPTIONS=".*"/OPTIONS="-F 2 -u chrony"/g' /etc/sysconfig/chronyd
sed -i 's/pool .*/pool nl.pool.ntp.org iburst maxsources 3/g' /etc/chrony.conf

# Re-start chrony
systemctl enable chronyd
chronyd

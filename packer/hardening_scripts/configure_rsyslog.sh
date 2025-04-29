#!/bin/bash
sed -i 's/#### GLOBAL DIRECTIVES ####/#### GLOBAL DIRECTIVES ####\n# Set global file writing mode (at top of file so all other processes adhere to it)\n$FileCreateMode 0640/g' /etc/rsyslog.conf

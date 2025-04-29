#!/bin/bash
sed -i 's/# deny = .*/deny = 3/g' /etc/security/faillock.conf
sed -i 's/# unlock_time = .*/unlock_time = 600/g' /etc/security/faillock.conf
sed -i 's/# even_deny_root/even_deny_root/g' /etc/security/faillock.conf

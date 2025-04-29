#!/bin/bash
sed -i 's/# minlen = .*/minlen = 16/g' /etc/security/pwquality.conf
sed -i 's/# dcredit = .*/dcredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# ucredit = .*/ucredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# lcredit = .*/lcredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# ocredit = .*/ocredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# minclass = .*/minclass = 4/g' /etc/security/pwquality.conf
sed -i 's/# usercheck = .*/usercheck = 1/g' /etc/security/pwquality.conf

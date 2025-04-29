#!/bin/bash
## Downgrade the audit version if necessary
if [ "$(rpm -q --qf '%{VERSION}-%{RELEASE}' audit)" == "4.0.3-4.el10" ] ; then
  sudo dnf downgrade -y audit-4.0.3-1.el10
fi
systemctl daemon-reload

# Configure audit rules
auditctl -a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k setuid
auditctl -a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k setgid
auditctl -a always,exit -F arch=b64 -S adjtimex -k time-change
auditctl -a always,exit -F arch=b64 -S settimeofday -k time-change
auditctl -a always,exit -F arch=b64 -S clock_settime -k time-change
auditctl -a always,exit -F arch=b64 -S sethostname -k system-locale
auditctl -a always,exit -F arch=b64 -S setdomainname -k system-locale
auditctl -a always,exit -F arch=b64 -S creat -F exit=-EACCES -F auid\>=15000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b64 -S open -F exit=-EACCES -F auid\>=15000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b64 -S openat -F exit=-EACCES -F auid\>=15000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b64 -S truncate -F exit=-EACCES -F auid\>=15000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b64 -S ftruncate -F exit=-EACCES -F auid\>=15000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b64 -S chmod -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fchmod -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fchmodat -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S chown -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fchown -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fchownat -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lchown -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S setxattr -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lsetxattr -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fsetxattr -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S removexattr -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lremovexattr -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fremovexattr -F auid\>=15000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S mount -F auid\>=15000 -F auid!=4294967295 -k mounts
auditctl -a always,exit -F arch=b64 -S mount -F auid=0 -k mounts
auditctl -a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid\>=15000 -F auid!=4294967295 -k delete
auditctl -a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid\>=15000 -F auid!=4294967295 -k prim_mod
auditctl -a always,exit -F path=/usr/bin/chacl -F perm=x -F auid\>=15000 -F auid!=4294967295 -k prim_mod
auditctl -a always,exit -F path=/usr/bin/usermod -F perm=x -F auid\>=15000 -F auid!=4294967295 -k privileged-usermod
auditctl -a always,exit -F arch=b64 -S init_module -S delete_module -k modules
auditctl -a always,exit -F arch=b32 -S create_module -k module-change
auditctl -a always,exit -F arch=b32 -S init_module -k module-change
auditctl -w /var/log/sudo.log -p wa -k actions
auditctl -w /etc/localtime -p wa -k time-change
auditctl -w /etc/issue -p wa -k system-locale
auditctl -w /etc/issue.net -p wa -k system-locale
auditctl -w /etc/hosts -p wa -k system-locale
auditctl -w /etc/sysconfig/network -p wa -k system-locale
auditctl -w /etc/sysconfig/network-scripts/ -p wa -k system-locale
auditctl -w /etc/group -p wa -k identity
auditctl -w /etc/passwd -p wa -k identity
auditctl -w /etc/gshadow -p wa -k identity
auditctl -w /etc/shadow -p wa -k identity
auditctl -w /etc/security/opasswd -p wa -k identity
auditctl -w /var/run/utmp -p wa -k session
auditctl -w /var/log/wtmp -p wa -k session
auditctl -w /var/log/btmp -p wa -k session
auditctl -w /var/log/lastlog -p wa -k logins
auditctl -w /var/run/faillock/ -p wa -k logins
auditctl -w /etc/selinux/ -p wa -k MAC-policy
auditctl -w /usr/share/selinux/ -p wa -k MAC-policy
auditctl -w /usr/bin/chcon -F auid\>=15000 -F auid!=4294967295 -k privileged-priv_change

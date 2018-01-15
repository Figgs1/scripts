#!/bin/bash
apt-get install openssh-server
update-rc.d -f ssh remove
update-rc.d -f ssh defaults
cd /etc/ssh/
mkdir insecure_original_default_kali_keys
mv ssh_host_* ./insecure_original_default_kali_keys/
dpkg-reconfigure openssh-server
sed -i "/^PermitRootLogin*/c\PermitRootLogin yes" /etc/ssh/sshd_config
service ssh restart
update-rc.d -f ssh enable 2 3 4 5
#Add MOTD if you desire vi /etc/motd | service ssh restart

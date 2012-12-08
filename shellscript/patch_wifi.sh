#!/bin/bash

# developer: ptantiku
# reference to : http://www.aircrack-ng.org/doku.php?id=compat-wireless

# 1. get lastest driver from http://wireless.kernel.org/en/users/Download/stable/
# assume this http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-1.tar.bz2
# on Aug 4, 2012

export old_pwd=`pwd`
cd /tmp
wget -O compat.tar.gz http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-1.tar.bz2
tar xvf compat.tar.gz
cd compat-wireless*

# 2. download negative-one patch
wget http://patches.aircrack-ng.org/mac80211.compat08082009.wl_frag+ack_v1.patch
patch -p1 < mac80211.compat08082009.wl_frag+ack_v1.patch

# 3. select driver using ./scripts/driver-select
# but I want to build all drivers

# 4. make & install
make
sudo make install

# 5. unload wireless driver
sudo make wlunload

# 6. modprobe for specific driver, or reboot
sudo modprobe iwl4965

cd $old_pwd


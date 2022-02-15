#!/bin/bash

name_rom=$(grep init $CIRRUS_WORKING_DIR/sync.sh -m 1 | cut -d / -f 4)
cd /home/cirrus-ci-build
mkdir -p ~/.config/rclone
echo "$rcloneconfig" > ~/.config/rclone/rclone.conf
mkdir -p $CIRRUS_WORKING_DIR/ccache
rclone copy NFS:ccache/$name_rom/ccache.tar.gz /home/cirrus-ci-build -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat > /etc/ccache.conf <<EOF
compression = true
EOF
for t in ccache gcc g++ cc c++ clang clang++; do ln -vs /usr/bin/ccache /usr/local/bin/$t; done   
update-ccache-symlinks
dpkg -l ccache 
echo export PATH="/usr/lib/ccache:$PATH"
which ccache gcc g++ cc c++ clang clang++

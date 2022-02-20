#!/bin/bash

name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
backup_url=https://needforspeed.projek.workers.dev/ccache/$name_rom/$name_rom.tar.gz
cd $CIRRUS_WORKING_DIR/rom
aria2c $backup_url
time tar -xvzf $name_rom.tar.gz
rm -rf $name_rom.tar.gz
cat > /etc/ccache.conf <<EOF
compression = true
run_second_cpp = true
depend_mode = true
direct_mode = true
file_clone = true
inode_cache = true
EOF
for t in ccache gcc g++ cc c++ clang clang++; do ln -vs /usr/bin/ccache /usr/local/bin/$t; done   
update-ccache-symlinks
dpkg -l ccache 
echo export PATH="/usr/lib/ccache:$PATH"
which ccache gcc g++ cc c++ clang clang++

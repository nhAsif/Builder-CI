#!/bin/bash

name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
cd $CIRRUS_WORKING_DIR
mkdir -p ~/.config/rclone
echo "$rcloneconfig" > ~/.config/rclone/rclone.conf
mkdir -p $CIRRUS_WORKING_DIR/ccache
url=https://needforspeed.projek.workers.dev/ccache/$name_rom/ccache.tar.gz
time aria2c $url -x16 -s50
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat > /etc/ccache.conf <<EOF
compression = true
run_second_cpp = true
depend_mode = true
direct_mode = true
file_clone = true
inode_cache = true
sloppiness = modules, include_file_mtime, include_file_ctime, time_macros, pch_defines, file_stat_matches, clang_index_store, system_headers
EOF
for t in ccache gcc g++ cc c++ clang clang++; do ln -vs /usr/bin/ccache /usr/local/bin/$t; done   
update-ccache-symlinks
dpkg -l ccache 
echo export PATH="/usr/lib/ccache:$PATH"
which ccache gcc g++ cc c++ clang clang++

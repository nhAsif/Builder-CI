#!/bin/bash

cd $WORKDIR
name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
rclone copy --drive-chunk-size 256M --stats 1s NFS:ccache/$name_rom/ccache.tar.gz $WORKDIR -P
tar xzf ccache.tar.gz
rm -rf ccache.tar.gz
cat > /etc/ccache.conf <<EOF
compression = true
file_clone = true
inode_cache = true
max_size = 100
EOF
for t in ccache gcc g++ cc c++ clang clang++; do ln -vs /usr/bin/ccache /usr/local/bin/$t; done   
update-ccache-symlinks
dpkg -l ccache 
export PATH="/usr/lib/ccache:$PATH"
which clang clang++

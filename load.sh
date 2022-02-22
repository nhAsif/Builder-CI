#!/bin/bash

cd $CIRRUS_WORKING_DIR
name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
rclone copy --drive-chunk-size 256M --stats 1s NFS:ccache/$name_rom/ccache.tar.gz $CIRRUS_WORKING_DIR -P
tar xzf ccache.tar.gz
rm -rf ccache.tar.gz
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
export PATH="/usr/lib/ccache:$PATH"
which c89-gcc clang++-12 clang-13 gcc-11 c99-gcc clang++-13 clang-9 x86_64-linux-gnu-g++ clang clang++-9 g++ x86_64-linux-gnu-g++-11 clang++ clang-11 g++-11 x86_64-linux-gnu-gcc clang++-11 clang-12 gcc x86_64-linux-gnu-gcc-11

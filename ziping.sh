#!/bin/bash

name_rom=$(grep init $CIRRUS_WORKING_DIR/sync.sh -m 1 | cut -d / -f 4)
if [ "$BUILD_CCACHE_ONLY" == "true" ]; then
   cd /home/cirrus-ci-build
   com ()
   {
       tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
   }
   time com ccache 1
   rclone copy ccache.tar.gz NFS:ccache/$name_rom -P
   rm -rf ccache.tar.gz
fi

if [ "$BUILD_CCACHE_ONLY" == "false" ]; then
   cd /home/cirrus-ci-build/rom/out/target/product/$device
   rclone copy $rom_name*.zip NFS:rom/$name_rom -P
fi

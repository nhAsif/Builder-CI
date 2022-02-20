#!/bin/bash

name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
cd $CIRRUS_WORKING_DIR/rom
com ()
{
  tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}
rm -rf $CIRRUS_WORKING_DIR/rom/$name_rom/out/target/product/$device
time com $name_rom 1
rclone copy $name_rom.tar.gz NFS:ccache/$name_rom -P
rm -rf $name_rom.tar.gz
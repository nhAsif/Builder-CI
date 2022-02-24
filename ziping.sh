#!/bin/bash

set -e

device=$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)
name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)

function upload_rom() {
   JOS=$WORKDIR/rom/$name_rom/out/target/product/$device/$name_rom*.zip
   curl -s -X POST https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d disable_web_page_preview=true -d parse_mode=html -d text="<b>Build status:</b>%0A@Bella_Aprilia_27 <code>Building Rom $name_rom succes [✔️]</code>"
   rclone copy --drive-chunk-size 256M --stats 1s $JOS NFS:rom/$name_rom -P
   curl -s -X POST https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d disable_web_page_preview=true -d parse_mode=html -d text="Link : https://needforspeed.projek.workers.dev/rom/$name_rom/$(cd $WORKDIR/rom/$name_rom/out/target/product/$device && ls $name_rom*.zip)"
}

function upload_ccache() {
   cd $WORKDIR
   com ()
   {
     tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
   }
   time com ccache 1
   rclone copy --drive-chunk-size 256M --stats 1s ccache.tar.gz NFS:ccache/$name_rom -P
   rm -rf ccache.tar.gz
}

upload_rom
upload_ccache

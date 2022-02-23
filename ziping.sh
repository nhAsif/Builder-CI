#!/bin/bash

export device=$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)
export name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
export JOS=$WORKDIR/rom/$name_rom/out/target/product/$device/$name_rom*.zip
cd $WORKDIR

function upload_rom() {
   rclone copy --drive-chunk-size 256M --stats 1s $JOS NFS:rom/$name_rom -P
}

function upload_ccache() {
   com ()
   {
     tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
   }
   time com ccache 1
   rclone copy --drive-chunk-size 256M --stats 1s ccache.tar.gz NFS:ccache/$name_rom -P
   rm -rf ccache.tar.gz
}

function checkrom() {
    curl -s -X POST https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d disable_web_page_preview=true -d parse_mode=html -d text="<b>Build status:</b>%0A@Bella_Aprilia_27 <code>Sorry Building Rom $name_rom Gagal [❌]</code>%0A %0A<b>Notes:</b>%0A<code>Karena system hanya mendeteksi Build ccache</code>"
    echo Upload ccache only..
    upload_ccache
}

function checkout() {
   if ! [ -a "$JOS" ]; then
     checkrom
     exit 1
   fi
     curl -s -X POST https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d disable_web_page_preview=true -d parse_mode=html -d text="<b>Build status:</b>%0A@Bella_Aprilia_27 <code>Building Rom $name_rom succes [✔️]</code>"
     upload_rom
     curl -s -X POST https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d disable_web_page_preview=true -d parse_mode=html -d text="Link : https://needforspeed.projek.workers.dev/rom/$name_rom/$(cd $WORKDIR/rom/$name_rom/out/target/product/$device && ls $name_rom*.zip)"
     upload_ccache
}

checkout
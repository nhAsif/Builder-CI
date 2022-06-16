# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/RiceDroid/android -b twelve -g default,-mips,-darwin,-notdefault
git clone https://github.com/nhAsif/local_manifest.git --depth 1 -b crd12 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync

# build rom
source build/envsetup.sh
lunch lineage_alioth-userdebug
export TZ=Asia/Dhaka
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="$(echo "${var_cache_report_config}")"
brunch alioth &
sleep 90m
kill %1 

# upload rom
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P

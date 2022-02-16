#sync rom
repo init --depth=1 --no-repo-verify -u git://git.polycule.co/ProjectKasumi/android/manifest.git -b kasumi-v1 -g default,,-mips,-darwin,-notdefault
git clone https://github.com/NFS86/local_manifest -b kasumi .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --force-sync -j8

# build rom
source build/envsetup.sh
lunch kasumi_rosy-userdebug
export TZ=Asia/Jakarta
export BUILD_USERNAME=rosy
export BUILD_HOSTNAME=userdebug
export KASUMI_BUILD_TYPE=auroraoss
export KASUMI_SHIP_LAWNCHAIR=true
export TARGET_BOOT_ANIMATION_RES=720
mka bandori &
sleep 90m
kill %1

# upload rom
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
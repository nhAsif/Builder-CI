#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Octavi-OS/platform_manifest.git -b 12 -g default,-mips,-darwin,-notdefault
git clone https://github.com/NFS-projects/local_manifest --depth 1 -b oct-12 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch octavi_rosy-userdebug
export TZ=Asia/Jakarta
export BUILD_USERNAME=rosy
export BUILD_HOSTNAME=userdebug
brunch rosy &
sleep 30m
kill %1

# upload rom
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
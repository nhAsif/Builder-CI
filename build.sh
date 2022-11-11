#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/PixelExperience/manifest -b thirteen-plus -g default,-mips,-darwin,-notdefault
git clone https://github.com/nhAsif/local_manifest.git --depth 1 -b pe13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch aosp_alioth-user
export KBUILD_BUILD_USER=nhAsif
export KBUILD_BUILD_HOST=pricexd
export BUILD_USERNAME=nhAsif
export BUILD_HOSTNAME=pricexd
export TZ=Asia/Dhaka
curl -s https://api.telegram.org/bot$TG_TOKEN/sendMessage -d chat_id=$TG_CHAT_ID -d text="$(echo "${var_cache_report_config}")"
mka bacon

# upload rom
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P

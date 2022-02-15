#sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/ProjectKasumi/android.git -b kasumi-v1 -g default,,-mips,-darwin,-notdefault
git clone https://github.com/NFS86/local_manifest -b kasumi .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --force-sync -j8

# build rom
source build/envsetup.sh
lunch kasumi_rosy-userdebug
mka bandori

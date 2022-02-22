FROM anggit86/ubuntu:21.10
WORKDIR /home/cirrus-ci-build

RUN mkdir -p $WORKDIR/rom/PixelExperience \
   && cd $WORKDIR/rom/PixelExperience \
   && repo init --depth=1 --no-repo-verify -u https://github.com/PixelExperience/manifest -b eleven -g default,-mips,-darwin,-notdefault \
   && git clone https://github.com/NFS-projects/local_manifest --depth 1 -b PE-11 .repo/local_manifests \
   && repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j4

VOLUME ["/home/cirrus-ci-build/ccache", "/home/cirrus-ci-build/rom"]
ENTRYPOINT ["/bin/bash"]

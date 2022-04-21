# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Spark-Rom/manifest.git -b spark -g default,-mips,-darwin,-notdefault
git clone https://github.com/hsx02/Local-Manifests.git --depth 1 -b spark-12.1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch spark_mi439-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export WITH_GAPPS=true
export TARGET_FACE_UNLOCK_SUPPORTED=false
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export TZ=Asia/Dhaka #put before last build command
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P



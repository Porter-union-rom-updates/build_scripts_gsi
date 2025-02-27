#!/bin/bash

rm -rf .repo/local_manifests/
rm -rf .repo/local_manifests/gapps.xml/

# repo init rom
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Porter-union-rom-updates/treble_manifest_1 -b inf .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Export
#export BUILD_USERNAME=un
export BUILD_HOSTNAME=crave
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=true
echo "======= Export Done ======"

# Set up build environment
./patches/apply-all.sh .
cd evo/treble_app
./build.sh release
cd ../..
echo "====== patch Done ======="

# Lunch
source build/envsetup.sh
ccache -M 50G -F 0
lunch infinity__arm64_bgN-ap4a-userdebug 
make systemimage -j$(nproc --all)
cd out/target/product/tdgsi_arm64_ab
xz -9 -T0 -v -z system.img 

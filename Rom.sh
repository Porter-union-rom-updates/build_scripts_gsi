#!/bin/bash

rm -rf .repo/local_manifests/
rm -rf .repo/local_manifests/gapps.xml/

# repo init rom
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b QPR3 -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Porter-union-rom-updates/treble_manifest .repo/local_manifests  -b Infinity/14
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Export
#export BUILD_USERNAME=FARHAN
export BUILD_HOSTNAME=crave
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export SELINUX_IGNORE_NEVERALLOWS=true
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
. build/envsetup.sh
ccache -M 50G -F 0
lunch treble_arm64_bgN-userdebug 
make systemimage -j$(nproc --all)
# son
cd out/target/product/tdgsi_arm64_ab
xz -z -k system.img 

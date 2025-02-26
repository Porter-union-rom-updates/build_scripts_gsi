#!/bin/bash

rm -rf .repo/local_manifests/
rm -rf .repo/local_manifests/gapps.xml/

# repo init rom
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/mytja/treble_manifest.git -b inf .repo/local_manifests
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
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
source build/envsetup.sh
ccache -M 50G -F 0
lunch infinity__arm64_bgN-ap4a-userdebug 
make systemimage -j$(nproc --all)

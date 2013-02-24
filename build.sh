#!/bin/bash

START=$(date +%s)

kernel_ver="Mackay_Kernel_1.0Alpha"

export USE_CCACHE=1

        CCACHE=ccache
        CCACHE_COMPRESS=1
        CCACHE_DIR="/home/kasper/android/ccache"
	CCACHE_LOGFILE="/home/kasper/android/ccache/ccache-log"
        export CCACHE_DIR CCACHE_COMPRESS CCACHE_LOGFILE

export LOCALVERSION="-"`echo $kernel_ver`
export ANDROID_BUILD_TOP=/home/kasper/android/cm101
export CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/linaro-4.7/bin/arm-linux-gnueabihf-
export KERNEL=$ANDROID_BUILD_TOP/kernel/samsung/aries
export RAMDISK=$KERNEL/usr/galaxysmtd-ramdisk
export OUT=$ANDROID_BUILD_TOP/kernel/samsung/output/galaxysmtd
export CWM=$OUT/cwm
export ARCH=arm

make aries_galaxysmtd_defconfig

# make -j8 modules
# find $KERNEL -name '*.ko' -exec cp -v {} $RAMDISK/files/lib/modules \;

make -j8 zImage

cd arch/arm/boot
tar cvf `echo $kernel_ver`.tar zImage
mv $kernel_ver.tar $OUT
cd ../../../

cp arch/arm/boot/zImage $CWM/boot.img
cd $CWM
zip -r `echo $kernel_ver`.zip *

mv `echo $kernel_ver`.zip $OUT

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Time Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC

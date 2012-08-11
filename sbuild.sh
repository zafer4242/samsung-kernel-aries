#!/bin/bash

START=$(date +%s)

kernel_ver="Mackay_Kernel_ICS_Final_VC"

export USE_CCACHE=1

        CCACHE=ccache
        CCACHE_COMPRESS=1
        CCACHE_DIR="/home/kasper/android/ccache"
	CCACHE_LOGFILE="/home/kasper/android/ccache/ccache-log"
        export CCACHE_DIR CCACHE_COMPRESS CCACHE_LOGFILE

export LOCALVERSION="-"`echo $kernel_ver`
export ANDROID_BUILD_TOP=/home/kasper/android/system

make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/gcc-linaro-arm-linux-gnueabihf-2012.07-20120720_linux/bin/arm-linux-gnueabihf- ARCH=arm aries_galaxysmtd_defconfig
## make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/gcc-linaro-arm-linux-gnueabihf-2012.06-20120625_linux/bin/arm-linux-gnueabihf- ARCH=arm aries_galaxysmtd_defconfig
## make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm aries_galaxysmtd_defconfig

make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/gcc-linaro-arm-linux-gnueabihf-2012.07-20120720_linux/bin/arm-linux-gnueabihf- ARCH=arm -j8 modules
## make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/gcc-linaro-arm-linux-gnueabihf-2012.06-20120625_linux/bin/arm-linux-gnueabihf- ARCH=arm -j8 modules
## make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm -j8 modules

find $ANDROID_BUILD_TOP/kernel/samsung/aries -name '*.ko' -exec cp -v {} $ANDROID_BUILD_TOP/kernel/samsung/ics-ramdisk/ics_combo/files/modules \;

make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/gcc-linaro-arm-linux-gnueabihf-2012.07-20120720_linux/bin/arm-linux-gnueabihf- ARCH=arm -j8 zImage
## make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/gcc-linaro-arm-linux-gnueabihf-2012.06-20120625_linux/bin/arm-linux-gnueabihf- ARCH=arm -j8 zImage
## make CROSS_COMPILE=$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm -j8 zImage

cd arch/arm/boot
tar cvf `echo $kernel_ver`.tar zImage
mv $kernel_ver.tar $ANDROID_BUILD_TOP/kernel/samsung/ics-ramdisk
cd ../../../

cp arch/arm/boot/zImage ../ics-ramdisk/cwm/boot.img

cd ../ics-ramdisk/cwm

zip -r `echo $kernel_ver`.zip *

mv  `echo $kernel_ver`.zip ../../kernelbuilds
mv  ../`echo $kernel_ver`.tar ../../kernelbuilds

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Time Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC

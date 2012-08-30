#!/bin/bash

START=$(date +%s)

kernel_ver="Mackay_kernel_0.53"

export LOCALVERSION="-"`echo $kernel_ver`
export ANDROID_BUILD_TOP=/home/kasper/android/system
export TOOLCHAIN=$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-

make CROSS_COMPILE=$TOOLCHAIN ARCH=arm aries_galaxysmtd_defconfig

make CROSS_COMPILE=$TOOLCHAIN ARCH=arm -j8 modules

find $ANDROID_BUILD_TOP/kernel/samsung/aries -name '*.ko' -exec cp -v {} $ANDROID_BUILD_TOP/kernel/samsung/ics-ramdisk/jb_combo/files/modules \;

make CROSS_COMPILE=$TOOLCHAIN ARCH=arm -j8 zImage

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

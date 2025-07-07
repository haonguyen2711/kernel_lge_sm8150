#!/bin/bash

echo
echo "🔧 Clean Build Directory"
echo 

make clean && make mrproper

echo
echo "🚀 Start Build Process"
echo

mkdir -p out
ARCH=arm64
SUBARCH=arm64
CLANG_PATH=~/toolchains/clang-r428724/bin
PATH=${CLANG_PATH}:${PATH}
DTC_EXT=/usr/bin/dtc
CLANG_TRIPLE=aarch64-linux-gnu-
CROSS_COMPILE=~/toolchains/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/bin/aarch64-linux-android-
CROSS_COMPILE_ARM32=~/toolchains/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/bin/arm-linux-androideabi-
LD_LIBRARY_PATH=~/toolchains/clang-r428724/lib64:$LD_LIBRARY_PATH

echo
echo "📦 Set DEFCONFIG"
echo 
make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out vendor/dragon_flash_defconfig

echo
echo "🧱 Building Kernel..."
echo 

make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out -j$(nproc --all)

# Tạo thư mục release
echo
echo "📁 Preparing AnyKernel3 Package"
mkdir -p release

# Xóa thư mục Dragon cũ nếu tồn tại
rm -rf release/Dragon

# Clone AnyKernel3 về
git clone --depth=1 https://github.com/haonguyen2711/AnyKernel3 release/Dragon

# Copy file Image.gz-dtb vào thư mục AnyKernel3
cp -f ./out/arch/arm64/boot/Image.gz-dtb ./release/Dragon/Image.gz-dtb

# Đóng gói đúng cách: chỉ nội dung trong Dragon/
echo
echo "📦 Creating Flashable ZIP"
cd release/Dragon
zip -r ../Dragon-AK3.zip . > /dev/null
cd ../..

echo
echo "✅ Done! Flashable kernel zip located at: release/Dragon-AK3.zip"
echo

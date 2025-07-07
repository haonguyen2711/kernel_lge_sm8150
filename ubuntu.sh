#!/bin/bash

echo
echo "🔧 Clean Build Directory"
echo 

make clean && make mrproper

echo
echo "🚀 Start Build Process"
echo

mkdir -p out
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

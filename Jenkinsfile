pipeline {
  agent any

  environment {
    // Khai báo biến dùng toàn cục
    CLANG_PATH = "/home/konadev/toolchains/clang-r428724/bin"
    CROSS_PATH = "/home/konadev/toolchains/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/bin"
  }

  stages {
    stage('Checkout') {
      steps {
        // Clone code từ GitHub (đã được trigger bởi webhook)
        checkout scm
      }
    }

    stage('Build Kernel') {
      steps {
        sh '''#!/bin/bash
          set -e

          # Thiết lập biến môi trường cho build kernel
          export ARCH=arm64
          export SUBARCH=arm64
          export CLANG_PATH="${CLANG_PATH}"
          export PATH="${CLANG_PATH}:${PATH}"
          export DTC_EXT=/usr/bin/dtc
          export CLANG_TRIPLE=aarch64-linux-gnu-
          export CROSS_COMPILE="${CROSS_PATH}/aarch64-linux-android-"
          export CROSS_COMPILE_ARM32="${CROSS_PATH}/arm-linux-androideabi-"
          export LD_LIBRARY_PATH="${CLANG_PATH}/../lib64:$LD_LIBRARY_PATH"

          # Cập nhật môi trường KernelSU nếu có
          curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -

          # Chạy file shell để build kernel
          chmod +x build_flash_googleclangubuntu.sh
          bash ./build_flash_googleclangubuntu.sh
        '''
      }
    }
  }

  post {
    failure {
      echo "❌ Build thất bại. Vui lòng kiểm tra lại log."
    }
    success {
      echo "✅ Build thành công."
    }
  }
}

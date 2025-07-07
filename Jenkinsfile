pipeline {
  agent any

  environment {
    CLANG_PATH = "/home/konadev/toolchains/clang-r428724/bin"
    CROSS_PATH = "/home/konadev/toolchains/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/bin"
  }

  stages {
    stage('Checkout') {
      steps {
        git changelog: false, poll: false, shallow: true, depth: 1,
            url: 'https://github.com/haonguyen2711/kernel_lge_sm8150',
            branch: 'OpenELA-4.14.y-Stock'
      }
    }

    stage('Build Kernel') {
      steps {
        sh '''#!/bin/bash
          set -e

          export ARCH=arm64
          export SUBARCH=arm64
          export CLANG_PATH="${CLANG_PATH}"
          export PATH="${CLANG_PATH}:${PATH}"
          export DTC_EXT=/usr/bin/dtc
          export CLANG_TRIPLE=aarch64-linux-gnu-
          export CROSS_COMPILE="${CROSS_PATH}/aarch64-linux-android-"
          export CROSS_COMPILE_ARM32="${CROSS_PATH}/arm-linux-androideabi-"
          export LD_LIBRARY_PATH="${CLANG_PATH}/../lib64:$LD_LIBRARY_PATH"

          curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -

          chmod +x ubuntu.sh
          bash ./ubuntu.sh
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

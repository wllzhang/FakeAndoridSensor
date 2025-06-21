#!/bin/bash

echo "🔧 手动修复Android开发环境..."

# 设置环境变量
export ANDROID_HOME=/home/vscode/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

echo "设置ANDROID_HOME: $ANDROID_HOME"

# 创建Android SDK目录
mkdir -p $ANDROID_HOME
echo "✅ 创建Android SDK目录"

# 检查是否已经有命令行工具
if [ ! -d "$ANDROID_HOME/cmdline-tools" ]; then
    echo "📥 下载Android命令行工具..."
    cd /tmp
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    unzip -q commandlinetools-linux-11076708_latest.zip
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
    rm -rf cmdline-tools commandlinetools-linux-11076708_latest.zip
    cd -
    echo "✅ Android命令行工具安装完成"
else
    echo "✅ Android命令行工具已存在"
fi

# 重新设置PATH
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# 检查sdkmanager是否可用
if command -v sdkmanager &> /dev/null; then
    echo "✅ sdkmanager可用"
    
    # 安装Android SDK组件
    echo "🔧 安装Android SDK组件..."
    yes | sdkmanager --licenses
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
    
    # 安装NDK
    echo "🔧 安装Android NDK..."
    sdkmanager "ndk;26.1.10909125"
    
    # 安装CMake
    echo "🔧 安装Android CMake..."
    sdkmanager "cmake;3.22.1"
    
    echo "✅ SDK组件安装完成"
else
    echo "❌ sdkmanager不可用，请检查PATH设置"
fi

# 安装Ninja构建工具
if ! command -v ninja &> /dev/null; then
    echo "🔧 安装Ninja构建工具..."
    sudo apt-get update
    sudo apt-get install -y ninja-build
    echo "✅ Ninja安装完成"
else
    echo "✅ Ninja已安装"
fi

# 永久设置环境变量
echo "⚙️ 配置环境变量到.bashrc..."
cat >> ~/.bashrc << EOF

# Android开发环境
export ANDROID_HOME=$ANDROID_HOME
export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:\$ANDROID_HOME/ndk/26.1.10909125
EOF

# 重新加载.bashrc
source ~/.bashrc

echo "✅ 环境修复完成！"
echo "📋 验证命令："
echo "  echo \$ANDROID_HOME"
echo "  sdkmanager --list"
echo "  cmake --version" 
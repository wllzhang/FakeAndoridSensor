#!/bin/bash

echo "🚀 正在配置Android C++开发环境..."

# 设置环境变量
export ANDROID_HOME=/home/vscode/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# 创建Android SDK目录
mkdir -p $ANDROID_HOME

# 下载并安装Android命令行工具
if [ ! -d "$ANDROID_HOME/cmdline-tools" ]; then
    echo "📥 下载Android命令行工具..."
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    unzip -q commandlinetools-linux-11076708_latest.zip
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
    rm -rf cmdline-tools commandlinetools-linux-11076708_latest.zip
fi

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

# 安装Ninja构建工具
if ! command -v ninja &> /dev/null; then
    echo "🔧 安装Ninja构建工具..."
    sudo apt-get update
    sudo apt-get install -y ninja-build
fi

# 配置环境变量到bashrc
echo "⚙️ 配置环境变量..."
cat >> ~/.bashrc << EOF

# Android开发环境
export ANDROID_HOME=$ANDROID_HOME
export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:\$ANDROID_HOME/ndk/26.1.10909125
EOF

# 创建项目构建脚本
echo "📝 创建构建脚本..."
cat > build.sh << 'EOF'
#!/bin/bash

# 设置NDK路径
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/26.1.10909125

# 创建构建目录
mkdir -p build

# 配置CMake
cmake -B build \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release

# 构建项目
cmake --build build --parallel $(nproc)

echo "✅ 构建完成！"
echo "📁 生成的文件："
ls -la build/
EOF

chmod +x build.sh

echo "✅ 环境配置完成！"
echo "📋 可用命令："
echo "  ./build.sh    - 构建项目"
echo "  adb devices   - 查看连接的设备"
echo "  ndk-build     - 使用NDK构建" 
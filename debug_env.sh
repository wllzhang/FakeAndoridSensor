#!/bin/bash

echo "🔍 环境诊断报告"
echo "=================="

echo "1. 检查当前用户："
whoami
echo ""

echo "2. 检查ANDROID_HOME环境变量："
echo "ANDROID_HOME: $ANDROID_HOME"
echo ""

echo "3. 检查Android SDK目录是否存在："
ls -la /home/vscode/Android/Sdk/ 2>/dev/null || echo "❌ Android SDK目录不存在"
echo ""

echo "4. 检查PATH中的Android工具："
echo $PATH | tr ':' '\n' | grep -i android || echo "❌ PATH中没有Android工具"
echo ""

echo "5. 检查sdkmanager是否可用："
which sdkmanager 2>/dev/null || echo "❌ sdkmanager未找到"
echo ""

echo "6. 检查.bashrc文件："
tail -10 ~/.bashrc
echo ""

echo "7. 检查setup.sh是否执行过："
ls -la .devcontainer/setup.sh
echo ""

echo "8. 检查Android SDK组件："
if [ -d "/home/vscode/Android/Sdk" ]; then
    echo "SDK目录内容："
    ls -la /home/vscode/Android/Sdk/
    echo ""
    echo "cmdline-tools内容："
    ls -la /home/vscode/Android/Sdk/cmdline-tools/ 2>/dev/null || echo "❌ cmdline-tools不存在"
else
    echo "❌ Android SDK目录不存在"
fi 
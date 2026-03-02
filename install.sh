#!/bin/bash

# 获取当前脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 1. 备份旧配置（如果存在且不是软链接）
if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    echo "发现旧的 .tmux.conf，正在备份到 .tmux.conf.bak..."
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
fi

# 2. 创建软链接
echo "正在创建软链接..."
ln -sf "$DIR/.tmux.conf" "$HOME/.tmux.conf"

# 3. 安装 TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "正在安装 Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# 4. 重新加载 tmux 环境（如果 tmux 正在运行）
if command -v tmux &> /dev/null && tmux info &> /dev/null; then
    tmux source-file ~/.tmux.conf
    echo "正在安装 tmux 插件..."
    ~/.tmux/plugins/tpm/bin/install_plugins
fi

echo "✅ Tmux 配置安装完成！"

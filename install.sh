#!/bin/bash

# Detect OS/Package Manager
if command -v pacman &> /dev/null; then
    INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v brew &> /dev/null; then
    INSTALL_CMD="brew install"
else
    echo "Error: Neither pacman nor brew found. This script supports Arch and macOS only."
    exit 1
fi

# Function to install if not present
check_and_install() {
    if ! command -v "$1" &> /dev/null; then
        echo "Installing $1..."
        $INSTALL_CMD "$2"
    else
        echo "$1 is already installed."
    fi
}

# 1. Neovim
check_and_install nvim neovim

# 2. GitHub CLI
check_and_install gh gh

# 3. Lazygit
check_and_install lazygit lazygit

# 4. shell-color-scripts (Manual Build)
if ! command -v colorscript &> /dev/null; then
    echo "Installing shell-color-scripts..."
    git clone git@gitlab.com:Emph/shell-color-scripts.git
    cd shell-color-scripts || exit
    sudo make install
    cd ..
    rm -rf shell-color-scripts
else
    echo "shell-color-scripts (colorscript) is already installed."
fi

# 5. Tree-sitter CLI and C Compiler (gcc)
check_and_install tree-sitter tree-sitter-cli
check_and_install gcc gcc

# 6. Curl
check_and_install curl curl

# 7. Ripgrep
check_and_install rg ripgrep

echo "Setup complete!"

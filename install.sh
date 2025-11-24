#!/bin/bash

GO_INSTALL_DIR="/usr/local"
GO_SRC_DIR="$HOME/go"
GO_MOD_ENABLED="on"

detect_architecture() {
    case "$(uname -m)" in
        x86_64|amd64) echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        armv7l) echo "armv7" ;;
        *) echo "unsupported" ;;
    esac
}

detect_package_manager() {
    command -v apt >/dev/null && echo "apt" && return
    command -v dnf >/dev/null && echo "dnf" && return
    command -v yum >/dev/null && echo "yum" && return
    command -v pacman >/dev/null && echo "pacman" && return
    command -v apk >/dev/null && echo "apk" && return
    echo "unsupported"
}

install_dependencies() {
    case "$1" in
        apt)    sudo apt update -y >/dev/null 2>&1 && sudo apt install -y wget tar >/dev/null 2>&1 ;;
        dnf)    sudo dnf install -y wget tar >/dev/null 2>&1 ;;
        yum)    sudo yum install -y wget tar >/dev/null 2>&1 ;;
        pacman) sudo pacman -Sy --noconfirm wget tar >/dev/null 2>&1 ;;
        apk)    sudo apk add wget tar >/dev/null 2>&1 ;;
        *) echo "Unsupported package manager"; exit 1 ;;
    esac
}

fetch_latest_go_version() {
    wget -qO- https://go.dev/dl/ |
        grep -oP 'go[0-9]+\.[0-9]+\.[0-9]+\.linux-[^"]+\.tar.gz' |
        head -n 1
}

install_go() {
    local file="$1"
    wget -q "https://go.dev/dl/$file" -P /tmp/
    sudo rm -rf "$GO_INSTALL_DIR/go" >/dev/null 2>&1
    sudo tar -C "$GO_INSTALL_DIR" -xzf "/tmp/$file" >/dev/null 2>&1
    rm "/tmp/$file"
}

set_go_env() {
    if [ -n "$BASH_VERSION" ]; then PROFILE="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then PROFILE="$HOME/.zshrc"
    else PROFILE="$HOME/.profile"
    fi

    cat >> "$PROFILE" << EOF
# Go Environment Variables
export GOROOT=$GO_INSTALL_DIR/go
export GOPATH=$GO_SRC_DIR
export GO111MODULE=$GO_MOD_ENABLED
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF
}

# ---------------- MAIN ----------------

echo "Detecting architecture..."
ARCH=$(detect_architecture)
[ "$ARCH" == "unsupported" ] && echo "Error: unsupported architecture." && exit 1
echo " - OK ($ARCH)"

echo "Detecting package manager..."
PKG=$(detect_package_manager)
[ "$PKG" == "unsupported" ] && echo "Error: unsupported package manager." && exit 1
echo " - OK ($PKG)"

echo "Installing dependencies..."
install_dependencies "$PKG"
echo " - OK"

echo "Fetching latest Go version..."
LATEST=$(fetch_latest_go_version)
[ -z "$LATEST" ] && echo "Error: failed to fetch latest Go version" && exit 1
echo " - Latest: $LATEST"

echo "Downloading & installing Go..."
install_go "$LATEST"
echo " - Installation complete"

echo "Configuring environment variables..."
set_go_env
echo " - PATH update added"

echo ""
echo "==============================="
echo "   Go installation finished"
echo "==============================="
echo ""
echo "⚠️  To apply the environment variables now, run:"
if [ -n "$BASH_VERSION" ]; then
    echo "    source ~/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    echo "    source ~/.zshrc"
else
    echo "    source ~/.profile"
fi
echo ""
echo "Or restart your terminal."
echo ""
echo "After that test with:"
echo "    go version"

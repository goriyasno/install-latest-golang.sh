#!/bin/bash

# Set Go install location
GO_INSTALL_DIR="/usr/local"
GO_BIN_DIR="$GO_INSTALL_DIR/go/bin"
GO_SRC_DIR="$HOME/go"  # Default GOPATH location (can be customized)
GO_MOD_ENABLED="on"    # Enable Go modules by default

# Function to detect the architecture
detect_architecture() {
    local arch
    arch=$(uname -m)
    
    case "$arch" in
        "x86_64"|"amd64")
            echo "amd64"
            ;;
        "aarch64"|"arm64")
            echo "arm64"
            ;;
        "armv7l")
            echo "armv7"
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

# Function to detect the package manager
detect_package_manager() {
    if command -v apt >/dev/null; then
        echo "apt"
    elif command -v dnf >/dev/null; then
        echo "dnf"
    elif command -v yum >/dev/null; then
        echo "yum"
    elif command -v pacman >/dev/null; then
        echo "pacman"
    elif command -v apk >/dev/null; then
        echo "apk"
    else
        echo "unsupported"
    fi
}

# Check for updates to the apt package list (for apt-based systems)
install_dependencies() {
    local package_manager="$1"
    
    case "$package_manager" in
        "apt")
            sudo apt update
            sudo apt install -y wget tar
            ;;
        "dnf")
            sudo dnf install -y wget tar
            ;;
        "yum")
            sudo yum install -y wget tar
            ;;
        "pacman")
            sudo pacman -Sy --noconfirm wget tar
            ;;
        "apk")
            sudo apk add wget tar
            ;;
        *)
            echo "Unsupported package manager."
            exit 1
            ;;
    esac
}

# Fetch the latest stable version of Go from the official Go GitHub releases
fetch_latest_go_version() {
    local latest_go_version
    latest_go_version=$(wget -qO- https://golang.org/dl/ | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]+\.linux-[^"]+\.tar.gz' | head -n 1)
    
    if [ -z "$latest_go_version" ]; then
        echo "Error: Unable to fetch the latest Go version."
        exit 1
    fi
    
    echo "$latest_go_version"
}

# Function to download and install Go
install_go() {
    local latest_go_version="$1"
    
    # Define download URL for the latest stable version
    local download_url="https://golang.org/dl/$latest_go_version"
    
    echo "Downloading Go from $download_url..."
    wget -q $download_url -P /tmp/
    
    # Remove any previous Go installation
    echo "Removing old Go installation (if exists)..."
    sudo rm -rf $GO_INSTALL_DIR/go
    
    # Extract the downloaded tarball to the installation directory
    echo "Extracting Go to $GO_INSTALL_DIR..."
    sudo tar -C $GO_INSTALL_DIR -xzf /tmp/$latest_go_version
    
    # Clean up the downloaded tarball
    rm /tmp/$latest_go_version
}

# Function to set and export Go-specific environment variables
set_go_env_vars() {
    echo "Setting Go environment variables..."

    # Set and export environment variables for this session
    export GOROOT=$GO_INSTALL_DIR/go
    export GOPATH=$GO_SRC_DIR
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    export GO111MODULE=$GO_MOD_ENABLED
    
    # Detect the shell and update the corresponding config file
    if [ -n "$BASH_VERSION" ]; then
        PROFILE_FILE="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        PROFILE_FILE="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] && [ ! -z "$PROFILE_FILE" ]; then
        echo "No shell-specific file found, using .profile as fallback"
        PROFILE_FILE="$HOME/.profile"
    fi

    echo "Adding Go environment variables to $PROFILE_FILE"
    echo "
    # Go Environment Variables
    export GOROOT=$GO_INSTALL_DIR/go
    export GOPATH=$GO_SRC_DIR
    export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
    export GO111MODULE=$GO_MOD_ENABLED
    " >> $PROFILE_FILE
}


# Main script logic

# Detect architecture
ARCH=$(detect_architecture)
if [ "$ARCH" == "unsupported" ]; then
    echo "Error: Unsupported architecture."
    exit 1
fi

echo "Detected architecture: $ARCH"

# Detect package manager
PACKAGE_MANAGER=$(detect_package_manager)
if [ "$PACKAGE_MANAGER" == "unsupported" ]; then
    echo "Error: Unsupported package manager. Please install wget and tar manually."
    exit 1
fi

echo "Detected package manager: $PACKAGE_MANAGER"

# Install required dependencies
install_dependencies "$PACKAGE_MANAGER"

# Fetch the latest Go version
LATEST_GO_VERSION=$(fetch_latest_go_version)

# Install Go
install_go "$LATEST_GO_VERSION"

# Set and export Go environment variables in this session
set_go_env_vars

# Verify the Go installation
echo "Go installation complete. Verifying Go version..."
go version

echo "Go has been successfully installed and environment variables are set!"

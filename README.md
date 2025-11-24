## 🚀 `install-latest-golang.sh`

**Automatically install the latest version of Go (Golang) on *any* Linux distribution — with environment variables configured for you.**

This script detects your **CPU architecture**, **Linux distribution**, installs **required dependencies**, downloads the **newest Go release**, and sets up `GOROOT`, `GOPATH`, and `PATH` automatically.

---

## ⭐ Why this Installer?

* Always installs the **latest official Go release**
* Works across **all major Linux ecosystems**
* Zero manual setup — environment variables handled for you
* Ideal for developers, CI servers, containers, VPS setups

---


## 🚀 Quick Install (one-liner)

> Works on all supported Linux systems.

```bash
curl -fsSL https://raw.githubusercontent.com/goriyasno/install-latest-golang.sh/main/install.sh | bash
```

---

## 🐧 Supported Linux Distributions

The script automatically detects your package manager and supports:

| Distribution Family             | Supported Distros                                                                    |
| ------------------------------- | ------------------------------------------------------------------------------------ |
| **Debian-based**                | Ubuntu, Debian, Linux Mint, Pop!_OS, Zorin OS, Kali, MX Linux, Parrot OS, Peppermint |
| **RedHat-based**                | Fedora, CentOS, RHEL, AlmaLinux, Rocky Linux, Oracle Linux, Amazon Linux             |
| **Arch-based**                  | Arch Linux, Manjaro, EndeavourOS, ArcoLinux, Garuda                                  |
| **Alpine Linux**                | Alpine in bare-metal, Docker, LXC                                                    |

Supported CPU architectures:

* `x86_64 / amd64`
* `arm64 / aarch64`
* `armv7`

---

## 🔧 What the Script Does

| Task                                                     | Status |
| -------------------------------------------------------- | ------ |
| Detects CPU architecture                                 | ✅      |
| Detects package manager                                  | ✅      |
| Installs missing dependencies (wget + tar)               | ✅      |
| Downloads newest stable Go version                       | ✅      |
| Replaces previous Go installation (if exists)            | ✅      |
| Configures `GOROOT`, `GOPATH`, `GO111MODULE`, `PATH`     | ✅      |
| Persists env to `~/.bashrc`, `~/.zshrc`, or `~/.profile` | ✅      |

---

## 📌 After Installation

To activate Go in the **current terminal**, run:

```bash
source ~/.bashrc   # or ~/.zshrc or ~/.profile depending on your shell
```

To verify that Go is installed:

```bash
go version
```

---

## 🧹 Uninstall Go (optional)

```bash
sudo rm -rf /usr/local/go
sed -i '/Go Environment Variables/,+5d' ~/.bashrc ~/.zshrc ~/.profile 2>/dev/null
```

---

## 🔒 Security

If security is a concern, inspect the script first:

```bash
curl -fsSL https://raw.githubusercontent.com/goriyasno/install-latest-golang.sh/main/install.sh
```


### `install-go-universal.sh`

**A simple script to install the latest version of Go and set up environment variables on any Linux system.**

---

#### How to Use:

Run the following command to download and execute the script in one step:

```bash
curl -sSL https://github.com/goriyasno/install-latest-golang.sh/raw/main/install.sh | bash
```

This will:

* Download and install the latest version of Go.
* Set up Go environment variables (`GOROOT`, `GOPATH`, `GO111MODULE`).
* Update `~/.bashrc` for persistent configuration.

---

### Supported Linux Distributions:

This script works on most **Linux distributions** with the following package managers:

* **Debian-based** (Ubuntu, Linux Mint, Debian, Pop!_OS, Kali, etc.)

  * Uses `apt` package manager
* **RedHat-based** (Fedora, CentOS, RHEL, Rocky Linux, AlmaLinux, etc.)

  * Uses `dnf` or `yum` package manager
* **Arch-based** (Arch Linux, Manjaro, etc.)

  * Uses `pacman` package manager
* **Alpine Linux**

  * Uses `apk` package manager

The script will automatically detect your distribution and install the necessary dependencies (`wget` and `tar`) for downloading and extracting Go.

---

### How It Works:

1. **Architecture Detection**: The script automatically detects the architecture (x86_64, ARM64, etc.) to download the correct Go binary.
2. **Package Manager Detection**: The script detects the package manager (`apt`, `dnf`, `yum`, `pacman`, `apk`) to install the necessary dependencies.
3. **Go Installation**: It installs the latest version of Go and sets up the required environment variables (`GOROOT`, `GOPATH`, `PATH`, `GO111MODULE`).
4. **Persistence**: The environment variables are added to `~/.bashrc` to persist across terminal sessions.

---

### Example:

For **Ubuntu**, just run:

```bash
curl -sSL https://github.com/yourusername/repo-name/raw/main/install-go-universal.sh | bash
```

---

### Requirements:

* `wget` and `tar` (automatically installed by the script if missing).

---

Let me know if you need any more tweaks to this! This version is simple and includes the supported distributions with the easy `curl | bash` install method.

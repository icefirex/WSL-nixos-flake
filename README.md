# WSL-nixos-flake

A ready-to-use NixOS configuration for Windows Subsystem for Linux with a focus on developer productivity. This flake includes:

- [Determinate Nix](https://determinate.systems/posts/determinate-nix) integration
- [Home Manager](https://github.com/nix-community/home-manager) for user configuration
- ZSH with sensible defaults and useful aliases
- Development tools and utilities

## Prerequisites

- Windows 10 (version 1903 or higher) or Windows 11
- WSL2 enabled
- At least 8GB of RAM recommended
- 5GB of free disk space

## Installation Guide

### Step 1: Install NixOS-WSL

1. Enable WSL in Windows if you haven't already:
   ```powershell
   # Run in PowerShell as Administrator
   wsl --install
   ```

2. Download the latest NixOS-WSL release (.wsl file) from [GitHub](https://github.com/nix-community/NixOS-WSL/releases)

3. Double-click the downloaded `.wsl` file to install NixOS as a WSL distribution

5. Alternatively, you can install it manually with PowerShell:
   ```powershell
   # Replace PATH_TO_NIXOS_WSL with the actual path to the downloaded .wsl file
   wsl --import NixOS .\NixOS\ PATH_TO_NIXOS_WSL --version 2
   ```

6. Start NixOS:
   ```powershell
   wsl -d NixOS
   ```

### Step 2: Enable Flakes in NixOS

1. Once inside NixOS, edit the basic configuration file:
   ```bash
   sudo nano /etc/nixos/configuration.nix
   ```

2. Add the following minimal configuration:
   ```nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```
   Above the line that says "system.stateVersion".

3. Save and exit (Ctrl+X, then Y, then Enter)

4. Apply the configuration:
   ```bash
   sudo nixos-rebuild switch
   ```

### Step 3: Clone This Repository

1. Clone this repository:
   ```bash
   sudo git clone https://github.com/icefirex/WSL-nixos-flake.git /etc/nixos
   # Or clone to a different location if you prefer
   ```

2. **Important**: Update the `flakeDir` in `options.nix` to match your actual location:
   ```bash
   sudo nano /etc/nixos/options.nix
   ```
   Change the `flakeDir` value to wherever you cloned the repository.

3. Also update the `username` and `hostname` in `options.nix` if you want to use different values.

### Step 4: Apply the Configuration

1. Build and apply the NixOS configuration:
   ```bash
   cd /etc/nixos
   sudo nixos-rebuild switch --flake .
   ```

2. After the configuration is applied, restart your WSL instance:
   ```bash
   # In PowerShell (outside WSL)
   wsl --shutdown
   wsl -d NixOS
   ```

## Configuration Options

### User Configuration

Edit `options.nix` to customize:

- `username`: Default user for the system (default: "nixos")
- `hostname`: System hostname (default: "nixos")
- `flakeDir`: Location of the flake files (default: "/etc/nixos")

### ZSH Configuration

This flake includes ZSH with:

- Syntax highlighting
- Auto-suggestions
- History substring search
- Aliases for common commands
- Starship prompt
- Direnv integration
- LSD (modern ls replacement)

To add personal ZSH configurations, create a `~/.zshrc-personal` file.

### Adding Software

1. System-wide packages can be added in `flake.nix` under `environment.systemPackages`
2. User-specific packages can be added in `home.nix`

## Updating and Maintenance

### Rebuild System

The flake includes several aliases to simplify system management:

- `rebuild-system-test`: Test configuration without applying changes
- `rebuild-system-switch`: Apply configuration changes
- `rebuild-system-boot`: Apply configuration on next boot
- `update-system-test`: Update flake inputs and test configuration
- `update-system-switch`: Update flake inputs and apply changes
- `update-system-boot`: Update flake inputs and apply on next boot
- `system-cleanup`: Remove old generations and free disk space

### Updating the Flake

To update all flake dependencies:

```bash
cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake .
```

To update a specific dependency:

```bash
cd /etc/nixos
nix flake lock --update-input nixpkgs
sudo nixos-rebuild switch --flake .
```

## Features

- **Determinate Nix**: Enhanced Nix experience with improved tooling and reliability
- **Home Manager**: Advanced user environment management
- **Development Tools**:
  - Vim for text editing
  - Git for version control
  - Lazygit for terminal Git UI
  - Btop for system monitoring
- **ZSH Setup**:
  - Starship prompt for a beautiful and informative command line
  - Direnv for environment management
  - LSD for improved file listing
  - Useful aliases and keyboard shortcuts

## Troubleshooting

### WSL Issues

If you encounter issues with WSL:

1. Check WSL status: `wsl --status`
2. Terminate the WSL instance: `wsl --terminate NixOS`
3. Restart from a clean state: `wsl --shutdown` then `wsl -d NixOS`

### Nix Issues

If you have problems with Nix:

1. Check Nix store consistency: `nix-store --verify --check-contents`
2. Garbage collect old generations: `nix-collect-garbage -d`
3. Check logs: `journalctl -xeu nixos-rebuild`

### Permissions Issues

If you encounter permissions problems:

1. Make sure you're using `sudo` when rebuilding the system
2. Check ownership of the flake directory: `ls -la /etc/nixos`
3. Reset ownership if needed: `sudo chown -R root:root /etc/nixos`

## Contributing

Feel free to fork this repository and submit pull requests for improvements or bug fixes.

## License

This project is open source and available under the [MIT License](LICENSE).

# Dendritic NixOS Configuration

This workspace contains a modern, highly modular NixOS configuration structured using the **Dendritic Pattern**. 

## What is the Dendritic Pattern?
The Dendritic Pattern is an architectural layout for Nix/NixOS repositories. Its core principles are:
1. **Thin Entrypoint**: The root [flake.nix](file:///home/tim/Projects/dendritic/flake.nix) is kept as minimal as possible, acting only as a manifest.
2. **Aspect-Oriented Modularization**: Configurations are structured by **features/concerns** (e.g., desktop, apps, system) instead of directory classes (NixOS vs. Home Manager).
3. **Automatic Discovery**: It uses [import-tree](https://github.com/denful/import-tree) recursively on the [modules/](file:///home/tim/Projects/dendritic/modules) directory, registering each file as a `flake-parts` module under the flake's output attributes.
4. **No Glue Code**: Modules register their NixOS components on `flake.nixosModules.<name>`, which can then be cleanly referenced by hosts from `self.nixosModules.<name>` without ad-hoc path importing.

---

## File Structure

```
dendritic/
├── [flake.nix](file:///home/tim/Projects/dendritic/flake.nix)                  # Root flake manifest and entry point
├── [flake.lock](file:///home/tim/Projects/dendritic/flake.lock)                # Flake lockfile
└── [modules/](file:///home/tim/Projects/dendritic/modules)                   # All aspects and configurations
    ├── [system/](file:///home/tim/Projects/dendritic/modules/system)
    │   └── [base.nix](file:///home/tim/Projects/dendritic/modules/system/base.nix)          # Base system configurations (audio, user, network)
    ├── [desktop/](file:///home/tim/Projects/dendritic/modules/desktop)
    │   └── [gnome.nix](file:///home/tim/Projects/dendritic/modules/desktop/gnome.nix)        # GNOME desktop environment & flatpak support
    ├── [apps/](file:///home/tim/Projects/dendritic/modules/apps)
    │   ├── [browser.nix](file:///home/tim/Projects/dendritic/modules/apps/browser.nix)      # Browsers: Firefox (configured policies) & Chromium
    │   └── [default-apps.nix](file:///home/tim/Projects/dendritic/modules/apps/default-apps.nix)  # Office, media, mail, torrent, password defaults
    └── [hosts/](file:///home/tim/Projects/dendritic/modules/hosts)
        ├── [typical-pc.nix](file:///home/tim/Projects/dendritic/modules/hosts/typical-pc.nix)    # Host configuration output definition
        └── [_hardware.nix](file:///home/tim/Projects/dendritic/modules/hosts/_hardware.nix)     # Mock hardware-configuration (untracked by import-tree)
```

---

## Configuration Aspects

### 1. Base System ([modules/system/base.nix](file:///home/tim/Projects/dendritic/modules/system/base.nix))
Defines hardware and core platform behaviors:
* **Bootloader**: Modern EFI systemd-boot.
* **Networking**: Hostname `typical-pc` managed by `NetworkManager` for seamless Wi-Fi/Ethernet connectivity.
* **Audio**: PipeWire setup with ALSA, PulseAudio, and JACK emulation layers.
* **Peripherals**: Bluetooth enabled on boot, touchpad tap-to-click configuration enabled by default.
* **Base User**: `user` with sudo access (`wheel` group) and default password `nixos`.
* **System Packages**: Essential CLI tools (`git`, `curl`, `wget`, `vim`, `htop`).
* **Hardware firmware**: All unfree firmware enabled (`hardware.enableAllFirmware = true`) for Wi-Fi and Bluetooth compatibility.

### 2. Desktop Environment ([modules/desktop/gnome.nix](file:///home/tim/Projects/dendritic/modules/desktop/gnome.nix))
* **Full GNOME Desktop**: GDM display manager and GNOME desktop environment.
* **Flatpak Integration**: Enabled system-wide to support software management directly through **GNOME Software**.
* **Utility Apps**: GNOME Tweaks, GNOME Extension Manager, weather, maps, clocks, calendar, calculator, nautilus (file manager), evince (document viewer), file-roller (archive manager), and seahorse (keyring manager).

### 3. Browsers ([modules/apps/browser.nix](file:///home/tim/Projects/dendritic/modules/apps/browser.nix))
* **Firefox**: Configured with user-privacy policies (disabled telemetry, pocket, recommendation prompts).
* **Chromium**: Included as a secondary web engine backup.

### 4. Default Desktop Apps ([modules/apps/default-apps.nix](file:///home/tim/Projects/dendritic/modules/apps/default-apps.nix))
Curated set of applications for typical PC users:
* **Office Suite**: LibreOffice (fresh branch).
* **Media Player**: VLC.
* **Image Editor**: GIMP.
* **Email Client**: Thunderbird.
* **Torrent Client**: Transmission (GTK client).
* **Password Manager**: Bitwarden desktop client.

### 5. Hosts and Hardware ([modules/hosts/](file:///home/tim/Projects/dendritic/modules/hosts/))
* **Host Definition** ([typical-pc.nix](file:///home/tim/Projects/dendritic/modules/hosts/typical-pc.nix)): Evaluates the final `typical-pc` config by pulling in base system, gnome desktop, browsers, and app suites.
* **Hardware Config** ([_hardware.nix](file:///home/tim/Projects/dendritic/modules/hosts/_hardware.nix)): Contains standard boilerplate hardware parameters. It is prefixed with an underscore (`_`), meaning `import-tree` ignores it, and it can be imported manually.

---

## How to use this Flake

### 1. Clone and update Hardware Configuration
Before applying, replace `modules/hosts/_hardware.nix` with your machine's generated hardware config:
```bash
cp /etc/nixos/hardware-configuration.nix modules/hosts/_hardware.nix
```
Ensure you update the import statement inside [typical-pc.nix](file:///home/tim/Projects/dendritic/modules/hosts/typical-pc.nix) if needed.

### 2. Add files to Git
Nix flakes require files to be tracked in Git to recognize them:
```bash
git add .
```

### 3. Test building the system
You can test compiling the configuration without installing it:
```bash
nix build .#nixosConfigurations.typical-pc.config.system.build.toplevel --extra-experimental-features "nix-command flakes"
```

### 4. Apply the configuration
To apply the configuration to the current system:
```bash
sudo nixos-rebuild switch --flake .#typical-pc
```

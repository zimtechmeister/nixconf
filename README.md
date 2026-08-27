# Installation
requires NixOS [minimal ISO](https://nixos.org/download.html#nixos-iso)
write the image to the USB flash drive.
```bash
sudo dd bs=4M conv=fsync oflag=direct status=progress if=<path-to-image> of=/dev/sdX
```
boot the latest Kernel and set the root password to connect via SSH
```bash
sudo passwd root
```

## Nix Flake Installer (`nix run .#install`)

You can install any host with a single command. The installer automatically:
1. Generates or copies the SSH host private/public key into `--extra-files` for `/etc/ssh`.
2. Computes the Age public key using `ssh-to-age` and checks it against `.sops.yaml`.
3. Extracts the `disk-encryption-key` from `secrets/hosts/<host>.yaml` (or `secrets/secrets.yaml`).
4. Runs `nixos-anywhere` with all parameters wired up.

```bash
# Install 'tower'
nix run .#install -- -H tower root@192.168.178.87

# Install 't480'
nix run .#install -- -H t480 root@192.168.178.88

# From any remote machine:
nix run github:zimtechmeister/nixconf#install -- -H tower root@192.168.178.87
```

---

## Manual One-Liner (Raw `nixos-anywhere`)

If you want to run `nixos-anywhere` manually without the wrapper script:

```bash
# 1. Create a temporary folder with host SSH keys
TMP_DIR=$(mktemp -d)
mkdir -p "$TMP_DIR/etc/ssh"
ssh-keygen -t ed25519 -N "" -C "root@tower" -f "$TMP_DIR/etc/ssh/ssh_host_ed25519_key"
chmod 600 "$TMP_DIR/etc/ssh/ssh_host_ed25519_key"

# 2. Extract disk key & run nixos-anywhere
nix run github:nix-community/nixos-anywhere -- \
  --disk-encryption-keys /tmp/disk.key <(sops --extract '["disk-encryption-key"]' -d secrets/secrets.yaml) \
  --extra-files "$TMP_DIR" \
  --flake ~/nixconf#tower \
  root@192.168.178.87

# 3. Clean up
rm -rf "$TMP_DIR"
```

# Hardware
```bash
sudo nix run nixpkgs#nixos-facter -- -o facter.json
sudo chown $USER:users facter.json
sudo chmod 644 facter.json
```
> [!NOTE]
> when swapping out some hardware you should generate a new facter.json

# Secure Boot
1. Put Secure Boot into **Setup Mode** (to allow automated enrollment).  
   In UEFI, look for options like "Secure Boot", "Key Management", or
   "Security". Select "Reset to Setup Mode" or similar to clear existing keys
   and allow new ones to be enrolled.

> [!WARNING]
> - If you are using a ThinkPad, do NOT select "Clear All Secure Boot Keys"; use "Reset to Setup Mode" to prevent deleting the Forbidden Signature Database (dbx).  
> - If you are on a Framework 13 (Core Ultra), manually delete keys from the PK/KEK/DB sections as "Erase all Secure Boot settings" is bugged in the firmware.

2. Boot into NixOS and rebuild the configuration. NixOS will automatically generate keys (under `/var/lib/sbctl`) and enroll them:
   ```bash
   sudo nixos-rebuild switch --flake .
   ```
> [!NOTE]
> automatic enrollment may fail on some hardware due to different UEFI implementations.
> If it does, you can try enrolling the keys manually or adjust the host specific limine config
> ```bash
> sudo sbctl enroll-keys --microsoft
> ```
> useful options are:
> ```
> -m --microsoft
> -b --firmware-builtin
> -i --ignore-immutable
> ```
> my t480 for example works with `sudo sbctl enroll-keys -m -i`

3. Reboot, enter your UEFI settings, and enable/enforce **Secure Boot**.

4. Verify Secure Boot status:
   ```bash
   sudo bootctl status
   # or check using sbctl
   sudo sbctl status
   ```

# Commands
## Rebuild
Rebuild: "tower" is the host in those examples
```bash
sudo nixos-rebuild switch --flake github:zimtechmeister/flocke#tower
```
```bash
nh os switch /path/to/flake -H tower
```

## Update
Update flake
```bash
nix flake update
```

Update packages locked to a specific version (helium)
```bash
cd /path/to/flake
nix run nixpkgs#nix-update -- --flake helium
```

## Garbage Collection

```bash
sudo nix-collect-garbage -d
```

```bash
sudo nix-store --optimise
```


# Secrets Management (sops-nix)

This repository uses [`sops-nix`](https://github.com/Mic92/sops-nix) for declarative, encrypted secret management.

- **Host SSH keys** (`/etc/ssh/ssh_host_ed25519_key`) are used by machines to decrypt secrets automatically at boot/switch.
- **User SSH/Age keys** (`~/.ssh/id_ed25519`) are used by administrators to edit secrets.

## Structure
- `secrets/secrets.yaml`: Shared secrets accessible by all hosts and user keys.
- `secrets/hosts/<hostname>.yaml`: Host-specific secrets accessible only by that host and user keys.

---

## 1. One-Time Setup (Export User Age Key for Editing)
To allow the `sops` CLI to decrypt/edit secrets using your existing SSH key:

```bash
mkdir -p ~/.config/sops/age

# Temporarily copy key to RAM (/dev/shm) to safely strip passphrase for conversion
TMP_KEY=$(mktemp -p /dev/shm)
install -m 600 ~/.ssh/id_ed25519 "$TMP_KEY"
ssh-keygen -p -N "" -f "$TMP_KEY"
ssh-to-age -private-key -i "$TMP_KEY" -o ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
rm -f "$TMP_KEY"
```

---

## 2. View and Edit Secrets
```bash
# Edit shared secrets:
sops secrets/secrets.yaml

# Edit host-specific secrets:
sops secrets/hosts/tower.yaml
sops secrets/hosts/t480.yaml
```
> [!TIP]
> To generate hashed passwords for user accounts, run:
> ```bash
> mkpasswd -m yescrypt
> ```

---

## 3. Adding a New Host Key
1. **Convert host SSH public key to Age**:
   ```bash
   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```
   *(If deploying with `nixos-anywhere`, pre-generate the SSH key locally and pass it via `--extra-files`).*

2. **Add the Age key to [.sops.yaml](file:///.sops.yaml)** under `keys` and update the relevant `creation_rules`.

3. **Re-encrypt secrets for the new host**:
   ```bash
   sops updatekeys secrets/secrets.yaml
   sops updatekeys secrets/hosts/<hostname>.yaml
   ```

---

## 4. Adding a New User Key
1. **Convert user SSH public key to Age**:
   ```bash
   ssh-to-age < ~/.ssh/id_ed25519.pub
   # or from age keyfile:
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

2. **Add the key to [.sops.yaml](file:///.sops.yaml)** under `keys` and include it in all `creation_rules`.

3. **Re-encrypt all secrets**:
   ```bash
   sops updatekeys secrets/secrets.yaml
   sops updatekeys secrets/hosts/tower.yaml
   sops updatekeys secrets/hosts/t480.yaml
   ```

---

## 5. Using Secrets in NixOS Modules
Declare secrets in your NixOS configuration (e.g. [modules/base/secrets.nix](file:///home/tim/nixconf/modules/base/secrets.nix)):

```nix
sops.secrets = {
  # Common secret from secrets/secrets.yaml
  "tim-password".neededForUsers = true; # Needed early at boot for user account creation

  # Host-specific secret
  "custom-token" = {
    sopsFile = ../../../secrets/hosts/tower.yaml;
    owner = "tim";
    group = "users";
    mode = "0400";
  };
};

# Plaintext secret path available at:
# config.sops.secrets."custom-token".path
```

> [!IMPORTANT]
> Nix Flakes only see files tracked by Git. Always stage changes after creating or updating secrets:
> ```bash
> git add .sops.yaml secrets/
> ```

# Eduroam
download the eduroam script from [here](https://cat.eduroam.org/)  
enter a shell with
```bash
nix-shell -p "python3.withPackages (ps: with ps; [ dbus-python ])"
```
and execute the eduroam script.  
In nmtui edit the eduroam connection and set "Store password for all users" so
you wont need to enter the password every time you log in
```bash
python ./location/eduroamscript
```

# TODO
[generally good source](https://www.vimjoyer.com/nix)
[vimjoyer](https://github.com/Goxore/nixconf)
- [ ] update (e.g. helium) using github actions
- [ ] devenv / devbox / flox / direnv / my own
- [ ] [anywhere](https://github.com/nix-community/nixos-anywhere) [example](https://github.com/nix-community/nixos-anywhere-examples)
laptop only:
- [ ] tlp

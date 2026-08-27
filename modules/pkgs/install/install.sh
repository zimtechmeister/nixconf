#!/usr/bin/env bash
# ==============================================================================
# NixOS Installation Flake App using nixos-anywhere
# ==============================================================================
# Automates provisioning NixOS via nixos-anywhere with:
#  - Disk encryption key extraction from SOPS
#  - SSH host key generation (or reuse) packed into --extra-files
#  - Age key derivation for sops-nix compatibility
# ==============================================================================

set -euo pipefail

# Color helpers
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# Determine default flake directory
if [[ -f "$PWD/flake.nix" ]]; then
  DEFAULT_FLAKE_DIR="$PWD"
elif git rev-parse --show-toplevel >/dev/null 2>&1; then
  DEFAULT_FLAKE_DIR="$(git rev-parse --show-toplevel)"
elif [[ -d "$HOME/nixconf" ]]; then
  DEFAULT_FLAKE_DIR="$HOME/nixconf"
else
  DEFAULT_FLAKE_DIR="$PWD"
fi

# Default configuration values
FLAKE_DIR="$DEFAULT_FLAKE_DIR"
HOST="tower"
TARGET=""
SOPS_FILE=""
KEY_NAME="disk-encryption-key"
REMOTE_KEY_PATH="/tmp/disk.key"
EXISTING_HOST_KEY=""
SAVE_HOST_KEY_DIR=""
EXTRA_ARGS=()
NO_CONFIRM=false

usage() {
  echo -e "${BOLD}Usage:${NC} nix run .#install -- [OPTIONS] <TARGET>

${BOLD}Arguments:${NC}
  <TARGET>                     SSH target (e.g. root@192.168.178.87)

${BOLD}Options:${NC}
  -h, --help                   Show this help message and exit
  -H, --host <NAME>            NixOS configuration name in flake (default: tower)
  -f, --flake <DIR>            Flake directory path (default: ${DEFAULT_FLAKE_DIR})
  -s, --sops-file <PATH>       Path to SOPS file containing disk encryption key
  -k, --key-name <NAME>        Key name inside SOPS file (default: disk-encryption-key)
  -r, --remote-key-path <PATH> Destination path on target for disk key (default: /tmp/disk.key)
  --host-key <PATH>            Path to existing SSH private host key to use instead of generating a new one
  --save-host-key <DIR>        Directory to save newly generated host keys locally
  -y, --yes                    Skip interactive confirmation prompt
  -- <EXTRA_ARGS...>           Additional arguments to pass directly to nixos-anywhere

${BOLD}Examples:${NC}
  nix run .#install -- root@192.168.178.87
  nix run .#install -- -H tower root@192.168.178.87
  nix run .#install -- -H t480 -r /tmp/secret.key root@192.168.178.88"
  exit 0
}

# Parse CLI arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    -H|--host)
      HOST="$2"
      shift 2
      ;;
    -f|--flake)
      FLAKE_DIR="$2"
      shift 2
      ;;
    -s|--sops-file)
      SOPS_FILE="$2"
      shift 2
      ;;
    -k|--key-name)
      KEY_NAME="$2"
      shift 2
      ;;
    -r|--remote-key-path)
      REMOTE_KEY_PATH="$2"
      shift 2
      ;;
    --host-key)
      EXISTING_HOST_KEY="$2"
      shift 2
      ;;
    --save-host-key)
      SAVE_HOST_KEY_DIR="$2"
      shift 2
      ;;
    -y|--yes)
      NO_CONFIRM=true
      shift
      ;;
    --)
      shift
      EXTRA_ARGS+=("$@")
      break
      ;;
    -*)
      error "Unknown option: $1. Use --help for usage."
      ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
        shift
      else
        error "Unexpected positional argument: $1"
      fi
      ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  error "Target SSH destination is required (e.g. root@192.168.178.87). Use --help for details."
fi

# Create a secure temporary directory with automatic cleanup on exit
TEMP_DIR="$(mktemp -d -t nixos-anywhere-XXXXXX)"
cleanup() {
  local exit_code=$?
  if [[ -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
  exit "$exit_code"
}
trap cleanup EXIT INT TERM

info "Setting up temporary working directory: $TEMP_DIR"

# ------------------------------------------------------------------------------
# 1. Prepare Extra Files (Host SSH Key)
# ------------------------------------------------------------------------------
EXTRA_FILES_DIR="$TEMP_DIR/extra-files"
SSH_DIR="$EXTRA_FILES_DIR/etc/ssh"
mkdir -p "$SSH_DIR"
chmod 755 "$EXTRA_FILES_DIR/etc" "$SSH_DIR"

HOST_PRIV_KEY="$SSH_DIR/ssh_host_ed25519_key"
HOST_PUB_KEY="$SSH_DIR/ssh_host_ed25519_key.pub"

if [[ -n "$EXISTING_HOST_KEY" ]]; then
  if [[ ! -f "$EXISTING_HOST_KEY" ]]; then
    error "Specified host key not found: $EXISTING_HOST_KEY"
  fi
  info "Using existing host SSH key: $EXISTING_HOST_KEY"
  cp "$EXISTING_HOST_KEY" "$HOST_PRIV_KEY"
  if [[ -f "${EXISTING_HOST_KEY}.pub" ]]; then
    cp "${EXISTING_HOST_KEY}.pub" "$HOST_PUB_KEY"
  else
    ssh-keygen -y -f "$HOST_PRIV_KEY" > "$HOST_PUB_KEY"
  fi
else
  info "Generating new Ed25519 SSH host key for host '${HOST}'..."
  ssh-keygen -t ed25519 -N "" -C "root@${HOST}" -f "$HOST_PRIV_KEY" >/dev/null
fi

# Ensure strict permissions required by OpenSSH
chmod 600 "$HOST_PRIV_KEY"
chmod 644 "$HOST_PUB_KEY"

# Optionally save the generated host key to a persistent directory
if [[ -n "$SAVE_HOST_KEY_DIR" ]]; then
  mkdir -p "$SAVE_HOST_KEY_DIR"
  cp "$HOST_PRIV_KEY" "$SAVE_HOST_KEY_DIR/ssh_host_ed25519_key"
  cp "$HOST_PUB_KEY" "$SAVE_HOST_KEY_DIR/ssh_host_ed25519_key.pub"
  info "Saved host key copy to $SAVE_HOST_KEY_DIR"
fi

# Derive Age key from the SSH host public key for sops-nix
SSH_PUB_CONTENT="$(cat "$HOST_PUB_KEY")"
HOST_AGE_KEY="$(ssh-to-age < "$HOST_PUB_KEY")"

echo ""
echo -e "${BOLD}--- Host SSH & Age Key Info ---${NC}"
echo -e "${BOLD}SSH Public Key:${NC}  $SSH_PUB_CONTENT"
echo -e "${BOLD}Age Public Key:${NC}  $HOST_AGE_KEY"
echo ""

# Check if age key exists in .sops.yaml
SOPS_CONFIG="$FLAKE_DIR/.sops.yaml"
if [[ -f "$SOPS_CONFIG" ]]; then
  if ! grep -q "$HOST_AGE_KEY" "$SOPS_CONFIG"; then
    warn "The generated Age public key ($HOST_AGE_KEY) was not found in $SOPS_CONFIG."
    warn "If this host uses host-specific sops-nix secrets, make sure to add it to .sops.yaml and run 'sops updatekeys'."
  else
    info "Host Age key is present in $SOPS_CONFIG."
  fi
fi

# ------------------------------------------------------------------------------
# 2. Extract Disk Encryption Key from SOPS
# ------------------------------------------------------------------------------
DISK_KEY_FILE="$TEMP_DIR/disk.key"

try_extract_key() {
  local file="$1"
  local key="$2"
  local out="$3"

  [[ -f "$file" ]] || return 1

  # Try sops --extract first
  if sops --extract "[\"${key}\"]" -d "$file" > "$out" 2>/dev/null; then
    [[ -s "$out" ]] && return 0
  fi

  # Fallback for plain YAML scalar
  if sops -d "$file" 2>/dev/null | grep -E "^${key}:" | sed -E "s/^${key}:[[:space:]]*['\"]?(.*)['\"]?/\1/" > "$out"; then
    [[ -s "$out" ]] && return 0
  fi

  return 1
}

USED_SOPS_FILE=""
if [[ -n "$SOPS_FILE" ]]; then
  info "Extracting disk encryption key '${KEY_NAME}' from $SOPS_FILE..."
  if try_extract_key "$SOPS_FILE" "$KEY_NAME" "$DISK_KEY_FILE"; then
    USED_SOPS_FILE="$SOPS_FILE"
  else
    error "Failed to extract key '${KEY_NAME}' from $SOPS_FILE. Ensure the key exists and your SOPS age key is configured."
  fi
else
  # Check host-specific secrets first, then global secrets.yaml
  if try_extract_key "$FLAKE_DIR/secrets/hosts/${HOST}.yaml" "$KEY_NAME" "$DISK_KEY_FILE"; then
    USED_SOPS_FILE="$FLAKE_DIR/secrets/hosts/${HOST}.yaml"
  elif try_extract_key "$FLAKE_DIR/secrets/secrets.yaml" "$KEY_NAME" "$DISK_KEY_FILE"; then
    USED_SOPS_FILE="$FLAKE_DIR/secrets/secrets.yaml"
  else
    error "Could not find '${KEY_NAME}' in '$FLAKE_DIR/secrets/hosts/${HOST}.yaml' or '$FLAKE_DIR/secrets/secrets.yaml'. Specify with -s / --sops-file."
  fi
  info "Extracted disk encryption key '${KEY_NAME}' from $USED_SOPS_FILE"
fi

chmod 600 "$DISK_KEY_FILE"
success "Disk encryption key successfully extracted."

# ------------------------------------------------------------------------------
# 3. Confirmation & Execution
# ------------------------------------------------------------------------------
echo ""
echo -e "${BOLD}=== NixOS Deployment Plan ===${NC}"
echo -e "  ${BOLD}Target:${NC}         $TARGET"
echo -e "  ${BOLD}Flake Host:${NC}     $FLAKE_DIR#$HOST"
echo -e "  ${BOLD}Extra Files:${NC}    $EXTRA_FILES_DIR (/etc/ssh host key)"
echo -e "  ${BOLD}Disk Key Dest:${NC}  $REMOTE_KEY_PATH"
if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  echo -e "  ${BOLD}Extra Flags:${NC}    ${EXTRA_ARGS[*]}"
fi
echo ""

if [[ "$NO_CONFIRM" != "true" ]]; then
  read -rp "Proceed with NixOS installation on $TARGET? [y/N]: " confirm
  if [[ "$confirm" != [yY] && "$confirm" != [yY][eE][sS] ]]; then
    warn "Installation aborted by user."
    exit 0
  fi
fi

info "Starting nixos-anywhere..."

# Execute nixos-anywhere directly (bundled in package PATH)
nixos-anywhere \
  --disk-encryption-keys "$REMOTE_KEY_PATH" "$DISK_KEY_FILE" \
  --extra-files "$EXTRA_FILES_DIR" \
  --flake "$FLAKE_DIR#$HOST" \
  "${EXTRA_ARGS[@]}" \
  "$TARGET"

success "NixOS installation completed successfully!"

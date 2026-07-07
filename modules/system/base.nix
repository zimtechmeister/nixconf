{ self, inputs, ... }: {
  flake.nixosModules.base = { config, lib, pkgs, ... }: {
    # Nix settings
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.hostName = "typical-pc";
    networking.networkmanager.enable = true;

    # Time and Locale
    time.timeZone = "UTC";
    i18n.defaultLocale = "en_US.UTF-8";

    # Sound (PipeWire)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    security.rtkit.enable = true;

    # Printing / CUPS
    services.printing.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Touchpad tap-to-click
    services.libinput.enable = true;

    # Basic system utilities
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      vim
      htop
    ];

    # Define a default user account
    users.users.user = {
      isNormalUser = true;
      description = "Typical PC User";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      initialPassword = "nixos";
    };

    # Essential firmware
    hardware.enableAllFirmware = true;

    system.stateVersion = "24.11";
  };
}
